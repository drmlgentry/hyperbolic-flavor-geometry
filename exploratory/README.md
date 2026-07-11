# Exploratory Calculations

Scripts in this directory are **exploratory numerical investigations**
that did not confirm the hypothesized relationship, or whose claims
require further development. They are retained for reproducibility and
intellectual honesty, but should **not** be cited as verification of
HFG results.

---

## verify_peripheral.py

**Hypothesis tested:** Does the peripheral determinant
δ(M_CKM) = |det Λ| / (p²+q²) match the Jarlskog CP-violation
invariant J_CKM?

**Result: NO MATCH.**

- Computed: δ ≈ 2.9 × 10⁻⁴
- PDG value: J_CKM ≈ 3.06 × 10⁻⁵ (factor ~10 discrepancy)

The HFG framework predicts J_CKM = 0 at zeroth order due to a
homological class collision in H₁(M_CKM) = ℤ/5. Explaining the
observed Jarlskog scale is an open problem (see SSRN 6775158, §7,
open problem #1).

The formula Λ_{ij} = ∂Re(log λᵢ)/∂sⱼ was not derived from first
principles; it was found by numerical search. The real-part
sub-matrix gives δ ≈ 2.9×10⁻⁴ while the full complex Jacobian
gives |det J_ℂ| ≈ 0.77. Neither matches J_CKM = 3.06×10⁻⁵.

**Status:** Open problem. Do not cite as a verified result.
