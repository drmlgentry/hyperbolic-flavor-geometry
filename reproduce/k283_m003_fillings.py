"""Null model 2: invariant trace fields of all Dehn fillings m003(p,q), |p|,|q| <= B, gcd 1.

Same tests as k283_census.py. Slopes are taken up to sign; non-hyperbolic or degenerate fillings
are skipped (SnapPy solution type must be 'all tetrahedra positively oriented').
"""
import csv
import random
import sys
from math import gcd

import snappy

from k283_census import holonomy, identify, is_k283, itf_gens

B = int(sys.argv[1]) if len(sys.argv) > 1 else 10
rng = random.Random(283)
with open('k283_m003_fillings.csv', 'w', newline='') as f:
    w = csv.writer(f)
    w.writerow(['p', 'q', 'volume', 'k283', 'deg', 'polredabs', 'disc'])
    for q in range(0, B + 1):
        for p in range(-B, B + 1):
            if gcd(p, q) != 1 or (q == 0 and p != 1):
                continue
            M = snappy.ManifoldHP('m003')
            M.dehn_fill((p, q))
            if M.solution_type() != 'all tetrahedra positively oriented':
                continue
            try:
                gens = itf_gens(holonomy(M))
                k = is_k283(gens)
                deg, red, disc = identify(gens, rng)
            except Exception as e:
                k, deg, red, disc = 'ERR', '', repr(e)[:80], ''
            w.writerow([p, q, f'{float(M.volume()):.9f}', k, deg, red, disc])
            f.flush()
