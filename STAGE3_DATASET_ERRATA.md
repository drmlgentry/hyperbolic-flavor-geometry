# Errata: stage3_blind_states.json

**The frozen packet is NOT edited in place.** `stage3_blind_states.json` and
`STAGE3_BLIND_PACKET.md` (commit `29c3c08`) remain exactly as they were when
handed to both blind sessions — they are the historical experimental input,
and rewriting them after the fact would defeat the point of freezing them.
This document records the correction separately.

## The error

`stage3_blind_states.json`'s `exact_facts_established_about_these_invariants`
list stated:

> "tr_b = tr_a + 1 exactly, in every state -- a fixed integer offset,
> independent of embedding or epsilon."

**This is an overgeneralization.** It is true only for the three `epsilon=+1`
states (`s0, s1, s2`). Caught by the independent blind GPT session, which
checked the claim against the raw `tr_a_re/im`, `tr_b_re/im` columns rather
than taking the packet's summary at face value — see `stage3_blind_response_gpt.md`'s
closing paragraph.

## The correct relationship

`tr_b` itself never flips sign with `epsilon` (established: `chi(b)=0`,
Stage 3A). `tr_a` does flip (`chi(a)=1`). So relative to the two *displayed*
columns:

- `epsilon = +1`: `tr_b = tr_a + 1`
- `epsilon = -1`: `tr_b = 1 - tr_a`

Verified directly against every row of the sealed data (not merely asserted):
for states `s3, s4, s5`, `tr_b - tr_a` computes to `-1.2056-1.3309i`,
`-1.2056+1.3309i`, and `3.4111` respectively — matching `1 - tr_a` in each
case, not `tr_a + 1`.

## What this is not

This is **not** a computational bug in the underlying construction. The
six rows of numbers in `stage3_blind_states.json` are internally consistent
with the already-established asymmetric spin character (`chi(a)=1,
chi(b)=0`) and require no correction themselves. The error was entirely in
one sentence of summary documentation describing that data.

## Downstream effect

Claude's blind candidate #3 (`Q = tr_b - tr_a`, reported as constant `1`
across all six states) relied on the packet's incorrect claim rather than
re-deriving the relationship from the raw columns, and is invalid for
states `s3, s4, s5` as a result. Candidates #1 and #2 from both sessions
do not reference `tr_b` and are unaffected. None of the five candidates
passed the pre-registered unblinding regardless (see
`MASTER_GAP_REPORT.md`, Aug 23 2026 entry) — this error did not change the
outcome of the blind test, only the validity of one already-failing
candidate's stated justification.

## Where the fix lives

`reproduce/stage3_enrich_state_invariants.sage` and its regenerated outputs
(`stage3_enriched_state_invariants.csv/json`) now document the correct,
epsilon-dependent relationship explicitly. Any future dataset built from
this construction should cite the corrected relation above, not the
original packet's claim.
