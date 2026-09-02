import csv
from collections import defaultdict

path = r"m003_word_atlas.csv"

by_filling = defaultdict(list)
with open(path, newline="") as f:
    R = csv.DictReader(f)
    for row in R:
        re = float(row["tr2_re"])
        im = float(row["tr2_im"])
        by_filling[row["filling"]].append((row["word"], re, im))

TOL = 1e-20  # generous relative to double precision noise from float() truncation of the 120-bit strings

def cluster(entries, tol):
    used = [False]*len(entries)
    groups = []
    for i in range(len(entries)):
        if used[i]:
            continue
        gi = [entries[i]]
        used[i] = True
        for j in range(i+1, len(entries)):
            if used[j]:
                continue
            dre = entries[i][1]-entries[j][1]
            dim = entries[i][2]-entries[j][2]
            if (dre*dre+dim*dim) < tol:
                gi.append(entries[j])
                used[j] = True
        groups.append(gi)
    return groups

print(f"{'filling':16s} {'#words in groups size>=2':>26s} {'#groups size>=2':>18s} {'top group sizes':>20s} {'H1':>10s}")

fill_h1 = {}
with open(path.replace("m003_word_atlas.csv","m003_filling_summary.csv"), newline="") as f:
    R = csv.DictReader(f)
    for row in R:
        fill_h1[row["filling"]] = row["homology"]

for filling, entries in by_filling.items():
    groups = cluster(entries, TOL)
    multi = [g for g in groups if len(g) >= 2]
    n_in_groups = sum(len(g) for g in multi)
    sizes = sorted((len(g) for g in multi), reverse=True)[:5]
    print(f"{filling:16s} {n_in_groups:26d} {len(multi):18d} {str(sizes):>20s} {fill_h1.get(filling,''):>10s}")
