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

## 2026-08-29 — First attack: exact-order inventory and determinant-class warning

**Objective.** Inspect existing scripts for reusable exact descriptions of (K,R,E,M_0,M_1), then derive the likely form of the full individual endpoint stabilizer before writing a new enumeration.

**Classification.** THEORETICAL DEDUCTION + OPEN DEPENDENCIES; no index promoted.

**Program Git state before experiment.** HEAD `bccae2933ca69cf39056bf9c82f9dc08a4a8c1bc`; tree already dirty as recorded above. The handoff file is untracked because sandbox ACLs prevent Git metadata writes.

**Commands executed.**

```powershell
rg -n "g0 =|g1 =|h =|M0|M1|E_std|global|maximal order|same_lattice|intersection|Gamma0|PGL2|PSL2|covol" ...
Get-Content reproduce/m009_dyadic_index_check.sage -TotalCount 420
Get-Content reproduce/m009_normalizer_certificate.sage -TotalCount 290
Get-Content -Raw reproduce/eichler_level_check.sage
Get-Content -Raw reproduce/order_index_predictions.sage
rg -n -g '*.sage' -g '*.log' -g '*.md' "g0 =|g1 =|connecting step|..." reproduce notes/MASTER_GAP_REPORT.md
```

The first `rg` call used shell-style wildcard path arguments, which Windows rejected. It produced no mathematical result and was superseded by the second `rg` call using `-g` filters.

**Exact reusable data found.**

- (K=mathbb Q(w)), (w^2-w+2=0), (mathcal O_K=mathbb Z[w]), and (ar{\mathfrak p}=(1-w)) with norm (2).
- `m009_atkin_lehner_global.log` records the exact local branch seed (g_0=\operatorname{diag}(2,1)), distance (1) from the identity vertex.
- The connecting step is exactly (h=\operatorname{diag}(2,1)); hence the other local branch vertex is represented by (g_1=g_0h=\operatorname{diag}(4,1)).
- In the (g_0)-pulled-back local frame,

  \[
  M_{0,\mathrm{std}}=M_2(\mathbb Z_2),\qquad
  M_{1,\mathrm{std}}=hM_2(\mathbb Z_2)h^{-1},
  \]

  and

  \[
  E_{\mathrm{std}}=M_{0,\mathrm{std}}\cap M_{1,\mathrm{std}}
  =\left\{\begin{pmatrix}a&b\\c&d\end{pmatrix}:a,c,d\in\mathbb Z_2, b\in2\mathbb Z_2\right\}.
  \]
- These are exact rational local representatives, not numerically recognized matrices. The existing scripts certify the local lattice statements and ([E_{\bar{\mathfrak p}}:R_{\bar{\mathfrak p}}]=2).
- The global discriminant scan certifies that (R) is maximal away from (ar{\mathfrak p}).

**Critical globalization caveat.** The rational representative (\operatorname{diag}(2,1)) is not automatically the correct global maximal-overorder representative: (2=w(1-w)) has positive valuation at both dyadic primes. A global lattice representing only the (ar{\mathfrak p})-vertex should instead use the uniformizer (pi=1-w) (up to local units) and must be checked by exact (mathcal O_K)-lattice containment against the actual global (R). Therefore the local formulas alone do not yet construct global (M_0,M_1).

**Derived stabilizer template, conditional on that global lattice check.** For a split maximal order (M\cong M_2(\mathcal O_K)), class number one should imply

\[
N_{PGL_2(K)}(M)=PGL_2(\mathcal O_K)
\]

in a suitable global frame. The subgroup fixing two adjacent maximal orders individually is then the intersection of their two projective unit groups, equivalently the projective level-(ar{\mathfrak p}) Iwahori congruence group. This derivation must be written carefully from the lattice/ideal-class model; it is not yet being used as an established exhaustion certificate.

**Determinant-squareclass warning.** The full projective endpoint stabilizer contains the class of (J=\operatorname{diag}(-1,1)), which fixes both standard adjacent maximal orders individually. Its determinant squareclass is ([-1]). Since (i\notin K=\mathbb Q(\sqrt{-7})), (-1) is not a square in (K), so (J) does not lie in the projective (PSL_2(K)) subgroup. By contrast, the explicit generators (a^2,ab,ba^{-1}) of (Gamma_{009}^+) have trivial determinant squareclass (this should be reasserted exactly in the eventual global script).

