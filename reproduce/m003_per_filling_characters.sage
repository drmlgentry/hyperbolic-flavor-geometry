"""
Compute the canonical character chi: pi_1(m003) -> H_1(filling) for
EACH of the 13 atlas fillings, using the SAME trusted method already
validated for m003(-2,3) (sage.all.FreeModule quotient -- not a
hand-rolled Smith normal form, which was tried and found buggy).

For every filling, builds the presentation matrix (relator row (0,5)
from r=abAAbabbb, plus the filling row p*[mu]+q*[lam] from
mu=ABABB=(-2,-3), lam=ABAbab=(-1,1) for closed fillings; just the
relator row for the cusped case), forms the quotient module, and
evaluates the character on every (exp_a, exp_b) pair actually
appearing in the frozen atlas for that filling. Also cross-checks the
computed group invariants against m003_filling_summary.csv's reported
homology as a sanity check.

Dumps a JSON: {filling: {"invariants": [...], "table": {"ea,eb": [residues...]}}}
"""
import json
import csv

R_EXP = (0, 5)
MU_EXP = (-2, -3)
LAM_EXP = (-1, 1)

ATLAS_DIR = "/mnt/c/dev/hyperbolic-flavor-geometry/reproduce"

fillings = {}
with open(ATLAS_DIR + "/m003_filling_summary.csv") as f:
    for row in csv.DictReader(f):
        fillings[row["filling"]] = row

exp_pairs_by_filling = {}
with open(ATLAS_DIR + "/m003_word_atlas.csv") as f:
    for row in csv.DictReader(f):
        fname = row["filling"]
        exp_pairs_by_filling.setdefault(fname, set())
        exp_pairs_by_filling[fname].add((int(row["exp_a"]), int(row["exp_b"])))

out = {}
for filling, info in fillings.items():
    p_raw, q_raw = info["slope_p"], info["slope_q"]
    if p_raw in ("", None):
        rows = [list(R_EXP)]
    else:
        p, q = int(p_raw), int(q_raw)
        fill_row = [p*MU_EXP[0] + q*LAM_EXP[0], p*MU_EXP[1] + q*LAM_EXP[1]]
        rows = [list(R_EXP), fill_row]

    Zn = ZZ**2
    rel = Zn.submodule([tuple(r) for r in rows])
    Q = Zn.quotient(rel)
    invariants = list(Q.invariants())

    table = {}
    for (ea, eb) in exp_pairs_by_filling.get(filling, []):
        img = Q(Zn((ea, eb)))
        # represent as a tuple of integers (one per invariant factor slot);
        # Q.invariants() may include 0 (free Z factors)
        vec = list(img.vector()) if hasattr(img, "vector") else list(img)
        table[f"{ea},{eb}"] = [int(x) for x in vec]

    out[filling] = {
        "slope": [p_raw, q_raw],
        "invariants": [int(x) for x in invariants],
        "reported_homology": info["homology"],
        "table": table,
    }
    print(filling, "invariants=", invariants, " reported=", info["homology"])

with open(ATLAS_DIR + "/m003_per_filling_characters.json", "w") as f:
    json.dump(out, f, indent=2)

print("SAGE_EXIT=0")
