import json
from itertools import combinations
from collections import Counter

with open("C:/dev/hyperbolic-flavor-geometry/reproduce/census_full_scan/census_field_classes.json") as f:
    fields = json.load(f)

items = list(fields.items())  # (field_key, data)
n = len(items)
print(f"Total distinct resolved fields: {n}")
print()

# --- (a) singleton-support exact matches ---
print("=== (a) Fields with ramification support exactly {p} ===")
targets = [3, 283, 7, 59]
found = {}
for p in targets:
    matches = [(k, v) for k, v in items if v['ramification_support'] == [p]]
    found[p] = matches
    print(f"  support=={{{p}}}: {len(matches)} field(s)")
    for k, v in matches:
        print(f"    {k}  galois={v['galois_group']}  closure_deg={v['closure_degree']}  stem_deg={v['stem_degree']}  stem_disc={v['stem_discriminant']}  #manifolds={len(v['manifolds'])}")
print()

# --- (b) singleton-support count overall ---
singleton = [(k, v) for k, v in items if len(v['ramification_support']) == 1]
print(f"=== (b) Fields with singleton ramification support (any single prime): {len(singleton)} / {n} ===")
sc = Counter(tuple(v['ramification_support']) for k, v in singleton)
print(f"  distinct singleton primes represented: {len(sc)}")
print()

# --- (c) 4-tuples with pairwise disjoint ramification support ---
print("=== (c)/(d) 4-tuples with pairwise-disjoint ramification support ===")
supports = [frozenset(v['ramification_support']) for k, v in items]
galois = [v['galois_group'] for k, v in items]
keys = [k for k, v in items]

# Build disjointness adjacency
adj = [[False]*n for _ in range(n)]
for i in range(n):
    for j in range(i+1, n):
        if supports[i].isdisjoint(supports[j]):
            adj[i][j] = adj[j][i] = True

# neighbor lists for pruning
neighbors = [set(j for j in range(n) if adj[i][j]) for i in range(n)]

# Count 4-cliques via ordered-index expansion (standard clique counting)
count_all_4tuples = 0
target_multiset = Counter(['C2', 'S4', 'C2', 'S3'])
count_matching_type = 0
example_matching = []

for i in range(n):
    Ni = [j for j in neighbors[i] if j > i]
    for a_idx in range(len(Ni)):
        j = Ni[a_idx]
        Nij = [x for x in Ni[a_idx+1:] if x in neighbors[j]]
        for b_idx in range(len(Nij)):
            k_ = Nij[b_idx]
            Nijk = [x for x in Nij[b_idx+1:] if x in neighbors[k_]]
            for l_ in Nijk:
                count_all_4tuples += 1
                gset = Counter([galois[i], galois[j], galois[k_], galois[l_]])
                if gset == target_multiset:
                    count_matching_type += 1
                    if len(example_matching) < 20:
                        example_matching.append((keys[i], keys[j], keys[k_], keys[l_]))

print(f"  Total 4-tuples (distinct fields) with pairwise-disjoint ramification support: {count_all_4tuples}")
print(f"  Of these, matching Galois-type multiset {{C2, S4, C2, S3}}: {count_matching_type}")
print()
if example_matching:
    print("  Matching examples (up to 20 shown):")
    for tup in example_matching:
        for k in tup:
            v = fields[k]
            print(f"      {k}  galois={v['galois_group']}  support={v['ramification_support']}  stem_disc={v['stem_discriminant']}")
        print("    ---")

# --- (e) uniqueness of the specific {3,283,7,59} configuration ---
print()
print("=== (e) Is the {-3,-283,-7,-59} tuple among the matching type-4-tuples? ===")

# Direct check: how many 4-tuples using exactly one field from each of found[3], found[283], found[7], found[59]
# and check pairwise disjoint (guaranteed since each singleton support is distinct prime) and check galois types
combo_count = 0
combo_list = []
if all(len(found[p]) >= 1 for p in targets):
    from itertools import product
    for c3, c283, c7, c59 in product(found[3], found[283], found[7], found[59]):
        combo_count += 1
        combo_list.append((c3[0], c283[0], c7[0], c59[0]))
print(f"  Number of ways to pick one field each with support exactly {{3}},{{283}},{{7}},{{59}}: {combo_count}")
for c in combo_list:
    print(f"    {c}")
    for k in c:
        v = fields[k]
        print(f"        {k}: galois={v['galois_group']} closure_deg={v['closure_degree']}")

print()
print("=== Summary stats for report ===")
print(f"n_fields={n}, singleton_support_fields={len(singleton)}, "
      f"total_disjoint_4tuples={count_all_4tuples}, matching_type_4tuples={count_matching_type}")
