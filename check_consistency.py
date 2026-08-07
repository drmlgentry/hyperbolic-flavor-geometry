#!/usr/bin/env python3
"""
Scans papers/ (all .tex) and the YouTube narration script for phrases that
were retracted, corrected, or superseded this program -- see CLAIMS_REGISTER.md
for the full story behind each one. Prints filename:line and the matched text;
does not modify anything.

Two phrases are context-sensitive rather than plain substrings:
  - "unique minimum-volume" is only flagged when the same line doesn't also
    mention H_1 / H1 (the qualifier that makes the claim correct -- see
    CLAIMS_REGISTER.md entry 8).
  - spelling variants (programme/flavour/colour/honour/behaviour) are reported
    but not treated as errors in archived paper versions -- per Aug 7 2026
    decision, spelling fixes apply to new/active work going forward only, not
    retroactively to historical drafts.
"""
import re
import sys
from pathlib import Path

REPO = Path(r"C:\dev\hyperbolic-flavor-geometry")
NARRATION_SCRIPT = Path(r"C:\dev\HFG-CORPUS\lecture\youtube_hfg_overview_narration_script.md")

SPELLING_VARIANTS = {"programme", "flavour", "colour", "honour", "behaviour"}

# (label, compiled regex, is_spelling)
PATTERNS = [
    ("Q(sqrt(17)) -- retracted ITF claim, F-002", re.compile(r"Q\(\s*\\?sqrt\{?17\}?\s*\)", re.IGNORECASE), False),
    ("order-6 Eisenstein torsion -- retracted, m206 H1=Z/5 not order 6", re.compile(r"order-6 Eisenstein torsion", re.IGNORECASE), False),
    ("N(16+12*omega) -- refuted Eisenstein BPS muon ratio", re.compile(r"N\(\s*16\D+12\D+omega", re.IGNORECASE), False),
    ("N(68+37*omega) -- refuted Eisenstein BPS tau ratio", re.compile(r"N\(\s*68\D+37\D+omega", re.IGNORECASE), False),
    ("0.003618 -- superseded CKM fitness (canonical is 0.002728)", re.compile(r"0\.003618"), False),
    ("zero free parameters -- overclaim, verify context (some results genuinely are; others fit sigma)", re.compile(r"zero free parameters", re.IGNORECASE), False),
    ("programme", re.compile(r"\bprogramme\b", re.IGNORECASE), True),
    ("flavour", re.compile(r"\bflavour\b", re.IGNORECASE), True),
    ("colour", re.compile(r"\bcolour\b", re.IGNORECASE), True),
    ("honour", re.compile(r"\bhonour\b", re.IGNORECASE), True),
    ("behaviour", re.compile(r"\bbehaviour\b", re.IGNORECASE), True),
]

UNIQUE_MIN_VOL_RE = re.compile(r"unique minimum[- ]volume", re.IGNORECASE)
H1_RE = re.compile(r"H[_\s]?1|H_?\{?1\}?|first homology", re.IGNORECASE)

def scan_file(path):
    hits = []
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(f"  ! could not read {path}: {e}", file=sys.stderr)
        return hits
    for lineno, line in enumerate(text.splitlines(), start=1):
        for label, pattern, is_spelling in PATTERNS:
            m = pattern.search(line)
            if m:
                hits.append((lineno, label, m.group(0), is_spelling))
        if UNIQUE_MIN_VOL_RE.search(line) and not H1_RE.search(line):
            hits.append((lineno, "unique minimum-volume claim missing H_1 qualifier (see CLAIMS_REGISTER.md #8)", UNIQUE_MIN_VOL_RE.search(line).group(0), False))
    return hits

def main():
    targets = list(REPO.glob("papers/**/*.tex"))
    if NARRATION_SCRIPT.exists():
        targets.append(NARRATION_SCRIPT)

    total_hits = 0
    spelling_hits = 0
    files_with_hits = 0

    for path in sorted(targets):
        hits = scan_file(path)
        if not hits:
            continue
        files_with_hits += 1
        rel = path.relative_to(REPO) if REPO in path.parents else path
        for lineno, label, matched, is_spelling in hits:
            total_hits += 1
            if is_spelling:
                spelling_hits += 1
            print(f"{rel}:{lineno}: [{label}] {matched!r}")

    print()
    print(f"--- {total_hits} matches across {files_with_hits} files "
          f"({spelling_hits} spelling, {total_hits - spelling_hits} content) ---")
    print("Spelling matches in archived/versioned paper drafts are NOT auto-fixed "
          "(Aug 7 2026 decision: spelling changes apply going forward only).")

if __name__ == "__main__":
    main()
