# Repository guidance

## Maintain docs/progress.html incrementally

`docs/progress.html` is a timestamped, honest research log for the HFG
program — see its own stated purpose in the page header: "A timestamped
record of results, corrections, and open questions — including errors and
how they were caught. Rigour requires honesty about the path, not just the
destination." It is deployed live at hyperbolicflavorgeometry.org.

**When a session reaches a significant result, correction, retraction, or
decision** (a new theorem proved, an error found and fixed, a claim
downgraded or withdrawn, a paper submitted or its status changing), add a
dated entry to `docs/progress.html` in the same session, following the
existing entry format (`.entry` block with date, type badge
correction/result/open/note, and a plain description of what changed and
why). Do this as the work happens, not retroactively.

**Do not attempt to backfill gaps in the log after the fact.** If entries
are missing for a stretch of time, do not write new entries dated to that
period based on reconstructed or incomplete memory of what happened —
a partial reconstruction makes the register *less* trustworthy, not more,
because it implies a completeness that isn't actually there. If a gap is
discovered, note the gap explicitly (e.g. an entry that says "records
between [date] and [date] were not kept contemporaneously and are not being
reconstructed retroactively") rather than papering over it with cherry-picked
entries.

The register is only useful if it can be trusted as complete-as-kept. The
discipline is: log it now, or explicitly flag that it wasn't logged --
never quietly half-fill it later.
