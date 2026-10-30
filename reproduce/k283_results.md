# K_283 census base rate — results (2026-10-29)

K_283 = Q(t), t^4 − t − 1 = 0, disc −283, signature (2,1), Galois closure S4.
It is the invariant trace field of m003(−2,3), the Meyerhoff manifold (vol 0.98137, the second-smallest closed orientable hyperbolic manifold).

## Relation to existing work (hyperbolic-flavor-geometry)
- **Closes the open item** in CLAIMS_REGISTER entry 19 and the Sep 29 2026 MASTER_GAP_REPORT caveat, where no rigorous base rate had been established.
  - The earlier `census_full_scan` data was cusped-only and biased.
  - The relevant population named there is the 134-manifold H₁ = ℤ/5 closed census (`data/h1z5_manifold_list.json`).
- **[Computed] H₁ = ℤ/5 population:** m003(−2,3) is the **only** manifold of the 134 with k_inv ≅ K_283 (1/134). It is one of just two with degree ≤ 4; the other is a cubic, and 106 of the 134 have degree 10.
  - This comes straight from the stored `itf_disc` values.
  - My independent PARI run agrees with that list on all 134 manifolds.
  - Caveat: m003(−2,3) is also the minimum-volume member of that stratum (v5 §2), and low degree concentrates at low volume. Its uniqueness there is therefore partly a volume effect.
- **Meyerhoff identification [Computed]:** SnapPy `is_isometric_to` confirms m003(−2,3) ≅ m004(5,1), the Meyerhoff manifold. v5 does not name it as such. That would be an optional one-line remark, not a correction, since v5 already states the H₁ = ℤ/5 volume minimality carefully.
- The field model used here, x⁴ − x − 1, is v5's X⁴ + X³ − 1 by the explicit isomorphism in register entry 19.

## Method
- **Census:** SnapPy 3.3.2 `OrientableClosedCensus` (11,031 manifolds), quad-double holonomy.
- **kM generators:** tr(g_i)^2, tr g_i tr g_j tr(g_i g_j), tr g_i tr g_j tr g_k tr(g_i g_j g_k) (Maclachlan–Reid Lemma 3.5.9).
- **Census-wide K_283 test (PARI, `k283_census.py`):** checks with `lindep` that each generator lies in Q(t) under one fixed embedding, accepting relation heights ≤ 10^8 at 55 digits. K_283 has no subfields other than Q and kM is never real, so containment gives equality.
- **Sage cross-check (WSL `sage` env, `k283_quaternion.sage`):** for all 28 hits:
  - `find_field` at 400 bits confirms kM = Q[x]/(x^4 − x − 1), signature (2,1).
  - Integral traces: tr^2 w is integral for every generator, pair and triple (MR Lemma 8.5.2).
  - The invariant quaternion algebra is A0 = (tr^2 g − 4, tr[g,h] − 2), with g = a², h = b² (MR Thm 3.6.2), computed with `ramified_places`.
- **Validation (`k283_qcheck.sage`):**
  - A0 is unchanged under four different choices of (g, h).
  - It reproduces the literature: Weeks is ramified at {real place, prime of norm 5}, and Meyerhoff at {both real places} only.

## Results
**[Computed] Field base rate: 28 / 11,031 = 0.25%** of the closed census has kM = K_283. Every one of the 28 has integral traces.

**[Computed] The 28 split by invariant quaternion algebra.** The finite ramification is listed by prime norm (primes of equal norm are not distinguished):

| arithmetic? | real places ramified | finite ramification (norms) | count | manifolds |
|---|---|---|---|---|
| yes | 2 | — | **11** | m003(−2,3), m006(2,3), m017(−1,3), m130(−2,3), m130(3,2), m189(−5,2), s650(−1,3), s543(5,2), v3215(3,1), s933(−2,3), s874(−2,3) |
| yes | 2 | 7, 13 | 3 | m139(3,2), m139(−2,3), v3431(−2,3) |
| yes | 2 | 11, 13 | 2 | v2771(−4,1), v2018(2,3) |
| yes | 2 | 7, 17 | 1 | m358(3,1) |
| yes | 2 | 7, 11 | 1 | v2573(−1,3) |
| yes | 2 | 16, 17 | 1 | s855(−3,2) |
| **no** | 1 | 17 | 3 | m339(−2,3), v3377(2,3), v3378(2,3) |
| **no** | 0 | 13, 17 | 2 | m294(−4,1), m293(4,3) |
| **no** | 0 | 17, 89 | 4 | v3244(4,3), v3243(−4,1), v3246(4,3), v3247(4,1) |

