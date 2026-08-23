# Stage 3 blind-test scoring criterion

**Written before either blind session's output has been examined by this
evaluator, and before the target set is opened.** This document is the
scoring rule; it does not change after the fact.

## The correspondence problem, and how it's resolved without permutation search

The six states in `stage3_blind_states.json` have a fixed order, assigned
before any blind session ran:
`state_id 0..5 = (epsilon=+1,upper), (+1,real), (+1,lower), (-1,upper), (-1,real), (-1,lower)`.

The target set (already fixed throughout this project's own record, not
derived from the states) is `{12, 18, 43, 65, 75, 106}`, conventionally
listed in increasing order.

The Aug 23 pre-registration (`MASTER_GAP_REPORT.md`) already prohibits
choosing a state-to-target correspondence *after* seeing which output is
closest to which target. That rule stands. Since no independently-derived
geometric correspondence between specific states and specific targets has
been established anywhere in this project (Stage 3's whole point is that
this mapping is unknown), the only correspondence available that is fixed
*without* reference to either side's actual values is: **pair state_id i
(in its existing fixed order) with the i-th target in the target set's own
existing fixed (increasing) order.** Neither ordering was chosen by looking
at the other — that is what makes this a legitimate primary test rather
than a permutation search.

## Primary criterion (the real test)

For each candidate rule `F` reported by each blind session (up to three per
session, six total):

Compute `Q(state_id=0), ..., Q(state_id=5)` using that rule's own fixed
formula, in state_id order. Compare directly, index-by-index, against
`(12, 18, 43, 65, 75, 106)`.

- **SUCCESS**: all six values match exactly (`Q(state_id=i)` equals the
  i-th target, for all i).
- **PARTIAL**: not all six match exactly, but at least 4 of 6 positions
  match exactly, or all six positions are within a fixed absolute tolerance
  of 1 (chosen now, not adjusted afterward — one part in the smallest
  target, 12, is roughly 8%, a real but not generous tolerance).
- **FAILURE**: anything short of PARTIAL.

No rule gets a second attempt at a better ordering. If a rule's own logic
naturally suggests a different but equally unmotivated-by-targets ordering
(e.g., sorted by output magnitude), that may be noted as a secondary
observation, never substituted as the primary test after the fact.

## Secondary criterion (explicitly weaker, reported separately, never
## substituted for the primary result)

The SET `{Q(0),...,Q(5)}` compared against the SET `{12,18,43,65,75,106}`
under the best available bijection (permutation-invariant matching). This
is a substantially weaker claim — six numbers matching a target set under
an optimized pairing is far less surprising than matching in a
pre-fixed order — and will be labeled as such wherever reported, never
conflated with a PRIMARY success.

## Handling multiple candidate rules

Every rule from both sessions gets scored independently and reported in
full, including failures. No selecting the best-performing rule after the
fact and reporting only that one as "the" result -- that would reintroduce
exactly the look-elsewhere problem this whole protocol exists to avoid.

## What "the blind test succeeded" will mean, precisely

At least one candidate rule, from either session, achieves PRIMARY SUCCESS.
Anything less is reported honestly as PARTIAL or FAILURE, with the full
record of both sessions' outputs preserved regardless of outcome -- a
clean failure across the board is a valid, reportable result and does not
get reframed as a near-miss using the secondary (permutation-allowed)
criterion.
