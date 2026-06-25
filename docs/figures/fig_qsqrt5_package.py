# fig_qsqrt5_package.py
# Four-figure package for the Q(sqrt(5)) Bianchi eigenvalue theorem
# Source from DS/GPT, to be built with HFG palette next session.
# Sequence: B -> F -> E -> C  (data -> theorem -> arithmetic -> interpretation)
#
# DATA (31 eigenvalues: p, a_p, k, A, B)
# p=31 excluded (conductor). Rational (k=0) points excluded from Figs F and C.

DATA = [
    # (p, a_p, k, A, B)
    (2,  -2, 4,  1,   -1),
    (3,  -1, 1,  0.5, -0.5),
    (5,   1, 0,  2,    0),       # rational
    (7,  -2, 3,  1,    1),
    (13,  4, 1, -2,    2),
    (17, -2, 2,  1,    1),
    (19,  0, 4,  0,    0),
    (23, -1, 2,  0.5,  0.5),
    (29,  0, 4,  0,    0),
    (37,  3, 0,  6,    0),       # rational
    (41, -8, 4,  4,   -4),
    (43, -6, 4,  3,   -3),
    (47,  8, 1, -4,    4),
    (53, -6, 2,  3,    3),
    (59,  5, 1, -2.5,  2.5),
    (61, 12, 0, 24,    0),       # rational, p_3
    (67, -7, 0,-14,    0),       # rational
    (71, -3, 2,  1.5,  1.5),
    (73,  4, 3, -2,   -2),
    (79,-10, 2,  5,    5),
    (83, -6, 4,  3,   -3),
    (89, 15, 3, -7.5, -7.5),
    (97, -7, 3,  3.5,  3.5),
    (101, 2, 2, -1,   -1),
    (107,18, 2, -9,   -9),
    (109,10, 1, -5,    5),
    (113, 9, 3, -4.5, -4.5),
    (127, 8, 1, -4,    4),
    (151, 2, 3, -1,   -1),
    (211,12, 0, 24,    0),       # rational, p_6
    (281,-18,4,  9,   -9),
]

TOWER_PRIMES = [11, 31, 61, 101, 151, 211, 281, 661, 911, 1051, 1201]


# ============================================================
# FIGURE B: Eigenvalue Geometry (all three rays visible)
# ============================================================
def fig_B():
    """
    Plots all 31 eigenvalues as (A, B) in Q(sqrt(5)).
    Three rays: B=0 (rational), B=A, B=-A.
    Lead figure -- shows the empirical pattern.
    """
    import matplotlib.pyplot as plt

    A = [d[3] for d in DATA]
    B = [d[4] for d in DATA]
    k = [d[2] for d in DATA]

    # Color by ray
    colors = {0: 'gold', 1: 'teal', 2: 'tomato', 3: 'tomato', 4: 'teal'}
    c = [colors[ki] for ki in k]

    plt.figure(figsize=(8, 8))
    plt.scatter(A, B, s=80, c=c, zorder=4)

    plt.axhline(0, color='gold',  lw=1.2, label='B=0 (rational, k=0)', zorder=2)
    x = [-26, 26]
    plt.plot(x, x,        color='tomato', lw=1.2, linestyle='--', label='B=A  (k=2,3)', zorder=2)
    plt.plot(x, [-t for t in x], color='teal', lw=1.2, linestyle='--', label='B=-A (k=1,4)', zorder=2)
    plt.axvline(0, color='gray', lw=0.5, alpha=0.4)

    plt.xlabel("A"); plt.ylabel("B")
    plt.title(r"$a_p^{\rm sym} = A + B\sqrt{5}$ in $\mathbb{Q}(\sqrt{5})$")
    plt.legend(fontsize=10)
    plt.grid(True, alpha=0.3); plt.axis('equal')
    plt.tight_layout()
    plt.savefig("fig_B_eigenvalue_geometry.png", dpi=300)
    plt.show()


# ============================================================
# FIGURE F: |A| = |B| Theorem (non-rational eigenvalues only)
# ============================================================
def fig_F():
    """
    Plots only non-rational eigenvalues (k != 0).
    Shows every point lies exactly on B=A or B=-A.
    Theorem-level rigidity.
    """
    import numpy as np
    import matplotlib.pyplot as plt

    nrat = [(d[3], d[4]) for d in DATA if d[2] != 0 and not (d[3] == 0 and d[4] == 0)]
    A = [a for a, b in nrat]
    B = [b for a, b in nrat]

    plt.figure(figsize=(8, 8))
    plt.scatter(A, B, s=90, zorder=4)

    x = np.linspace(-11, 11, 200)
    plt.plot(x,  x, lw=2, label=r'$B = A$  (multiplier $-\phi$)')
    plt.plot(x, -x, lw=2, label=r'$B = -A$ (multiplier $\phi^{-1}$)')

    plt.xlabel("A"); plt.ylabel("B")
    plt.title(r'Non-Rational Eigenvalues: $|A| = |B|$ (Theorem)')
    plt.legend(); plt.grid(True, alpha=0.3); plt.axis('equal')
    plt.tight_layout()
    plt.savefig("fig_F_absA_absB_theorem.png", dpi=300)
    plt.show()