Consequently, if (N_K^+(R)) means exactly the full (PGL_2(K)) simultaneous stabilizer stated in the task, a separate PGL/PSL factor may double the earlier candidate. Rough covolume bookkeeping would then suggest candidate index (4), decomposing as a possible index (2) inside the determinant-square subgroup and an additional determinant-squareclass factor (2). This is **CONJECTURAL bookkeeping only**, not a certified covolume or index.

**Why no equality is promoted.** Still required:

1. Exact global (mathcal O_K)-lattice descriptions of the two maximal overorders containing the actual global (R), verified at every prime.
2. A proof that their individual projective stabilizer is exhausted by the stated Iwahori/projective-unit intersection, including ideal-class and scalar issues.
3. Exact containment and index of (Gamma_{009}^+) in the determinant-square part, via exhaustive cosets or an independently certified covolume.
4. Confirmation that the notation (N_K^+(R)) includes both determinant squareclasses and that `+` refers only to endpoint preservation.

### CURRENT STATE

**Established since handoff**

- Existing exact local representatives and their limitations have been identified.
- The full-(PGL) determinant-squareclass factor is now an explicit issue that any final certificate must address.

**Disconfirmed since handoff**

- Nothing. The value (2) remains unproved; it is no longer the only plausible candidate under the literal full-(PGL) definition.

**Still open**

- Exact global (M_0,M_1,E) lattices in the holonomy/order frame.
- Exhaustive structure of their full individual (PGL_2(K)) stabilizer.
- Exact index ([N_K^+(R):\Gamma_{009}^+]).

**Current best evidence for the index**

- Candidate (2) applies naturally to the determinant-square/PSL portion. Candidate (4) may apply to the literal full-(PGL) simultaneous stabilizer because of (J). Neither is certified.

**Next exact computation**

- Construct candidate global maximal orders using (pi=1-w) in the exact global (R) frame; verify by exact (mathcal O_K)-lattice containment/equality that they are precisely the two global maximal overorders of (R). Then derive their complete individual projective stabilizer, keeping determinant squareclasses explicit.

**Files/logs Claude should inspect**

- `reproduce/m009_dyadic_index_check.sage`
- `reproduce/m009_atkin_lehner_global.log`
- `reproduce/m009_global_discriminant_scan.log`
- `notes/MASTER_GAP_REPORT.md`, especially the prior PGL/PSL covolume audit around lines 739–774.
- This handoff entry.

**Program repo HEAD**

- `bccae2933ca69cf39056bf9c82f9dc08a4a8c1bc`

**Corpus repo HEAD**

- `7adde4e597655a28fe4bdeb3508fa93607ed435d`

## 2026-08-29 — Manual scaffold checkpoint completed

The repository-owning user successfully staged only the handoff file and committed the 172-line logging scaffold.

- Commit: 4d338ecd447db2acad0177c92b1a9af220b2c4c4
- Message: “Add Codex handoff log for m009 normalizer work”
- The later “First attack” entry was appended after that commit and remains a working-tree modification.

## 2026-08-29 — Notation correction to the first-attack entry

**Classification.** REPRODUCIBILITY CLEANUP.

The preceding first-attack entry suffered a text-escaping defect while being appended: some inline LaTeX backslashes were lost, and occurrences of \bar became a control character followed by “ar.” The prose and mathematical status labels remain readable, but its malformed inline notation is superseded by this clean statement:

\[
K=\mathbb Q(w),\qquad w^2-w+2=0,\qquad
\mathcal O_K=\mathbb Z[w],\qquad
\bar{\mathfrak p}=(1-w),\qquad N(\bar{\mathfrak p})=2.
\]

The exact local branch representatives are

\[
g_0=\operatorname{diag}(2,1),\qquad
h=\operatorname{diag}(2,1),\qquad
g_1=g_0h=\operatorname{diag}(4,1).
\]

In the \(g_0\)-pulled-back local frame,

\[
M_{0,\mathrm{std}}=M_2(\mathbb Z_2),\qquad
M_{1,\mathrm{std}}=hM_2(\mathbb Z_2)h^{-1},
\]

and

