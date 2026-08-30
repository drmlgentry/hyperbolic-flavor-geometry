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

## 2026-08-29 - Determinant-image certification checkpoint

The repository-owning user created the exact three-file checkpoint after
the successful determinant-image run.

- Commit: `0d8346b928cef1b88190b95586f515100674edaf`.
- Parent: `52bc85ef692b98423daba2adec602be6f6fb976c`.
- Message: `Certify m009 determinant squareclass image`.
- Commit contents:
  - `CODEX_HANDOFF_2026-08-29.md`
  - `reproduce/m009_determinant_image_certificate.log`
  - `reproduce/m009_determinant_image_certificate.sage`
- Verification: the staged-name list contained exactly those three files;
  `git diff --cached --check` returned no errors.

This is the authoritative determinant-image anchor. It certifies

\[
\delta(N_K^+(R))=\{[1],[-1]\},\qquad
|\delta(N_K^+(R))|=2,
\]

and reduces the remaining target to

\[
[N_K^+(R):\Gamma_{009}^+]
=2[N^{+,0}:\Gamma_{009}^+]
\]

whenever the remaining index is finite.

## 2026-08-29 - Square-determinant stabilizer certificate prepared

**Objective.** Construct the square-determinant simultaneous stabilizer
intrinsically and compare it exhaustively with
\(\Gamma_{009}^+=\langle a^2,ab,ba^{-1}\rangle\).

**Classification.** EXACT THEOREM DERIVATION AND GAP CERTIFICATE PREPARED;
NEW SCRIPT NOT YET EXECUTED. No new equality or numerical index is promoted
from this entry.

**File prepared.**

- `reproduce/m009_square_stabilizer_certificate.sage`

**Structural derivation encoded.** Put

\[
d_0=\operatorname{diag}(1-w,1),\qquad
t=d_0^{-1}d_1=\operatorname{diag}(1-w,1).
\]

In the \(M_0\)-frame, \(L_0=\mathcal O_K^2\) and
\(L_1=t\mathcal O_K^2\). For

\[
A=\begin{pmatrix}a&b\\c&d\end{pmatrix}\in SL_2(\mathcal O_K),
\]

one has exactly

\[
t^{-1}At=
\begin{pmatrix}
a&b/(1-w)\\
(1-w)c&d
\end{pmatrix}.
\]

Thus \(A\) preserves \(L_1\) exactly iff
\(b\in\bar{\mathfrak p}=(1-w)\). The script also records the projective
homothety argument: if \(AL_1=\alpha L_1\) and \(\det A=1\), then
\(\alpha^2\) is a unit, hence \(\alpha\) is a unit. Therefore no additional
order stabilizers arise from non-unit homotheties. The expected structural
identification, pending the script's successful assertions, is

\[
N^{+,0}=d_0\Gamma^0(\bar{\mathfrak p})d_0^{-1},
\]

where

\[
\Gamma^0(\bar{\mathfrak p})=
\left\{
\begin{pmatrix}a&b\\c&d\end{pmatrix}\in SL_2(\mathcal O_K):
b\in\bar{\mathfrak p}
\right\}/\{\pm I\}.
\]

**Exact generator matrices to be asserted in the \(M_0\)-frame.**

\[
a^2\sim
\begin{pmatrix}1-2w&-1-w\\w-1&w\end{pmatrix},\quad
ab\sim
\begin{pmatrix}2-w&-1-w\\-1&w\end{pmatrix},
\]

\[
ba^{-1}\sim
\begin{pmatrix}w&w-1\\1-w&2-w\end{pmatrix}.
\]

All three have determinant one and upper-right entry in
\(\bar{\mathfrak p}\), subject to the prepared exact assertions.

**Independent ambient presentation.** The script uses Tanner Reese's
presentation of \(PSL_2(\mathcal O_{-7})\), already used and provenance-
audited in `reproduce/bianchi_d7_lowindex.g`:

\[
\langle A,B,U\mid B^2,(BA)^3,[A,U],(BAU^{-1}BU)^2\rangle,
\]

with \(A=T_1\), \(B=\left(\begin{smallmatrix}0&1\\-1&0\end{smallmatrix}\right)\),
and \(U=T_w\). Every relator is also checked against the exact matrices.

