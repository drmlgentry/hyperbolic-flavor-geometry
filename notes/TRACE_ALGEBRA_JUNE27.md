
SESSION RESULTS — June 27, 2026
================================

THEOREM 1 (tr(a) = -alpha):
  Let alpha generate K_10 (ITF of M_CKM) via
  x^10 - 7x^8 - 4x^7 + 17x^6 + 14x^5 - 18x^4 - 14x^3 + 8x^2 + 3x - 1 = 0
  Then tr(rho(a)) = -alpha.
  Proof: ITF(-x) = minimal poly of tr(a). Unique embedding K1->K2 is a1|->-a2.
  Status: PROVED by exact Sage computation.

THEOREM 2 (Fricke codimension-1):
  tr(rho(ab)) = tr(rho(a))
  Equivalently: z = x in Fricke coordinates, constraining the
  representation to a codimension-1 slice of the Fricke cubic.
  Algebraic consequence: tr(aB) = tr(a) * (tr(b) - 1)
  Source: Dehn filling relation mu^{-5} * lambda^2 = 1.
  Status: PROVED by direct computation.

THEOREM 3 (Trace quotient graph):
  The character variety of pi_1(M_CKM) has exactly 122 distinct
  trace classes reachable by words of length <= scan cutoff.
  88 of these lie in the CKM scan range (ell < 4.1).
  The 18,079 scan results are 18,079 words over 88 trace classes.
  Status: ESTABLISHED by BFS computation.

RULED OUT:
  - 283 as arithmetic invariant of K_10: FALSE (283 does not divide disc)
  - Degree-8 subfield (tr(AAAAB), tr(aaaba)) is NOT a known HFG field
  - Q(sqrt(17)) connection to traces: NOT SUPPORTED
  - PMNS translation lengths in CKM word traces: NOT FOUND

NEW OPEN QUESTION:
  What is the degree-8 subfield containing tr(AAAAB)?
  Poly: 18x^8 + 243x^7 + 970x^6 + 872x^5 - 729x^4 - 1878x^3 + 37x^2 - 1659x + 3202
  Disc: 2^3 * 4552131887387683 * 126409903291590489805049177
  Sig: (0,4) -- totally complex
  Is this a subfield of the Galois closure of K_10?