\[
E_{\mathrm{std}}
=M_{0,\mathrm{std}}\cap M_{1,\mathrm{std}}
=
\left\{
\begin{pmatrix}a&b\\c&d\end{pmatrix}:
a,c,d\in\mathbb Z_2,\ b\in2\mathbb Z_2
\right\}.
\]

The unresolved global issue is to replace the locally suitable factor \(2=w(1-w)\) by a correctly supported global construction using \(\pi=1-w\), and then verify the resulting \(\mathcal O_K\)-lattices against the actual global order \(R\).

The determinant-class warning is:

\[
J=\operatorname{diag}(-1,1)
\]

fixes the two standard endpoints individually and has nonsquare determinant class \([-1]\in K^\times/(K^\times)^2\), while the three explicit generators of \(\Gamma_{009}^+\) have square determinant classes; in particular,

\[
\det\!\bigl(B\,\operatorname{adj}(A)\bigr)
=(4+2w)(3-w)=16=4^2.
\]

Thus candidate \(2\) may describe only the determinant-square/PSL portion, whereas candidate \(4\) may describe the literal full-\(PGL_2(K)\) simultaneous stabilizer. Both remain **CONJECTURE**, pending exact global maximal-order construction and stabilizer exhaustion.

## 2026-08-29 — GPT Work audit: determinant-map reframing

**Objective.** Audit the preceding determinant-class warning and separate the local and global claims correctly.

**Classification.** THEOREM (abstract index decomposition) + CORRECTION OF FRAMING + OPEN COMPUTATIONS.

Define

\[
\delta:PGL_2(K)\longrightarrow K^\times/K^{\times2},
\qquad [g]\longmapsto \det(g)\bmod K^{\times2}.
\]

Its kernel is the image of \(PSL_2(K)\). The certified square determinant classes of \(a^2,ab,ba^{-1}\) give

\[
\Gamma_{009}^+\subseteq\ker\delta.
\]

For \(N^+=N_K^+(R)\), provided the relevant indices are finite,

\[
[N^+:\Gamma_{009}^+]
=
[N^+\cap\ker\delta:\Gamma_{009}^+]\,
|\delta(N^+)|.
\]

This is the correct framework for the remaining computation.

**Correction to the preceding warning.** The local standard-frame matrix

\[
J=\operatorname{diag}(-1,1)
\]

proves only that \([-1]\) occurs in the determinant image of the local endpoint stabilizer at \(\bar{\mathfrak p}\). It does not by itself prove

\[
[-1]\in\delta(N_K^+(R))
\]

globally. Even if a global \(J_{\mathrm{glob}}\) passes exact stabilization tests at every finite place, that gives only \(|\delta(N^+)|\ge2\), not equality with \(2\). The entire determinant image must be exhausted independently.

Likewise, candidate \(4\) requires two separate certified statements:

\[
[N^+\cap\ker\delta:\Gamma_{009}^+]=2
\quad\text{and}\quad
|\delta(N^+)|=2.
\]

Neither is currently certified. Candidate \(2\) is specifically a possible value for the square-determinant factor, not automatically for the full \(PGL_2(K)\) index.

**Next exact computations, now separated.**

1. Recover actual global maximal-order lattices \(M_0,M_1\) and the exact \(K\)-rational frame relating them to the local standard edge.
2. Form the corresponding \(J_{\mathrm{glob}}\) and test exact lattice equalities
   \[
   J_{\mathrm{glob}}M_iJ_{\mathrm{glob}}^{-1}=M_i,\qquad i=0,1,
   \]
   at every finite localization. If it fails, record the obstructing prime.
3. Independently construct/exhaust
   \[
   N^{+,0}=N_K^+(R)\cap\ker\delta.
   \]
4. Independently compute the full finite determinant image \(\delta(N_K^+(R))\).
5. Multiply the two certified factors only after both exhaustiveness arguments are complete.

All three quantities remain **OPEN**:

\[
[N^{+,0}:\Gamma_{009}^+],\qquad
|\delta(N_K^+(R))|,\qquad
[N_K^+(R):\Gamma_{009}^+].
\]

## Execution environment

The authoritative computation environment is the existing local SageMath/SnapPy setup used by Claude Code, apparently through WSL, operating on:

- Program repository: C:\dev\hyperbolic-flavor-geometry
- Sage scripts/logs: C:\dev\hyperbolic-flavor-geometry\reproduce
- Canonical corpus record: C:\dev\HFG-CORPUS\MASTER_GAP_REPORT.md

