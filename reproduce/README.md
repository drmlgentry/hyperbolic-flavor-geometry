# Reproduction Scripts

## verify_bloch_quantum.py
Verifies vol(m019) = 3·v₀ and vol(m178) = 4·v₀ at 100-digit precision.
**Status: SOLID — citable.**

## verify_trace.py
Verifies §18 trace quotient theorems (15/15 PASS).
**Status: SOLID — citable.**

## census_null_test.py
H₁=ℤ/5 census scan over 11,031 manifolds.
**Status: SOLID — citable.**

## verify_peripheral.py
**MOVED to exploratory/verify_peripheral.py.**
The peripheral determinant δ(M_CKM) ≈ 2.9×10⁻⁴ does not match
J_CKM = 3.06×10⁻⁵ (PDG). Not a verified HFG result.

---

# Reproducing the m003 paper ("Trace Collisions on the Character Variety of m003 ...")

Every result in Table 1 of `papers/gentry-m003-arithmetic-v5.tex` has a script
in this directory and a committed log. `SHA256SUMS` / `MANIFEST.md` list the 13
scripts named in the paper and their logs (30 files) with SHA-256 hashes.

## Check the archive

On Linux/macOS, from the repository root:

    sha256sum -c reproduce/SHA256SUMS

On any platform (hashes the committed blobs, independent of line-ending
conversion; Windows checkouts use CRLF):

    python reproduce/make_sha256_manifest.py --verify

## Script for each result in the paper's Table 1

| Result | Script | Needs |
|---|---|---|
| Surgery law | `m003_surgery_law_certificate.py` | Python, sympy |
| ITF gates F1-F4 (invariant trace field) | `pmns_itf_certificate.sage` | Sage, SnapPy |
| Presentation bridge | `m003_dehn_relator_certificate.py` | Python, sympy |
| Short-word atlas | `m003_structure_atlas.sage` | Sage, SnapPy |
| Universal identities | `m003_three_universal_identities.sage` | Sage |
| Component is G_m; ambient decomposition | `m003_stage4_x0_identity_origin.py` | Python, sympy |
| Collision ideal: intersection point | `m003_m006_X0_cap_N_point_argument.py` | Python, sympy, mpmath |
| Collision ideal: length-3 witness | `m003_J3_strengthening_certificate.py` | Python, sympy |
| Bezout route; m006 analogue | `m003_collision_ideal_certificate.py` | Python, sympy |
| J_L = K for L <= 10 (m003, m006; regression) | `m003_J10_vs_intersection.py`, `m006_J10_vs_intersection.py` | Python, sympy |
| Signed characterization; conjugacy | `m003_squared_locus_and_conjugacy.sage` | Sage |
| Sign twist | `m003_identify_Y_minus.sage` | Sage |

Each script prints its checks and exits 0 only if every assertion holds.
Run a Python script from this directory, e.g. `python m003_J3_strengthening_certificate.py`;
run a Sage script as `sage <file>.sage`.

## Environment

Pinned versions: `requirements-m003.txt` (pure-Python scripts) and the Sage
note below.

- Python scripts: Python 3.13, sympy 1.14.0, mpmath 1.3.0.
- Sage scripts: SageMath 10.9 with SnapPy 3.3.2 (Python 3.13.14; the atlas
  manifest `m003_atlas_manifest.json` records the same Sage/SnapPy versions).

Re-run check, Oct 31 2026 (Python 3.13.14, sympy 1.14.0, mpmath 1.3.0): the six
fast pure-Python scripts (`m003_J3_strengthening_certificate`,
`m003_collision_ideal_certificate`, `m003_surgery_law_certificate`,
`m003_dehn_relator_certificate`, `m003_stage4_x0_identity_origin`,
`m003_m006_X0_cap_N_point_argument`) all exit 0 in 36 s or less. The two
`J10` regression scripts and the five Sage scripts were NOT re-run in that check;
their committed logs are the recorded outputs.

## Atlas outputs

The three atlas CSVs (`m003_filling_summary.csv`, `m003_pair_atlas.csv`,
`m003_word_atlas.csv`) are stored byte-exact (CRLF, `-text` in `.gitattributes`)
because `m003_atlas_manifest.json` records the SHA-256 of those exact bytes.
