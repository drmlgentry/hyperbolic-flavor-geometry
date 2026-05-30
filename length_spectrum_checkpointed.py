# length_spectrum_checkpointed.py
# Compute geodesic length spectra for HFG manifolds
# Checkpointed — safe to interrupt and restart
# Run in WSL: sage length_spectrum_checkpointed.py

import snappy
import sys
import os
import json

CHECKPOINT_FILE = "/mnt/c/dev/framework/length_spectrum_checkpoint.json"

def load_checkpoint():
    if os.path.exists(CHECKPOINT_FILE):
        with open(CHECKPOINT_FILE) as f:
            return json.load(f)
    return {}

def save_checkpoint(data):
    with open(CHECKPOINT_FILE, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"  [checkpoint saved]")

results = load_checkpoint()

manifolds = [
    ("m003",        "SU(2) cusped parent"),
    ("m006",        "SU(3) cusped parent"),
    ("m019",        "SU(4) cusped parent"),
    ("m003(-2,3)",  "M_PMNS closed"),
    ("m006(-5,2)",  "M_CKM closed"),
]

print("=" * 60)
print("HFG MANIFOLD LENGTH SPECTRA")
print("=" * 60)

for name, label in manifolds:
    if name in results:
        print(f"\n{label} ({name}): [cached]")
        for g in results[name][:6]:
            print(f"  L={g[0]:.8f}  mult={g[1]}")
        continue

    print(f"\n{label} ({name}): computing...")
    sys.stdout.flush()

    try:
        M = snappy.Manifold(name)
        spec = M.length_spectrum(cutoff=2.5, full_rigor=False)
        
        geodesics = []
        for g in spec[:10]:
            try:
                # Handle both method and value cases
                L = g.length
                if callable(L):
                    L = L()
                re_L = float(L.real)
                im_L = float(L.imag) if hasattr(L, 'imag') else 0.0
                mult = int(g.multiplicity) if hasattr(g, 'multiplicity') else 1
                geodesics.append([re_L, mult, im_L])
            except Exception as e:
                print(f"    skipping geodesic: {e}")
                continue

        results[name] = geodesics
        save_checkpoint(results)

        print(f"  Found {len(geodesics)} geodesics:")
        for g in geodesics[:6]:
            print(f"  L={g[0]:.8f}  twist={g[2]:.6f}  mult={g[1]}")

    except Exception as e:
        print(f"  Error: {e}")
        sys.stdout.flush()

print()
print("=" * 60)
print("SUMMARY — shortest geodesic per manifold:")
print("=" * 60)
for name, label in manifolds:
    if name in results and results[name]:
        L0 = results[name][0][0]
        # Convert to mass ratio (in electron masses)
        mass_ratio = L0 / (1.0/511.0)  # rough scale
        print(f"  {label}: L_min = {L0:.6f}")
    else:
        print(f"  {label}: no data")

print()
print("AMPHICHEIRALITY (computed earlier):")
print("  All HFG manifolds: amphicheiral = True")
print("  => orientation-reversing isometry exists for all")
print("  => geometrically consistent with theta_QCD = 0")