The current Codex sandbox can inspect and edit program files after an explicit path grant, but WSL launch returns E_ACCESSDENIED and sandbox ACLs prevent writes to the repository’s .git metadata. Therefore Codex can design/audit scripts and maintain this handoff; Claude Code or the repository-owning user should run Sage and make commits. GPT Work is useful as an independent mathematical auditor, but its conclusions enter the computational record only when backed by exact scripts/logs in the local program repository.

## 2026-08-29 — Global-order/J certificate prepared

**Objective.** Turn the next valid local-to-global test into one exact, assertion-driven Sage certificate.

**Classification.** REPRODUCIBILITY ARTIFACT PREPARED; NOT YET A COMPUTATIONAL RESULT.

**File created.** reproduce/m009_endpoint_global_orders.sage

**Existing exact constructions reused.**

- The trusted SnapPy-to-\(K\) reconstruction of \(aa,bb,ab,ba\).
- The trusted Hermite-form construction of the exact global \(\mathcal O_K\)-basis of \(R\).
- The certified local branch representatives \(g_0=\operatorname{diag}(2,1)\), \(g_1=\operatorname{diag}(4,1)\).
- The certified fact that \(R\) is maximal away from \(\bar{\mathfrak p}=(1-w)\).

**New exact test designed.**

With \(\pi=1-w\), form

\[
d_0=\operatorname{diag}(\pi,1),\qquad
d_1=\operatorname{diag}(\pi^2,1),
\]

and \(M_i=d_iM_2(\mathcal O_K)d_i^{-1}\). The script then:

1. tests \(R\subset M_0\) and \(R\subset M_1\) by exact \(\mathcal O_K\)-coordinate integrality;
2. verifies \(M_0\ne M_1\);
3. constructs
   \[
   E=\mathcal O_KE_{11}\oplus\pi^2\mathcal O_KE_{12}
     \oplus\pi^{-1}\mathcal O_KE_{21}\oplus\mathcal O_KE_{22};
   \]
4. verifies \(R\subset E\), computes the determinant/index ideal, and asserts \([E:R]=2\);
5. verifies globally
   \[
   R=\{x\in E:\operatorname{tr}(x)\in\bar{\mathfrak p}\}
   \]
   by containment and equal index;
6. tests \(J=\operatorname{diag}(-1,1)\) against the actual global bases of \(M_0,M_1,E,R\);
7. asserts \(-1\) is nonsquare in \(K\);
8. rechecks square determinant classes for the three \(\Gamma_{009}^+\) generators, including
   \[
   \det(B\operatorname{adj}(A))=16.
   \]

**Exhaustion argument encoded in the script comments.** Each \(M_i\) is explicitly conjugate to \(M_2(\mathcal O_K)\), hence maximal. If both exact global containments pass, prior branch exhaustion gives exactly two maximal overorders at \(\bar{\mathfrak p}\), while the discriminant scan makes \(R\) maximal everywhere else. Thus these two orders exhaust the global maximal overorders containing \(R\).

**Not yet run.** Codex cannot launch the WSL Sage runtime. No mathematical output is claimed until a clean Sage log exists. Recommended command:

    sage reproduce/m009_endpoint_global_orders.sage | tee reproduce/m009_endpoint_global_orders.log

**Program repository state.** HEAD remains 4d338ecd447db2acad0177c92b1a9af220b2c4c4; the handoff modifications and new Sage script are uncommitted.

### CURRENT STATE

**Established since handoff**

- The determinant-map decomposition is the accepted framework.
- An exact global-order/J test is prepared, not executed.

**Disconfirmed since handoff**

- No numerical index has been disconfirmed or established.

**Still open**

- Whether the candidate \(M_0,M_1\) contain the actual global \(R\).
- Whether \([-1]\) occurs in the global determinant image.
- The square-determinant index factor.
- The full determinant image and total index.

**Current best evidence for the index**

- No certified numerical value. Candidate \(2\) for the square-determinant factor and candidate \(4\) for the product remain hypotheses only.

**Next exact computation**

- Run the new Sage script and inspect every assertion/output. If it fails, record the first failed global containment and the prime/frame correction it indicates. If it passes, promote only the global \(M_0,M_1,E,J\), trace-kernel, and determinant-class statements explicitly printed by the script.