Reduction modulo \(\bar{\mathfrak p}\) maps this group onto
\(PSL_2(\mathbf F_2)\cong S_3\). The prepared GAP computation defines
\(\Gamma^0(\bar{\mathfrak p})\) as the exact preimage of the stabilizer of
the projective line \(e_2\), and asserts its ambient index is three.

**Exact word derivation prepared.** A norm-Euclidean algorithm in
\(\mathcal O_{-7}\) expresses the three matrices as words in \(A,B,U\),
checking each matrix identity projectively. The hand-derived words, which
the script will independently reproduce, are

\[
\begin{aligned}
a^2&=A^{-2}BA^{-1}UBA U^{-1},\\
ab&=A^{-2}UBU^{-1},\\
ba^{-1}&=A^{-1}BA^{-1}UBA.
\end{aligned}
\]

**Result-neutral exhaustion.** GAP computes
\([\Gamma^0(\bar{\mathfrak p}):\Gamma_{009}^+]\) without using candidate
\(2\) as an input. The script accepts and prints any positive finite exact
index. It also tests the explicit candidate

\[
x=T_{1-w},\qquad
d_0xd_0^{-1}=
\begin{pmatrix}1&(1-w)^2\\0&1\end{pmatrix},
\]

and separately enumerates both

\[
[\langle\Gamma_{009}^+,x\rangle:\Gamma_{009}^+]
\quad\text{and}\quad
[\Gamma^0(\bar{\mathfrak p}):
\langle\Gamma_{009}^+,x\rangle].
\]

This certifies non-membership and exhaustion if the corresponding exact
indices warrant those conclusions; the existence of \(x\) alone is not
used to infer the answer.

**Execution boundary.** There is no log and no new certificate yet. Run in
the WSL Conda environment `sage`:

    set -o pipefail
    sage reproduce/m009_square_stabilizer_certificate.sage 2>&1 \
    | tee reproduce/m009_square_stabilizer_certificate.log
    echo "SAGE_EXIT=$?"

Promote only after `SAGE_EXIT=0`, every assertion passes, GAP returns a
positive finite index, and the complete conclusion footer is present.

**Still open until that run.**

\[
[N^{+,0}:\Gamma_{009}^+],\qquad
[N_K^+(R):\Gamma_{009}^+].
\]

**Program repo HEAD before this uncommitted script/handoff update.**

- `0d8346b928cef1b88190b95586f515100674edaf`.

**Corpus repo HEAD.**

- `7adde4e597655a28fe4bdeb3508fa93607ed435d`.

## 2026-08-29 - Explicit square-part coset hardening executed successfully

**Objective.** Execute and audit
`reproduce/m009_square_stabilizer_coset_rep.sage`, extract the nonidentity
coset representative from GAP, convert it to exact matrices, and verify the
degree-two quotient action independently.

**Classification.** CERTIFIED EXACT COMPUTATION / CERTIFICATE HARDENING. The
index theorem at commit `c744ee8b1a97a148dc229b009783ef8dcf6f730c`
is unchanged.

**Execution status.** EXECUTED - PASS. The user reported `SAGE_EXIT=0`.
Codex independently read the complete 5,481-byte saved log and found the
hardening conclusion footer, no traceback, no assertion failure, and no
error line.

**Certificate files.**

- `reproduce/m009_square_stabilizer_coset_rep.sage`
- `reproduce/m009_square_stabilizer_coset_rep.log`

**Exact GAP transversal output.** For

\[
G=\Gamma^0(\bar{\mathfrak p}),\qquad H=\Gamma_{009}^+,
\]

the exact right transversal has two elements. GAP returns the unique
representative outside \(H\) as

\[
\boxed{y=f_1^{-1}f_3^{-1}}.
\]

With the Reese generators \(f_1=A=T_1\) and \(f_3=U=T_w\), this is

\[
y=A^{-1}U^{-1}=T_{-1-w}.
\]

Direct GAP membership checks certify

\[
\boxed{y\notin\Gamma_{009}^+},\qquad
\boxed{y^2\in\Gamma_{009}^+}.
\]

**Exact matrices.** The GAP external word converts to the determinant-one
matrix

\[
Y=\begin{pmatrix}1&-1-w\\0&1\end{pmatrix}
\]

in the \(M_0\)-frame. Its upper-right entry lies in
\(\bar{\mathfrak p}=(1-w)\), so \([Y]\in\Gamma^0(\bar{\mathfrak p})\).
In the original global frame,

