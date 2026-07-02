#!/usr/bin/env python3
"""
archimedean_scan.py
===================
Systematic search over elementary functions of the roots of the degree-10
invariant trace field polynomial of M_CKM = m006(-5,2):

    f10(x) = x^10 - 7x^8 + 4x^7 + 17x^6 - 14x^5 - 18x^4
             + 14x^3 + 8x^2 - 3x - 1

The polynomial has 8 real roots r1,...,r8 and 1 complex conjugate pair s, s*.
We search for simple functions matching the six mixing angles.

Known (prior work):
    arg(s)             -> theta_12_PMNS = 33.4 deg
    arccos(|s|/2)      -> theta_23_PMNS = 42.1 deg
    arcsin(|r5|/|r1|)  -> theta_12_CKM  = 13.0 deg

Open:
    theta_23_CKM  = 2.377 deg
    theta_13_CKM  = 0.2146 deg
    theta_13_PMNS = 8.57  deg

Usage:  python3 reproduce/archimedean_scan.py
Requires: numpy, mpmath
Author: M. L. Gentry / Claude (Anthropic), July 2026
"""

import numpy as np
import itertools, sys
from mpmath import mp, polyroots, fabs, arg as mparg, nstr, pi

mp.dps = 60

# ── ITF polynomial f10 ────────────────────────────────────────────────────────
# coefficients from degree 10 down to degree 0
POLY = [1, 0, -7, 4, 17, -14, -18, 14, 8, -3, -1]

# ── PDG 2024 targets ──────────────────────────────────────────────────────────
# (central value degrees, matching tolerance degrees)
TARGETS = {
    'th12_CKM' : (13.040, 0.10),
    'th23_CKM' : ( 2.377, 0.06),
    'th13_CKM' : ( 0.2146,0.015),
    'th12_PMNS': (33.44,  0.40),
    'th23_PMNS': (42.10,  0.40),
    'th13_PMNS': ( 8.570, 0.20),
}
KNOWN = {'th12_CKM', 'th12_PMNS', 'th23_PMNS'}
OPEN  = {'th23_CKM', 'th13_CKM', 'th13_PMNS'}

DEG = 180.0 / np.pi

# ── Roots ─────────────────────────────────────────────────────────────────────
print("Computing roots of f10 at 60-digit precision...")
raw = polyroots(POLY, maxsteps=200, extraprec=20)

reals   = sorted([r for r in raw if fabs(r.imag) < 1e-40],
                 key=lambda x: float(x.real))
cplx    = sorted([r for r in raw if r.imag > 0],
                 key=lambda x: -x.imag)   # upper half-plane

R  = [float(r.real) for r in reals]   # 8 real roots
aR = [abs(x) for x in R]              # absolute values

S  = complex(cplx[0])                  # the complex root (Im > 0)
aS = abs(S)
gS = float(mparg(cplx[0])) * DEG      # argument in degrees
rS, iS = S.real, S.imag

print(f"\nReal roots (sorted ascending):")
for i, r in enumerate(R, 1):
    print(f"  r{i:d} = {r:+.8f}   |r{i}| = {aR[i-1]:.8f}")
print(f"\nComplex root:")
print(f"  s  = {rS:.8f} + {iS:.8f}i")
print(f"  |s| = {aS:.8f},  arg(s) = {gS:.5f} deg")

# ── Build candidate pool ──────────────────────────────────────────────────────
cands = []   # (angle_deg, formula_string)

def add(angle, label):
    if angle is not None and np.isfinite(angle) and 0.0 < angle < 90.0:
        cands.append((float(angle), label))

def arcsin_safe(x):
    x = float(x)
    return np.arcsin(x) * DEG if abs(x) <= 1 else None

def arccos_safe(x):
    x = float(x)
    return np.arccos(x) * DEG if abs(x) <= 1 else None

# ─── Group A: complex root s ──────────────────────────────────────────────────
add(gS,                           "arg(s)")
add(arccos_safe(aS / 2),          "arccos(|s|/2)")
add(arccos_safe(aS),              "arccos(|s|)")
add(arcsin_safe(aS),              "arcsin(|s|)")
add(np.arctan(aS) * DEG,          "arctan(|s|)")
add(arcsin_safe(rS),              "arcsin(Re s)")
add(arccos_safe(rS),              "arccos(Re s)")
add(arcsin_safe(iS),              "arcsin(Im s)")
add(arccos_safe(iS),              "arccos(Im s)")
add(np.arctan(abs(iS / rS)) * DEG if rS != 0 else None, "arctan(|Im s/Re s|)")
add(np.arctan(abs(rS / iS)) * DEG if iS != 0 else None, "arctan(|Re s/Im s|)")
add(arcsin_safe(rS / aS),         "arcsin(Re s / |s|)")   # = arg(s) complement
add(arccos_safe(rS / aS),         "arccos(Re s / |s|)")
add(np.arctan2(abs(iS), abs(rS)) * DEG, "arctan2(|Im s|,|Re s|)")
# powers of |s|
for e in [0.5, 2, 3, 1/3]:
    add(arcsin_safe(aS**e),       f"arcsin(|s|^{e:.2g})")
    add(arccos_safe(aS**e),       f"arccos(|s|^{e:.2g})")
    add(np.arctan(aS**e) * DEG,   f"arctan(|s|^{e:.2g})")

