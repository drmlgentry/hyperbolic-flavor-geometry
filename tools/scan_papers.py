#!/usr/bin/env python3
"""
scan_papers.py — HFG Paper Disposition Scanner v2
Scans a directory of PDFs, extracts abstracts, and uses Claude
to classify each paper's disposition and recommend a venue.

Usage:
    python scan_papers.py [--dir PATH] [--out OUTPUT.md] [--filter gentry]
    python scan_papers.py --triage-only        # only classify UNKNOWN papers
    python scan_papers.py --no-api             # fast mode, known status only

Requirements:
    pip install pypdf pdfplumber requests
    Set ANTHROPIC_API_KEY environment variable for API classification.
"""

import os, sys, json, argparse, re, time
from pathlib import Path
from datetime import datetime

try:
    import pdfplumber
    HAS_PDFPLUMBER = True
except ImportError:
    HAS_PDFPLUMBER = False

try:
    from pypdf import PdfReader
    HAS_PYPDF = True
except ImportError:
    HAS_PYPDF = False

import requests

# ─── KNOWN SUBMISSION STATUS ──────────────────────────────────────────────────
# Update this dict as papers are submitted/rejected/accepted.
# Keys are PDF stems (filename without .pdf).
KNOWN_STATUS = {
    # TODAY — new papers
    "gentry_meyerhoff_gauss":    ("NEW_NEEDS_SSRN",          "Letters in Mathematical Physics",      "Post to SSRN; then submit to LMP"),
    "gentry-gauss-wrt":          ("NEW_NEEDS_SSRN",          "Letters in Mathematical Physics",      "Post to SSRN; same content as meyerhoff_gauss — merge or pick one"),
    "gentry-bps-lepton":         ("NEW_NEEDS_SSRN",          "JHEP or Commun. Math. Phys.",          "Post to SSRN; requires arXiv for JHEP"),

    # ACTIVE in review
    "gentry-torsion-plb":        ("ACTIVE_REVIEW",           "PLB-D-26-01449 (Kitano)",              "Monitor"),
    "gentry-pmns-plb":           ("ACTIVE_REVIEW",           "PLB-D-26-01448 (Kitano)",              "Monitor"),
    "gentry-hfg-unified-v3":     ("ACTIVE_REVIEW",           "NPB-D-26-00999 + PTEP 2605-035",       "Monitor"),
    "gentry-twist-symmetry":     ("ACTIVE_REVIEW",           "Universe universe-4362980",            "Monitor"),
    "gentry_farey_tower":        ("ACTIVE_REVIEW",           "Exp.Math. 266619148",                  "Monitor"),
    "gentry-farey-tower":        ("ACTIVE_REVIEW",           "Exp.Math. 266619148",                  "Monitor"),
    "gentry-cp-npb2":            ("ACTIVE_REVIEW",           "NPB-D-26-00998 (handling editor)",     "Monitor"),
    "gentry-mixing-jpa":         ("ACTIVE_REVIEW",           "JPhysA-124843",                        "Monitor"),
    "gentry-holonomy-cp-ahp":    ("ACTIVE_REVIEW",           "AHPO-D-26-00231 (rejected by Pillet)", "Content covered by PLB/NPB submissions; retire AHP version"),
    "gentry-flavor-mixing-jgp":  ("ACTIVE_REVIEW",           "JGP13076 (transfer to PLB pending)",   "Submit gentry-ckm-plb directly to PLB; don't wait for transfer"),
    "gentry-qubit-gates-jmp":    ("ACTIVE_REVIEW",           "JMP26-AR-01272",                       "Monitor"),

    # READY to submit
    "gentry-ckm-plb":            ("READY_TO_SUBMIT",         "PLB (direct submission)",              "Submit to PLB now — use editorialmanager.com/plb"),

    # REJECTED — needs redirect
    "gentry-cp-final":           ("REJECTED_NEEDS_REDIRECT", "PTEP 2605-036 covers this",            "No action — content is in PTEP T06113 and NPB-D-26-00998"),
    "gentry-neutrino-jphysg":    ("REJECTED_NEEDS_REDIRECT", "European Physical Journal C (neutrinos)", "Update with Eisenstein BPS framework; submit to EPJC neutrino section"),
    "gentry-neutrino":           ("REJECTED_NEEDS_REDIRECT", "European Physical Journal C (neutrinos)", "Same content as neutrino-jphysg; use the jphysg version"),

    # SUPERSEDED
    "gentry-pmns-jgp":           ("SUPERSEDED",              "Superseded by gentry-pmns-plb",        "Archive; no action"),
    "gentry-hfg-unified-v2":     ("SUPERSEDED",              "Superseded by v3",                     "Archive; no action"),
    "gentry-ckm-rip":            ("SUPERSEDED",              "Superseded by gentry-ckm-plb",         "Archive; no action"),
    "gentry-ckm-prd":            ("SUPERSEDED",              "Superseded by gentry-ckm-plb",         "Archive; no action"),
    "gentry-hfg-unified-v2":     ("SUPERSEDED",              "Superseded by v3",                     "Archive; no action"),
    "gentry_lucas_pure":         ("SUPERSEDED",              "Content in NPB-D-26-00998/999",        "Archive; no action"),
    "gentry_lucas_structure":    ("SUPERSEDED",              "Content in NPB-D-26-00998/999",        "Archive; no action"),

    # KNOWN UNKNOWNS — best inference without reading
    "gentry-x011-bridge-v2":     ("READY_TO_SUBMIT",         "Journal of Number Theory",             "Post to SSRN 6815721 (done); submit to J. Number Theory"),
    "gentry-x011-bridge":        ("SUPERSEDED",              "Superseded by v2",                     "Use gentry-x011-bridge-v2"),
    "gentry-hfg-unified-npb":    ("SUPERSEDED",              "Superseded by gentry-hfg-unified-v3",  "Archive; no action"),
    "gentry-hfg-unified":        ("SUPERSEDED",              "Superseded by v3",                     "Archive; no action"),
    "gentry-pmns-final":         ("SUPERSEDED",              "Superseded by gentry-pmns-plb",        "Archive; no action"),
    "gentry-ckm-final":          ("SUPERSEDED",              "Superseded by gentry-ckm-plb",         "Archive; no action"),
    "gentry-pmns-rip-final":     ("SUPERSEDED",              "Superseded by gentry-pmns-plb",        "Archive; no action"),
    "gentry-ckm-rip-final":      ("SUPERSEDED",              "Superseded by gentry-ckm-plb",         "Archive; no action"),
    "gentry-pmns-rip":           ("SUPERSEDED",              "Superseded by gentry-pmns-plb",        "Archive; no action"),
    "gentry-pmns-rip-fixed":     ("SUPERSEDED",              "Superseded by gentry-pmns-plb",        "Archive; no action"),
    "gentry-flavor-mixing":      ("SUPERSEDED",              "Superseded by gentry-flavor-mixing-jgp","Archive; no action"),
    "gentry-flavor-mixing (1)":  ("SUPERSEDED",              "Duplicate of gentry-flavor-mixing",    "Archive; no action"),
    "gentry-holonomy-cp":        ("SUPERSEDED",              "Superseded by gentry-holonomy-cp-ahp", "Archive; no action"),
    "gentry-covering-tower":     ("SUPERSEDED",              "Superseded by gentry-farey-tower",     "Archive; no action"),
    "gentry_covering_tower":     ("SUPERSEDED",              "Superseded by gentry-farey-tower",     "Archive; no action"),
    "gentry-hyperbolic-flavor-cp-epjc": ("SUPERSEDED",       "Superseded by gentry-cp-npb2",        "Archive; no action"),
    "gentry-mixing-jpa (1)":     ("DUPLICATE",               "Duplicate of gentry-mixing-jpa",       "Archive; use gentry-mixing-jpa"),
    "gentry-qubit-gates-jmp2":   ("DUPLICATE",               "Duplicate/revision of jmp version",    "Confirm which version was submitted to JMP26-AR-01272"),
    "gentry-qubit-gates":        ("SUPERSEDED",              "Superseded by gentry-qubit-gates-jmp", "Archive; no action"),
    "gentry-twist-symmetry-figs":("SUPERSEDED",              "Figures supplement only",              "Archive; figures are embedded in main paper"),
    "gentry-twist-final":        ("SUPERSEDED",              "Superseded by gentry-twist-symmetry",  "Archive; no action"),
    "gentry_covering_tower_mmj": ("NEEDS_UPDATE",            "Michigan Mathematical Journal",        "Compare to Exp.Math. version; MMJ is stronger venue if more rigorous"),
}

