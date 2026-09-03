"""Call the UNMODIFIED pmns_borel() function directly (no reimplementation)
against several different manifolds, to eliminate any possibility that the
manifold-independence finding is an artifact of a reimplementation."""
import sys
sys.path.insert(0, "/mnt/c/dev/hyperbolic-flavor-scan")
import snappy
from hfg_reproduce import pmns_borel

WORDS = ["aa", "aaB", "baa"]
for name in ["m003(-2,3)", "m004(5,2)", "m006(-5,2)", "m038(3,2)", "m032(7,1)"]:
    M = snappy.Manifold(name)
    U, fit = pmns_borel(M, WORDS)
    print(f"{name:15s}  fitness = {fit:.9f}")
print("EXIT=0")
