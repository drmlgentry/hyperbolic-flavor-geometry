import snappy, sys, time
t0 = time.time()
census = snappy.OrientableCuspedCensus
target_disc = -7
matches = []
count = 0
for M in census:
    count += 1
    try:
        K = M.invariant_trace_field_gens().find_field(prec=200, degree=4, optimize=True)
        if K is None:
            continue
        field = K[0]
        if field.degree() == 2 and field.discriminant() == target_disc:
            matches.append((M.name(), float(M.volume())))
    except Exception:
        continue
    if count % 5000 == 0:
        print(f"  scanned {count}, found {len(matches)} so far, elapsed {time.time()-t0:.0f}s", flush=True)
    if count >= 20000:
        break

print(f"scanned {count} manifolds in {time.time()-t0:.1f}s")
print(f"found {len(matches)} manifolds with trace field Q(sqrt(-7))")
matches.sort(key=lambda p: p[1])
for name, vol in matches[:15]:
    print(f"  {name}: volume={vol}")
if matches:
    print()
    print('minimum volume manifold:', matches[0])
    is_m010_min = matches[0][0] == 'm010'
    print('is m010 the minimum?', is_m010_min)