\[
\boxed{
Y_{\rm glob}=d_0Yd_0^{-1}
=\begin{pmatrix}1&w-3\\0&1\end{pmatrix}
}.
\]

Every exact global predicate printed `True`:

\[
Y_{\rm glob}M_0Y_{\rm glob}^{-1}=M_0,
\qquad
Y_{\rm glob}M_1Y_{\rm glob}^{-1}=M_1,
\]

\[
Y_{\rm glob}RY_{\rm glob}^{-1}=R,
\qquad
\delta(Y_{\rm glob})=[1].
\]

**Independent quotient-action cross-check.** GAP's action of \(G\) on the
two right cosets has image of order two. Its kernel was checked by mutual
subgroup containment and is exactly \(H\). The explicit representative has
image \((1,2)\), while its square has trivial image. GAP printed the images
of its Iwahori generators as:

- \(f_1^{-2}\mapsto(1,2)\);
- \(f_3f_1^{-1}\mapsto()\);
- \(f_1f_2f_1^{-1}\mapsto(1,2)\).

This independently verifies the degree-two quotient and its kernel rather
than merely repeating the direct `Index` output.

**Certified hardening conclusion.**

\[
\boxed{
N^{+,0}/\Gamma_{009}^+
=\{\Gamma_{009}^+,\ y\Gamma_{009}^+\}
},
\]

with \(y\), \(Y\), and \(Y_{\rm glob}\) explicit above.

**Theorem status, unchanged.**

\[
[N^{+,0}:\Gamma_{009}^+]=2,
\qquad
|\delta(N_K^+(R))|=2,
\]

and therefore

\[
\boxed{[N_K^+(R):\Gamma_{009}^+]=4}.
\]

The old guess \(T_{1-w}\) remains separately disconfirmed as the missing
representative because it lies in \(\Gamma_{009}^+\). The extracted element
is instead \(T_{-1-w}\).

**Program repo HEAD before this uncommitted hardening certificate.**

- `c744ee8b1a97a148dc229b009783ef8dcf6f730c`.

**Corpus repo HEAD before the append-only canonical chronology update.**

- `7adde4e597655a28fe4bdeb3508fa93607ed435d`.

## 2026-08-29 - Explicit-coset hardening checkpoint

The repository-owning user created the exact three-file checkpoint after the
successful transversal and quotient-action run.

- Full commit: `363e2c7eaed19b87ba1f718af353824c789774f3`.
- Parent: `c744ee8b1a97a148dc229b009783ef8dcf6f730c`.
- Message: `Harden m009 square stabilizer coset certificate`.
- Commit contents:
  - `CODEX_HANDOFF_2026-08-29.md`
  - `reproduce/m009_square_stabilizer_coset_rep.log`
  - `reproduce/m009_square_stabilizer_coset_rep.sage`
- Verification: the staged-name list contained exactly those files and
  `git diff --cached --check` returned no errors. The LF/CRLF notice for the
  log was a Git line-ending warning only and did not produce a cached-diff
  error.

This is the authoritative hardening anchor for

\[
y=T_{-1-w},\qquad
N^{+,0}/\Gamma_{009}^+
=\{\Gamma_{009}^+,y\Gamma_{009}^+\},
\]

and the independent degree-two quotient-action kernel check. The arithmetic
theorem remains closed at

\[
\boxed{[N_K^+(R):\Gamma_{009}^+]=4}.
\]

The canonical `MASTER_GAP_REPORT.md` append is the remaining documentation
step; it does not affect theorem status.

## 2026-08-29 - Final index-certificate checkpoint

The repository-owning user created the exact three-file checkpoint for the
square-stabilizer theorem.

- Full commit: `c744ee8b1a97a148dc229b009783ef8dcf6f730c`.
- Parent: `0d8346b928cef1b88190b95586f515100674edaf`.
- Message: `Certify m009 square stabilizer index`.
- Commit contents:
  - `CODEX_HANDOFF_2026-08-29.md`
  - `reproduce/m009_square_stabilizer_certificate.log`
  - `reproduce/m009_square_stabilizer_certificate.sage`
- Verification: the staged-name list contained exactly those files;
  `git diff --cached --check` returned no errors; the three committed paths
  were clean afterward.

The exact arithmetic frontier is CLOSED at this commit:

\[
\boxed{[N_K^+(R):\Gamma_{009}^+]=4}.
\]