Arithmetic means one complex place, integral traces and A0 ramified at all real places (MR Thm 8.3.2). Arithmetic groups with the same (k, A0) are commensurable (MR Thm 8.4.1).

- **[Proved, given the numerics] Meyerhoff's commensurability class in the census has 11 members: 11/11,031 = 0.10%.**
- The other 17 K_283 manifolds lie in at least five further arithmetic classes, plus 9 non-arithmetic manifolds that cannot be commensurable with Meyerhoff.

**Correction to the earlier draft.** All 28 volumes are exact half-integer multiples of vol(Meyerhoff), checked to 60 digits even for the non-arithmetic ones (e.g. m294(−4,1) = 4·vol exactly). This is **not** evidence of commensurability. K_283 has one complex place, so its Bloch group has rank 1 (Borel), and the volume of *any* manifold with this invariant trace field is a rational multiple of a single regulator. The earlier "single commensurability class" conjecture is false.

**[Computed] Within the fillings of m003** (all coprime slopes with |p|,|q| ≤ 12, 176 hyperbolic slopes): K_283 occurs only at (−2,3) and at its symmetric partner (−1,3), which give the same manifold.

**[Computed] Exact quartic counts** (`k283_quartic_exact.py`, same membership test, all 49 quartic fields detected): 362 manifolds in total. The top fields are K_283 28, disc −2151 26, −688 24, 788 22, −1588 21 and −331 19. K_283 leads only by 28 to 26 and spans several commensurability classes, so the lead is not meaningful. The algdep pass recovered 90% of quartic cases (325/362); scaling its counts by the 11.7% overall identification rate would be wrong.

## Interpretation for the paper
- **The field alone does not single out Meyerhoff.** K_283 is shared by at least six arithmetic classes and by non-arithmetic manifolds. What is distinctive about m003(−2,3) is the pair (K_283, A0 ramified only at the real places), together with arithmeticity.
- **The arithmetic half of the paper should rest on the quaternion algebra, not the field.** If it currently argues from K_283 alone, a referee can point to the 17 other K_283 manifolds that are not commensurable with Meyerhoff.
- **Referee-proof statements:**
  - "K_283 is the invariant trace field of 28 of the 11,031 census manifolds."
  - "Of these, exactly 11 are commensurable with the Meyerhoff manifold, being arithmetic with A0 ramified exactly at the two real places."
  - "Among the m003 fillings with |p|,|q| ≤ 12, only (−2,3) yields K_283."
- **Side observation [Computed]:** non-arithmetic closed manifolds with kM = K_283 exist at volume exactly 4·vol(Meyerhoff), namely m294(−4,1) and m293(4,3).

## Open follow-ups
1. Distinguish primes of equal norm (7, 13, 17) to confirm the arithmetic classes beyond Meyerhoff's are grouped correctly.
2. ~~Run the exact PARI test for competitor quartic fields.~~ Done Oct 29 2026 (`k283_quartic_exact.py`; see Results).
3. Optional: check whether the non-arithmetic K_283 manifolds sharing (k, A0) are commensurable with each other, using SnapPy's `is_isometric_to` on covers.

Scripts: `k283_census.py`, `k283_analyze.py`, `k283_m003_fillings.py`, `k283_quartic_exact.py` (PARI, any Python with SnapPy); `k283_quaternion.sage`, `k283_qcheck.sage` (WSL `conda activate sage`). Data: `k283_census.csv`, `k283_m003_fillings.csv`, `k283_quaternion.out`, `k283_quartic_exact.csv`/`.log`.