# ─── Group B: single real root ────────────────────────────────────────────────
for i, r in enumerate(R, 1):
    a = aR[i-1]
    add(arcsin_safe(a),     f"arcsin(|r{i}|)")
    add(arccos_safe(a),     f"arccos(|r{i}|)")
    add(np.arctan(a) * DEG, f"arctan(|r{i}|)")
    add(arcsin_safe(r),     f"arcsin(r{i})")
    for e in [0.5, 2, 3, 1/3]:
        add(arcsin_safe(a**e),     f"arcsin(|r{i}|^{e:.2g})")
        add(arccos_safe(a**e),     f"arccos(|r{i}|^{e:.2g})")
        add(np.arctan(a**e) * DEG, f"arctan(|r{i}|^{e:.2g})")
    # scaled
    for sc in [0.5, 2, 3, 4, 0.25, 1/3]:
        add(arcsin_safe(a * sc),   f"arcsin({sc:.2g}·|r{i}|)")

# ─── Group C: ratios of pairs of real roots ───────────────────────────────────
for i, j in itertools.combinations(range(8), 2):
    ai, aj = aR[i], aR[j]
    li, lj = f"r{i+1}", f"r{j+1}"
    if aj > 0:
        x = ai / aj
        add(arcsin_safe(x),     f"arcsin(|{li}|/|{lj}|)")
        add(arccos_safe(x),     f"arccos(|{li}|/|{lj}|)")
        add(np.arctan(x) * DEG, f"arctan(|{li}|/|{lj}|)")
    if ai > 0:
        x = aj / ai
        add(arcsin_safe(x),     f"arcsin(|{lj}|/|{li}|)")
        add(arccos_safe(x),     f"arccos(|{lj}|/|{li}|)")
        add(np.arctan(x) * DEG, f"arctan(|{lj}|/|{li}|)")
    # squares/products
    p = ai * aj
    add(arcsin_safe(p),         f"arcsin(|{li}|·|{lj}|)")
    add(arccos_safe(p),         f"arccos(|{li}|·|{lj}|)")
    add(np.arctan(p) * DEG,     f"arctan(|{li}|·|{lj}|)")
    d = abs(ai - aj)
    add(arcsin_safe(d),         f"arcsin(||{li}|-|{lj}||)")
    add(np.arctan(d) * DEG,     f"arctan(||{li}|-|{lj}||)")
    s = abs(ai + aj)
    add(arcsin_safe(s),         f"arcsin(|{li}|+|{lj}|)")

# ─── Group D: real root vs complex root ───────────────────────────────────────
for i, r in enumerate(R, 1):
    a = aR[i-1]
    for num, den, tag in [
        (a,      aS,      f"|r{i}|/|s|"),
        (aS,     a,       f"|s|/|r{i}|"),
        (abs(rS),a,       f"|Re s|/|r{i}|"),
        (abs(iS),a,       f"|Im s|/|r{i}|"),
        (a,      abs(rS), f"|r{i}|/|Re s|"),
        (a,      abs(iS), f"|r{i}|/|Im s|"),
        (a*aS,   1,       f"|r{i}|·|s|"),
    ]:
        if den == 0: continue
        x = num / den
        add(arcsin_safe(x),     f"arcsin({tag})")
        add(arccos_safe(x),     f"arccos({tag})")
        add(np.arctan(x) * DEG, f"arctan({tag})")

# ─── Group E: triples of real roots ──────────────────────────────────────────
for i, j, k in itertools.combinations(range(8), 3):
    ai, aj, ak = aR[i], aR[j], aR[k]
    # ratio: (product of two) / third
    for num, den, tag in [
        (ai*aj, ak, f"|r{i+1}·r{j+1}|/|r{k+1}|"),
        (ai*ak, aj, f"|r{i+1}·r{k+1}|/|r{j+1}|"),
        (aj*ak, ai, f"|r{j+1}·r{k+1}|/|r{i+1}|"),
    ]:
        if den == 0: continue
        x = num / den
        add(arcsin_safe(x),     f"arcsin({tag})")
        add(np.arctan(x) * DEG, f"arctan({tag})")

print(f"\nTotal candidates: {len(cands)}")

# ── Match ─────────────────────────────────────────────────────────────────────
HLINE = "=" * 72
SLINE = "-" * 72

print(f"\n{HLINE}")
print("  MATCHING RESULTS")
print(HLINE)

hits = {name: [] for name in TARGETS}
for angle, formula in cands:
    for name, (target, tol) in TARGETS.items():
        residual = abs(angle - target)
        if residual < tol:
            hits[name].append((residual, angle, formula))

new_matches = []
for name, (target, tol) in TARGETS.items():
    tag = "** KNOWN **" if name in KNOWN else ">> OPEN <<"
    print(f"\n  {name} = {target:.4f} deg  [{tag}]  tol={tol} deg")
    matches = sorted(hits[name])
    if matches:
        for res, angle, formula in matches[:6]:
            print(f"    {formula:45s}  {angle:.6f} deg   Δ={res:+.6f}")
            if name in OPEN:
                new_matches.append((name, target, angle, res, formula))
    else:
        print("    (no match within tolerance)")

print(f"\n{HLINE}")
print("  SUMMARY")
print(HLINE)
open_matched   = sorted(set(n for n, *_ in new_matches))
open_unmatched = sorted(OPEN - set(open_matched))
print(f"  Open angles with matches   : {open_matched}")
print(f"  Open angles without matches: {open_unmatched}")

if new_matches:
    print(f"\n  Best new matches:")
    print(f"  {'Angle':15s}  {'Target':8s}  {'Value':10s}  {'Delta':9s}  Formula")
    print(f"  {SLINE}")
    seen = set()
    for name, target, angle, res, formula in sorted(new_matches, key=lambda x: x[3]):
        if name not in seen:
            print(f"  {name:15s}  {target:8.4f}  {angle:10.6f}  {res:+9.6f}  {formula}")
            seen.add(name)

print(HLINE)
