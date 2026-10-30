"""Exact census counts for every quartic invariant trace field seen in k283_census.csv.

Same lindep membership test as k283_census.py (Test A), applied to each quartic field F found by the
algdep pass: kM = F iff every kM generator lies in F under one fixed complex embedding of F.
Quartic fields have only Q and (possibly) one quadratic subfield; a hit whose generators all lie in a
quadratic subfield is excluded by requiring that algdep degree of some generator be 4.
"""
import csv
import sys
from collections import Counter

import snappy
from cypari import pari

from k283_census import ACC, holonomy, in_field, itf_gens

pari.set_real_precision(80)
rows = list(csv.DictReader(open('k283_census.csv')))
quartics = sorted({r['polredabs'] for r in rows if r['deg'] == '4'})
FIELDS = []
for p in quartics:
    rts = pari(f'polroots({p})')
    embs = [rts[i] for i in range(4) if abs(float(rts[i].imag())) > 1e-30]
    FIELDS.append((p, int(pari(f'nfdisc({p})')), embs))  # all non-real embeddings


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else len(rows)
    hits = Counter()
    with open('k283_quartic_exact.csv', 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['index', 'name', 'polredabs', 'disc'])
        for idx in range(n):
            M = snappy.ManifoldHP(snappy.OrientableClosedCensus[idx])
            gens = [z for z in itf_gens(holonomy(M)) if abs(z) > pari(10) ** (-40)]
            for p, d, embs in FIELDS:
                if not any(in_field(gens[0], t, 4) for t in embs):  # cheap reject
                    continue
                if any(all(in_field(z, t, 4) for z in gens) for t in embs):
                    # exclude kM a quadratic subfield of F
                    if all(pari.poldegree(pari.algdep(z, 2, ACC)) <= 2 and
                           max(abs(int(c)) for c in pari.Vec(pari.algdep(z, 2, ACC))) < 10 ** 8
                           for z in gens):
                        continue
                    hits[(p, d)] += 1
                    w.writerow([idx, str(M), p, d])
            if idx % 1000 == 0:
                f.flush()
                print(idx, flush=True)
    for (p, d), c in hits.most_common():
        print(f'{d:>8} {c:>4}  {p}')


if __name__ == '__main__':
    main()
