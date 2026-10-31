#!/usr/bin/env python3
"""
make_sha256_manifest.py
=======================
Builds / checks reproduce/SHA256SUMS for every certificate script named in
the paper papers/gentry-m003-arithmetic-v5.tex (Table 1 and the text), plus
each script's committed log.

Hashes are taken over the COMMITTED blob contents (git show HEAD:<path>), not
the working-tree copy, so they do not depend on the checkout's line-ending
conversion (this repository checks text files out as CRLF on Windows).
`sha256sum -c reproduce/SHA256SUMS` therefore verifies on a Linux/macOS
clone; on Windows use `python reproduce/make_sha256_manifest.py --verify`.

Usage (from anywhere inside the repo):
    python reproduce/make_sha256_manifest.py              # dry run, writes nothing
    python reproduce/make_sha256_manifest.py --write      # writes SHA256SUMS + MANIFEST.md
    python reproduce/make_sha256_manifest.py --verify     # checks HEAD blobs against SHA256SUMS

Exit status is non-zero if a script named in the paper is missing from the
repository, appears at more than one path, or has no committed log.
"""
import argparse
import hashlib
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
TEX = "papers/gentry-m003-arithmetic-v5.tex"
SUMS = "reproduce/SHA256SUMS"
MANIFEST = "reproduce/MANIFEST.md"
LOG_SUFFIXES = (".log", ".out")

# The atlas script writes a run log under a different stem plus three CSVs and
# its own manifest (reproduce/m003_atlas_manifest.json), which records the CSV
# hashes; they are listed explicitly and cross-checked against that manifest.
EXTRA_OUTPUTS = {
    "m003_structure_atlas.sage": [
        "reproduce/m003_atlas_run.log",
        "reproduce/m003_atlas_manifest.json",
        "reproduce/m003_filling_summary.csv",
        "reproduce/m003_pair_atlas.csv",
        "reproduce/m003_word_atlas.csv",
    ],
}


def git(*args, binary=False):
    p = subprocess.run(["git", "-C", str(REPO), *args], capture_output=True)
    if p.returncode != 0:
        raise RuntimeError(p.stderr.decode("utf-8", "replace").strip())
    return p.stdout if binary else p.stdout.decode("utf-8", "replace")


def paper_script_names():
    text = (REPO / TEX).read_text(encoding="utf-8")
    raw = re.findall(r"\\texttt\{([^}]*)\}", text)
    names = set()
    for r in raw:
        n = r.replace("\\_", "_")
        if n.endswith((".py", ".sage")):
            names.add(n)
    return sorted(names)


def blob_sha256(path):
    return hashlib.sha256(git("show", "HEAD:" + path, binary=True)).hexdigest()


def build():
    tracked = git("ls-files").splitlines()
    rows, problems = [], []
    for name in paper_script_names():
        hits = [t for t in tracked if t == name or t.endswith("/" + name)]
        if len(hits) == 0:
            problems.append(f"MISSING  script named in paper is not tracked: {name}")
            continue
        if len(hits) > 1:
            problems.append(f"AMBIGUOUS {name} appears at {hits}")
            continue
        script = hits[0]
        stem = script.rsplit(".", 1)[0]
        logs = [t for t in tracked
                if t.rsplit(".", 1)[0] == stem and t.endswith(LOG_SUFFIXES)]
        if name in EXTRA_OUTPUTS:
            logs = logs + [e for e in EXTRA_OUTPUTS[name] if e in tracked]
            for e in EXTRA_OUTPUTS[name]:
                if e not in tracked:
                    problems.append(f"MISSING  atlas output not tracked: {e}")
        if not logs:
            problems.append(f"NO LOG   no committed log/out next to {script}")
        rows.append((name, script, logs))
    return rows, problems


def check_atlas_manifest():
    """The atlas manifest records the CSV and script hashes; confirm them."""
    import json
    m = json.loads(git("show", "HEAD:reproduce/m003_atlas_manifest.json"))
    msgs = []
    for key, info in m["outputs"].items():
        path = "reproduce/" + info["path"].lstrip("./")
        ok = blob_sha256(path).upper() == info["sha256"].upper()
        msgs.append(f"  atlas manifest vs committed {path}: {'match' if ok else 'MISMATCH'}")
    ok = blob_sha256("reproduce/m003_structure_atlas.sage").upper() == m["script_sha256"].upper()
    msgs.append(f"  atlas manifest vs committed m003_structure_atlas.sage: {'match' if ok else 'MISMATCH'}")
    return msgs


def dirty(paths):
    out = git("status", "--porcelain", "--", *paths)
    return [l for l in out.splitlines() if l.strip()]


def main():
    ap = argparse.ArgumentParser()
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--write", action="store_true")
    g.add_argument("--verify", action="store_true")
    args = ap.parse_args()

    if args.verify:
        bad = 0
        for line in (REPO / SUMS).read_text().splitlines():
            if not line.strip():
                continue
            h, p = line.split(None, 1)
            p = p.strip()
            ok = blob_sha256(p) == h
            bad += (not ok)
            print(("OK    " if ok else "FAIL  ") + p)
        print("verify:", "all match" if not bad else f"{bad} MISMATCH(ES)")
        sys.exit(1 if bad else 0)

    rows, problems = build()
    files = []
    for _, script, logs in rows:
        files += [script] + logs
    print(f"{len(rows)} scripts named in the paper; {len(files)} files to hash\n")
    for name, script, logs in rows:
        print(f"  {name:46s} -> {script}  |  logs: {', '.join(logs) if logs else '(none)'}")
    if problems:
        print("\nPROBLEMS:")
        for pr in problems:
            print("  " + pr)
    d = dirty(files)
    if d:
        print("\nWARNING: uncommitted changes in files to be hashed (hash uses HEAD):")
        for l in d:
            print("  " + l)
    print("\nCross-check against the atlas's own manifest:")
    for msg in check_atlas_manifest():
        print(msg)
        if "MISMATCH" in msg:
            problems.append("ATLAS   " + msg.strip())
    if problems:
        sys.exit(2)
    if not args.write:
        print("\ndry run: nothing written (use --write)")
        return

    head = git("rev-parse", "HEAD").strip()
    lines = [f"{blob_sha256(f)}  {f}" for f in sorted(set(files))]
    (REPO / SUMS).write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    md = ["# SHA-256 manifest", "",
          "Scripts named in `papers/gentry-m003-arithmetic-v5.tex` (Table 1 and text) "
          "and their committed logs, hashed over the committed blob contents at "
          f"commit `{head}`.", "",
          "Verify on Linux/macOS: `sha256sum -c reproduce/SHA256SUMS` (run from the "
          "repository root).  Verify anywhere: "
          "`python reproduce/make_sha256_manifest.py --verify`.  Regenerate: "
          "`python reproduce/make_sha256_manifest.py --write`.", "",
          "| Script | Log(s) | SHA-256 of script |", "|---|---|---|"]
    for name, script, logs in rows:
        md.append(f"| `{script}` | {', '.join('`'+l+'`' for l in logs)} | `{blob_sha256(script)}` |")
    (REPO / MANIFEST).write_text("\n".join(md) + "\n", encoding="utf-8", newline="\n")
    print(f"\nwrote {SUMS} ({len(lines)} lines) and {MANIFEST}")


if __name__ == "__main__":
    main()
