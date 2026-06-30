"""Quick verification that the itf_signature matches the original Sage session."""
import snappy
import numpy as np
from sage.all import CC, algdep, NumberField

def itf_signature(M):
    """
    Exact replication of the original working Sage session approach:
      algdep(CC(complex(tr_a)), 10, known_bits=50)
    No loop. algdep returns the actual minimal polynomial (degree <= 10).
    known_bits=50 matches the real precision of the double-precision input.
    """
    rho  = M.polished_holonomy()
    mat_a = np.array(rho('a'), dtype=complex)
    tr_a  = np.trace(mat_a)

    mp = algdep(CC(complex(tr_a)), 10, known_bits=50)
    K  = NumberField(mp, 'g')
    return {
        'degree':    mp.degree(),
        'disc':      int(K.discriminant()),
        'signature': list(K.signature()),
        'tr_a_real': float(tr_a.real),
        'tr_a_imag': float(tr_a.imag),
    }

tests = [
    (43,  'm006(-5,2)', 10, -271488204251, [8, 1]),
    (209, 'm206',        3, -23,           [1, 1]),
    (437, 'm222',        7, None,          [5, 1]),
    (457, 'm155',       10, None,          [0, 5]),
]

census = snappy.OrientableClosedCensus
for idx, label, exp_deg, exp_disc, exp_sig in tests:
    M = census[idx]
    r = itf_signature(M)
    ok_deg  = r['degree'] == exp_deg
    ok_sig  = r['signature'] == exp_sig
    ok_disc = (exp_disc is None) or (r['disc'] == exp_disc)
    status  = 'PASS' if (ok_deg and ok_sig and ok_disc) else 'FAIL'
    print(f"[{idx}] {label:12s}: deg={r['degree']} sig={r['signature']} "
          f"disc={r['disc']}  --> {status}")
