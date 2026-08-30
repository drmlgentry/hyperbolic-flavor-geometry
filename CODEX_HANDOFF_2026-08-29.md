# Codex Handoff — m009 Endpoint-Preserving Normalizer

This is the continuous research log for Codex work performed while Claude is unavailable. It is intended to let Claude reconstruct every development from repository artifacts without relying on chat history.

## Standing scope and evidentiary rule

The sole unresolved arithmetic target is

\[
[N_K^+(R):\Gamma_{009}^+],\qquad
\Gamma_{009}^+=\langle a^2,ab,ba^{-1}\rangle.
\]

The value \(2\) is a **CONJECTURE/candidate**, not a theorem. It must not be promoted unless the full simultaneous stabilizer

\[
N_K^+(R)=\{g\in PGL_2(K):gM_0g^{-1}=M_0,\ gM_1g^{-1}=M_1\}
\]

is independently constructed or measured and compared with \(\Gamma_{009}^+\) by either an exact coset enumeration or an independently certified covolume/index. Volume coincidence, a finite candidate search, or a non-exhaustive local/residual enumeration is insufficient.

## 2026-08-29 — Logging scaffold

**Objective.** Establish an immutable provenance checkpoint before new arithmetic work.

**Classification.** REPRODUCIBILITY CLEANUP.

**Program repository before this checkpoint.**

- Path: `C:\dev\hyperbolic-flavor-geometry`
- HEAD: `bccae2933ca69cf39056bf9c82f9dc08a4a8c1bc`
- Tree: dirty before this file was created. Pre-existing modified and untracked files belong to Claude/the user and must not be overwritten or included in this checkpoint.

**Corpus repository.**

- Path: `C:\dev\HFG-CORPUS`
- Last previously inspected HEAD: `7adde4e`
- Canonical research record: `C:\dev\HFG-CORPUS\MASTER_GAP_REPORT.md`
- No corpus file is modified by this logging checkpoint.

**Commands used to establish provenance.**

```powershell
git rev-parse HEAD
git status --short
git -C C:\dev\HFG-CORPUS rev-parse HEAD
git -C C:\dev\HFG-CORPUS status --short
```

The corpus queries initially encountered Git's dubious-ownership protection under the Codex sandbox account. Future read-only queries should use a per-command `-c safe.directory=C:/dev/HFG-CORPUS` override; do not mutate global Git configuration merely to inspect it.

## Certified boundary at handoff

The following are already established and should not consume new compute unless needed as dependencies:

- **CERTIFIED COMPUTATION:** \(\varepsilon(a)=\varepsilon(b)=1\).
- **CERTIFIED COMPUTATION:** \(\varepsilon(ab)=\varepsilon(ba^{-1})=0\).
- **THEOREM + CERTIFIED COMPUTATION:** \(\Gamma_{009}^+=\ker\varepsilon=\langle a^2,ab,ba^{-1}\rangle\).
- **CERTIFIED COMPUTATION:** \([\Gamma_{009}:\Gamma_{009}^+]=2\).
- **CERTIFIED COMPUTATION:** all three kernel generators have explicit \(K\)-rational projective representatives.
- **CERTIFIED COMPUTATION:** \(H_1(\Gamma_{009}^+)\cong\mathbb Z^2\).
- **CERTIFIED COMPUTATION:** the associated double cover is \(L6a1\cong s780\), and it has two cusps.
- **THEOREM/CERTIFIED LOCAL COMPUTATION:** \(N(R_{\bar{\mathfrak p}})=N(E_{\bar{\mathfrak p}})\).
- **THEOREM, using standard strong approximation:** the local branch-swapping coset globalizes.
- **CERTIFIED COMPUTATION:** \(\Gamma_{009}\) itself contains branch-swapping elements.

Primary reproduced logs include:

- `reproduce/m009_task2_epsilon_krational.log`
- `reproduce/ba_inv_check.log`
- `reproduce/m009_task2_epsilon_vs_H1.log`
- `reproduce/m009_task2_identify_double_cover_v2.log`
- `reproduce/m009_task2_identify_double_cover_v3.log`
- `reproduce/m009_normalizer_certificate.log`
- `reproduce/m009_strong_approx_local_check.log`

The direct \(ba^{-1}\) endpoint test presently resides in `ba_inv_check.log`, rather than being asserted inside `m009_task2_epsilon_krational.sage`. Incorporating it and asserting all four endpoint outcomes would be reproducibility cleanup, not new mathematics.