**Files/logs Claude should inspect**

- reproduce/m009_endpoint_global_orders.sage
- CODEX_HANDOFF_2026-08-29.md

**Program repo HEAD**

- 4d338ecd447db2acad0177c92b1a9af220b2c4c4

**Corpus repo HEAD**

- 7adde4e597655a28fe4bdeb3508fa93607ed435d

## 2026-08-29 — Execution and post-pass checkpoint protocol

**Classification.** REPRODUCIBILITY CLEANUP; no new mathematical result.

As of this check, reproduce/m009_endpoint_global_orders.log is absent. The global-order certificate has not run, so none of its expected conclusions is certified.

Run in the established Sage/WSL shell while preserving Sage’s failure status through tee:

    set -o pipefail
    sage reproduce/m009_endpoint_global_orders.sage 2>&1 \
      | tee reproduce/m009_endpoint_global_orders.log

A visually complete log is insufficient if the pipeline exits nonzero. Record the shell exit status together with the log.

If and only if the command exits zero and all assertions pass, the permitted certified upgrade is:

\[
J\in N_K^+(R),\qquad
\delta(J)=[-1],\qquad
|\delta(N_K^+(R))|\ge2.
\]

Even after a clean run, all of the following remain open:

\[
|\delta(N_K^+(R))|,\qquad
[N^{+,0}:\Gamma_{009}^+],\qquad
[N_K^+(R):\Gamma_{009}^+].
\]

For the post-4d338ec certification checkpoint, stage only:

- reproduce/m009_endpoint_global_orders.sage
- reproduce/m009_endpoint_global_orders.log
- CODEX_HANDOFF_2026-08-29.md

Then verify staged names before committing:

    git add -- reproduce/m009_endpoint_global_orders.sage \
      reproduce/m009_endpoint_global_orders.log \
      CODEX_HANDOFF_2026-08-29.md
    git diff --cached --name-only
    git diff --cached --check

Do not create that certification commit if the Sage pipeline exits nonzero. Preserve and log any failing output instead.

## 2026-08-29 — First execution attempt: Sage environment not activated

**Objective.** Run the prepared global-order certificate.

**Classification.** FAILED ATTEMPT / REPRODUCIBILITY ENVIRONMENT.

**Command context.** WSL was launched from PowerShell. The prompt showed Conda environment base. The command “which sage” returned no path, but the Sage command was attempted.

**Result.**

- Shell/pipeline exit: 127.
- Error: “sage: command not found.”
- A 421-byte log was created at reproduce/m009_endpoint_global_orders.log containing only the command-not-found diagnostic.
- No Sage code executed and no assertion ran.
- No mathematical statement is promoted.

**Environment correction.** Existing repository launch scripts consistently activate the Conda environment named sage. In the current interactive WSL shell:

    conda activate sage
    echo "$CONDA_DEFAULT_ENV"
    which sage
    sage --version

Proceed only if the environment prints sage, “which sage” returns an executable, and “sage --version” succeeds. Then rerun the pipefail command; ordinary tee will replace the failed diagnostic log.

**Git staging correction.** The repository’s .gitignore ignores all log files, including this certificate log. A successful post-run checkpoint must use:

    git add -- reproduce/m009_endpoint_global_orders.sage \
      CODEX_HANDOFF_2026-08-29.md
    git add -f -- reproduce/m009_endpoint_global_orders.log
    git diff --cached --name-only
    git diff --cached --check

The staged-name list must contain exactly the script, log, and handoff.

## 2026-08-29 — Global-order/J certificate executed successfully

**Objective.** Execute and audit reproduce/m009_endpoint_global_orders.sage.

**Classification.** CERTIFIED COMPUTATION + THEOREM-LEVEL CONSEQUENCES FROM EXACT LATTICE EQUALITIES.

**Execution status.** EXECUTED — PASS. The user reports SAGE_EXIT=0. Codex independently read the complete 2,192-byte log and found the success footer, no traceback, no assertion failure, and no false required predicate.

**Output log.** reproduce/m009_endpoint_global_orders.log

**Exact outputs.**

