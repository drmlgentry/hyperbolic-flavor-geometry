"""
Census-wide test of the "quarter-Lucas geodesic" selection criterion
still cited in the live manuscript (gentry-pmns-plb.tex, lines 162-165):

  "M_PMNS contains a geodesic of length
   sigma_opt = (3/2) log sqrt(13/5) = 0.7218 (second shortest, to 0.03%)
   -- the same sigma that minimises the CKM fitness."

This is the CORRECTED sigma_opt (the project's own later fix from
(3/2)log(phi) to (3/2)log(sqrt(13/5)), already reflected in the current
manuscript -- confirmed this session by direct reading). This check does
NOT rely on the retracted "Lucas-purity covering tower" claim (v4 of
gentry_lucas_structure.tex explicitly does not reassert that
conjecture) -- it tests only the sigma_opt geodesic leg, using SnapPy's
proper length_spectrum rather than ad hoc word-based extraction, across
the full 134-manifold H1=Z/5 census already used throughout this report.

For each manifold: compute the real-length geodesic spectrum up to a
generous cutoff, find the geodesic whose real length is closest to
sigma_opt, and record that gap. Rank m003 by this gap among the census.
"""
import json
import math
import snappy

CENSUS_PATH = "/mnt/c/dev/hyperbolic-flavor-geometry/data/h1z5_manifold_list.json"
SIGMA_OPT = 1.5 * math.log(math.sqrt(13.0 / 5.0))
CUTOFF = 2.0  # real length cutoff for the spectrum scan -- generous for "second shortest"

print(f"sigma_opt = (3/2)*log(sqrt(13/5)) = {SIGMA_OPT:.6f}")
print(f"(manuscript states 0.7218)")
print()

census = json.load(open(CENSUS_PATH))
print("N manifolds:", len(census))

results = []
n_fail = 0
for i, entry in enumerate(census):
    name = entry["full_name"]
    try:
        M = snappy.Manifold(name)
        spec = M.length_spectrum(CUTOFF)
        lengths = sorted(set(round(float(g.length.real()), 8) for g in spec if float(g.length.real()) > 1e-6))
        if not lengths:
            n_fail += 1
            results.append({"name": name, "census_index": entry["census_index"], "error": "no geodesics under cutoff"})
            continue
        closest = min(lengths, key=lambda L: abs(L - SIGMA_OPT))
        gap = abs(closest - SIGMA_OPT)
        rel_gap = gap / SIGMA_OPT
        rank_in_own_spectrum = 1 + sum(1 for L in lengths if L < closest)
        results.append({
            "name": name, "census_index": entry["census_index"],
            "closest_length": closest, "gap": gap, "rel_gap_pct": rel_gap * 100,
            "rank_in_own_spectrum": rank_in_own_spectrum, "n_geodesics_under_cutoff": len(lengths),
        })
    except Exception as e:
        n_fail += 1
        results.append({"name": name, "census_index": entry["census_index"], "error": str(e)})
    if (i + 1) % 20 == 0:
        print(f"  {i+1}/{len(census)} done")

print("failures:", n_fail, "/", len(census))
valid = [r for r in results if "gap" in r]
print("valid:", len(valid))

m003_row = [r for r in results if r["name"] == "m003(-2,3)"][0]
print()
print("m003(-2,3) row:", m003_row)

rel_gaps = sorted(r["rel_gap_pct"] for r in valid)
print()
print("rel_gap_pct distribution: min={:.4f} p10={:.4f} median={:.4f} p90={:.4f} max={:.4f}".format(
    rel_gaps[0], rel_gaps[len(rel_gaps)//10], rel_gaps[len(rel_gaps)//2],
    rel_gaps[int(len(rel_gaps)*0.9)], rel_gaps[-1]))

g_m003 = m003_row["rel_gap_pct"]
rank = 1 + sum(1 for r in valid if r["rel_gap_pct"] < g_m003 and r["name"] != "m003(-2,3)")
print(f"m003 rank by closeness to sigma_opt: {rank} / {len(valid)}  (rel_gap={g_m003:.4f}%)")

with open("/mnt/c/dev/hyperbolic-flavor-geometry/reproduce/sigma_opt_geodesic_census_results.json", "w") as f:
    json.dump(results, f, indent=2, default=str)

print("EXIT=0")
