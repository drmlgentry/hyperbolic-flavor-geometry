<#
.SYNOPSIS
    Sets up the hyperbolic-flavor-geometry repository structure and writes
    all paper content, code, and config files in a single pass.
    Run from C:\dev\framework\
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

function Write-File {
    param([string]$Path, [string]$Content)
    $dir = Split-Path $Path -Parent
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.Encoding]::UTF8)
    Write-Host "  wrote: $Path"
}

Write-Host "`n=== Hyperbolic Flavor Geometry: Repository Setup ===" -ForegroundColor Cyan

# ============================================================
# .gitignore
# ============================================================
Write-File "$root\.gitignore" @'
*.aux
*.log
*.out
*.toc
*.bbl
*.blg
*.fls
*.fdb_latexmk
*.synctex.gz
*.pdf
*.dvi
*.ps
__pycache__/
*.pyc
*.pyo
.vscode/settings.json
Thumbs.db
desktop.ini
'@

# ============================================================
# README.md
# ============================================================
Write-File "$root\README.md" @'
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
'@

# ============================================================
# VS Code settings
# ============================================================
Write-File "$root\.vscode\settings.json" @'
{
    "latex-workshop.latex.tools": [
        {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": ["-synctex=1","-interaction=nonstopmode","-file-line-error","%DOC%"]
        },
        {
            "name": "bibtex",
            "command": "bibtex",
            "args": ["%DOCFILE%"]
        },
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": ["-synctex=1","-interaction=nonstopmode","-file-line-error","-pdf","%DOC%"]
        }
    ],
    "latex-workshop.latex.recipes": [
        {
            "name": "pdflatex x3 + bibtex",
            "tools": ["pdflatex","bibtex","pdflatex","pdflatex"]
        },
        {
            "name": "latexmk",
            "tools": ["latexmk"]
        }
    ],
    "latex-workshop.latex.recipe.default": "pdflatex x3 + bibtex",
    "latex-workshop.view.pdf.viewer": "tab",
    "latex-workshop.latex.autoBuild.run": "onSave",
    "latex-workshop.latex.clean.fileTypes": [
        "*.aux","*.bbl","*.blg","*.idx","*.ind","*.lof","*.lot","*.out",
        "*.toc","*.acn","*.acr","*.alg","*.glg","*.glo","*.gls","*.ist",
        "*.fls","*.log","*.fdb_latexmk","*.synctex.gz"
    ]
}
'@

# ============================================================
# Move existing code files
# ============================================================
Write-Host "`nMoving existing code files..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$root\code" -Force | Out-Null
foreach ($f in @("verify_ckm.py","verify_ckm_v2.py","mass_only_eval.py")) {
    $src = "$root\$f"
    $dst = "$root\code\$f"
    if (Test-Path $src) {
        Move-Item $src $dst -Force
        Write-Host "  moved: $f -> code\$f"
    }
}

# ============================================================
# PAPER 3 — Geometric Origin of CP Phases from Hyperbolic Holonomy
# ============================================================
Write-Host "`nWriting Paper 3..." -ForegroundColor Yellow