## 2026-08-29 - Explicit square-part coset hardening prepared

**Objective.** Extract the nonidentity element of the already-certified
two-coset quotient directly from GAP, convert its Reese word to exact
matrices, and cross-check the quotient by its degree-two permutation action.

**Classification.** CERTIFICATE HARDENING PREPARED; SCRIPT NOT YET EXECUTED.
This does not reopen or change the theorem at commit `c744ee8`.

**File prepared.**

- `reproduce/m009_square_stabilizer_coset_rep.sage`

**Prepared exact checks.** The script loads the committed square-stabilizer
certificate and reuses its exact GAP objects

\[
G=\Gamma^0(\bar{\mathfrak p}),\qquad H=\Gamma_{009}^+.
\]

It then:

1. constructs `RightTransversal(G,H)` and asserts it has two elements;
2. selects the unique representative \(y\notin H\) by exact GAP membership,
   rather than guessing a matrix;
3. asserts \(y^2\in H\);
4. prints \(y\) as a Reese-generator word;
5. converts the GAP external word representation back to an exact matrix
   \(Y\in SL_2(\mathcal O_K)\);
6. asserts \(Y_{12}\in\bar{\mathfrak p}\);
7. independently constructs the action of \(G\) on \(G/H\), asserts its
   image has order two, and asserts its kernel equals \(H\);
8. asserts the image of \(y\) is the nonidentity permutation;
9. forms \(Y_{\rm glob}=d_0Yd_0^{-1}\) and checks exact stabilization of
   \(M_0,M_1,R\) plus trivial determinant squareclass.

The degree-two quotient is defined on the Iwahori group \(G\), not on all of
\(PSL_2(\mathcal O_K)\). Accordingly the script prints the quotient images
of GAP's generators of \(G\), expressed as Reese words; it does not
incorrectly apply the quotient map to Reese generators lying outside
\(G\).

**Execution boundary.** There is no hardening log and no explicit
representative certificate yet. Run in the WSL Conda environment `sage`:

    set -o pipefail
    sage reproduce/m009_square_stabilizer_coset_rep.sage 2>&1 \
    | tee reproduce/m009_square_stabilizer_coset_rep.log
    echo "SAGE_EXIT=$?"

Promote only after `SAGE_EXIT=0`, all assertions pass, the direct membership
and quotient-action checks agree, and the exact global lattice predicates
all print `True`.

**Theorem status during this hardening boundary.**

- Certified and unchanged:
  \([N^{+,0}:\Gamma_{009}^+]=2\).
- Certified and unchanged:
  \([N_K^+(R):\Gamma_{009}^+]=4\).
- Pending optional hardening only: a printed exact representative of the
  nontrivial square-part coset.

**Program repo HEAD before this uncommitted hardening script.**

- `c744ee8b1a97a148dc229b009783ef8dcf6f730c`.

**Corpus repo HEAD.**

- `7adde4e597655a28fe4bdeb3508fa93607ed435d`.

## 2026-08-29 - Square-determinant stabilizer executed successfully

**Objective.** Execute and audit
`reproduce/m009_square_stabilizer_certificate.sage`, identify
\(N^{+,0}\) independently, and exhaust its quotient by
\(\Gamma_{009}^+\).

**Classification.** THEOREM + CERTIFIED EXACT COMPUTATION + EXHAUSTIVE GAP
COSET ENUMERATION.

**Execution status.** EXECUTED - PASS. The user reported `SAGE_EXIT=0`.
Codex independently read the complete 4,244-byte saved log and found the
conclusion footer, no traceback, no assertion failure, and no error line.

**Certificate files.**

- `reproduce/m009_square_stabilizer_certificate.sage`
- `reproduce/m009_square_stabilizer_certificate.log`

**Exact structural identification.** In the \(M_0\)-frame,

\[
L_0=\mathcal O_K^2,\qquad
L_1=\operatorname{diag}(1-w,1)\mathcal O_K^2.
\]

For

\[
A=\begin{pmatrix}a&b\\c&d\end{pmatrix}\in SL_2(\mathcal O_K),
\]

the exact conjugation formula is

\[
\operatorname{diag}(1-w,1)^{-1}A
\operatorname{diag}(1-w,1)=
\begin{pmatrix}
a&b/(1-w)\\
(1-w)c&d
\end{pmatrix}.
\]

