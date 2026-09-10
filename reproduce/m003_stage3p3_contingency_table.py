"""
Stage 3.3, step 2: the proper contingency table, specifically for
m003(-2,3) (not pooled across fillings with different H1 structures),
using the refined, non-overlapping categories:

  H_0:     chi(u) = chi(v) = 0
  H_-:     chi(v) = -chi(u), both nonzero
  H_=:     chi(v) =  chi(u), both nonzero
  H_other: none of the above

  T_0:     tau_u = tau_v = 0 (numerically)
  T_+:     tau_u =  tau_v, not both zero
  T_-:     tau_u = -tau_v, not both zero
  T_other: none of the above

Reports the full 4x4 contingency table over the 136 curated pairs for
m003(-2,3), both conditional probabilities
  P(T=T_+ | H=H_-)  -- does homology inversion predict trace equality?
  P(H=H_- | T=T_+)  -- is trace equality enriched for inverse homology?
which are different claims, per the review. Also reports the
sign-twist parity control (n_a(u)-n_a(v) mod 2) for every T_+ pair,
as a discrete label alongside (not a proposed cause of) the homology
relation. All results here are NUMERICAL candidates (from the CSV's
decimal tau_re/tau_im) -- the already fully-investigated 4 pairs are
separately known to be exactly certified (via
m003_three_universal_identities.sage and
m003_squared_locus_and_conjugacy.sage); the step-1 dedup scan already
showed no OTHER candidates exist in this atlas to certify.
"""
import csv
import json
from collections import defaultdict

ATLAS_DIR = "/mnt/c/dev/hyperbolic-flavor-geometry/reproduce"
TOL = 1e-6
FILLING = "m003(-2,3)"

chars = json.load(open(f"{ATLAS_DIR}/m003_per_filling_characters.json"))[FILLING]
invariants = chars["invariants"]
table = chars["table"]

words_exp = {}
words_trace = {}
with open(f"{ATLAS_DIR}/m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        if row["filling"] != FILLING:
            continue
        words_exp[row["word"]] = (int(row["exp_a"]), int(row["exp_b"]))
        words_trace[row["word"]] = complex(float(row["tr_re"]), float(row["tr_im"]))

pairs = []
with open(f"{ATLAS_DIR}/m003_pair_atlas.csv") as f:
    for row in csv.DictReader(f):
        if row["filling"] != FILLING:
            continue
        pairs.append((row["u"], row["v"]))

print(f"filling: {FILLING}  invariants: {invariants}  n_pairs: {len(pairs)}")


def chi(word):
    ea, eb = words_exp.get(word, (None, None))
    if ea is None:
        return None
    v = table.get(f"{ea},{eb}")
    return tuple(v) if v is not None else None


def negate(vec):
    return tuple(-c if m == 0 else (-c) % m for c, m in zip(vec, invariants))


def norm(vec):
    return tuple(c if m == 0 else c % m for c, m in zip(vec, invariants))


def is_zero(vec):
    return all(c == 0 for c in vec)


def n_a(word):
    return sum(1 for c in word if c == "a") - sum(1 for c in word if c == "A")


H_labels = ["H_0", "H_-", "H_=", "H_other"]
T_labels = ["T_0", "T_+", "T_-", "T_other"]
contingency = {h: {t: 0 for t in T_labels} for h in H_labels}
T_plus_pairs = []

for u, v in pairs:
    cu, cv = chi(u), chi(v)
    tu, tv = words_trace.get(u), words_trace.get(v)
    if cu is None or cv is None or tu is None or tv is None:
        continue
    cu_n, cv_n = norm(cu), norm(cv)

    if is_zero(cu_n) and is_zero(cv_n):
        h = "H_0"
    elif cu_n == negate(cv_n) and not is_zero(cu_n):
        h = "H_-"
    elif cu_n == cv_n and not is_zero(cu_n):
        h = "H_="
    else:
        h = "H_other"

    u_zero = abs(tu) < TOL
    v_zero = abs(tv) < TOL
    if u_zero and v_zero:
        t = "T_0"
    elif abs(tu - tv) < TOL and not (u_zero and v_zero):
        t = "T_+"
    elif abs(tu + tv) < TOL and not (u_zero and v_zero):
        t = "T_-"
    else:
        t = "T_other"

    contingency[h][t] += 1
    if t == "T_+":
        parity = (n_a(u) - n_a(v)) % 2
        T_plus_pairs.append((u, v, h, parity))

print()
print("=" * 78)
print(f"CONTINGENCY TABLE for {FILLING} (n={len(pairs)} pairs)")
print("=" * 78)
header = f"{'':10s}" + "".join(f"{t:>10s}" for t in T_labels) + f"{'Total':>10s}"
print(header)
for h in H_labels:
    row = contingency[h]
    total = sum(row.values())
    print(f"{h:10s}" + "".join(f"{row[t]:>10d}" for t in T_labels) + f"{total:>10d}")
col_totals = {t: sum(contingency[h][t] for h in H_labels) for t in T_labels}
grand_total = sum(col_totals.values())
print(f"{'Total':10s}" + "".join(f"{col_totals[t]:>10d}" for t in T_labels) + f"{grand_total:>10d}")

assert grand_total == len(pairs), (
    f"partitions not exhaustive/disjoint: sum(N_ij)={grand_total} != n_pairs={len(pairs)}")
print(f"\n[assertion passed: sum(N_ij) = {grand_total} = n_pairs, partitions exhaustive and disjoint]")

print()
n_H_minus = sum(contingency["H_-"].values())
n_H_minus_Tplus = contingency["H_-"]["T_+"]
n_Tplus = col_totals["T_+"]

print(f"P(T=T_+ | H=H_-) = {n_H_minus_Tplus}/{n_H_minus} = "
      f"{n_H_minus_Tplus/n_H_minus if n_H_minus else float('nan'):.4f}"
      "   [does homology inversion predict trace equality?]")
print(f"P(H=H_- | T=T_+) = {n_H_minus_Tplus}/{n_Tplus} = "
      f"{n_H_minus_Tplus/n_Tplus if n_Tplus else float('nan'):.4f}"
      "   [is trace equality enriched for inverse homology?]")

print()
print("=" * 78)
print("SIGN-TWIST PARITY CONTROL for every T_+ (exact trace-equal) pair")
print("epsilon(a)=-1, epsilon(b)=+1  =>  tau_twisted(w) = (-1)^n_a(w) * tau(w)")
print("parity = (n_a(u) - n_a(v)) mod 2: 1 => equality flips to a T_- under twist")
print("=" * 78)
for u, v, h, parity in T_plus_pairs:
    tu, tv = words_trace[u], words_trace[v]
    tu_twisted = ((-1) ** n_a(u)) * tu
    tv_twisted = ((-1) ** n_a(v)) * tv
    twisted_eq = abs(tu_twisted - tv_twisted) < TOL
    twisted_neg = abs(tu_twisted + tv_twisted) < TOL
    twisted_rel = "T_+ (unchanged)" if twisted_eq else ("T_- (flipped to NEG!)" if twisted_neg else "?")
    print(f"  ({u}, {v})  homology={h}  parity={parity}  "
          f"under epsilon-twist: {twisted_rel}")

print()
print("If any pair flips to T_- under the twist, that DIRECTLY shows 'NEG=0'")
print("among the untwisted representation's pairs is a property of the SAMPLED")
print("component/lift (rho_geom specifically), not a prohibition intrinsic to")
print("the character variety X_0 as a whole -- the twisted component rho^epsilon")
print("would supply the missing NEG branch for that same pair.")

print()
print("EXIT=0")