# Papers Claude should classify via API (not in KNOWN_STATUS)
NEEDS_API = {
    "gentry-hfg-arithmetic",
    "gentry-wrt-x011",
    "gentry-cof-lattice",
    "gentry-rigidity",
    "gentry-twist-dc",
    "gentry-weeks-dehn",
    "SU_paper_short",
    "GW_phi_lattice",
    "gentry-hyperbolic-lattice",
}

# ─── EMOJI MAP ────────────────────────────────────────────────────────────────
DISP_EMOJI = {
    "ACTIVE_REVIEW":           "🟢",
    "READY_TO_SUBMIT":         "🔵",
    "NEW_NEEDS_SSRN":          "🆕",
    "REJECTED_NEEDS_REDIRECT": "🔴",
    "NEEDS_UPDATE":            "🟡",
    "SUPERSEDED":              "⚫",
    "DUPLICATE":               "🔁",
    "SPECULATIVE_HOLD":        "🔮",
    "UNKNOWN":                 "❓",
    "API_ERROR":               "⚠️",
    "API_KEY_MISSING":         "⚠️",
    "PARSE_ERROR":             "⚠️",
}

# ─── PDF EXTRACTION ───────────────────────────────────────────────────────────
def extract_abstract(pdf_path: Path) -> str:
    text = ""
    if HAS_PDFPLUMBER:
        try:
            with pdfplumber.open(str(pdf_path)) as pdf:
                for page in pdf.pages[:2]:
                    t = page.extract_text()
                    if t: text += t + "\n"
        except Exception:
            pass
    if not text and HAS_PYPDF:
        try:
            reader = PdfReader(str(pdf_path))
            for page in reader.pages[:2]:
                t = page.extract_text()
                if t: text += t + "\n"
        except Exception:
            pass
    if not text:
        return ""
    return _isolate_abstract(text)[:2000]

