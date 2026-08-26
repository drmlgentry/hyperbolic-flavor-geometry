#!/usr/bin/env python3
"""
Persistent per-manifold worker for census_disjoint_ramification_scan.sage.py.

Reads sage/snappy once, then loops: read a manifold name from stdin, compute
its invariant-trace-field recognition + Galois closure record, write one
JSON line to stdout. Maintains its own field-key cache so repeat fields
(common in a census scan) skip the expensive closure recomputation.

Exists because Python's signal.alarm() cannot reliably bound the cost of a
PARI/GP call inside Sage: those run in C and don't yield to the interpreter
until they return on their own, so an in-process alarm can only report
"more than N seconds elapsed" long after the fact, not actually cap it.
Running each manifold in a subprocess lets the PARENT enforce a real
wall-clock cap via a hard OS-level kill, independent of what this process
is doing internally.
"""
import sys, json
import snappy
from sage.all import ZZ, pari

def recognize_itf(M, precision, degree_bound):
    S = M.invariant_trace_field_gens()
    res = S.find_field(precision, degree_bound, optimize=True)
    return res[0] if isinstance(res, tuple) else res

def reduced_poly_string(K):
    f = K.defining_polynomial()
    try:
        return str(pari(f).polredabs())
    except Exception:
        return str(f)

def closure_record(K, closure_degree_max):
    deg = int(K.degree())
    disc = int(K.discriminant())
    key = reduced_poly_string(K)
    L = K if K.is_galois() else K.galois_closure('z')
    Ldeg = int(L.degree())
    if Ldeg > closure_degree_max:
        raise RuntimeError("closure degree %d exceeds bound %d" % (Ldeg, closure_degree_max))
    Ldisc = int(L.discriminant())
    primes = [int(q) for q in ZZ(abs(Ldisc)).prime_divisors()]
    G = L.galois_group()
    try:
        gdesc = G.structure_description()
    except Exception:
        gdesc = str(G)
    return {
        "field_key": key, "stem_degree": deg, "stem_discriminant": disc,
        "closure_degree": Ldeg, "closure_discriminant": Ldisc,
        "ramification_support": primes, "galois_group": gdesc,
    }

def main():
    precision = int(sys.argv[1])
    degree_bound = int(sys.argv[2])
    closure_degree_max = int(sys.argv[3])
    field_cache = {}

    print("READY", flush=True)
    for line in sys.stdin:
        name = line.strip()
        if not name:
            continue
        try:
            K = recognize_itf(snappy.Manifold(name), precision, degree_bound)
            if K is None:
                print(json.dumps({"ok": False, "error": "field_not_recognized"}), flush=True)
                continue
            key = reduced_poly_string(K)
            if key in field_cache:
                print(json.dumps({"ok": True, "field_key": key, "new": False}), flush=True)
            else:
                fr = closure_record(K, closure_degree_max)
                field_cache[key] = fr
                print(json.dumps({"ok": True, "field_key": key, "new": True, "closure": fr}), flush=True)
        except Exception as e:
            print(json.dumps({"ok": False, "error": repr(e)}), flush=True)

if __name__ == "__main__":
    main()