### CURRENT STATE

**Established since handoff**

- Logging/provenance scaffold created; no new mathematical claim.

**Disconfirmed since handoff**

- Nothing.

**Still open**

- Exact determination of \([N_K^+(R):\Gamma_{009}^+]\).

**Current best evidence for the index**

- Candidate value: \(2\), supported by a volume heuristic only. The covolume of the actual full endpoint-preserving normalizer has not been independently certified, so this is not theorem-level evidence.

**Next exact computation**

- Construct or measure the full global simultaneous stabilizer of \(M_0,M_1\) from global order/ideal-class data, then perform an exact coset or independently certified covolume comparison against \(\langle a^2,ab,ba^{-1}\rangle\).

**Files/logs Claude should inspect**

- `CODEX_HANDOFF_2026-08-29.md`
- The seven reproduced logs listed above.

**Program repo HEAD**

- Before scaffold commit: `bccae2933ca69cf39056bf9c82f9dc08a4a8c1bc`
- After scaffold commit: to be recorded after commit in the next log entry.

**Corpus repo HEAD**

- `7adde4e` (last previously inspected; to be rechecked with a per-command safe-directory override).

## 2026-08-29 — Scaffold commit attempt blocked

**Objective.** Commit the logging scaffold alone, without staging any pre-existing dirty-tree work.

**Exact commands attempted.**

```powershell
git add -- CODEX_HANDOFF_2026-08-29.md
git diff --cached --check
git diff --cached --stat
git diff --cached --name-only
git commit -m "Add Codex handoff scaffold for m009 normalizer work"
```

**Result.** FAILED ATTEMPT / ENVIRONMENTAL BLOCKER. Git could not create `C:/dev/hyperbolic-flavor-geometry/.git/index.lock`: permission denied. A second attempt after requesting explicit write permission for the repository's `.git` directory failed identically. Nothing was staged or committed; program HEAD remains `bccae2933ca69cf39056bf9c82f9dc08a4a8c1bc`. The handoff file itself exists as an untracked working-tree file.

**Safety consequence.** No unrelated Claude/user changes were staged, modified, or committed. Claude or the user can create the intended immutable checkpoint later with the same single-file `git add` and commit commands under the repository-owning account.

## 2026-08-29 — Local `.git` write diagnosis

**Objective.** Determine whether the scaffold commit failure came from a stale lock, file attributes, another Git process, local ACLs, or remote authentication.

**Classification.** REPRODUCIBILITY CLEANUP / NEGATIVE RESULT.

**Commands executed.**

```powershell
Test-Path -LiteralPath '.git\index.lock'
Get-Item -Force -LiteralPath '.git' | Format-List FullName,Attributes,Mode
Get-Item -Force -LiteralPath '.git\index' | Format-List FullName,Attributes,Mode
icacls '.git'
Get-Process git* -ErrorAction SilentlyContinue
```

An explicitly requested temporary-file test using `.git\codex_write_test.tmp` was also submitted, but sandbox policy rejected the command before it launched; therefore no temporary file was created and no cleanup was necessary.

**Exact results.**

- `.git\index.lock` does not exist (`Test-Path` returned `False`).
- `.git` attributes are `Hidden, Directory`; it is not marked read-only.
- `.git\index` attributes are `Archive`; it is not marked read-only.
- No running `git*` process was returned.
- `icacls .git` reports explicit `DENY` access-control entries including `W`, `D`, `Rc`, `GW`, and `DC` for sandbox-related SIDs, despite inherited modify entries.
- The direct `.git` write test was rejected by sandbox policy before PowerShell execution.

**Conclusion.** The inability to create `.git/index.lock` is conclusively local sandbox/ACL enforcement. It occurs before any remote operation and is unrelated to PATs, GitHub, or Microsoft Credential Manager. It is not caused by a stale lock, read-only file attributes, or a currently running Git process.

**Manual checkpoint recipe for the repository-owning user.**

```powershell
cd C:\dev\hyperbolic-flavor-geometry
git add -- CODEX_HANDOFF_2026-08-29.md
git diff --cached --name-only
git commit -m "Add Codex handoff log for m009 normalizer work"
git rev-parse HEAD
```

The staged-name check should print only `CODEX_HANDOFF_2026-08-29.md`. After the user supplies the resulting hash, Codex should append it here.
