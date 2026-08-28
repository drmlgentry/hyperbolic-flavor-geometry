import json

with open("C:/dev/hyperbolic-flavor-geometry/reproduce/census_full_scan/census_field_classes.json") as f:
    fields = json.load(f)

items = list(fields.items())

# --- Build the 86-vertex universe: only C2, S4, S3 fields are relevant ---
verts = [(k, v['galois_group'], frozenset(v['ramification_support'])) for k, v in items
         if v['galois_group'] in ('C2', 'S4', 'S3')]
n = len(verts)
print(f"Universe size (C2+S4+S3 fields): {n}  "
      f"(C2={sum(1 for _,g,_ in verts if g=='C2')}, "
      f"S4={sum(1 for _,g,_ in verts if g=='S4')}, "
      f"S3={sum(1 for _,g,_ in verts if g=='S3')})")

# --- Map primes to bit positions ---
all_primes = sorted({p for _, _, s in verts for p in s})
bitpos = {p: i for i, p in enumerate(all_primes)}
print(f"Distinct primes appearing across the 86-field universe: {len(all_primes)}")

def support_bitmask(support):
    m = 0
    for p in support:
        m |= (1 << bitpos[p])
    return m

vert_mask = [support_bitmask(s) for _, _, s in verts]
vert_type = [g for _, g, _ in verts]
vert_key = [k for k, _, _ in verts]

C2_idx = [i for i in range(n) if vert_type[i] == 'C2']
S4_idx = [i for i in range(n) if vert_type[i] == 'S4']
S3_idx = [i for i in range(n) if vert_type[i] == 'S3']

# --- Build adjacency as integer bitmasks over vertex indices (disjoint-support graph) ---
adj_bit = [0] * n
for i in range(n):
    bits = 0
    for j in range(n):
        if i != j and (vert_mask[i] & vert_mask[j]) == 0:
            bits |= (1 << j)
    adj_bit[i] = bits

def bitmask_from_indices(idxs):
    m = 0
    for i in idxs:
        m |= (1 << i)
    return m

S4_bitset = bitmask_from_indices(S4_idx)
S3_bitset = bitmask_from_indices(S3_idx)

def iter_bits(mask):
    while mask:
        low = mask & (-mask)
        idx = low.bit_length() - 1
        yield idx
        mask ^= low

def popcount(x):
    return bin(x).count("1")

# --- Enumerate colored K4's: (C2, C2, S4, S3) via pure bitmask ops (independent of the earlier frozenset-based script) ---
total_colored_k4 = 0
target_primes = frozenset({3, 7, 59, 283})
target_mask = support_bitmask(target_primes)
exact_signature_matches = []

for ci, i in enumerate(C2_idx):
    for j in C2_idx[ci+1:]:
        if not (adj_bit[i] >> j) & 1:
            continue  # i,j not disjoint
        pair_mask = vert_mask[i] | vert_mask[j]
        common_after_ij = adj_bit[i] & adj_bit[j] & S4_bitset
        for k in iter_bits(common_after_ij):
            triple_mask = pair_mask | vert_mask[k]
            common_after_ijk = adj_bit[i] & adj_bit[j] & adj_bit[k] & S3_bitset
            n_s3_here = popcount(common_after_ijk)
            total_colored_k4 += n_s3_here
            # check exact-union-signature constraint for each such S3 completion
            for l in iter_bits(common_after_ijk):
                full_mask = triple_mask | vert_mask[l]
                if full_mask == target_mask:
                    exact_signature_matches.append((vert_key[i], vert_key[j], vert_key[k], vert_key[l]))

print()
print(f"=== Independent bitmask certificate ===")
print(f"N_colored_K4 (C2,C2,S4,S3, pairwise disjoint support) = {total_colored_k4}")
print(f"N_prime_signature_exact({{3,7,59,283}}) = {len(exact_signature_matches)}")
for m in exact_signature_matches:
    print("  ", m)

# --- Structural short-explanation check ---
print()
print("=== Structural uniqueness explanation ===")
for p in (3, 283, 59, 7):
    candidates = [(vert_key[i], vert_type[i]) for i in range(n) if vert_mask[i] == (1 << bitpos[p])]
    print(f"  support=={{{p}}} among C2/S4/S3 universe: {candidates}")
# also check across ALL 165 fields (not just C2/S4/S3) for completeness, matching earlier report
