#!/usr/bin/env sage
from sage.all import *
from sage.env import SAGE_VERSION
import snappy, csv, json, hashlib, itertools, os, platform, sys
from datetime import datetime, timezone

BITS = 300
MAX_WORD_LENGTH = 6
PAIR_WORD_LENGTH = 4
NEAR_TOL = RealField(80)("1e-24")
FG_ARGS = [True, False, True, False]
Q_FAMILY = [3,5,7,9,11,13,15]
FAREY_RAY = [(-k, 2*k-1) for k in range(2,8)]
OUTDIR = os.environ.get("M003_ATLAS_OUTDIR", ".")
os.makedirs(OUTDIR, exist_ok=True)

ALPHABET = ("a","A","b","B")
INV = {"a":"A","A":"a","b":"B","B":"b"}

def sha256_file(path):
    h = hashlib.sha256()
    with open(path,"rb") as f:
        for chunk in iter(lambda: f.read(1<<20), b""):
            h.update(chunk)
    return h.hexdigest().upper()

def json_default(obj):
    """Serialize Sage integer scalars without weakening JSON type checks."""
    if isinstance(obj, Integer):
        return int(obj)
    raise TypeError("Object of type %s is not JSON serializable" % type(obj).__name__)

def free_reduce(word):
    st=[]
    for c in word:
        if st and INV[c]==st[-1]:
            st.pop()
        else:
            st.append(c)
    return "".join(st)

def inverse_word(word):
    return "".join(INV[c] for c in reversed(word))

def cyclically_reduced(word):
    w=free_reduce(word)
    return bool(w) and INV[w[0]]!=w[-1]

def rotations(word):
    return [word[i:]+word[:i] for i in range(len(word))]

def canonical_dihedral_word(word):
    w=free_reduce(word)
    if not cyclically_reduced(w):
        return None
    return min(rotations(w)+rotations(inverse_word(w)))

