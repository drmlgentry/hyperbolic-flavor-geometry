"""Summarize k283_census.csv: K_283 base rate and where K_283 sits in the census field distribution."""
import csv
from collections import Counter

rows = list(csv.DictReader(open('k283_census.csv')))
N = len(rows)
hit = [r for r in rows if r['k283'] in ('t', 'conj_t')]
err = [r for r in rows if r['k283'] == 'ERR']
ided = [r for r in rows if r['deg']]

print(f'manifolds: {N}   errors: {len(err)}   field identified (deg<=8): {len(ided)} ({len(ided)/N:.1%})')
print(f'\nK_283 (Test A, lindep membership): {len(hit)} / {N} = {len(hit)/N:.3%}')

b = [r for r in rows if r['disc'] == '-283' and r['deg'] == '4']
print(f'K_283 (Test B, algdep+polredabs):  {len(b)}   agree with A: {set(r["index"] for r in b) == set(r["index"] for r in hit)}')

print('\nK_283 manifolds (volume order):')
for r in hit:
    print(f"  #{r['index']:>5}  {r['name']:<16} vol {r['volume']}")

fields = Counter((r['deg'], r['polredabs'], r['disc']) for r in ided)
print(f'\ndistinct fields among identified: {len(fields)}')
ranked = fields.most_common()
print('top 15 fields by number of census manifolds:')
for i, ((d, p, D), c) in enumerate(ranked[:15], 1):
    print(f'  {i:>2}. deg {d} disc {D:>10}  {c:>4}  {p}')
rank = next(i for i, (k, _) in enumerate(ranked, 1) if k[2] == '-283' and k[0] == '4')
print(f'K_283 frequency rank: {rank} of {len(fields)}')

deg = Counter(r['deg'] or '>8/unid' for r in rows)
print('\nfield degree distribution:', dict(sorted(deg.items())))
q = [k for k in fields if k[0] == '4']
print(f'quartic fields seen: {len(q)}; manifolds with a quartic field: {sum(fields[k] for k in q)}')
print('quartic fields ranked:', [(k[2], fields[k]) for k in sorted(q, key=lambda k: -fields[k])][:10])

for cut in (10, 50, 100, 500, 1000):
    h = sum(1 for r in hit if int(r['index']) < cut)
    print(f'first {cut:>5} by volume: {h} with K_283')

m3 = [r for r in rows if r['name'].startswith('m003(')]
print(f'\ncensus manifolds presented as m003 fillings: {len(m3)}, with K_283: {sum(r in hit for r in m3)}')
