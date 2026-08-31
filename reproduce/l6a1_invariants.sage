import snappy

names = ['L6a1', 's780', '6^2_3']
for nm in names:
    try:
        M = snappy.Manifold(nm)
        print(f"--- {nm} -> {M.name()} ---")
    except Exception as ex:
        print(f"--- {nm}: FAILED to load ({ex}) ---")

M = snappy.Manifold('L6a1')
print()
print("name:", M.name())
print("volume:", M.volume())
print("num cusps:", M.num_cusps())
print("homology:", M.homology())
print("is_orientable:", M.is_orientable())

print()
print("cusp_info:")
for c in M.cusp_info():
    print(" ", c)

print()
try:
    print("identify():", M.identify())
except Exception as ex:
    print("identify() failed:", ex)

print()
try:
    itf = M.invariant_trace_field_gens()
    print("invariant trace field gens:", itf)
    print("invariant trace field (min poly candidate):", itf.find_field(100, 10, True))
except Exception as ex:
    print("invariant_trace_field_gens failed:", ex)

print()
try:
    tf = M.trace_field_gens()
    print("trace field gens:", tf)
    print("trace field (min poly candidate):", tf.find_field(100, 10, True))
except Exception as ex:
    print("trace_field_gens failed:", ex)

print()
try:
    print("is_arithmetic hints via arithmetic invariants module...")
    from snappy import twister
except Exception:
    pass

try:
    print("symmetry group:", M.symmetry_group())
except Exception as ex:
    print("symmetry_group failed:", ex)

# Check commensurability-relevant invariant: does it appear related to
# m009/m010 in SnapPy's own commensurability tools, if available.
try:
    print()
    print("Checking snappy.snap for arithmetic invariants...")
    inv = M.invariant_trace_field_gens().find_field(1000, 20, True)
    print("invariant trace field:", inv)
except Exception as ex:
    print("extended search failed:", ex)
