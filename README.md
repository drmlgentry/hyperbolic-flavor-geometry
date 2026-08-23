# Hyperbolic Flavor Geometry

**Arithmetic hyperbolic 3-manifolds encoding Standard Model flavor parameters.**

Marvin L. Gentry · Independent Researcher · Seattle, WA
ORCID: [0009-0006-4550-2663](https://orcid.org/0009-0006-4550-2663) · drmlgentry@protonmail.com

🌐 **[hyperbolicflavorgeometry.org](https://hyperbolicflavorgeometry.org)**
📄 **[SSRN Preprints](https://ssrn.com/author=11170302)** · 📦 **[LatticeFit on PyPI](https://pypi.org/project/latticefit/)**

---

## What Is HFG?

The Hyperbolic Flavor Geometry (HFG) program proposes that the flavor structure of the Standard Model — the PMNS and CKM mixing matrices, CP-violating phases, and fermion mass hierarchies — arises from the arithmetic geometry of compact hyperbolic 3-manifolds.

The core observation: the unique minimum-volume closed orientable hyperbolic 3-manifold (the **Meyerhoff manifold**, m003(−2,3)) encodes the PMNS lepton mixing matrix to within current experimental precision, with **zero free parameters**.

---

## Recent Results (August 2026)

- **[Proved]** Four-Field Galois Product Theorem: Gal(L/ℚ) ≅ C₂ × S₄ × C₂ × S₃, order 576 — the complete Pati–Salam-plus-color Weyl group, assembled from four arithmetically independent cusp fields (entries 14–17, [CLAIMS_REGISTER.md](CLAIMS_REGISTER.md))
- Three papers submitted: Journal of Topology (Torsion), Annals of Physics ×2 (CKM v3, PMNS)
- **[Computed → Proved]** Oriented G/H coset selector for m006 — the oriented holonomy canonically selects one of three conjugate embeddings of the cusp field, invariant under peripheral basis change (entry 17)
- Substack: [The 576-Element Breakthrough](https://marvingentrynd.substack.com/p/the-576-element-breakthrough-how)

---

## Canonical Results (June 2026)

| Observable | Manifold | HFG value | PDG value | Status |
|---|---|---|---|---|
| PMNS matrix | m003(−2,3) | fitness 0.005087 | — | Global minimum |
| CKM matrix | m006(−5,2) | fitness 0.003618 | — | Global best (len-6 scan) |
| CKM target fitness | m006(−5,2) | 0.003989 | — | Word-search null p=0.005 |
| CP phase δ | m003(−2,3) | 195.91° | 197.0° | 1.09° error |
| θ₁₂ (PMNS) | m003(−2,3) | 33.67° | 33.65° | 0.02° |
| θ₂₃ (PMNS) | m003(−2,3) | 47.63° | 47.64° | 0.01° |
| θ₁₃ (PMNS) | m003(−2,3) | 8.37° | 8.57° | 0.23° |

### CKM Global Best (June 2026)

**Best triple**: {aaab, aBaB, ABBaB} at σ = 2/5 = 0.400 (exact), fitness = 0.003618.
This is 4.68× better than the canonical triple {aaB, AbA, AAb} (fitness = 0.016949).
From an exhaustive scan of 865k word triples (freely-reduced, length ≤ 6).

### Statistical Validation (June 28, 2026)

The CKM fit is statistically significant:

- **Same-search null test** (p = 0.005): Holding the manifold and search fixed, 200 random CKM-shaped matrices achieve fitness no better than 0.146 (mean 0.288). The physical CKM matrix at 0.003989 is a strict outlier. One-sided Monte Carlo p ≤ 0.005.
- **Census null test**: Among 12 H₁=ℤ/5 manifolds scanned, m006(−5,2) ranks 6th by fitness — it is **not** selected by fitness.

### Manifold Selection: Arithmetic, Not Fitness (June 28–29, 2026)

m006(−5,2) is selected by arithmetic, not by CKM fitness:

- Its invariant trace field (ITF) has degree 10, discriminant −271488204251, and **signature (8,1)** — eight real places, one complex pair.
- **m006(−5,2) is the unique H₁=ℤ/5 manifold with ITF signature (8,1)** in the full SnapPy closed census (948 candidates across 11,031 manifolds).
- All manifolds with better CKM fitness have signatures (1,1), (5,1), or (0,5) — incompatible with suppressed CP violation.

This is a **falsifiable selection criterion**: any H₁=ℤ/5 manifold with ITF sig=(8,1) and better CKM fitness would require explanation. The full-census enumeration finds none.

---

## Arithmetic Foundations

- **Trace field (PMNS)**: K = ℚ(w), w⁴ − w − 1 = 0, disc(K) = −283, signature (2,1)
- **Trace field (CKM)**: K₁₀ = ℚ[t]/(t¹⁰ − 7t⁸ − 4t⁷ + 17t⁶ + 14t⁵ − 18t⁴ − 14t³ + 8t² + 3t − 1), disc = −271488204251, sig = (8,1), Gal = S₁₀
- **ITF generator identity**: tr(ρ(a)) = −α, where α is the primitive element of K₁₀
- **Fricke collapse**: tr(ρ(ab)) = tr(ρ(a)) — forces a finite 122-node trace quotient graph
- **Sigma quantization**: best fits at σ = n/10, n ∈ {2,…,9} (exact rationals only)
- **Bianchi connection**: 31 → χ₅ → ℚ(√5) → φ forced by a₃₁² − 4·31 = −3·5²
- **Galois-Weyl**: Gal(m003) = ℤ/2 = Weyl(SU(2)); Gal(m006) = S₃ = Weyl(SU(3))
- **Lucas structure**: geodesic lengths ℓ = 2k·log φ ↔ |tr(γ)| = Lₖ (Lucas numbers)

---

## Reproduce the Results

All scripts run in WSL with `conda activate sage` (SageMath + SnapPy).

```bash
cd /mnt/c/dev/hyperbolic-flavor-geometry

# Theorem A: Frobenius discriminant (< 10 seconds)
python3 reproduce/verify_frobenius.py

# Theorem B: Three-ray eigenvalue structure (< 30 seconds)
python3 reproduce/verify_three_ray.py

# Theorem C: Fricke collapse, trace equalities, ITF generator (< 5 minutes)
python3 reproduce/verify_trace.py

# Statistical validation: same-search null test p=0.005 (< 10 minutes)
python3 reproduce/census_null_test.py

# Arithmetic uniqueness: m006 is unique H1=Z/5 manifold with ITF sig=(8,1)
# (Phase 1+2 ~2 minutes; Phase 3 fitness comparison ~15 hours)
python3 reproduce/signature_enum_test.py
```

Each script prints `PASS`/`FAIL` per claim and a final verdict line.

**Expected outputs:**
- `verify_frobenius.py` → `THEOREM A: VERIFIED [PASS]`
- `verify_three_ray.py` → `THEOREM B: VERIFIED [PASS]`
- `verify_trace.py`     → `THEOREM C: VERIFIED [PASS]`
- `census_null_test.py` → `TAIL -- m006(-5,2) is special (p=0.005)`
- `signature_enum_test.py` → Phase 2: 1 sig=(8,1) manifold found (m006(-5,2))

---

## Papers

### In Preparation
| Paper | Target | Status |
|---|---|---|
| Frobenius Discriminant, Bianchi Descent, and Character Variety of a Hyperbolic Dehn Surgery | Experimental Mathematics / NYJM | Draft complete (June 29, 2026) |
| CKM holonomy paper (revised) | PTEP | Major revision in progress |

### Under Review / Active
| Paper | Journal | ID | Status |
|---|---|---|---|
| Chirality from hyperbolic geometry | Phys. Lett. B | PLB-D-26-01006 | Under Review (68+ days) |
| Sextic-Octic Decomposition | Res. Number Theory | RNTB-D-26-00299 | New Submission |
| PMNS from Meyerhoff | Phys. Lett. B | PLB-D-26-01448 | With Editor |
| CKM | Results Phys. | RINP-D-26-00327 | Under Review |
| PMNS | Results Phys. | RINP-D-26-00328 | Under Review |
| Unified HFG | Phys. Rev. D | es2026may16_552 | Under Review |

### SSRN Preprints
- [6981259](https://ssrn.com/abstract=6981259): Lucas Numbers v4
- [6988018](https://ssrn.com/abstract=6988018): Z/5 Bridge
- [6988058](https://ssrn.com/abstract=6988058): Mu-function v2
- [6876278](https://ssrn.com/abstract=6876278): Sextic-Octic

---

## Repository Contents

```
reproduce/                  Verification scripts (all print PASS/FAIL)
  verify_frobenius.py       §16: Frobenius discriminant theorem
  verify_three_ray.py       §17: Three-ray eigenvalue theorem
  verify_trace.py           §18: Trace quotient + ITF generator
  census_null_test.py       Statistical null test (p=0.005)
  signature_enum_test.py    Full-census ITF signature enumeration
papers/
  hyperbolic-flavor-ckm/    CKM paper LaTeX (under revision)
  nt-paper/                 NT paper LaTeX (§§1–5 complete)
    main.tex                Master file
    section_intro.tex       §1 Introduction
    section16.tex           §2 Frobenius discriminant theorem
    section17.tex           §3 Three-ray eigenvalue theorem
    section18.tex           §4 Trace quotient structure
    section_connections.tex §5 Connections and open problems
data/
  ckm_scan_len6_final.txt   18,079 scan results (865k triples)
  null_test_result_june28.txt  Same-search null: p=0.005
  census_null_result.json   Census null: m006 ranks 6/12
docs/                       Website source (hyperbolicflavorgeometry.org)
notes/                      Session handoffs and working notes
```

---

## Citation

```bibtex
@misc{gentry2026hfg,
  author = {Gentry, Marvin L.},
  title  = {Hyperbolic Flavor Geometry: Arithmetic 3-Manifolds and Standard Model Mixing},
  year   = {2026},
  note   = {SSRN preprint 6775158},
  url    = {https://ssrn.com/abstract=6775158}
}
```

---

*© 2026 Marvin L. Gentry · hyperbolicflavorgeometry.org*