def _isolate_abstract(text: str) -> str:
    patterns = [
        r'(?i)abstract\s*\n+(.*?)(?=\n\s*(?:1\.?\s+intro|introduction|keywords|1\s+intro))',
        r'(?i)abstract[:\.\—\-–]\s*(.*?)(?=\n\s*(?:1\.?\s+intro|introduction|keywords))',
        r'(?i)abstract\s+(.*?)(?=\n{2,})',
    ]
    for pattern in patterns:
        m = re.search(pattern, text, re.DOTALL)
        if m:
            abstract = m.group(1).strip()
            if len(abstract) > 100:
                return abstract
    return text[:1500].strip()

# ─── CLAUDE CLASSIFICATION ────────────────────────────────────────────────────
def classify_via_api(filename: str, abstract: str) -> tuple:
    """Returns (disposition, venue, reasoning, action)"""
    api_key = os.environ.get("ANTHROPIC_API_KEY", "")
    if not api_key:
        return ("API_KEY_MISSING", "Set ANTHROPIC_API_KEY",
                "No API key", "Set ANTHROPIC_API_KEY environment variable")

    system = """You are a mathematical physics publication strategist for the HFG 
(Hyperbolic Flavor Geometry) program by Marvin Gentry. Papers cover:
- Compact hyperbolic 3-manifolds (m003, m006) reproducing SM flavor parameters
- WRT invariants, Z-hat/GPPV homological blocks, Eisenstein lattice
- X_0(11) modular curve, BPS masses, class S theories, AdS3/CFT2
- Covering towers, Lucas primes, Bianchi modular forms, Langlands
- Qubit gate configurations, rigidity theorems, shape spaces

Given a filename and abstract, classify the paper.

Respond ONLY with valid JSON (no markdown fences):
{
  "disposition": "one of: READY_TO_SUBMIT / NEW_NEEDS_SSRN / NEEDS_UPDATE / SPECULATIVE_HOLD / SUPERSEDED / DUPLICATE",
  "venue": "specific journal name",
  "reasoning": "one sentence",
  "action": "one specific imperative sentence"
}

Venue guide:
- Rigorous topology/quantum invariants → Letters in Mathematical Physics OR Algebraic & Geometric Topology
- Arithmetic geometry / Langlands → Journal of Number Theory OR Compositio Mathematica  
- Physics phenomenology → Physics Letters B OR Nuclear Physics B
- Mathematical physics hybrid → Communications in Mathematical Physics OR Annales Henri Poincaré
- Exploratory/speculative → SSRN preprint only for now
- Qubit/quantum computing → Journal of Mathematical Physics
- Covering towers / arithmetic → Experimental Mathematics OR Michigan Mathematical Journal"""

    prompt = f"Filename: {filename}\n\nAbstract:\n{abstract if abstract else '[Could not extract text]'}"

    try:
        resp = requests.post(
            "https://api.anthropic.com/v1/messages",
            headers={
                "Content-Type": "application/json",
                "x-api-key": api_key,
                "anthropic-version": "2023-06-01"
            },
            json={
                "model": "claude-sonnet-4-20250514",
                "max_tokens": 300,
                "system": system,
                "messages": [{"role": "user", "content": prompt}]
            },
            timeout=30
        )
        resp.raise_for_status()
        raw = resp.json()["content"][0]["text"].strip()
        raw = re.sub(r'^```(?:json)?\s*|\s*```$', '', raw).strip()
        d = json.loads(raw)
        return (d.get("disposition","UNKNOWN"), d.get("venue","unknown"),
                d.get("reasoning",""), d.get("action","Review manually"))
    except json.JSONDecodeError:
        return ("PARSE_ERROR", "unknown", f"Parse error: {raw[:100]}", "Review manually")
    except Exception as e:
        return ("API_ERROR", "unknown", str(e)[:100], "Check API key")