Write-File "$root\papers\paper3-holonomy\paper3.bib" @'
@article{Jarlskog,
  author  = {C. Jarlskog},
  title   = {A Basis Independent Formulation of the Connection Between
             Quark Mass Matrices, {CP} Violation and Experiment},
  journal = {Z. Phys. C},
  volume  = {29},
  pages   = {491},
  year    = {1985}
}
@incollection{Weeks,
  author    = {J. R. Weeks},
  title     = {Computation of Hyperbolic Structures in Knot Theory},
  booktitle = {Handbook of Knot Theory},
  publisher = {Elsevier},
  year      = {2005}
}
@article{GoodmanEtAl,
  author  = {O. Goodman and D. Heard and C. Hodgson},
  title   = {Commensurators of Cusped Hyperbolic Manifolds},
  journal = {Exp. Math.},
  volume  = {17},
  pages   = {283},
  year    = {2008}
}
@misc{SnapPy,
  author = {M. Culler and N. Dunfield and M. Goerner and J. R. Weeks},
  title  = {{SnapPy}, a computer program for studying the geometry and
            topology of 3-manifolds},
  note   = {\url{http://snappy.computop.org}}
}
@book{bridsonhaefliger,
  author    = {M. R. Bridson and A. Haefliger},
  title     = {Metric Spaces of Non-Positive Curvature},
  publisher = {Springer},
  year      = {1999}
}
@book{ratcliffe,
  author    = {J. G. Ratcliffe},
  title     = {Foundations of Hyperbolic Manifolds},
  publisher = {Springer},
  year      = {2006}
}
@book{thurston,
  author    = {W. P. Thurston},
  title     = {Three-Dimensional Geometry and Topology},
  publisher = {Princeton University Press},
  year      = {1997}
}
@book{BrancoCP,
  author    = {G. C. Branco and L. Lavoura and J. P. Silva},
  title     = {{CP} Violation},
  publisher = {Oxford University Press},
  year      = {1999}
}
'@

Write-File "$root\papers\paper3-holonomy\paper3.tex" @'
\documentclass[12pt]{article}
\usepackage{amsmath,amssymb,amsfonts,amsthm}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

\newcommand{\Hthree}{\mathbb{H}^3}
\newcommand{\GammaG}{\Gamma}
\newcommand{\Uone}{\mathrm{U}(1)}
\newcommand{\pione}{\pi_1}

\title{Geometric Origin of CP Phases from Hyperbolic Holonomy}
\author{Marvin L.\ Gentry}
\date{}

\begin{document}
\maketitle

\begin{abstract}
We show that CP-violating phases arise naturally as geometric holonomy
invariants associated with closed geodesics in compact hyperbolic
3-manifolds. For a discrete group acting properly discontinuously and
cocompactly on $\mathbb{H}^3$, an orientation-reversing isometry induces
complex conjugation on all holonomy phases of a fixed background
$\mathrm{U}(1)$ connection. Any geodesic whose holonomy is not $\pm 1$
therefore witnesses CP violation that is rephasing-invariant, topologically
stable, and independent of continuous parameter tuning. We make the
argument precise, prove a clean stability theorem for flat connections,
and illustrate the mechanism with the Weeks manifold.
\end{abstract}

\section{Introduction}

CP violation in the Standard Model is parametrized by complex phases in
Yukawa couplings or mixing matrices. Rephasing-invariant combinations such
as the Jarlskog invariant~\cite{Jarlskog} isolate the physical content, but
their origin remains unexplained by the Standard Model itself. In this paper
we show that CP-violating phases can arise from geometry alone, without
assumptions about flavor dynamics or continuous parameter choices.

The mechanism is simple. In a compact hyperbolic 3-manifold $M$ every
closed geodesic carries a holonomy phase of a background $\Uone$
connection. If $M$ admits an orientation-reversing isometry $\Theta$, then
$\Theta$ acts on each holonomy by complex conjugation: the phase flips sign.
A geodesic with holonomy $W(\gamma)\notin\{\pm1\}$ therefore provides an
observable that distinguishes geometry from its mirror image.

The paper is organized as follows. Section~2 sets up hyperbolic holonomy.
Section~3 proves the orientation-reversal lemma and the main CP theorem.
Section~4 establishes rephasing invariance. Section~5 proves topological
stability for flat connections. Section~6 discusses the Weeks manifold
example. Section~7 discusses future directions.

\section{Hyperbolic Holonomy}

Let $\GammaG$ be a torsion-free discrete group acting properly
discontinuously and cocompactly on $\Hthree$ by orientation-preserving
isometries, so that $M=\Hthree/\GammaG$ is a compact oriented hyperbolic
3-manifold. Fix a basepoint $x_0\in M$.

\begin{definition}[Closed geodesic]\label{def:geodesic}
A \emph{closed geodesic} in $M$ corresponds to a nontrivial conjugacy class
$[\gamma]\subset\GammaG$ where $\gamma$ is a hyperbolic element. Its length
is $\ell(\gamma)=d(x,\gamma\cdot x)$ for any $x$ on the axis.
\end{definition}

Let $A$ be a fixed smooth $\Uone$ connection on $M$. Its holonomy around a
loop $c$ based at $x_0$ is
\begin{equation}\label{eq:holonomy}
W(c)=\exp\!\Bigl(i\oint_c A\Bigr)\in\Uone.
\end{equation}
Since $\Uone$ is abelian, $W(c)$ depends only on the free homotopy class
of $c$; we write $W(\gamma)$ for this invariant.

\section{Orientation Reversal and CP}

Let $\Theta\colon M\to M$ be an orientation-reversing isometry.

\begin{lemma}[Holonomy conjugation under orientation reversal]
\label{lem:hol-conj}
Let $A$ be a fixed background $\Uone$ connection on $M$, and let
$\Theta\colon M\to M$ be an orientation-reversing isometry. For every
hyperbolic $\gamma\in\GammaG$,
\begin{equation}
W\!\bigl(\Theta(\gamma)\bigr)=W(\gamma)^{-1}=\overline{W(\gamma)}.
\end{equation}
\end{lemma}

\begin{proof}
\textbf{Step~1 (geometric).} Since $\Theta$ is an isometry, it maps the
closed geodesic $c_\gamma$ to the closed geodesic $c_{\Theta(\gamma)}$ of
the same length.

\textbf{Step~2 (orientation).} Since $\Theta$ reverses orientation, it
reverses the orientation of every curve. Therefore
\begin{equation}
\oint_{\Theta(c_\gamma)}A=\oint_{c_\gamma}\Theta^*A=-\oint_{c_\gamma}A,
\end{equation}
where the second equality uses $\Theta^*A=-A$ for an orientation-reversing
isometry acting on a $\Uone$ connection.
Exponentiating gives
$W(\Theta(\gamma))=W(\gamma)^{-1}=\overline{W(\gamma)}$.
\end{proof}

\begin{theorem}[Geometric CP violation]\label{thm:CP}
Fix a background $\Uone$ connection $A$ on $M$. If $M$ admits an
orientation-reversing isometry $\Theta$ and there exists a hyperbolic
$\gamma\in\GammaG$ with $W(\gamma)\notin\{\pm1\}$, then
$\arg W(\gamma)\neq0,\pi$ is a rephasing-invariant observable that changes
sign under $\Theta$.
\end{theorem}

\begin{proof}
We work with a fixed background connection $A$; we do not optimize over
the space of connections. The Wilson loop $W(\gamma)$ is invariant under
all local gauge transformations $A\to A+d\lambda$ because
$\oint d\lambda=\lambda(x_0)-\lambda(x_0)=0$. By Lemma~\ref{lem:hol-conj},
$\arg W(\Theta(\gamma))=-\arg W(\gamma)$. If $W(\gamma)\notin\{\pm1\}$ the
phase is nonzero and no field redefinition can simultaneously set it to zero
and respect the geometry.
\end{proof}

\section{Rephasing Invariance}

\begin{proposition}[Rephasing invariance]\label{prop:rephasing}
Holonomy phases $W(\gamma)$ are invariant under all smooth $\Uone$ gauge
transformations $A\mapsto A+d\lambda$.
\end{proposition}

\begin{proof}
$W(\gamma)\mapsto W(\gamma)\cdot\exp(i\oint_{c_\gamma}d\lambda)
=W(\gamma)\cdot e^{i(\lambda(x_0)-\lambda(x_0))}=W(\gamma)$.
\end{proof}

\section{Topological Stability for Flat Connections}

\begin{theorem}[Topological stability]\label{thm:stability}
Let $A$ be a flat $\Uone$ connection on $M$, classified by a representation
$\rho\colon\pione(M)\to\Uone$. For any hyperbolic $\gamma\in\GammaG$,
$W(\gamma)=\rho([\gamma])$, which:
\begin{enumerate}
\item[\emph{(i)}] is invariant under all metric deformations preserving
topological type;
\item[\emph{(ii)}] is invariant under continuous deformations of $A$ within
its gauge equivalence class;
\item[\emph{(iii)}] gives a stable CP-odd observable under any deformation
satisfying \emph{(i)}, \emph{(ii)}, and preserving $\Theta$.
\end{enumerate}
\end{theorem}

\begin{proof}
For a flat connection, parallel transport depends only on homotopy class, so
$W(\gamma)=\rho([\gamma])$ is purely topological. Statement~(i): metric
deformations do not change $\pione(M)$ or $\rho$. Statement~(ii): within a
gauge class, $\rho$ is constant. Statement~(iii) follows from Theorem~\ref{thm:CP}.
\end{proof}

\section{Example: The Weeks Manifold}

The Weeks manifold~\cite{Weeks} is the compact hyperbolic 3-manifold of
smallest known volume ($v\approx0.9427$). It admits an orientation-reversing
involution~\cite{GoodmanEtAl}, and its first homology is
$H_1(M_W;\mathbb{Z})\cong\mathbb{Z}/5\oplus\mathbb{Z}/5\oplus\mathbb{Z}/5$
\cite{SnapPy}, admitting nontrivial characters $\chi\colon H_1\to\Uone$
sending generators to fifth roots of unity. Setting
$W(\gamma)=e^{2\pi i/5}$ for an appropriate generator gives
$\arg W(\gamma)=2\pi/5\neq0,\pi$, realizing a geometric CP-odd observable.

\section{Relation to Physical CP Observables: Outlook}

The geometric mechanism described here produces rephasing-invariant,
topologically stable CP-odd phases. In a concrete physical model such phases
could arise from a hidden-sector $\Uone$ gauge field whose holonomy around
compact extra dimensions enters effective Yukawa couplings through boundary
conditions. The holonomy phases would then contribute to rephasing invariants
such as the Jarlskog determinant~\cite{Jarlskog}. Constructing a realistic
embedding is a substantial further project left for future investigation.

\section{Conclusion}

We have shown that CP violation can arise from geometry: holonomy phases of
a background $\Uone$ connection on a compact hyperbolic 3-manifold, combined
with an orientation-reversing isometry, produce rephasing-invariant CP-odd
observables. For flat connections these phases are topological invariants
stable under all metric deformations. The Weeks manifold provides a concrete
example realizing the mechanism at fifth roots of unity. The construction
requires no continuous parameter tuning and applies to any compact hyperbolic
3-manifold admitting both a nontrivial flat $\Uone$ connection and an
orientation-reversing isometry.

\bibliographystyle{plain}
\bibliography{paper3}

\end{document}
'@

# ============================================================
# PAPER 6 — Discrete Shape Space and Integer Logarithmic Lattices
# ============================================================
Write-Host "`nWriting Paper 6..." -ForegroundColor Yellow

Write-File "$root\papers\paper6-shapespace\paper6.bib" @'
@book{ratcliffe,
  author    = {J. G. Ratcliffe},
  title     = {Foundations of Hyperbolic Manifolds},
  publisher = {Springer},
  year      = {2006}
}
@book{coxeter,
  author    = {H. S. M. Coxeter},
  title     = {Regular Polytopes},
  publisher = {Dover},
  year      = {1973}
}
@book{weyl,
  author    = {H. Weyl},
  title     = {The Classical Groups},
  publisher = {Princeton University Press},
  year      = {1946}
}
@book{neukirch,
  author    = {J. Neukirch},
  title     = {Algebraic Number Theory},
  publisher = {Springer},
  year      = {1999}
}
'@

Write-File "$root\papers\paper6-shapespace\paper6.tex" @'
\documentclass[12pt]{article}
\usepackage{amsmath,amssymb,amsfonts,amsthm}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

\newcommand{\R}{\mathbb{R}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\Q}{\mathbb{Q}}
\newcommand{\End}{\mathrm{End}}
\newcommand{\Endzero}{\mathrm{End}^{\,\mathrm{tr}=0}}
\renewcommand{\varphi}{\varphi}

\title{Discrete Shape Space and Integer Logarithmic Lattices}
\author{Marvin L.\ Gentry}
\date{}

\begin{document}
\maketitle

\begin{abstract}
Many physical and geometric observables are inherently multiplicative:
their ratios, not their absolute values, carry intrinsic meaning. When
expressed in logarithmic coordinates, an overall additive shift is
physically redundant. Removing this redundancy defines a quotient space
we call \emph{shape space}. We show that for quadratic descriptions of
rank~$n$, the number of independent scale-free deformation directions
is exactly $n^2-1$, the dimension of the traceless endomorphism space
$\mathrm{End}^{\,\mathrm{tr}=0}(V)$. For $n=3,4,5$ this yields $8,15,24$.
We establish this as a formal proposition with proof, note its coincidence
with adjoint representation dimensions of $\mathrm{SU}(n)$, and discuss
how golden-ratio-saturated geometries provide examples in which quadratic
invariants remain within the rank-2 integer module $\Z[\varphi]$.
\end{abstract}

\section{Introduction}

Many quantities of physical and geometric interest span many orders of
magnitude. Their ratios, not their absolute values, carry the meaningful
information. This suggests working in logarithmic coordinates, where
multiplicative relationships become additive. The space of logarithmic
coordinates carries a redundancy: an overall additive constant corresponds
to a simultaneous rescaling of all quantities. Factoring out this redundancy
leads to \emph{shape space}.

In this paper we study the structure of shape space for quadratic data.
Our central result (Proposition~\ref{prop:dim}) is that the space of
independent scale-free deformation directions for a rank-$n$ quadratic
description has dimension $n^2-1$, following from the rank-nullity theorem
applied to the trace map on endomorphisms.

\section{Logarithmic Coordinates and Shape Space}

\begin{definition}[Shape space]\label{def:shapespace}
The \emph{shape space} associated with $N$ positive quantities is the
quotient $\mathcal{S}_N=\R^N/\R\mathbf{1}$, where
$\R\mathbf{1}=\{(t,\ldots,t):t\in\R\}$. It has dimension $N-1$.
\end{definition}

\section{The $n^2-1$ Count}

Infinitesimal deformations of quadratic data on an $n$-dimensional space
are represented by endomorphisms $T\colon V\to V$. Uniform rescalings
$T=\lambda I$ are shape-redundant and must be quotiented out.

\begin{proposition}[Dimension of shape-space deformations]
\label{prop:dim}
The space of independent scale-free deformation directions of a rank-$n$
quadratic description is
\[
\dim\Endzero(V)=n^2-1,
\]
where $\Endzero(V)=\{T\in\End(V):\operatorname{tr}T=0\}$.
\end{proposition}

\begin{proof}
The trace map $\operatorname{tr}\colon\End(V)\to k$ is surjective with
kernel $\Endzero(V)$. By the rank-nullity theorem,
$\dim\Endzero(V)=\dim\End(V)-1=n^2-1$.
The canonical splitting $\End(V)=\Endzero(V)\oplus k\cdot I$ confirms
that $\Endzero(V)$ is exactly the scale-free quotient.
\end{proof}

\begin{corollary}
For ranks $n=3,4,5$ the independent deformation count is $8,15,24$.
\end{corollary}

\begin{remark}[Relation to $\mathrm{SU}(n)$ adjoint representations]
\label{rem:sun}
The integers $n^2-1$ are also the dimensions of the adjoint representations
of $\mathrm{SU}(n)$: $\dim\mathfrak{su}(3)=8$, $\dim\mathfrak{su}(4)=15$,
$\dim\mathfrak{su}(5)=24$. The Lie algebra $\mathfrak{su}(n)$ consists of
skew-Hermitian traceless $n\times n$ matrices, the complex analogue of the
real traceless endomorphisms here. The present derivation reaches the same
count from scale-free shape space without invoking any symmetry assumption.
\end{remark}

\section{Golden-Ratio Closure and Quadratic Invariants}

Many discrete geometries involve the golden ratio $\varphi=(1+\sqrt5)/2$,
which satisfies $\varphi^2=\varphi+1$. The set
$\Z[\varphi]=\{a+b\varphi:a,b\in\Z\}$ is a commutative ring (the ring
of integers of $\Q(\sqrt5)$~\cite{neukirch}).

\begin{proposition}[Quadratic closure of $\Z[\varphi]$]
\label{prop:closure}
Let $T\in M_n(\Z[\varphi])$. Then $\operatorname{tr}(T^2)\in\Z[\varphi]$.
More generally, all polynomial invariants of $T$ with integer coefficients
lie in $\Z[\varphi]$.
\end{proposition}

\begin{proof}
$\Z[\varphi]$ is a commutative ring closed under addition and multiplication.
The $(i,j)$ entry of $T^2$ is $\sum_k T_{ik}T_{kj}\in\Z[\varphi]$, and
$\operatorname{tr}(T^2)=\sum_i(T^2)_{ii}\in\Z[\varphi]$. The argument
for general polynomial invariants is identical.
\end{proof}

\begin{remark}[Scope of Proposition~\ref{prop:closure}]
Proposition~\ref{prop:closure} establishes that if deformation data lies
in $\Z[\varphi]$, then quadratic invariants also lie in $\Z[\varphi]$.
It does not select the values $n=3,4,5$; those come from
Proposition~\ref{prop:dim}. The role of $\Z[\varphi]$ is algebraic
closure, not geometric selection.
\end{remark}

\section{Orientation and Signed Directions}

\begin{definition}[Orientation-reversed deformation]
Let $T\in\Endzero(V)$. The \emph{orientation-reversed} deformation is
$-T\in\Endzero(V)$. In a Hermitian setting one may use the adjoint $T^\dagger$,
which reverses orientation while preserving norm.
\end{definition}

Signed integer coefficients in logarithmic coordinates have direct geometric
meaning: $+k$ represents $k$ steps forward along a deformation axis,
$-k$ represents $k$ steps in reverse.

\section{Scope and Generalization}

The derivation in Section~3 uses only finite dimensionality of $\End(V)$
and surjectivity of the trace map. It does not depend on any specific group,
representation, or geometric realization. For other discrete geometries
the role of $\Z[\varphi]$ in Proposition~\ref{prop:closure} is replaced by
the appropriate ring of integers of the relevant quadratic field; the
formula $n^2-1$ remains universal.

\section{Conclusion}

We have shown that $n^2-1$ arises as the dimension of the space of
independent scale-free deformation directions for a rank-$n$ quadratic
description, proved by rank-nullity alone. For $n=3,4,5$ this gives
$8,15,24$. Golden-ratio-saturated geometries provide examples where all
quadratic invariants remain within $\Z[\varphi]$ by ring closure. The
construction is independent of any specific physical model.

\bibliographystyle{plain}
\bibliography{paper6}

\end{document}
'@

# ============================================================
# PAPER 2 — Uniqueness and Operator Realization
# ============================================================
Write-Host "`nWriting Paper 2..." -ForegroundColor Yellow

Write-File "$root\papers\paper2-uniqueness\paper2.bib" @'
@book{bridsonhaefliger,
  author    = {M. R. Bridson and A. Haefliger},
  title     = {Metric Spaces of Non-Positive Curvature},
  publisher = {Springer},
  year      = {1999}
}
@article{gromov,
  author  = {M. Gromov},
  title   = {Hyperbolic Groups},
  booktitle = {Essays in Group Theory},
  series  = {MSRI Publications},
  volume  = {8},
  publisher = {Springer},
  year    = {1987}
}
@book{ratcliffe,
  author    = {J. G. Ratcliffe},
  title     = {Foundations of Hyperbolic Manifolds},
  publisher = {Springer},
  year      = {2006}
}
@book{maskit,
  author    = {B. Maskit},
  title     = {Kleinian Groups},
  publisher = {Springer},
  year      = {1988}
}
'@

Write-File "$root\papers\paper2-uniqueness\paper2.tex" @'
\documentclass[12pt]{article}
\usepackage{amsmath,amssymb,amsfonts,amsthm}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{assumption}[theorem]{Assumption}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

\newcommand{\Hthree}{\mathbb{H}^3}
\newcommand{\GammaG}{\Gamma}
\newcommand{\R}{\mathbb{R}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\bdry}{\partial\mathbb{H}^3}

\title{Uniqueness and Operator Realization\\on Hyperbolic Logarithmic Lattices}
\author{Marvin L.\ Gentry}
\date{}

\begin{document}
\maketitle

\begin{abstract}
Let $\GammaG$ be a hyperbolic Coxeter group acting properly discontinuously
and cocompactly on $\mathbb{H}^3$. We assign to each group element $\gamma$
a logarithmic weight $q(\gamma)=\kappa\,d(0,\gamma\cdot0)$. We prove three
structural results: (1) each boundary direction $\xi\in\bdry$ admits a
unique minimal representative in $\GammaG$ (torsion-free case: exactly
unique); (2) there is a uniform positive gap $\Delta>0$ between any two
distinct values in the weight spectrum; (3) integer coordinates defined via
the Milnor--\v{S}varc quasi-isometry are stable under bounded deformations
of the boundary configuration. All results follow from hyperbolicity, proper
discontinuity, and the classification of isometries of $\mathbb{H}^3$.
\end{abstract}

\section{Introduction}

Discrete logarithmic hierarchies appear in warped geometries, renormalization
group flows, and bulk-boundary correspondences. A physically useful framework
must explain why each weight supports a unique dominant contribution, why
subleading contributions are suppressed by a definite amount, and why the
organization is stable under perturbations. We show all three properties
follow from the geometry of a cocompact group action on hyperbolic space.

Our three main results are: \textbf{uniqueness}
(Theorem~\ref{thm:uniqueness}), \textbf{uniform gap} (Lemma~\ref{lem:gap}),
and \textbf{coordinate rigidity} (Theorem~\ref{thm:rigidity}).

\section{Geometric Setting}

\begin{assumption}\label{ass:action}
$\GammaG$ is torsion-free, acting properly discontinuously and cocompactly
on $\Hthree$ by orientation-preserving isometries. Fix basepoint $0\in\Hthree$.
\end{assumption}

For $\gamma\in\GammaG$ set $q(\gamma)=\kappa\,d(0,\gamma\cdot0)$, $\kappa>0$.

\begin{definition}[Isometry types]\label{def:types}
An isometry $\delta\in\mathrm{Isom}(\Hthree)$ is \emph{elliptic} if it
fixes a point in $\Hthree$; \emph{parabolic} if it fixes exactly one point
on $\bdry$ and no point in $\Hthree$; \emph{hyperbolic} if it fixes exactly
two points on $\bdry$ and translates along the geodesic connecting them.
\end{definition}

\begin{lemma}[Parabolic elements increase distance]\label{lem:parabolic}
A cocompact group $\GammaG$ contains no parabolic elements~\cite{ratcliffe}.
\end{lemma}

\section{Boundary Directions and Minimal Representatives}

\begin{definition}[Boundary direction]\label{def:bdrydir}
A \emph{boundary direction} is a point $\xi\in\bdry\cong\mathbb{S}^2$.
We say $\gamma\in\GammaG$ \emph{converges to} $\xi$ if the geodesic ray
from $0$ through $\gamma\cdot0$ has $\xi$ as its ideal endpoint.
\end{definition}

\begin{definition}[Minimal representative]\label{def:minimal}
$\gamma\in\GammaG$ is a \emph{minimal representative} for $\xi$ if it
converges to $\xi$ and $q(\gamma)=\inf\{q(\gamma'):\gamma'\text{ converges to }\xi\}$.
\end{definition}

\section{Uniqueness of Minimal Representatives}

\begin{theorem}[Uniqueness]\label{thm:uniqueness}
Let $\gamma_1,\gamma_2\in\GammaG$ be two minimal representatives for
$\xi\in\bdry$. Then $\delta:=\gamma_1^{-1}\gamma_2$ is elliptic. Since
$\GammaG$ is torsion-free, $\delta=\mathrm{id}$ and $\gamma_1=\gamma_2$.
\end{theorem}

\begin{proof}
Since $\gamma_1$ and $\gamma_2$ both converge to $\xi$, the element
$\delta=\gamma_1^{-1}\gamma_2$ fixes $\xi\in\bdry$. An isometry fixing a
boundary point is either elliptic or parabolic. Since $\GammaG$ is cocompact
it contains no parabolic elements (Lemma~\ref{lem:parabolic}). Hence $\delta$
is elliptic. Since $\GammaG$ is torsion-free the only elliptic element is
the identity, so $\delta=\mathrm{id}$ and $\gamma_1=\gamma_2$.
\end{proof}

\section{The Uniform Suppression Gap}

\begin{lemma}[Uniform gap]\label{lem:gap}
There exists $\Delta>0$ such that any two distinct elements
$\gamma,\gamma'\in\GammaG$ satisfy $|q(\gamma)-q(\gamma')|\geq\Delta$.
\end{lemma}

\begin{proof}
The orbit $\GammaG\cdot0$ is discrete by proper discontinuity. The systole
$\Delta_0=\min_{\gamma\neq\mathrm{id}}d(0,\gamma\cdot0)>0$, and
$\Delta=\kappa\Delta_0$.
\end{proof}

\begin{corollary}[Uniform suppression]
Every subleading operator satisfies $q(\gamma')\geq q(\gamma)+\Delta$.
\end{corollary}

\section{Integer Coordinates and the Milnor--\v{S}varc Quasi-isometry}

\begin{definition}[Integer coordinates]\label{def:intcoords}
Fix a finite generating set $\mathcal{S}=\{s_1,s_2,s_3\}$ for $\GammaG$.
The integer coordinates $(a,b,c)\in\Z^3$ of $\gamma$ are the net counts
of each generator in a reduced word: $a=n_1(\gamma)-n_1^-(\gamma)$, etc.
\end{definition}

\begin{proposition}[Milnor--\v{S}varc quasi-isometry]
\label{prop:msvarcqi}
Since $\GammaG$ acts properly discontinuously and cocompactly on $\Hthree$,
the orbit map $\gamma\mapsto\gamma\cdot0$ is a quasi-isometry
$(\GammaG,d_\mathcal{S})\to(\Hthree,d)$~\cite{bridsonhaefliger}.
\end{proposition}

\section{Coordinate Rigidity under Bounded Deformations}

\begin{definition}[Bounded deformation]\label{def:deform}
A \emph{bounded deformation of magnitude $\varepsilon$} perturbs each
boundary direction $\xi(f)$ to $\xi'(f)$ with
$d_{\mathbb{S}^2}(\xi(f),\xi'(f))\leq\varepsilon$.
\end{definition}

\begin{theorem}[Coordinate rigidity]\label{thm:rigidity}
For $\varepsilon\leq\varepsilon_0:=\tfrac12\min_{f\neq f'}
d_{\mathbb{S}^2}(\xi(f),\xi(f'))$, each minimal representative
$\gamma_\xi$ and its integer coordinates $(a,b,c)$ are unchanged.
\end{theorem}

\begin{proof}
For $\varepsilon\leq\varepsilon_0$, perturbed directions $\xi'(f)$ and
$\xi'(f')$ remain distinct and each $\xi'(f)$ lies closer to $\xi(f)$
than to any other direction. Hence the minimal representative for $\xi'(f)$
equals that for $\xi(f)$.
\end{proof}

\section{Conclusion}

Hyperbolic logarithmic lattices arising from cocompact group actions on
$\Hthree$ are rigid in three ways: unique minimal representatives, uniform
positive gap between weight values, and stable integer coordinates under
small deformations. These properties hold for any cocompact torsion-free
group and require no external dynamical assumptions.

\bibliographystyle{plain}
\bibliography{paper2}

\end{document}
'@

# ============================================================
# PAPER 4 — Flavor Mixing from Boundary Misalignment
# ============================================================
Write-Host "`nWriting Paper 4..." -ForegroundColor Yellow

Write-File "$root\papers\paper4-mixing\paper4.bib" @'
@article{Jarlskog,
  author  = {C. Jarlskog},
  title   = {A Basis Independent Formulation of the Connection Between
             Quark Mass Matrices, {CP} Violation and Experiment},
  journal = {Z. Phys. C},
  volume  = {29},
  pages   = {491},
  year    = {1985}
}
@book{bridsonhaefliger,
  author    = {M. R. Bridson and A. Haefliger},
  title     = {Metric Spaces of Non-Positive Curvature},
  publisher = {Springer},
  year      = {1999}
}
@book{ratcliffe,
  author    = {J. G. Ratcliffe},
  title     = {Foundations of Hyperbolic Manifolds},
  publisher = {Springer},
  year      = {2006}
}
@article{PDGreview,
  author  = {R. L. Workman and others},
  title   = {Review of Particle Physics},
  journal = {Prog. Theor. Exp. Phys.},
  volume  = {2022},
  pages   = {083C01},
  year    = {2022}
}
'@

Write-File "$root\papers\paper4-mixing\paper4.tex" @'
\documentclass[12pt]{article}
\usepackage{amsmath,amssymb,amsfonts,amsthm}
\usepackage{braket}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{corollary}[theorem]{Corollary}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{assumption}[theorem]{Assumption}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

\newcommand{\Hthree}{\mathbb{H}^3}
\newcommand{\Sphere}{\mathbb{S}^2}
\newcommand{\GammaG}{\Gamma}
\newcommand{\U}{\mathrm{U}}
\newcommand{\calH}{\mathcal{H}}
\newcommand{\calHS}{\mathcal{H}_S}
\newcommand{\calHT}{\mathcal{H}_T}

\title{Flavor Mixing from Boundary Misalignment\\in Hyperbolic Geometry}
\author{Marvin L.\ Gentry}
\date{}

\begin{document}
\maketitle

\begin{abstract}
We formalize a kinematic mechanism by which fermion mixing matrices arise
from the misalignment between discrete boundary sectors associated with
logarithmic mass organization in hyperbolic space. Mixing matrices are
defined as overlap operators between preferred orthonormal bases of sector
subspaces and are shown to be uniquely determined up to sector-local
rephasings. Our main result (Theorem~\ref{thm:discrete-classes}) establishes
that the set of accessible mixing matrices is discrete in $\U(n)$ modulo
sector-local rephasings, providing a structural explanation for the
stability of mixing patterns without continuous parameter tuning.
\end{abstract}

\section{Introduction}

The Standard Model fermion mixing matrices exhibit stable, non-generic
patterns unexplained by gauge structure alone. We develop a kinematic
explanation: mixing arises from the misalignment between boundary sectors
naturally associated with discrete logarithmic mass organization.

If fermion mass scales are organized near a discrete logarithmic lattice,
each fermion is associated with a definite direction on the boundary sphere
$\bdry\cong\Sphere$. Different generations of a given sector span different
subspaces of a boundary Hilbert space $\calH$; their overlap is the mixing
matrix. The key structural result is that if boundary directions are assigned
by a \emph{discrete} selection rule, the set of accessible mixing matrices
is itself discrete (Theorem~\ref{thm:discrete-classes}).

\section{Geometric Setup and the Discreteness Assumption}

\begin{definition}[Boundary direction]\label{def:bdrydir}
A \emph{boundary direction} is a point $\xi\in\bdry\cong\Sphere$.
Group elements $\gamma\in\GammaG$ are \emph{associated with} $\xi$ when
the geodesic ray from basepoint $0$ through $\gamma\cdot0$ converges to~$\xi$.
\end{definition}

\begin{assumption}[Discrete sector assignment]\label{ass:discrete}
Each fermion flavor $f\in F$ is assigned a unique boundary direction
$\xi(f)\in\bdry$ by a deterministic, discrete selection rule: the image
$\Xi=\{\xi(f):f\in F\}$ is finite, and the assignment is locally rigid.
One concrete realization: $\xi(f)$ is the ideal endpoint of the geodesic
ray to the minimal representative $\gamma_f\cdot0$, whose uniqueness and
rigidity follow from the companion paper on operator realization.
\end{assumption}

\section{Boundary Hilbert Space and Localized States}

\begin{definition}[Boundary-localized state]\label{def:localized}
For each $\xi\in\Sphere$, fix a normalized state $\ket{\xi}\in\calH$
with $\langle\xi|\xi\rangle=1$, depending continuously on $\xi$, with
$\langle\xi|\zeta\rangle=1$ iff $\xi=\zeta$.
\end{definition}

\section{Sector Subspaces and Preferred Bases}

\begin{definition}[Sector subspace]\label{def:sectorspan}
The \emph{sector subspace} of $S$ is
$\calHS=\overline{\mathrm{span}}\{\ket{\xi(f)}:f\in S\}\subset\calH$,
with $\dim\calHS=|S|$ by linear independence.
\end{definition}

\begin{definition}[Preferred orthonormal basis]\label{def:preferred}
The \emph{preferred ONB} of $\calHS$ is the Gram--Schmidt
orthonormalization of $(\ket{\xi(f_1)},\ldots,\ket{\xi(f_{n_S})})$
in the fixed sector ordering, with all pivot coefficients real and positive.
\end{definition}

\section{Mixing Matrices as Overlap Operators}

\begin{definition}[Mixing matrix]\label{def:mixing}
For sectors $S$, $T$ of equal cardinality $n$ with preferred ONBs
$\{\ket{S,i}\}$ and $\{\ket{T,j}\}$, the \emph{mixing matrix} is
$(U_{ST})_{ji}=\braket{T,j|S,i}$.
\end{definition}

\begin{proposition}[Unitarity]\label{prop:unitary}
If $\calHS=\calHT$, then $U_{ST}\in\U(n)$.
\end{proposition}

\begin{theorem}[Geometric dependence]\label{thm:geom}
$U_{ST}$ is determined entirely by $\Xi_{ST}=\{\xi(f):f\in S\cup T\}$
and the inner product on $\calH$.
\end{theorem}

\section{Rephasing Invariance}

\begin{proposition}[Rephasing-invariant quantities]\label{prop:rephinv}
Under sector-local rephasings $\ket{S,i}\mapsto e^{i\alpha_i}\ket{S,i}$,
$\ket{T,j}\mapsto e^{i\beta_j}\ket{T,j}$, the following are invariant:
\emph{(i)} the moduli $|(U_{ST})_{ji}|^2$;
\emph{(ii)} the quartic products
$J_{ji,j'i'}=(U_{ST})_{ji}(U_{ST})_{j'i'}\overline{(U_{ST})_{ji'}}\,\overline{(U_{ST})_{j'i}}$;
\emph{(iii)} $\det(U_{ST})$ up to overall phase.
\end{proposition}

\section{Discreteness and Stability of Mixing Classes}

\begin{theorem}[Stability]\label{thm:stability}
For $\varepsilon\leq\varepsilon_0=\delta_{\min}/2$, where
$\delta_{\min}=\min_{f\neq f'}d_\Sphere(\xi(f),\xi(f'))$, any bounded
deformation of magnitude $\varepsilon$ leaves $\Xi$, the preferred bases,
and $U_{ST}$ unchanged.
\end{theorem}

\begin{theorem}[Discreteness of mixing classes]\label{thm:discrete-classes}
Under Assumption~\ref{ass:discrete}, the set of accessible mixing matrices
$\mathcal{M}_{ST}$ is discrete in $\U(n)/(\U(1)^n\times\U(1)^n)$.
\end{theorem}

\begin{proof}
The set of admissible configurations $\Xi_{ST}$ is finite (discrete).
By Theorem~\ref{thm:geom}, the map $\Xi_{ST}\mapsto U_{ST}$ is continuous,
so it maps a finite set to a finite set. Quotienting by rephasings
preserves finiteness.
\end{proof}

\begin{corollary}[No continuous drift]\label{cor:nodrift}
No continuous deformation of physical parameters can produce continuous
drift in any rephasing-invariant mixing observable.
\end{corollary}

\section{Conclusion}

We have shown that fermion mixing matrices arising from boundary-sector
misalignment are unitary by construction, rephasing-invariant, stable under
bounded deformations, and discrete modulo rephasings. These properties are
structural consequences of the discrete selection rule and require no
dynamical input or continuous tuning.

\bibliographystyle{plain}
\bibliography{paper4}

\end{document}
'@

# ============================================================
# PAPER 7 — EFT Framework and Spectrum Obstruction
# ============================================================
Write-Host "`nWriting Paper 7..." -ForegroundColor Yellow

Write-File "$root\papers\paper7-eft\paper7.bib" @'
@article{PDGreview,
  author  = {R. L. Workman and others},
  title   = {Review of Particle Physics},
  journal = {Prog. Theor. Exp. Phys.},
  volume  = {2022},
  pages   = {083C01},
  year    = {2022}
}
@article{FroggattNielsen,
  author  = {C. D. Froggatt and H. B. Nielsen},
  title   = {Hierarchy of Quark Masses, Cabibbo Angles and {CP} Violation},
  journal = {Nucl. Phys. B},
  volume  = {147},
  pages   = {277},
  year    = {1979}
}
@article{AltarelliFeruglio,
  author  = {G. Altarelli and F. Feruglio},
  title   = {Discrete Flavor Symmetries and Models of Neutrino Mixing},
  journal = {Rev. Mod. Phys.},
  volume  = {82},
  pages   = {2701},
  year    = {2010}
}
@article{KingLuhn,
  author  = {S. F. King and C. Luhn},
  title   = {Neutrino Mass and Mixing with Discrete Symmetry},
  journal = {Rept. Prog. Phys.},
  volume  = {76},
  pages   = {056201},
  year    = {2013}
}
@article{Jarlskog,
  author  = {C. Jarlskog},
  title   = {A Basis Independent Formulation of the Connection Between
             Quark Mass Matrices, {CP} Violation and Experiment},
  journal = {Z. Phys. C},
  volume  = {29},
  pages   = {491},
  year    = {1985}
}
'@

Write-File "$root\papers\paper7-eft\paper7.tex" @'
\documentclass[11pt]{article}
\usepackage{amsmath,amssymb,amsfonts,amsthm}
\usepackage{booktabs}
\usepackage{hyperref}
\usepackage{geometry}
\geometry{margin=1in}

\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{remark}[theorem]{Remark}
\newtheorem{corollary}[theorem]{Corollary}

\newcommand{\R}{\mathbb{R}}
\newcommand{\Z}{\mathbb{Z}}

\title{Uniqueness-First Effective Field Theory Realization\\
of Logarithmic Mass Lattices:\\
Framework, Feasibility, and the Spectrum Obstruction}
\author{Marvin L.\ Gentry}
\date{}

\begin{document}
\maketitle

\begin{abstract}
We present a minimal effective field theory framework in which fermion mass
hierarchies are organized by a discrete logarithmic lattice. Each mass
arises from a unique leading operator, fixed by a shaping symmetry and a
finite set of spurions and their conjugates. We conduct a rigorous
feasibility analysis of the hypothesis that the nine charged Standard Model
fermion masses lie on a common three-generator integer lattice with
well-conditioned basis and small integer coordinates. The analysis identifies
a concrete obstruction: the near-coincidence of the strange-quark and muon
masses ($|\ln m_s-\ln m_\mu|\approx0.124$ natural units) combined with the
large dynamic range of the full spectrum ($\approx12.8$ natural log units)
forces either large coordinates, badly conditioned generators, or trivially
decoupled subsectors. Within the charged-lepton sector alone, a
one-generator fit with integer coordinates $(0,2,3)$ achieves a residual
of $5.8\%$ on the $\tau$ mass. We report these as the best results
currently achievable and identify what additional structure would be
required to extend them.
\end{abstract}

\section{Introduction}

Fermion masses in the Standard Model span roughly thirteen orders of
magnitude. In logarithmic coordinates, nontrivial regularities motivate a
careful organizational analysis. We ask whether these regularities are
captured by a discrete integer lattice: a finite set of basis vectors
$\{\lambda_i\}$ such that each fermion's logarithmic mass is well
approximated by $\sum_i n_i\lambda_i$ with small integers $n_i$.

This paper proceeds in two parts. Sections~\ref{sec:eft}--\ref{sec:cp}
develop the EFT framework independently of any specific numerical lattice.
Section~\ref{sec:feasibility} tests the simplest lattice hypothesis against
PDG data and proves a precise obstruction theorem.

\section{Uniqueness-First Operator Realization}
\label{sec:eft}

\subsection{Setup}

We work in logarithmic coordinates $q=\alpha\ln(m/m_0)$. We hypothesize
basis vectors $\{\lambda_1,\lambda_2,\lambda_3\}\subset\R_{>0}$ and integer
assignments $(a_f,b_f,c_f)\in\Z^3$ such that
\begin{equation}\label{eq:lattice}
q(m_f)\approx a_f\lambda_1+b_f\lambda_2+c_f\lambda_3.
\end{equation}

\subsection{Spurion framework}

A shaping symmetry $\mathcal{S}$ forbids renormalizable mass terms. Scalar
spurions $\{\Phi_i\}$ carry charges $Q_i$ under $\mathcal{S}$. Fermion
masses arise from operators
\begin{equation}\label{eq:operator}
\mathcal{O}_f=\frac{1}{\Lambda^{d-4}}\bar\psi_L H\psi_R
\prod_i\Phi_i^{\,n_i}(\Phi_i^\dagger)^{\bar n_i},
\end{equation}
giving $m_f\sim v\prod_i(\langle\Phi_i\rangle/\Lambda)^{n_i-\bar n_i}$.
Negative coordinates ($n_i-\bar n_i<0$) are realized by net conjugate
spurion insertions without inverse operators.

\subsection{Uniqueness}

\begin{theorem}[Uniqueness of leading operator]\label{thm:uniqueness}
Given fixed $\mathcal{S}$ and spurion set, the leading operator for each
fermion $f$ is unique.
\end{theorem}

\begin{proof}
The leading operator minimizes total spurion count $\sum_i(n_i+\bar n_i)$
subject to charge neutrality. Any other contribution involves additional
$\Phi_i\Phi_i^\dagger$ pairs and is suppressed by additional powers of
$\langle\Phi_i\rangle/\Lambda<1$.
\end{proof}

\section{Sector-by-Sector Analysis}
\label{sec:sectors}

Table~\ref{tab:coords} records the integer coordinate assignments. The
charged-lepton entries are established by the single-generator fit of
Section~\ref{sec:feasibility}. Quark entries are undetermined pending
resolution of the spectrum obstruction (Theorem~\ref{thm:obstruction}).

\begin{table}[h]
\centering
\begin{tabular}{llccc}
\toprule
Sector & Fermion & $a_f$ & $b_f$ & $c_f$ \\
\midrule
Charged leptons & $e$ & 0 & 0 & 0 \\
 & $\mu$ & 2 & 0 & 0 \\
 & $\tau$ & 3 & 0 & 0 \\
\midrule
Up-type quarks & $u$ & $a_u$ & $b_u$ & $c_u$ \\
 & $c$ & $a_c$ & $b_c$ & $c_c$ \\
 & $t$ & $a_t$ & $b_t$ & $c_t$ \\
\midrule
Down-type quarks & $d$ & $a_d$ & $b_d$ & $c_d$ \\
 & $s$ & $a_s$ & $b_s$ & $c_s$ \\
 & $b$ & $a_b$ & $b_b$ & $c_b$ \\
\bottomrule
\end{tabular}
\caption{Integer lattice coordinates. Lepton entries from
Proposition~\ref{prop:leptons}; quark entries undetermined
(see Theorem~\ref{thm:obstruction}).}
\label{tab:coords}
\end{table}

\begin{remark}[Neutrino sector]\label{rem:neutrinos}
Neutrino masses lie at $\ln(m_\nu/m_e)\approx-16$ to $-20$, requiring
large negative coordinates or a separate mechanism. We leave the neutrino
sector to a separate treatment.
\end{remark}

\section{Discrete CP/T Structure}
\label{sec:cp}

The plaquette invariant
\begin{equation}\label{eq:plaquette}
\Theta=\arg\!\left(\frac{Y_{12}Y_{23}Y_{31}}{Y_{13}Y_{21}Y_{32}}\right)
\end{equation}
is invariant under all independent rephasings. Since Yukawa phases belong
to a finite alphabet determined by $\mathcal{S}$, $\Theta$ is restricted
to a finite set: CP/T violation is discrete.

The \emph{cap inversion} map $\phi_{ij}\mapsto-\phi_{ij}$ sends
$\Theta\mapsto-\Theta$. By Lemma~3.1 of the companion paper on CP phases
from hyperbolic holonomy, orientation reversal of a closed geodesic induces
exactly this sign flip on holonomy phases. Cap inversion is therefore the
algebraic counterpart of geometric orientation reversal.

\section{Feasibility Analysis: The Spectrum Obstruction}
\label{sec:feasibility}

\subsection{Data}

\begin{table}[h]
\centering
\begin{tabular}{llrr}
\toprule
Sector & Fermion & $\ln(m_f/m_e)$ & $\ln(m_f/m_e)/\ln\varphi$ \\
\midrule
Charged leptons & $e$ & 0.000 & 0.000 \\
 & $\mu$ & 5.333 & 11.082 \\
 & $\tau$ & 7.944 & 16.507 \\
\midrule
Up quarks & $u$ & 1.441 & 2.994 \\
 & $c$ & 7.813 & 16.235 \\
 & $t$ & 12.818 & 26.637 \\
\midrule
Down quarks & $d$ & 2.212 & 4.596 \\
 & $s$ & 5.209 & 10.824 \\
 & $b$ & 8.999 & 18.698 \\
\bottomrule
\end{tabular}
\caption{Logarithmic mass coordinates relative to $m_e=0.51100$~MeV.
PDG~2022~\cite{PDGreview} central values.}
\label{tab:masses}
\end{table}

\subsection{The obstruction theorem}

\begin{theorem}[Spectrum obstruction]\label{thm:obstruction}
Let $\delta_{\min}=0.124$ (the $s$--$\mu$ separation) and
$q_{\max}=12.818$ (the top quark). Any three-generator integer lattice fit
to all nine charged fermion masses with residual $\varepsilon<\delta_{\min}/2$
and coordinate bound $N$ satisfies
\begin{equation}\label{eq:condbound}
\kappa:=\frac{\max_i\lambda_i}{\min_i\lambda_i}
\geq\frac{q_{\max}}{3N\,\delta_{\min}}
=\frac{34.46}{N}.
\end{equation}
For $N\leq6$ the basis is ill-conditioned ($\kappa>5$).
\end{theorem}

\begin{proof}
Since $\varepsilon<\delta_{\min}/2$, distinct fermions map to distinct
lattice points. The $s$--$\mu$ pair differs by $0.124$, forcing a nonzero
lattice vector of magnitude $<0.248$, so $\lambda_{\min}\leq0.248$. The
top quark at $q_{\max}=12.818$ with coordinates bounded by $N$ forces
$\lambda_{\max}\geq12.818/(3N)$. Dividing gives~\eqref{eq:condbound}.
\end{proof}

\subsection{Single-sector result}

\begin{proposition}[Charged-lepton fit]\label{prop:leptons}
With $\lambda_1=\ln(m_\mu/m_e)/2=2.6665$ and coordinates $(0,2,3)$:
the $e$ and $\mu$ are exact; the $\tau$ residual is
$|3\times2.6665-7.9440|=0.0555$, a mass ratio error of $5.7\%$.
The midpoint fit $\lambda_1=2.657$ gives $\pm1\%$ on each.
\end{proposition}

\section{Discussion and Outlook}

The uniqueness-first EFT framework and the spectrum obstruction theorem are
the primary results. The obstruction rules out the simplest discrete
generalization of Froggatt--Nielsen~\cite{FroggattNielsen} across all three
sectors simultaneously. The most structurally motivated path forward is
sector-specific generator subsets drawn from a common eight-dimensional
shape-space basis (see companion paper on discrete shape space), with
cross-sector near-coincidences explained by algebraic relations between
generators of different sectors. Connecting cap inversion explicitly to the
holonomy structure of the CP companion paper is a natural next step.

\section{Conclusion}

We have established the uniqueness-first EFT framework, the spectrum
obstruction theorem, and the best currently achievable single-sector
lattice result. The framework is falsifiable and we have reported the
results of the first feasibility test honestly. Extending to the full
spectrum requires additional structure identified in the obstruction proof.

\bibliographystyle{plain}
\bibliography{paper7}

\end{document}
'@

# ============================================================
# Git initialization
# ============================================================
Write-Host "`nInitializing git repository..." -ForegroundColor Yellow

Push-Location $root
git init
git add .
git commit -m "Initial commit: five-paper series, code, and VS Code config"
Pop-Location

Write-Host "`n=== Setup complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Create repo on GitHub named: hyperbolic-flavor-geometry"
Write-Host "  2. Run from C:\dev\framework\:"
Write-Host "       git remote add origin https://github.com/drmlgentry/hyperbolic-flavor-geometry.git"
Write-Host "       git branch -M main"
Write-Host "       git push -u origin main"
Write-Host ""
Write-Host "  3. Test compile Paper 3:"
Write-Host "       cd papers\paper3-holonomy"
Write-Host "       latexmk -pdf paper3.tex"
Write-Host ""
Write-Host "  4. Open C:\dev\framework\ in VS Code -- LaTeX Workshop will"
Write-Host "     auto-build on save once the extension is installed."