# ============================================================
# FIGURE E: Tower Prime Sectors
# ============================================================
def fig_E():
    """
    Shows how tower primes distribute among the three Q(sqrt(5)) sectors.
    Color by k (Galois class of chi_5(p)).
    """
    import matplotlib.pyplot as plt

    g = 3  # primitive root mod 31

    def kval(p):
        if p % 31 == 0: return None
        x, k = 1, 0
        while x != p % 31 and k < 30:
            x = (x * g) % 31; k += 1
        return k % 5

    sector_color  = {0: 'gold', 1: 'teal', 2: 'tomato', 3: 'tomato', 4: 'teal'}
    sector_label  = {0: r'$2$ (rational)',
                     1: r'$\phi^{-1}$', 4: r'$\phi^{-1}$',
                     2: r'$-\phi$',     3: r'$-\phi$'}

    primes = [p for p in TOWER_PRIMES if p != 31]
    ks     = [kval(p) for p in primes]
    cols   = [sector_color[k] for k in ks]
    labs   = [sector_label[k] for k in ks]

    plt.figure(figsize=(11, 5))
    plt.scatter(range(len(primes)), primes, c=cols, s=150, zorder=4)
    for i, (p, lab) in enumerate(zip(primes, labs)):
        plt.text(i, p + 30, lab, ha='center', fontsize=10)

    plt.ylabel(r'$p_k$'); plt.xlabel('Tower Index $k$')
    plt.xticks(range(len(primes)), [str(p) for p in primes], rotation=30)
    plt.title(r'Tower Primes Distributed Among Three $\mathbb{Q}(\sqrt{5})$ Sectors')
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.savefig("fig_E_tower_sectors.png", dpi=300)
    plt.show()


# ============================================================
# FIGURE C: Self-Referential Eigenfield Triangle
# ============================================================
def fig_C():
    """
    Conceptual diagram: phi generates Q(sqrt(5)), which contains the
    Hecke multipliers {phi, phi^{-1}}, which generate phi.
    Self-referential structure in one glance.
    """
    import matplotlib.pyplot as plt

    fig, ax = plt.subplots(figsize=(8, 6))
    ax.set_xlim(0, 10); ax.set_ylim(0, 10); ax.axis('off')

    # Three nodes
    ax.text(5, 8.5, r'$\phi$', fontsize=32, ha='center', va='center',
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#1C2742', edgecolor='gold', lw=2))
    ax.text(1.5, 2.5, r'$\mathbb{Q}(\sqrt{5})$', fontsize=22, ha='center',
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#1C2742', edgecolor='teal', lw=2))
    ax.text(8.5, 2.5, r'Hecke multipliers' + '\n' + r'$\{2,\,\phi^{-1},\,-\phi\}$',
            fontsize=14, ha='center',
            bbox=dict(boxstyle='round,pad=0.4', facecolor='#1C2742', edgecolor='tomato', lw=2))

    # Arrows
    ax.annotate("", xy=(4.0, 7.8), xytext=(2.5, 3.5),
                arrowprops=dict(arrowstyle='->', color='teal', lw=1.8))
    ax.annotate("", xy=(6.0, 7.8), xytext=(7.5, 3.5),
                arrowprops=dict(arrowstyle='->', color='tomato', lw=1.8))
    ax.annotate("", xy=(6.5, 2.5), xytext=(3.5, 2.5),
                arrowprops=dict(arrowstyle='<->', color='gray', lw=1.5))

    # Labels on arrows
    ax.text(2.5, 6.0, "generated by", fontsize=11, color='teal', rotation=60, ha='center')
    ax.text(7.5, 6.0, "contains", fontsize=11, color='tomato', rotation=-60, ha='center')
    ax.text(5.0, 2.1, "generate each other", fontsize=10, color='gray', ha='center')

    ax.set_title(r'Self-Referential Structure: $\phi$ generates its own eigenvalue field',
                 fontsize=13, pad=10)

    plt.tight_layout()
    plt.savefig("fig_C_self_referential_triangle.png", dpi=300)
    plt.show()


if __name__ == "__main__":
    fig_B()
    fig_F()
    fig_E()
    fig_C()