# ─── MAIN ─────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir",          default=".", help="Directory to scan")
    parser.add_argument("--out",          default="paper_dispositions.md")
    parser.add_argument("--filter",       default="gentry")
    parser.add_argument("--no-api",       action="store_true")
    parser.add_argument("--triage-only",  action="store_true", help="Only process UNKNOWN papers")
    parser.add_argument("--limit",        type=int, default=0)
    args = parser.parse_args()

    scan_dir = Path(args.dir).expanduser().resolve()
    pdfs = sorted(
        [p for p in scan_dir.glob("*.pdf") if args.filter.lower() in p.name.lower()],
        key=lambda p: p.stat().st_mtime, reverse=True
    )
    if args.limit: pdfs = pdfs[:args.limit]

    print(f"Found {len(pdfs)} PDFs in {scan_dir}")
    print(f"API mode: {'OFF' if args.no_api else 'ON'}")
    print()

    results = []
    by_disp = {}

    for i, pdf in enumerate(pdfs):
        stem = pdf.stem
        known = KNOWN_STATUS.get(stem)

        if known:
            disp, venue, action = known
            reasoning = f"Known: {disp}"
            confidence = "HIGH"
            used_api = False
        elif args.no_api or stem not in NEEDS_API:
            disp, venue, action = "UNKNOWN", "Needs manual review", "Upload PDF for review or run without --no-api"
            reasoning = "Not in known status dict"
            confidence = "LOW"
            used_api = False
        else:
            # Call Claude
            abstract = extract_abstract(pdf)
            disp, venue, reasoning, action = classify_via_api(stem, abstract)
            confidence = "MEDIUM"
            used_api = True
            time.sleep(0.4)

        emoji = DISP_EMOJI.get(disp, "❓")
        api_tag = " [API]" if used_api else ""
        print(f"[{i+1:2d}/{len(pdfs)}] {stem[:48]:<48} {emoji} {disp}{api_tag}")

        entry = {
            "filename": pdf.name, "stem": stem,
            "modified": datetime.fromtimestamp(pdf.stat().st_mtime).strftime("%Y-%m-%d"),
            "size_kb": round(pdf.stat().st_size/1024),
            "disposition": disp, "venue": venue,
            "confidence": confidence, "reasoning": reasoning, "action": action,
        }
        results.append(entry)
        by_disp.setdefault(disp, []).append(entry)

    # ── Write report ──────────────────────────────────────────────────────────
    lines = [
        "# HFG Paper Disposition Report",
        f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M')}",
        f"Directory: {scan_dir}",
        f"Papers scanned: {len(results)}",
        "",
        "## Summary",
        "",
        "| # | Disposition | Count | Details |",
        "|---|---|---|---|",
    ]
    order = ["NEW_NEEDS_SSRN","READY_TO_SUBMIT","ACTIVE_REVIEW",
             "REJECTED_NEEDS_REDIRECT","NEEDS_UPDATE","UNKNOWN",
             "NEEDS_API_REVIEW","SUPERSEDED","DUPLICATE","SPECULATIVE_HOLD",
             "API_ERROR","API_KEY_MISSING","PARSE_ERROR"]
    for n, d in enumerate(order, 1):
        items = by_disp.get(d, [])
        if not items: continue
        emoji = DISP_EMOJI.get(d,"❓")
        sample = ", ".join(e["stem"][:25] for e in items[:4])
        if len(items) > 4: sample += f" (+{len(items)-4})"
        lines.append(f"| {n} | {emoji} {d} | {len(items)} | {sample} |")

    lines += ["", "---", ""]

    # Priority sections
    sections = [
        ("🆕 Post to SSRN / New Papers",     ["NEW_NEEDS_SSRN"]),
        ("🔵 Ready to Submit Now",            ["READY_TO_SUBMIT"]),
        ("🔴 Rejected — Needs Redirect",      ["REJECTED_NEEDS_REDIRECT"]),
        ("🟡 Needs Update",                   ["NEEDS_UPDATE"]),
        ("❓ Needs Triage (API not run)",      ["UNKNOWN"]),
        ("🟢 Active in Review",               ["ACTIVE_REVIEW"]),
        ("🔁 Duplicates",                     ["DUPLICATE"]),
        ("⚫ Superseded / Archived",          ["SUPERSEDED"]),
        ("🔮 Speculative Hold",               ["SPECULATIVE_HOLD"]),
        ("⚠️  Errors",                        ["API_ERROR","API_KEY_MISSING","PARSE_ERROR"]),
    ]

    for title, disps in sections:
        items = []
        for d in disps:
            items.extend(by_disp.get(d, []))
        if not items: continue
        lines += [f"## {title} ({len(items)})", ""]
        for e in sorted(items, key=lambda x: x["modified"], reverse=True):
            lines += [
                f"### `{e['stem']}`",
                f"**Date:** {e['modified']} | **Size:** {e['size_kb']} KB | **Confidence:** {e['confidence']}",
                f"**Venue:** {e['venue']}",
                f"**→ {e['action']}**",
                f"*{e['reasoning']}*",
                "",
            ]

    # Save
    out = Path(args.out)
    out.write_text("\n".join(lines), encoding="utf-8")
    Path(args.out.replace(".md",".json")).write_text(
        json.dumps(results, indent=2), encoding="utf-8")

    print(f"\n✓ {out.resolve()}")

    # Action summary
    print("\n" + "="*60)
    print("PRIORITY ACTIONS")
    print("="*60)
    for disp, label in [
        ("NEW_NEEDS_SSRN","🆕 POST TO SSRN"),
        ("READY_TO_SUBMIT","🔵 SUBMIT NOW"),
        ("REJECTED_NEEDS_REDIRECT","🔴 REDIRECT"),
        ("NEEDS_UPDATE","🟡 UPDATE"),
        ("UNKNOWN","❓ NEEDS TRIAGE (run without --no-api)"),
    ]:
        items = by_disp.get(disp,[])
        if items:
            print(f"\n{label} ({len(items)}):")
            for e in items:
                print(f"  {e['stem'][:42]:<42} → {e['action'][:55]}")

if __name__ == "__main__":
    main()