Thus simultaneous stabilization is exactly the upper-right congruence
condition \(b\in\bar{\mathfrak p}=(1-w)\). The determinant-one homothety
argument excludes additional projective lattice homotheties. Therefore

\[
\boxed{
N^{+,0}=d_0\Gamma^0(\bar{\mathfrak p})d_0^{-1}
},
\]

where

\[
\Gamma^0(\bar{\mathfrak p})=
\left\{
\begin{pmatrix}a&b\\c&d\end{pmatrix}\in SL_2(\mathcal O_K):
b\in\bar{\mathfrak p}
\right\}/\{\pm I\}.
\]

**Independent ambient-group certificate.** The script uses Tanner Reese's
presentation of \(PSL_2(\mathcal O_{-7})\), with every relator also checked
against the exact matrices. Reduction modulo \(\bar{\mathfrak p}\) maps
onto \(PSL_2(\mathbf F_2)\cong S_3\). GAP constructs
\(\Gamma^0(\bar{\mathfrak p})\) as the preimage of a projective-point
stabilizer and returns exactly

\[
[PSL_2(\mathcal O_K):\Gamma^0(\bar{\mathfrak p})]=3.
\]

**Exact embedded generators.** The exact norm-Euclidean reduction writes
the certified \(\Gamma_{009}^+\) matrices as the following words in the
presented Bianchi group (GAP prints its generators as \(f_1,f_2,f_3\)):

\[
\begin{aligned}
a^2&=f_1^{-2}f_2^{-1}f_3f_1^{-1}f_2^{-1}f_1f_3^{-1},\\
ab&=f_3f_1^{-2}f_2^{-1}f_3^{-1},\\
ba^{-1}&=f_1^{-1}f_2^{-1}f_3f_1^{-1}f_2^{-1}f_1.
\end{aligned}
\]

Every word-to-matrix identity is asserted exactly up to the central sign.

**Exhaustive quotient.** GAP returns

\[
\boxed{
[\Gamma^0(\bar{\mathfrak p}):\Gamma_{009}^+]=2
}.
\]

Combining this with the independently certified determinant image at commit
`0d8346b928cef1b88190b95586f515100674edaf`,

\[
|\delta(N_K^+(R))|=2,
\]

gives the final exact answer

\[
\boxed{
[N_K^+(R):\Gamma_{009}^+]=4
}.
\]

There is no remaining finiteness assumption: GAP's finite coset enumeration
certifies the square-determinant factor, and the determinant-image factor was
already exhausted exactly.

**Explicit-candidate correction.** The prepared candidate

\[
x=T_{1-w}
\]

does fix both endpoints, but GAP proves

\[
[\langle\Gamma_{009}^+,x\rangle:\Gamma_{009}^+]=1,
\qquad
[\Gamma^0(\bar{\mathfrak p}):
\langle\Gamma_{009}^+,x\rangle]=2.
\]

Hence

\[
\boxed{x\in\Gamma_{009}^+}.
\]

It is not a representative of the nontrivial coset. This disconfirmation is
recorded explicitly and does not affect the exhaustive index computation.
Printing a simpler representative of the nontrivial coset would be useful
certificate hardening, but it is not a gap in the index proof.

### FINAL CURRENT STATE

**Certified theorem/computation.**

\[
\delta(N_K^+(R))=\{[1],[-1]\},
\]

\[
N^{+,0}=d_0\Gamma^0(\bar{\mathfrak p})d_0^{-1},
\]

\[
[N^{+,0}:\Gamma_{009}^+]=2,
\]

and therefore

\[
\boxed{[N_K^+(R):\Gamma_{009}^+]=4}.
\]

**Disconfirmed.** \(T_{1-w}\) represents the missing square-determinant
coset. It lies in \(\Gamma_{009}^+\).

**Remaining optional cleanup, not a mathematical gap.** Print and verify a
particularly simple explicit representative of the nontrivial coset, and
append the result to the canonical corpus report after this three-file
certificate is checkpointed.

**Program repo HEAD before this uncommitted certificate.**

- `0d8346b928cef1b88190b95586f515100674edaf`.

**Corpus repo HEAD.**

- `7adde4e597655a28fe4bdeb3508fa93607ed435d`.

## 2026-08-29 — Determinant-image exhaustion executed successfully

**Objective.** Execute and audit reproduce/m009_determinant_image_certificate.sage.

