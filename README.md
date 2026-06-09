# Hyperbolic Flavor Geometry

**Arithmetic hyperbolic 3-manifolds encoding Standard Model flavor parameters.**

Marvin L. Gentry · Independent Researcher · Seattle, WA
ORCID: [0009-0006-4550-2663](https://orcid.org/0009-0006-4550-2663) · drmlgentry@protonmail.com

🌐 **[hyperbolicflavorgeometry.org](https://hyperbolicflavorgeometry.org)**
📄 **[SSRN Preprints](https://ssrn.com/author=11170302)** · 📦 **[LatticeFit on PyPI](https://pypi.org/project/latticefit/)**

---

## What Is HFG?

The Hyperbolic Flavor Geometry (HFG) programme proposes that the flavor structure of the Standard Model — the PMNS and CKM mixing matrices, CP-violating phases, and fermion mass hierarchies — arises from the arithmetic geometry of compact hyperbolic 3-manifolds.

The core observation: the unique minimum-volume closed orientable hyperbolic 3-manifold (the **Meyerhoff manifold**, m003(−2,3)) encodes the PMNS lepton mixing matrix to within current experimental precision, with **zero free parameters**.

---

## Canonical Results (June 2026)

| Observable | Manifold | HFG value | PDG value | Status |
|---|---|---|---|---|
| PMNS matrix | m003(−2,3) | fitness 0.005087 | — | Global minimum |
| CKM matrix | m006(−5,2) | fitness 0.016482 | — | 0 free params |
| CP phase δ | m003(−2,3) | 195.91° | 197.0° | 1.09° error |
| θ₁₂ (PMNS) | m003(−2,3) | 33.67° | 33.65° | 0.02° |
| θ₂₃ (PMNS) | m003(−2,3) | 47.63° | 47.64° | 0.01° |
| θ₁₃ (PMNS) | m003(−2,3) | 8.37° | 8.57° | 0.23° |

### Selection Principle (June 8 2026)

The CP phase 195.91° is a **manifold invariant** of m003(−2,3):

- 216 candidate word triples collapse under conjugacy to **2 primitive geodesic classes**
- The ℤ/5 phase resonance at θ* = −180° selects the inverse pair (1,4) with **3.1× advantage** over the competing pair (2,3)
- Selection is canonical without reference to the PDG value

| Manifold | Matrix | Resonance θ* | Factorization | D-sum (selected) | D-sum (alt) |
|---|---|---|---|---|---|
| m003(−2,3) | PMNS | −180° | Borel | 15.91° | 48.95° |
| m006(−5,2) | CKM | +90° | Iwasawa | 21.09° | 60.99° |

---

## Repository Contents

```
docs/               Website source (GitHub Pages → Cloudflare → hyperbolicflavorgeometry.org)
  index.html        Homepage with results, papers, articles
  article1.html     Article I: The Smallest Universe
  article2.html     Article II: Why Hyperbolic Space Looks Impossible
  article3.html     Article III: The CP Phase Is a Manifold Invariant (June 2026)
  art.html          Hyperbolic Atelier — mathematical art
  hfg_resonance_explorer.html   Interactive geodesic phase explorer
  figures/          PNG figures for papers and articles
papers/             LaTeX source for submitted manuscripts
```

---

## Active Submissions (June 2026)

| Paper | Journal | ID | Status |
|---|---|---|---|
| Sextic-Octic Decomposition | Res. Number Theory | RNTB-D-26-00299 | New Submission ✓ |
| PMNS from Meyerhoff | Phys. Lett. B | PLB-D-26-01448 | With Editor |
| Torsion | Phys. Lett. B | PLB-D-26-01449 | With Editor |
| CP Phase | Nucl. Phys. B | NPB-D-26-00998 | With Editor |
| Unified HFG | Nucl. Phys. B | NPB-D-26-00999 | With Editor |
| CKM | Results Phys. | RINP-D-26-00327 | Under Review |
| PMNS | Results Phys. | RINP-D-26-00328 | Under Review |
| Unified HFG | Phys. Rev. D | es2026may16_552 | Under Review |

---

## Arithmetic Foundations

- **Trace field**: K = ℚ(w), w⁴ − w − 1 = 0, disc(K) = −283, signature (2,1)
- **Shape polynomial**: p₈(y) = y⁸ + y⁶ − 2y⁵ + y⁴ − y³ + 3y² − 3y + 1
- **Norm decomposition**: p₈ = Norm_{K/ℚ}(q₂), q₂ = y² − wy + (−w³+w²+1)
- **Volume quantum**: vol(M) = v₀ = 0.9813688289..., volumes of 16 census manifolds ∈ ½ℤ·v₀
- **Galois-Weyl**: Gal(m003) = ℤ/2 = Weyl(SU(2)); Gal(m006) = S₃ = Weyl(SU(3)); Gal(m019) = S₄ = Weyl(SU(4))
- **Lucas structure**: geodesic lengths ℓ = 2k·log φ ↔ |tr(γ)| = Lₖ (Lucas numbers)

---

## Reproduce the Core Result

```bash
# Install dependencies
pip install snappy latticefit numpy scipy

# Run the canonical reproduction script
git clone https://github.com/drmlgentry/hyperbolic-flavor-scan
cd hyperbolic-flavor-scan
python hfg_reproduce.py
# Expected: PMNS fitness 0.005087, CKM fitness 0.016482
```

**Platform note**: PMNS requires WSL + conda sage environment (SnapPy 3.3.2). CKM reproduces on both Windows and Linux.

---

## Citation

```
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
