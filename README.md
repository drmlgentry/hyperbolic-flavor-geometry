# Hyperbolic Flavor Geometry

A geometric framework for discrete flavor structure based on compact
hyperbolic 3-manifolds, Coxeter group actions, and arithmetic unit lattices.

## Papers

| # | Title | Status |
|---|-------|--------|
| 2 | Uniqueness and Operator Realization on Hyperbolic Logarithmic Lattices | Ready for submission |
| 3 | Geometric Origin of CP Phases from Hyperbolic Holonomy | Ready for submission |
| 4 | Flavor Mixing from Boundary Misalignment in Hyperbolic Geometry | Ready for submission |
| 6 | Discrete Shape Space and Integer Logarithmic Lattices | Ready for submission |
| 7 | Uniqueness-First EFT Framework: Framework, Feasibility, and the Spectrum Obstruction | Held |

Recommended submission order: 3, 6, 2, 4, 7.

## Compilation
```powershell
cd papers\paper3-holonomy
latexmk -pdf paper3.tex
```

Or use VS Code with LaTeX Workshop (auto-builds on save).

## Dependencies
- TeXLive (full)
- Python 3.x + numpy
- VS Code + LaTeX Workshop extension