**Classification.** THEOREM + CERTIFIED EXACT FIELD/ORDER COMPUTATION.

**Execution status.** EXECUTED — PASS. The shell reported SAGE_EXIT=0. Codex independently read the complete 4,221-byte log and found the exact conclusion footer, no traceback, and no assertion failure.

**Output log.** reproduce/m009_determinant_image_certificate.log

**Exact computational dependencies confirmed.**

\[
\operatorname{signature}(K)=(0,1),\qquad
h_K=1,\qquad
|\mu(K)|=2,\qquad
-1\notin K^{\times2}.
\]

The loaded global-order certificate also reran successfully, reconfirming the exact \(M_0,M_1,E,R,J\) assertions.

**Exhaustion proof.** Since \(N_K^+(R)\) fixes \(M_0\) individually,

\[
N_K^+(R)\subseteq N_{PGL_2(K)}(M_0).
\]

Writing \(M_0=\operatorname{End}_{\mathcal O_K}(L_0)\), a normalizing element sends \(L_0\) to an \(M_0\)-stable lattice. Matrix units show every such full lattice is \(I L_0\) for a fractional ideal \(I\). Since \(h_K=1\), \(I\) is principal, so projectively

\[
N_{PGL_2(K)}(M_0)
=d_0PGL_2(\mathcal O_K)d_0^{-1}.
\]

Conjugation and projective scalar rescaling preserve determinant squareclass. Hence every determinant class in \(N_K^+(R)\) is represented by a unit of \(\mathcal O_K\). Dirichlet’s unit theorem plus the exact root-of-unity count gives

\[
\mathcal O_K^\times=\{\pm1\}.
\]

Therefore

\[
\delta(N_K^+(R))\subseteq\{[1],[-1]\}.
\]

The identity realizes \([1]\), while the globally certified \(J\) realizes the distinct class \([-1]\). Both bounds match.

**Certified conclusion.**

\[
\boxed{\delta(N_K^+(R))=\{[1],[-1]\}},\qquad
\boxed{|\delta(N_K^+(R))|=2}.
\]

Consequently, assuming the remaining index is finite,

\[
\boxed{
[N_K^+(R):\Gamma_{009}^+]
=2\,[N^{+,0}:\Gamma_{009}^+]
}.
\]

**Still open.**

\[
[N^{+,0}:\Gamma_{009}^+]
\]

is the sole remaining numerical factor. The full index is not assigned a number until this square-determinant factor is certified.

### CURRENT STATE

**Established since handoff**

- Exact global \(M_0,M_1,E,R,J\) structure.
- \(\delta(N_K^+(R))=\{[1],[-1]\}\) exactly.
- The full index is twice the square-determinant index, assuming finiteness.

**Disconfirmed since handoff**

- The determinant image cannot be larger than two classes; all suggested larger determinant-image possibilities are ruled out by maximal-order normalization, class number \(1\), and the unit group.

**Still open**

- \([N^{+,0}:\Gamma_{009}^+]\).
- The resulting full numerical index.

**Current best evidence for the index**

- Determinant factor exactly \(2\).
- Candidate square-determinant factor \(2\) remains conjectural and would imply total index \(4\), but neither value is promoted.

**Next exact computation**

- Construct \(N^{+,0}\) intrinsically as the determinant-square part of the individual global endpoint stabilizer and compare it exhaustively with \(\Gamma_{009}^+\), by exact cosets or an independently derived covolume.

**Files/logs Claude should inspect**

- reproduce/m009_determinant_image_certificate.sage
- reproduce/m009_determinant_image_certificate.log
- reproduce/m009_endpoint_global_orders.sage
- reproduce/m009_endpoint_global_orders.log
- CODEX_HANDOFF_2026-08-29.md

**Program repo HEAD**

- 52bc85ef692b98423daba2adec602be6f6fb976c

**Corpus repo HEAD**

- 7adde4e597655a28fe4bdeb3508fa93607ed435d

## 2026-08-29 — Post-global-orders certification checkpoint

The repository-owning user created the exact three-file checkpoint after the successful Sage run.

- Commit: 52bc85ef692b98423daba2adec602be6f6fb976c
- Parent provenance anchor: 4d338ecd447db2acad0177c92b1a9af220b2c4c4
- Message: “Certify m009 global endpoint orders and determinant class”
- Commit contents:
  - CODEX_HANDOFF_2026-08-29.md
  - reproduce/m009_endpoint_global_orders.sage
  - reproduce/m009_endpoint_global_orders.log
