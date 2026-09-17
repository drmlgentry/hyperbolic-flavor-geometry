"""
Sharper, decisive test of the 3-trace-state closure question, replacing
the earlier (weaker) tr(u.ab)=?=tr(u.ba) sampling.

State: S(u) = (tr(u), tr(u.a), tr(u.b)) on X_0(m003), for LITERAL
freely-reduced prefixes u (no cyclic reduction, no canonicalization,
no proper-power exclusion -- this is about the actual free-monoid
prefix tree, not the atlas's word-class quotient).

Already established (linear, hence automatic once S(u)=S(v)):
    tr(uA) = x*tr(u) - tr(ua)      [Cayley-Hamilton 2-term recursion]
    tr(uB) = y*tr(u) - tr(ub)
    tr(uaa) = x*tr(ua) - tr(u)
    tr(ubb) = y*tr(ub) - tr(u)
So the ENTIRE automaton-closure question reduces to one scalar:
    S(u) = S(v)  ==>?  tr(uab) = tr(vab)
(and by the symmetric argument, tr(uba) similarly, but tr(uba) is
determined by tr(ub),tr(u) and tr(uba) itself is the same kind of new
quantity as tr(uab) -- test both explicitly for full rigor.)

Search: generate literal freely-reduced words u up to length L, compute
exact S(u) on X_0(m003), hash by the EXACT triple, and for every
collision (two distinct u,v with identical S(u)=S(v)) check whether
tr(uab) and tr(uba) agree across all colliding prefixes. A single
disagreement is an exact witness that the 3-trace state does not
close, definitively, on the actual m003 orbit -- not just generically.
"""

import sys
import time
from collections import defaultdict
from itertools import product

import sympy as sp

try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

x, y, z, u, t = sp.symbols("x y z u t")

A = sp.Matrix([[x, -1], [1, 0]])
uinv = -z - u
B = sp.Matrix([[0, -u], [uinv, y]])
I2 = sp.eye(2)


def inv_sl2(M):
    return sp.Matrix([[M[1, 1], -M[0, 1]], [-M[1, 0], M[0, 0]]])


MATS = {"a": A, "A": inv_sl2(A), "b": B, "B": inv_sl2(B)}
DET_REL = sp.Poly(u**2 + z * u + 1, u)

CANCELS = {("a", "A"), ("A", "a"), ("b", "B"), ("B", "b")}


def word_matrix(word):
    M = I2
    for c in word:
        M = M * MATS[c]
    return sp.expand(M)


def tr_xyz(word):
    tr = sp.expand(word_matrix(word).trace())
    _, r = sp.div(sp.Poly(tr, u), DET_REL, u)
    r = sp.expand(r.as_expr())
    assert sp.Poly(r, u).degree() <= 0, f"{word}: residual u term {r}"
    return sp.expand(r)


PARAM3 = {x: t, y: 1 - t**2, z: -1 / t}


def tr_on_X0(word):
    return sp.cancel(sp.together(tr_xyz(word).subs(PARAM3)))


def gen_literal_freely_reduced(max_len):
    """literal freely-reduced words (no cyclic reduction, no dedup by
    rotation/inversion, no proper-power exclusion), length 0..max_len."""
    words = [""]
    alphabet = "aAbB"
    for n in range(1, max_len + 1):
        for tup in product(alphabet, repeat=n):
            w = "".join(tup)
            if any((w[i], w[i + 1]) in CANCELS for i in range(n - 1)):
                continue
            words.append(w)
    return words


def banner(s):
    print("\n" + "=" * 78 + "\n" + s + "\n" + "=" * 78)


L = 7  # prefix length bound (ua,ub reach L+1; uab,uba reach L+2)

banner(f"1. generate literal freely-reduced prefixes, length <= {L}")
prefixes = gen_literal_freely_reduced(L)
print(f"  {len(prefixes)} literal prefixes (length 0..{L})")

banner("2. compute S(u) = (tr(u), tr(ua), tr(ub)) on X_0(m003) for each")
t0 = time.time()
tr_u = {}
tr_ua = {}
tr_ub = {}
for i, u_ in enumerate(prefixes):
    tr_u[u_] = tr_on_X0(u_) if u_ != "" else sp.Integer(2)
    tr_ua[u_] = tr_on_X0(u_ + "a")
    tr_ub[u_] = tr_on_X0(u_ + "b")
    if (i + 1) % 500 == 0:
        print(f"    ... {i+1}/{len(prefixes)} ({time.time()-t0:.0f}s)")
print(f"  done in {time.time()-t0:.1f}s")

banner("3. hash by exact state triple S(u), find collisions among DISTINCT prefixes")
by_state = defaultdict(list)
for u_ in prefixes:
    key = (sp.srepr(tr_u[u_]), sp.srepr(tr_ua[u_]), sp.srepr(tr_ub[u_]))
    by_state[key].append(u_)

collision_groups = [sorted(v, key=len) for v in by_state.values() if len(v) > 1]
print(f"  {len(prefixes)} prefixes -> {len(by_state)} distinct states, "
      f"{len(collision_groups)} state-collision groups")

banner("4. THE DECISIVE TEST: for each state-collision group, does tr(uab), tr(uba) agree?")
t0 = time.time()
witnesses = []
checked = 0
for grp in collision_groups:
    u0 = grp[0]
    tr_u0ab = tr_on_X0(u0 + "ab")
    tr_u0ba = tr_on_X0(u0 + "ba")
    for v_ in grp[1:]:
        checked += 1
        tr_vab = tr_on_X0(v_ + "ab")
        tr_vba = tr_on_X0(v_ + "ba")
        if sp.expand(tr_u0ab - tr_vab) != 0:
            witnesses.append((u0, v_, "ab", tr_u0ab, tr_vab))
        if sp.expand(tr_u0ba - tr_vba) != 0:
            witnesses.append((u0, v_, "ba", tr_u0ba, tr_vba))
print(f"  checked {checked} same-state prefix pairs in {time.time()-t0:.1f}s")

banner("5. VERDICT")
if witnesses:
    print(f"  {len(witnesses)} WITNESSES FOUND -- the 3-trace state does NOT close, "
          f"exactly, on the actual m003 orbit:")
    for u0, v_, ext, tru, trv in witnesses[:10]:
        print(f"    S({u0!r}) == S({v_!r})  but  tr({u0+ext!r})={tru}  !=  "
              f"tr({v_+ext!r})={trv}")
else:
    print(f"  ZERO witnesses across {checked} same-state prefix pairs "
          f"({len(collision_groups)} collision groups, prefixes up to length {L}).")
    print(f"  The 3-trace state S(u)=(tr(u),tr(ua),tr(ub)) shows NO detected failure")
    print(f"  of the automaton/determinism property on this data -- strong evidence")
    print(f"  (not proof) that it closes on the actual X_0(m003) orbit, even though")
    print(f"  the generic Fricke identity leaves it undetermined in the abstract.")

print("\nPY_EXIT=0")
