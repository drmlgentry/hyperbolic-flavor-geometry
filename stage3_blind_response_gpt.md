# Stage 3 blind selector task — frozen GPT response

Session role: blinded (fresh) GPT session, working only from
`STAGE3_BLIND_PACKET.md` and `stage3_blind_states.json`.
This record is frozen per rule 5 of the packet.

---

Within the permitted forms, I find one nontrivial candidate that separates all six states, plus one stronger exact arithmetic candidate that detects only the binary parity. I would not introduce any further rules: beyond these, the packet's restrictions would start to make the exercise an unjustified search for patterns.

## Ranked candidate 1 — degree-normalized principal argument

Define

Q₁(s) = round( (3/π) · Arg(tr_a(s)) )

with the standard principal argument Arg z ∈ (−π, π].

The factor 3 is not fitted to the six outputs: it is the degree [K:Q]=3, equivalently the size of the three-element embedding/coset factor of the state space. Division by π is the standard dimensionless normalization of an angular invariant, and B=0.

For the six states,

(3/π)·Arg(tr_a) = (−2.48153038, 2.48153038, 0, 0.51846962, −0.51846962, 3).

Therefore

(Q₁(s₀), …, Q₁(s₅)) = (−2, 2, 0, 1, −1, 3).

This is natural specifically here because the state space contains a distinguished threefold embedding factor and tr_a is a canonical cubic-field quantity varying over that factor and also changing under the binary sheet. The degree-normalized angular coordinate consequently resolves all six states using one invariant and no fitted coefficients.

There is an important qualification: this is a rounding selector rather than an exact arithmetic integer invariant. Its two nonzero closest distances from a half-integer boundary are only about 0.01847.

Thus it is mathematically admissible under the packet, but substantially less canonical than an exact norm. The choice of the conventional principal branch is also essential; in particular the negative-real state is assigned Arg=π.

## Ranked candidate 2 — field norm of tr_a

Define

Q₂(s) = N_{K/Q}(tr_a(s)).

For the ε=+1 sheet, the three conjugate values of tr_a have elementary symmetric quantities

α₀+α₁+α₂ = −1, α₀α₁+α₀α₂+α₁α₂ = −1, α₀α₁α₂ = 2.

Hence they are the roots of x³+x²−x−2 and N_{K/Q}(tr_a) = 2.

On the ε=−1 sheet, the listed tr_a values are the negatives of those cubic conjugates. Since K/Q has odd degree 3, N(−α) = (−1)³N(α) = −N(α).

Consequently

(Q₂(s₀), …, Q₂(s₅)) = (2, 2, 2, −2, −2, −2).

This is the most canonical exact arithmetic rule in the data: no rounding, normalization, scale, or free coefficient is required. Its limitation is that the norm is Galois invariant, so it necessarily collapses the three embeddings and detects only the ε sheet.

The result also agrees exactly with the already integral invariant Q₂(s) = tr_μ(s) = tr_s(s) = −tr_λ(s), for these six states. I therefore do not count those expressions as separate candidates; they reproduce the same integer function.

## Conclusion

Under the packet's permitted forms, the answer is therefore yes, with an important distinction:

Q₁ = (−2, 2, 0, 1, −1, 3) is a low-complexity, internally motivated rule that assigns six distinct integers, while

Q₂ = (2, 2, 2, −2, −2, −2) is the cleaner and genuinely exact arithmetic invariant but distinguishes only the two parity sheets.

I do not regard the data as supporting a third independent natural rule worth reporting.

One internal consistency issue in the frozen data should be recorded: the stated exact identity tr_b=tr_a+1 is satisfied by states s₀,s₁,s₂ but not by the tabulated ε=−1 rows s₃,s₄,s₅. Neither candidate above depends on tr_b, so this discrepancy does not affect the two reported rules.