- Summary: 3 files changed, 864 insertions; the script and log were created in this commit.
- Verification: the staged-name list contained exactly these three files and the cached-diff whitespace check returned no errors.

This commit is the authoritative post-global-orders certification anchor. Subsequent work on determinant-image exhaustion and the square-determinant index should cite 52bc85e as its starting point.

## 2026-08-29 — Determinant-image exhaustion certificate prepared

**Objective.** Determine the exact finite subgroup

\[
\delta(N_K^+(R))\subset K^\times/K^{\times2}
\]

from the global stabilizer conditions.

**Classification.** THEOREM DERIVATION ENCODED; SAGE DEPENDENCIES NOT YET EXECUTED IN THIS NEW SCRIPT.

**File created.** reproduce/m009_determinant_image_certificate.sage

**Key reduction.** Since every element of \(N_K^+(R)\) fixes \(M_0\) individually,

\[
N_K^+(R)\subseteq N_{PGL_2(K)}(M_0).
\]

Writing \(M_0=\operatorname{End}_{\mathcal O_K}(L_0)\), an element normalizing \(M_0\) sends \(L_0\) to an \(M_0\)-stable lattice. Matrix units imply every such lattice is \(I L_0\) for a fractional ideal \(I\). Class number \(1\) makes \(I\) principal, so projectively

\[
N_{PGL_2(K)}(M_0)=d_0PGL_2(\mathcal O_K)d_0^{-1}.
\]

Therefore every determinant squareclass in \(N_K^+(R)\) is represented by a unit of \(\mathcal O_K\).

For the imaginary quadratic field \(K=\mathbb Q(\sqrt{-7})\), Dirichlet’s unit theorem and the exact root-of-unity count give

\[
\mathcal O_K^\times=\{\pm1\}.
\]

Thus

\[
\delta(N_K^+(R))\subseteq\{[1],[-1]\}.
\]

The identity realizes \([1]\), while the certified global \(J\) realizes the distinct class \([-1]\). Subject only to the new script’s exact rechecks of class number, signature, roots of unity, and the prior global assertions, the expected exhaustive conclusion is

\[
\delta(N_K^+(R))=\{[1],[-1]\},\qquad
|\delta(N_K^+(R))|=2.
\]

**Execution boundary.** The new script has not yet run. Do not promote the equality from this entry alone. Run:

    set -o pipefail
    sage reproduce/m009_determinant_image_certificate.sage 2>&1 \
      | tee reproduce/m009_determinant_image_certificate.log
    echo "SAGE_EXIT=$?"

Promote only if the shell reports SAGE_EXIT=0, every assertion passes, the exact field facts print as expected, and the full exhaustion proof/conclusion footer appears.

**What a clean run would settle.**

\[
|\delta(N_K^+(R))|=2
\]

and, assuming the remaining index is finite,

\[
[N_K^+(R):\Gamma_{009}^+]
=2\,[N^{+,0}:\Gamma_{009}^+].
\]

**Still open after a prospective pass.**

\[
[N^{+,0}:\Gamma_{009}^+]
\]

and therefore the numerical full index until that factor is determined.

### CURRENT STATE

**Established since handoff**

- Global \(M_0,M_1,E,R,J\) certificate at 52bc85e.
- Determinant-image upper-bound proof has been reduced to exact class-number and unit-group facts and encoded for execution.

**Disconfirmed since handoff**

- Nothing new.

**Still open**

- The new determinant-image script’s execution.
- The square-determinant index.
- The final numerical index.

**Current best evidence for the index**

- Certified lower bound \(|\delta|\ge2\).
- Mathematical exhaustion argument predicts exactly \(|\delta|=2\), pending the script’s exact dependency checks.

**Next exact computation**

- Run reproduce/m009_determinant_image_certificate.sage with pipefail and audit the resulting log.

**Files/logs Claude should inspect**

- reproduce/m009_determinant_image_certificate.sage
- reproduce/m009_endpoint_global_orders.sage
- reproduce/m009_endpoint_global_orders.log
- CODEX_HANDOFF_2026-08-29.md

**Program repo HEAD**

- 52bc85ef692b98423daba2adec602be6f6fb976c

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