- \(K=\mathbb Q(w)\), \(w^2-w+2=0\), class number \(1\), and \(\bar{\mathfrak p}=(1-w)\) has norm \(2\).
- Exact global \(R\)-basis:
  \[
  [I,\;-(w+1)E_{12},\;(w/2)E_{21},\;(1-w)E_{22}].
  \]
- Exact global containment:
  \[
  R\subset M_0,\qquad R\subset M_1.
  \]
  Both predicates printed True.
- Exact intersection basis:
  \[
  E=M_0\cap M_1
   =\mathcal O_KE_{11}\oplus(-w-1)\mathcal O_KE_{12}
    \oplus(w/2)\mathcal O_KE_{21}\oplus\mathcal O_KE_{22}.
  \]
- The coordinate determinant ideal for \(R\subset E\) is \((1-w)\), of norm \(2\):
  \[
  [E:R]=2.
  \]
- Every \(R\)-basis trace lies in \(\bar{\mathfrak p}\), while the trace map \(E\to\mathcal O_K/\bar{\mathfrak p}\) is nonzero and hence surjective. By containment and equal index,
  \[
  R=\{x\in E:\operatorname{tr}(x)\in\bar{\mathfrak p}\}.
  \]
- For \(J=\operatorname{diag}(-1,1)\), all exact global lattice predicates printed True:
  \[
  JM_0J^{-1}=M_0,\quad
  JM_1J^{-1}=M_1,\quad
  JEJ^{-1}=E,\quad
  JRJ^{-1}=R.
  \]
- \(\det(J)=-1\), and Sage reports that \(-1\) is not a square in \(K\).
- Determinants of the three certified \(\Gamma_{009}^+\) generators:
  \[
  \det(a^2)=1,\qquad
  \det(ab)=1,\qquad
  \det(ba^{-1})=16,
  \]
  all square in \(K\).

**Certified promotions.**

\[
J\in N_K^+(R),\qquad
\delta(J)=[-1]\ne[1],\qquad
|\delta(N_K^+(R))|\ge2.
\]

Also,

\[
\Gamma_{009}^+\subseteq
N^{+,0}:=N_K^+(R)\cap\ker\delta.
\]

Consequently \(J\notin N^{+,0}\), the global determinant image is nontrivial, and—if the full index is finite—the full index is divisible by \(2\).

**Explicit non-promotions.** This run does not determine:

\[
|\delta(N_K^+(R))|,\qquad
[N^{+,0}:\Gamma_{009}^+],\qquad
[N_K^+(R):\Gamma_{009}^+].
\]

Candidate \(2\) for the square-determinant factor would imply only that the full index is at least \(4\), not that it equals \(4\).

### CURRENT STATE

**Established since handoff**

- The two exact global maximal overorders \(M_0,M_1\), their intersection \(E\), and \([E:R]=2\).
- The global trace-\(\bar{\mathfrak p}\) kernel description of \(R\).
- \(J\) fixes both global endpoints individually and belongs to \(N_K^+(R)\).
- \(\delta(J)=[-1]\ne[1]\), so the determinant image has at least two elements.
- \(\Gamma_{009}^+\subseteq N^{+,0}\).

**Disconfirmed since handoff**

- The local/global caveat for \(J\) is resolved positively by exact global lattice tests.
- No proposed numerical index is established or disconfirmed.

**Still open**

- The complete finite image \(\delta(N_K^+(R))\).
- The exhaustive square-determinant index \([N^{+,0}:\Gamma_{009}^+]\).
- The full index \([N_K^+(R):\Gamma_{009}^+]\).

**Current best evidence for the index**

- The full index, if finite, is divisible by \(2\).
- Candidate \(2\) for the square-determinant factor remains conjectural; combined with the certified nontrivial determinant image it would imply a full index of at least \(4\).

**Next exact computation**

- Derive and exhaust the full determinant image of the simultaneous global stabilizer, independently of the square-determinant quotient. Then construct or measure \(N^{+,0}\) and compare it exhaustively with \(\Gamma_{009}^+\).

**Files/logs Claude should inspect**

- reproduce/m009_endpoint_global_orders.sage
- reproduce/m009_endpoint_global_orders.log
- CODEX_HANDOFF_2026-08-29.md

**Program repo HEAD**

- 4d338ecd447db2acad0177c92b1a9af220b2c4c4

**Corpus repo HEAD**

- 7adde4e597655a28fe4bdeb3508fa93607ed435d
