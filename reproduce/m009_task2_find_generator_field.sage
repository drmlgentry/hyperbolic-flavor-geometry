# Task 2, step 1b: identify the actual number field the raw holonomy
# generators a, b live in (already shown NOT to be K=Q(sqrt(-7))).
# Uses Sage's QQbar + number_field_elements_from_algebraics, which finds
# a SINGLE common field for a whole list of algebraic numbers at once --
# more robust than per-entry algdep with a guessed degree bound (which
# produced huge-coefficient, hard-to-read polynomials last time).

import snappy
from sage.all import ComplexField, algdep, QQ, QQbar, AA, matrix, Matrix, polygen
from sage.rings.qqbar import number_field_elements_from_algebraics

x = polygen(QQ, 'x')
CCf0 = ComplexField(300)
w_num = (1 + CCf0(-7).sqrt()) / 2
K = NumberField(x**2 - x + 2, 'w', embedding=w_num)
w = K.gen()
CCf = ComplexField(300)

print("Loading m009 holonomy...")
M = snappy.Manifold('m009')
G = M.polished_holonomy(bits_prec=300)
raw = {wd: G.SL2C(wd) for wd in ['a', 'b', 'aa', 'ab']}
beta = CCf(raw['aa'][0, 1])

# Build the same beta-rescaled numeric entries as before for a and b.
entries = []
labels = []
for wd in ['a', 'b']:
    m = raw[wd]
    a_, b_, c_, d_ = CCf(m[0, 0]), CCf(m[0, 1]), CCf(m[1, 0]), CCf(m[1, 1])
    new_b, new_c = beta * b_, c_ / beta
    for val, lab in [(a_, f"{wd}[0,0]"), (new_b, f"{wd}[0,1]"),
                      (new_c, f"{wd}[1,0]"), (d_, f"{wd}[1,1]")]:
        entries.append(val)
        labels.append(lab)

print("Converting", len(entries), "numeric values to QQbar (algebraic closure)...")
qq_entries = []
for val, lab in zip(entries, labels):
    dep = algdep(val, 8, known_bits=250)  # allow up to degree 8, generous
    print(f"  {lab}: minimal-poly candidate degree {dep.degree()}, poly={dep}")
    roots = dep.roots(QQbar, multiplicities=False)
    best, best_err = None, None
    for r in roots:
        err = abs(CCf(r) - val)
        if best_err is None or err < best_err:
            best_err, best = err, r
    print(f"    best root err = {best_err}")
    qq_entries.append(best)

print()
print("Finding a common number field for all entries via")
print("number_field_elements_from_algebraics...")
Lfield, field_elts, hom = number_field_elements_from_algebraics(qq_entries, minimal=True)
print("Common field L:", Lfield)
print("L degree over Q:", Lfield.degree())
print("L defining polynomial:", Lfield.polynomial())
print("L discriminant:", Lfield.discriminant())

print()
print("Does K embed into L?")
try:
    embs = K.embeddings(Lfield)
    print("  K.embeddings(L):", embs, " count:", len(embs))
except Exception as ex:
    print("  embeddings() failed:", ex)
