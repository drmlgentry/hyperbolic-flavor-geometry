x = polygen(QQ, 'x')
K.<w> = NumberField(x^2 - x + 2)
OK = K.ring_of_integers()

Pw = K.ideal(w)          # one prime above 2, norm 2
P1w = K.ideal(1 - w)     # the conjugate prime above 2, norm 2
print('P (=w):', Pw, 'norm', Pw.norm())
print('Pbar (=1-w):', P1w, 'norm', P1w.norm())
print('P == Pbar?', Pw == P1w)

candidates = {
    '(3w-1)/2  [from 2x^2-x+8, both m009 and m010]': (3*w - 1)/2,
    '-w/2  [from 2x^2+x+1, m009 ab[1,0] / m010 ba[1,0]]': -w/2,
}

for name, val in candidates.items():
    print(f"\n{name}")
    print(f"  value: {val}")
    print(f"  in O_K? {val in OK}")
    # valuation at P and Pbar -- for a non-integral element, express as
    # fractional ideal and check valuations directly via the ideal it
    # generates (numerator/denominator structure)
    frac_ideal = K.ideal(val)
    print(f"  fractional ideal (val): {frac_ideal}")
    try:
        vP = frac_ideal.valuation(Pw)
        vPbar = frac_ideal.valuation(P1w)
        print(f"  v_P(val) = {vP},  v_Pbar(val) = {vPbar}")
    except Exception as e:
        print("  valuation computation failed:", e)
