#!/usr/bin/env python3
"""
census_null_test.py
Tests whether m006(-5,2) = OrientableClosedCensus[43] is special among
H1=Z/5 closed hyperbolic 3-manifolds for fitting the CKM matrix.

Same pipeline as the word-triple null test, now varied over manifolds.
For each manifold: best-of-30k-triples x sigma-sweep fitness to PDG CKM.
If m006(-5,2) sits in the tail of this distribution, the manifold
selection is not arbitrary.

Run: conda activate sage && python3 census_null_test.py
Output: census_null_result.txt
"""

import snappy, numpy as np, math, random
from scipy.linalg import logm
from itertools import permutations as iperms
import json

PERMS = list(iperms(range(3)))
PDG_CKM = np.array([[0.97435,0.22500,0.00369],
                    [0.22486,0.97349,0.04182],
                    [0.00857,0.04110,0.99917]])
SIGMAS = [0.30, 0.35, 0.40, 0.45, 0.50]
N_TRIPLES = 30000
RANDOM_SEED = 42

def get_axis(rho, w):
    try:
        mat = np.array(rho(w), dtype=complex)
        mat = mat/np.sqrt(np.linalg.det(mat))
        L = logm(mat)
        x=float(np.real(L[0,1]+L[1,0]))/2
        y=float(np.imag(L[1,0]-L[0,1]))/2
        z=float(np.real(L[0,0]-L[1,1]))/2
        v=np.array([x,y,z]); n=np.linalg.norm(v)
        return v/n if n>1e-10 else None
    except: return None

inv = {'a':'A','A':'a','b':'B','B':'b'}
def gen_words(n):
    words=[]
    def build(w):
        if w: words.append(w)
        if len(w)==n: return
        for g in 'aAbB':
            if w and g==inv[w[-1]]: continue
            build(w+g)
    build(''); return words

ALL_WORDS = gen_words(6)

def scan_manifold(M, label):
    """Run best-of-30k scan on a single manifold. Returns fitness."""
    try:
        rho = M.polished_holonomy()
    except Exception as e:
        print(f"  {label}: holonomy failed ({e})", flush=True)
        return None

    # Build axes
    axes = {}
    for w in ALL_WORDS:
        ax = get_axis(rho, w)
        if ax is not None: axes[w] = ax
    valid_words = list(axes.keys())

    if len(valid_words) < 10:
        print(f"  {label}: too few valid words ({len(valid_words)})", flush=True)
        return None

    # Sample triples
    random.seed(RANDOM_SEED)
    N = len(valid_words)
    sampled = set()
    triples = []
    attempts = 0
    while len(triples) < N_TRIPLES and attempts < N_TRIPLES * 20:
        attempts += 1
        if N < 3: break
        i,j,k = sorted(random.sample(range(N), 3))
        key = (i,j,k)
        if key not in sampled:
            sampled.add(key)
            triples.append((valid_words[i], valid_words[j], valid_words[k]))

    if len(triples) < 1000:
        print(f"  {label}: too few triples ({len(triples)})", flush=True)
        return None

    # Score CKM
    best = 999
    for w1,w2,w3 in triples:
        ax = [axes[w1], axes[w2], axes[w3]]
        for sig in SIGMAS:
            O = np.zeros((3,3))
            for i in range(3):
                for j in range(3):
                    ang = np.arccos(np.clip(abs(np.dot(ax[i],ax[j])),-1,1))
                    O[i,j] = np.exp(-ang**2/(2*sig**2))
            Q,_ = np.linalg.qr(O)
            U = np.abs(Q)
            f = min(np.sqrt(np.sum((U[:,list(p)]-PDG_CKM)**2)) for p in PERMS)
            if f < best: best = f

    return best

# ============================================================
# FIND ALL H1=Z/5 MANIFOLDS IN CENSUS
# ============================================================
print("Scanning OrientableClosedCensus for H1=Z/5 manifolds...", flush=True)
census = snappy.OrientableClosedCensus
h1_z5_indices = []
for i in range(min(500, len(census))):
    try:
        M = census[i]
        h1 = str(M.homology())
        if h1 == 'Z/5':
            h1_z5_indices.append(i)
    except: pass

print(f"Found {len(h1_z5_indices)} manifolds with H1=Z/5: indices {h1_z5_indices[:20]}...", flush=True)
print(flush=True)

# ============================================================
# SCAN EACH H1=Z/5 MANIFOLD
# ============================================================
results = {}
M_CKM_INDEX = 43

print(f"Scanning {len(h1_z5_indices)} H1=Z/5 manifolds...", flush=True)
print(f"Target (M_CKM): index {M_CKM_INDEX}", flush=True)
print(flush=True)

for idx in h1_z5_indices:
    M = census[idx]
    label = f"[{idx}] {M.name()}"
    marker = " <-- M_CKM (TARGET)" if idx == M_CKM_INDEX else ""
    print(f"Scanning {label}{marker}...", flush=True)
    fitness = scan_manifold(M, label)
    results[idx] = {
        'name': M.name(),
        'index': idx,
        'fitness': fitness,
        'is_target': idx == M_CKM_INDEX,
    }
    if fitness is not None:
        print(f"  fitness = {fitness:.6f}{marker}", flush=True)
    print(flush=True)

# ============================================================
# RESULTS
# ============================================================
print("="*60, flush=True)
print("CENSUS NULL TEST RESULTS", flush=True)
print("="*60, flush=True)
print(flush=True)

valid = [(idx, r) for idx, r in results.items() if r['fitness'] is not None]
valid.sort(key=lambda x: x[1]['fitness'])

print(f"{'Rank':>4} {'Index':>6} {'Name':>12} {'Fitness':>10} {'Target?':>8}", flush=True)
print("-"*50, flush=True)
for rank, (idx, r) in enumerate(valid, 1):
    marker = " ***" if r['is_target'] else ""
    print(f"{rank:>4} {idx:>6} {r['name']:>12} {r['fitness']:>10.6f} {marker}", flush=True)

# Target rank and p-value
target_fitness = results.get(M_CKM_INDEX, {}).get('fitness')
if target_fitness is not None:
    n_better = sum(1 for _, r in valid if r['fitness'] <= target_fitness and not r['is_target'])
    n_total = len(valid) - 1  # exclude target
    p_census = (1 + n_better) / (1 + n_total)
    target_rank = sum(1 for _, r in valid if r['fitness'] < target_fitness) + 1

    print(flush=True)
    print(f"M_CKM fitness: {target_fitness:.6f}", flush=True)
    print(f"M_CKM rank: {target_rank} of {len(valid)} H1=Z/5 manifolds", flush=True)
    print(f"Manifolds fitting CKM better: {n_better}", flush=True)
    print(f"Census p-value (corrected): {p_census:.4f}", flush=True)
    print(f"{'TAIL - m006(-5,2) is special' if p_census < 0.05 else 'BULK - m006(-5,2) not special'}", flush=True)

# Save
with open('census_null_result.json', 'w') as f:
    json.dump({
        'results': {str(k): v for k,v in results.items()},
        'target_index': M_CKM_INDEX,
        'target_fitness': target_fitness,
        'n_manifolds': len(valid),
    }, f, indent=2)
print(flush=True)
print("Saved to census_null_result.json", flush=True)
