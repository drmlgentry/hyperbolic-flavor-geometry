# Blind selector task

You are given a frozen data file, `stage3_blind_states.json`, describing a
six-element state space `S` built from the arithmetic of a number field and
its Galois group, together with five numerical invariants attached to every
state. Read that file's own `construction_summary` and
`invariants_attached_to_each_state` fields for the exact definitions — this
document only states the task and the rules.

## The question

**Does this specific set of six states admit a natural, low-complexity,
integer-valued function `Q: S -> Z`, built from a single fixed rule applied
uniformly to the five invariants already attached to each state?**

Do not assume such a function exists. A negative answer — "no natural rule
of the permitted forms produces six well-defined integers here" — is a
completely valid, useful outcome and should be reported as such if that is
what you find.

## Rules for constructing a candidate `Q`

1. **One fixed rule `F` for all six states.** `Q(s_i) = F(I_1(s_i), I_2(s_i),
   ...)` where `I_1, I_2, ...` are drawn only from the five invariants
   already in the data file (`tr_a`, `tr_b`, `tr_mu`, `tr_lambda`, `tr_s`,
   `epsilon`, `embedding`) or simple, standard derived quantities of them
   (e.g. modulus, argument, real/imaginary part, a field norm, an eigenvalue
   computed from a trace). No state-specific constants — the same `F`, with
   the same coefficients, must apply to every one of the six rows.
2. **Restricted functional forms only.** Permitted starting points:
   - `Q = round(A*I + B)` for a single invariant `I` and constants `A, B`;
   - `Q = N(alpha)` — an algebraic norm of a canonical element attached to
     the state;
   - `Q = c1*I_1 + c2*I_2` — a simple linear combination of at most two
     invariants;
   - an exact integer that the arithmetic already produces without any
     scaling at all.
   Do **not** search over arbitrary nonlinear combinations, and do not
   introduce new free constants purely to make outputs land in some
   preferred range — every constant used must be independently motivated
   from the mathematical structure itself (e.g. a quantity that already
   appears elsewhere in the construction, or a small integer with a clear
   combinatorial meaning), not chosen to make the output "look right."
3. **No external target data of any kind.** You have not been given, and
   should not seek out, guess, or assume the existence of any comparison
   values for these six states. Treat this purely as a question about
   whether the given algebraic/geometric data canonically supports an
   integer-valued function — not as a fitting problem.
4. **Report at most three candidate rules**, ranked by mathematical
   naturalness (fewest free choices, clearest motivation from the
   construction, cleanest resulting integers), each with:
   - the exact formula for `F`,
   - the resulting six values `Q(s_0), ..., Q(s_5)`,
   - one or two sentences on why this rule is a natural one to propose
     for this specific structure, not a generic template.
5. **Freeze your answer.** Once you state your ranked candidate(s), do not
   revise them in light of any later information. This response is the
   experimental record.

## What you do not need, and should not need, to answer this

You do not need to know what this state space is "for," what field it
might apply to, or what scale of numbers might be expected. If you find
yourself reasoning about what the "right" output range should look like
for some external reason, stop — that is outside the scope of this
question. Answer strictly from the internal structure of `S` and its five
invariants.
