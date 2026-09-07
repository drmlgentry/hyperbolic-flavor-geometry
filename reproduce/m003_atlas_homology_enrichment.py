"""
Exhaustive enrichment test: is inversion in H_1 (h_i = -h_j) statistically
enriched among squared-trace collisions (near_equal_tr2=True) in the
frozen target-free m003 atlas?

Uses:
  - m003_per_filling_characters.json: per-filling character table, built
    from the SAME method already validated against the independently
    Sage-verified (-2,3) character (m003_canonical_character.py) --
    a hand-rolled Smith-normal-form attempt was tried first, found to
    disagree with the validated result, and discarded. This is the
    trusted version.
  - m003_pair_atlas.csv: the frozen, target-free pairwise near_equal_tr2
    classification (built before any of this homology analysis existed).

For each filling, classifies every atlas word pair (u,v) as:
  S : chi(u) == chi(v)
  I : chi(u) == -chi(v)  (elementwise negation against each invariant's
      own modulus; a free Z-factor component is negated the same way)
  O : neither
then cross-tabulates against near_equal_tr2, per filling and pooled.
"""
import csv
import json
from collections import defaultdict

ATLAS_DIR = "/mnt/c/dev/hyperbolic-flavor-geometry/reproduce"

chars = json.load(open(f"{ATLAS_DIR}/m003_per_filling_characters.json"))

words_by_filling = defaultdict(dict)
with open(f"{ATLAS_DIR}/m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        words_by_filling[row["filling"]][row["word"]] = (int(row["exp_a"]), int(row["exp_b"]))

pairs_by_filling = defaultdict(list)
with open(f"{ATLAS_DIR}/m003_pair_atlas.csv") as f:
    for row in csv.DictReader(f):
        pairs_by_filling[row["filling"]].append(
            (row["u"], row["v"], row["near_equal_tr2"] == "True"))


def negate(vec, invariants):
    out = []
    for v, m in zip(vec, invariants):
        if m == 0:
            out.append(-v)
        else:
            out.append((-v) % m)
    return tuple(out)


def norm(vec, invariants):
    return tuple(v if m == 0 else v % m for v, m in zip(vec, invariants))


results_summary = []
grand = {"S_collide": 0, "S_not": 0, "I_collide": 0, "I_not": 0, "O_collide": 0, "O_not": 0}

for filling, cdata in chars.items():
    invariants = cdata["invariants"]
    table = cdata["table"]
    words = words_by_filling[filling]

    def chi(word):
        ea, eb = words.get(word, (None, None))
        if ea is None:
            return None
        key = f"{ea},{eb}"
        v = table.get(key)
        return tuple(v) if v is not None else None

    counts = {"S_collide": 0, "S_not": 0, "I_collide": 0, "I_not": 0, "O_collide": 0, "O_not": 0}
    n_pairs_used = 0
    for u, v, collide in pairs_by_filling[filling]:
        cu, cv = chi(u), chi(v)
        if cu is None or cv is None:
            continue
        n_pairs_used += 1
        cu_n, cv_n = norm(cu, invariants), norm(cv, invariants)
        if cu_n == cv_n:
            rel = "S"
        elif cu_n == negate(cv_n, invariants):
            rel = "I"
        else:
            rel = "O"
        key = f"{rel}_{'collide' if collide else 'not'}"
        counts[key] += 1
        grand[key] += 1

    n_S = counts["S_collide"] + counts["S_not"]
    n_I = counts["I_collide"] + counts["I_not"]
    n_O = counts["O_collide"] + counts["O_not"]
    p_I = counts["I_collide"] / n_I if n_I else None
    p_notI = ((counts["S_collide"] + counts["O_collide"]) / (n_S + n_O)) if (n_S + n_O) else None
    enrich = (p_I / p_notI) if (p_I is not None and p_notI) else None

    print(f"{filling:16s} invariants={invariants}  n_pairs_used={n_pairs_used}  "
          f"S={n_S} I={n_I} O={n_O}")
    print(f"  {counts}")
    print(f"  P(collide|I)={p_I}  P(collide|not I)={p_notI}  E={enrich}")
    print()

    results_summary.append({
        "filling": filling, "invariants": invariants, "n_pairs_used": n_pairs_used,
        "n_S": n_S, "n_I": n_I, "n_O": n_O, "counts": counts,
        "p_collide_given_I": p_I, "p_collide_given_not_I": p_notI, "enrichment": enrich,
    })

print("=" * 70)
print("GRAND (pooled across all 13 fillings) TABLE")
print("=" * 70)
print(grand)
n_S = grand["S_collide"] + grand["S_not"]
n_I = grand["I_collide"] + grand["I_not"]
n_O = grand["O_collide"] + grand["O_not"]
p_I = grand["I_collide"] / n_I if n_I else None
p_notI = (grand["S_collide"] + grand["O_collide"]) / (n_S + n_O) if (n_S + n_O) else None
print(f"n_S={n_S} n_I={n_I} n_O={n_O}")
print(f"P(collide | I)     = {p_I}")
print(f"P(collide | not I) = {p_notI}")
print(f"pooled enrichment E = {p_I/p_notI if (p_I is not None and p_notI) else None}")

with open(f"{ATLAS_DIR}/m003_atlas_homology_enrichment_results.json", "w") as f:
    json.dump({"per_filling": results_summary, "grand_table": grand}, f, indent=2, default=str)

print()
print("EXIT=0")