def is_cyclic_power(word):
    n=len(word)
    for d in divisors(n):
        d=int(d)
        if d==n: continue
        if word[:d]*(n//d)==word:
            return True
    return False

def exponent_vector(word):
    return ZZ(word.count("a")-word.count("A")), ZZ(word.count("b")-word.count("B"))

def pmns_h1_class(word):
    na,nb=exponent_vector(word)
    return int((3*na+nb)%5)

def enumerate_word_classes(L):
    reps=set()
    for n in range(1,L+1):
        for tup in itertools.product(ALPHABET, repeat=n):
            w="".join(tup)
            if free_reduce(w)!=w or not cyclically_reduced(w):
                continue
            c=canonical_dihedral_word(w)
            if c is None or is_cyclic_power(c):
                continue
            reps.add(c)
    return sorted(reps, key=lambda w:(len(w),w))

def cplx_mid(z):
    try:
        return ComplexField(120)(z)
    except Exception:
        return CC(z)

def canonical_complex_length_from_trace(t):
    C=ComplexField(120)
    L=2*C(t/2).arccosh()
    if L.real()<0:
        L=-L
    re,im=L.real(),L.imag()
    twopi=2*C.pi()
    while im<=-C.pi(): im += twopi
    while im>C.pi(): im -= twopi
    return C(re,im)

def row_for_word(rho,word,label):
    M=rho(word)
    t=cplx_mid(M.trace())
    tsq=t*t
    L=canonical_complex_length_from_trace(t)
    na,nb=exponent_vector(word)
    return {
        "filling":label,
        "word":word,
        "length_letters":len(word),
        "exp_a":int(na),
        "exp_b":int(nb),
        "h_pmns_mod5":pmns_h1_class(word) if label=="m003(-2,3)" else "",
        "tr_re":str(t.real()),
        "tr_im":str(t.imag()),
        "tr2_re":str(tsq.real()),
        "tr2_im":str(tsq.imag()),
        "complex_length_re":str(L.real()),
        "twist_rad":str(L.imag()),
        "twist_deg":str(L.imag()*180/pi),
        "abs_tr":str(abs(t)),
    }

def presentation_fingerprint(M):
    G=M.fundamental_group(*FG_ARGS)
    return {
        "generators":tuple(str(x) for x in G.generators()),
        "relators":tuple(str(x) for x in G.relators()),
        "peripheral_curves":tuple(tuple(str(y) for y in x) for x in G.peripheral_curves()),
    }

def guarded_rho(M, expected_generators=None):
    rho=M.polished_holonomy(bits_prec=BITS, fundamental_group_args=FG_ARGS)
    rg=tuple(str(x) for x in rho.generators())
    if expected_generators is not None and rg!=tuple(expected_generators):
        raise RuntimeError("GENERATOR BASIS GUARD FAILED: %s != %s"%(rg,expected_generators))
    return rho

def hyperbolicity_status(M):
    try:
        ans=M.verify_hyperbolicity(holonomy=True,bits_prec=BITS)
        return bool(ans[0] if isinstance(ans,tuple) else ans)
    except Exception:
        return False

def write_csv(path,rows):
    if not rows:
        open(path,"w").close()
        return
    fields=list(rows[0].keys())
    with open(path,"w",newline="") as f:
        W=csv.DictWriter(f,fieldnames=fields)
        W.writeheader()
        W.writerows(rows)

script_path=os.path.realpath(sys.argv[0])
manifest={
    "created_utc":datetime.now(timezone.utc).isoformat(),
    "purpose":"target-free structural atlas of m003",
    "status":"computational/exploratory; not exact ITF certificate",
    "contains_pmns_target":False,
    "contains_historical_pmns_word_selection":False,
    "sage_version":str(SAGE_VERSION),
    "snappy_version":getattr(snappy,"__version__","unknown"),
    "python_version":platform.python_version(),
    "bits_prec":BITS,
    "max_word_length":MAX_WORD_LENGTH,
    "pair_word_length":PAIR_WORD_LENGTH,
    "word_equivalence":"freely reduced + cyclically reduced; quotient by cyclic rotation and inverse; cyclic proper powers excluded",
    "homology_classifier_pmns":"h = 3*n_a + n_b mod 5",
    "fundamental_group_args":FG_ARGS,
    "q_family":[[-2,q] for q in Q_FAMILY],
    "farey_h1_Z5_ray":[list(x) for x in FAREY_RAY],
    "script_sha256":sha256_file(script_path),
}

words=enumerate_word_classes(MAX_WORD_LENGTH)
pair_words=[w for w in words if len(w)<=PAIR_WORD_LENGTH]
fillings=[("m003(cusp)",None)]
seen=set()
for slope in [(-2,q) for q in Q_FAMILY]+FAREY_RAY:
    if slope in seen: continue
    seen.add(slope)
    fillings.append(("m003(%d,%d)"%slope,slope))

M0=snappy.Manifold("m003")
cusp_fp=presentation_fingerprint(M0)
expected_generators=cusp_fp["generators"]
manifest["cusped_presentation_fingerprint"]={
    "generators":list(cusp_fp["generators"]),
    "relators":list(cusp_fp["relators"]),
    "peripheral_curves":[list(x) for x in cusp_fp["peripheral_curves"]],
}

word_rows=[]
pair_rows=[]
fill_rows=[]

for label,slope in fillings:
    M=snappy.Manifold("m003")
    if slope is not None:
        M.dehn_fill(slope)
    verified=True if slope is None else hyperbolicity_status(M)
    if slope is not None and not verified:
        fill_rows.append({"filling":label,"slope_p":slope[0],"slope_q":slope[1],"verified_hyperbolic":False,"basis_guard":"SKIPPED","volume":"","homology":"","n_words":0})
        continue

    fp=presentation_fingerprint(M)
    basis_ok=tuple(fp["generators"])==tuple(expected_generators)
    if not basis_ok:
        raise RuntimeError("FATAL BASIS DRIFT at %s: %s"%(label,fp))

    rho=guarded_rho(M,expected_generators)

    for w in words:
        word_rows.append(row_for_word(rho,w,label))

    for i,u in enumerate(pair_words):
        for v in pair_words[i+1:]:
            Mu,Mv=rho(u),rho(v)
            tu,tv=cplx_mid(Mu.trace()),cplx_mid(Mv.trace())
            tuv=cplx_mid((Mu*Mv).trace())
            comm=Mu*Mv*(Mu**-1)*(Mv**-1)
            tc=cplx_mid(comm.trace())
            duv=abs(tu*tu-tv*tv)
            pair_rows.append({
                "filling":label,
                "u":u,
                "v":v,
                "u_h_pmns_mod5":pmns_h1_class(u) if label=="m003(-2,3)" else "",
                "v_h_pmns_mod5":pmns_h1_class(v) if label=="m003(-2,3)" else "",
                "tr_uv_re":str(tuv.real()),
                "tr_uv_im":str(tuv.imag()),
                "tr_comm_re":str(tc.real()),
                "tr_comm_im":str(tc.imag()),
                "abs_tr2_difference":str(duv),
                "near_equal_tr2":bool(duv<NEAR_TOL),
            })

    fill_rows.append({
        "filling":label,
        "slope_p":"" if slope is None else slope[0],
        "slope_q":"" if slope is None else slope[1],
        "verified_hyperbolic":verified,
        "basis_guard":"PASS",
        "volume":str(M.volume()),
        "homology":str(M.homology()),
        "n_words":len(words),
    })

word_path=os.path.join(OUTDIR,"m003_word_atlas.csv")
pair_path=os.path.join(OUTDIR,"m003_pair_atlas.csv")
fill_path=os.path.join(OUTDIR,"m003_filling_summary.csv")
write_csv(word_path,word_rows)
write_csv(pair_path,pair_rows)
write_csv(fill_path,fill_rows)

manifest["word_class_count"]=len(words)
manifest["pair_word_class_count"]=len(pair_words)
manifest["outputs"]={
    "word_atlas":{"path":word_path,"sha256":sha256_file(word_path),"rows":len(word_rows)},
    "pair_atlas":{"path":pair_path,"sha256":sha256_file(pair_path),"rows":len(pair_rows)},
    "filling_summary":{"path":fill_path,"sha256":sha256_file(fill_path),"rows":len(fill_rows)},
}

manifest_path=os.path.join(OUTDIR,"m003_atlas_manifest.json")
with open(manifest_path,"w") as f:
    json.dump(manifest,f,indent=2,sort_keys=True,default=json_default)

print("="*78)
print("m003 TARGET-FREE INVARIANT ATLAS")
print("="*78)
print("word classes:",len(words))
print("pair word classes:",len(pair_words))
print("fillings/controls attempted:",len(fillings))
print("BITS:",BITS)
print("contains PMNS target: FALSE")
print("contains historical PMNS word selection: FALSE")
print("manifest:",manifest_path)
print("manifest SHA256:",sha256_file(manifest_path))
print("word atlas SHA256:",manifest["outputs"]["word_atlas"]["sha256"])
print("pair atlas SHA256:",manifest["outputs"]["pair_atlas"]["sha256"])
print("filling summary SHA256:",manifest["outputs"]["filling_summary"]["sha256"])
print("ATLAS COMPUTATION: PASS")
print("SAGE_EXIT=0")
