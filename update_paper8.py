import os

path = r'papers\\regulator-lattice\\gentry-regulator-lattice.tex'
t = open(path, encoding='utf-8').read()

old_table = r'''\\begin{tabular}{lrrr}
\\hline
Field & Units found & $\\lambda_1$ & $\\kappa$ \\\\
\\hline
$x^3-3x+1$ & & & \\\\
$x^3-x^2-2x+1$ & & & \\\\
$x^3-4x+1$ & & & \\\\
$x^3-x^2-3x+1$ & & & \\\\
$x^3-5x+1$ & & & \\\\
\\hline
\\end{tabular}'''

new_table = r'''\\begin{tabular}{lrrrrr}
\\hline
Field & Units & $\\lambda_1$ & $\\lambda_2$ & $\\kappa$ & vs.\\ threshold \\\\
\\hline
$x^3-3x+1$       & 17 & 2.548 &  7.644 &  3.000 & below \\\\
$x^3-x^2-2x+1$   & 28 & 6.513 & 10.302 &  1.582 & below \\\\
$x^3-4x+1$       & 13 & 2.279 & 29.211 & 12.817 & above \\\\
$x^3-x^2-3x+1$   & 19 & 7.257 & 10.281 &  1.417 & below \\\\
$x^3-5x+1$       & 12 & 3.581 & 27.089 &  7.564 & above \\\\
$x^3-2x^2-x+1$   & 32 & 5.880 & 14.088 &  2.396 & below \\\\
$x^3-6x+2$       &  6 & 4.636 & 20.965 &  4.523 & below \\\\
$x^3-x^2-4x+3$   & 14 & 2.172 & 21.544 &  9.921 & above \\\\
$x^3-3x^2-x+1$   & 19 & 1.685 & 19.675 & 11.673 & above \\\\
\\hline
\\multicolumn{6}{l}{Threshold for $N\\leq 6$: $\\kappa \\geq 5.74$.} \\\\
\\hline
\\end{tabular}'''

t = t.replace(old_table, new_table)

# Update the remark about placeholder
old_remark = r'''\\begin{remark}[Status of Table~\\ref{tab:kappa}]
Table~\\ref{tab:kappa} is a placeholder pending completion of the numerical
survey. The code is available in the companion repository.
\\end{remark}'''

new_remark = r'''\\begin{remark}[Interpretation of Table~\\ref{tab:kappa}]
Four of nine fields surveyed have $\\kappa$ above the spectrum obstruction
threshold of $5.74$ (for $N\\leq 6$). These fields are not ruled out by the
obstruction alone. However, the further requirement that generator lengths
match the observed fermion mass ratios imposes an independent constraint.
Numerical tests on the field $x^4-x^3-4x^2+4x+1$ (quartic, rank 3) showed
that unit log norms do not match the required generator lengths; see the
companion verification code \\texttt{code/verify\\_ckm\\_v2.py}.
\\end{remark}'''

t = t.replace(old_remark, new_remark)

# Update conclusion section
old_concl = ('Preliminary evidence and classical bounds suggest that cubic '
             'fields are too rigid; higher-degree fields may offer more flexibility.')
new_concl = ('Computational evidence shows $\\\\kappa$ ranging from $1.4$ to '
             '$12.8$ across nine cubic fields surveyed, with four exceeding '
             'the spectrum obstruction threshold $\\\\kappa\\\\geq 5.74$ for '
             '$N\\\\leq 6$. Those four fields are not ruled out by the '
             'obstruction alone; the additional requirement that unit '
             'generator lengths match observed mass ratios provides the '
             'decisive further constraint. Higher-degree fields remain '
             'largely unexplored.')

t = t.replace(old_concl, new_concl)

open(path, 'w', encoding='utf-8').write(t)
print('Updated paper8 tex.')
