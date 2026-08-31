import snappy

for name, idx in [('m006', 43), ('m003', 1)]:
    M = snappy.OrientableClosedCensus[idx]
    print(f"--- {name} ({M.name()}) ---")
    print("has length_spectrum:", hasattr(M, 'length_spectrum'))
    try:
        spec = M.length_spectrum(0.6)
        print("length_spectrum(0.6) sample (first 10):")
        for row in list(spec)[:10]:
            print(" ", row)
        print("total entries:", len(spec))
    except Exception as ex:
        print("length_spectrum failed:", ex)
    print()
