#############################################################################
# bianchi_d7_lowindex.g
#
# PSL_2(O_{-7}) low-index subgroup experiment -- SKELETON, DO NOT RUN YET.
#
# REQUIRES: a verified d=-7 presentation copied directly from
# Grunewald & Schwermer, "Subgroups of Bianchi groups and arithmetic
# quotients of hyperbolic 3-space", Trans. Amer. Math. Soc. 335(1), 1993,
# pp. 47-78. Do not reconstruct the relators from memory or a relayed
# summary -- copy them from the source table.
#
# The companion presentation for the extended/maximal arithmetic overgroup
# (needed for Stage 2 below) is not yet sourced at all as of 2026-08-25.
#
# PURPOSE
# -------
# Stage 1 (control): enumerate index <= 6 subgroups of the ORDINARY
#   T7 = PSL_2(O_{-7}). Independently verified this session:
#     covol(T7) = 0.888914927816353  (Humbert volume formula, computed
#     directly via Sage/PARI, not taken from any relay)
#     vol(m009) = vol(m010) = 2.66674478344906
#     2.66674478344906 / 0.888914927816353 = 3.000000... exactly
#   Grunewald-Schwermer's torsion obstruction requires any torsion-free
#   finite-index subgroup of T7 to have index divisible by 6. Since the
#   volume ratio forces index 3 for a literal embedding, m009/m010 CANNOT
#   be subgroups of ordinary T7 -- this stage exists to confirm that
#   deduction computationally (all index-3 classes should show torsion)
#   and to see what index-6 torsion-free classes exist as a control, not
#   as a target (they'd have volume ~5.333, not ~2.667).
#
# Stage 2 (target, NOT YET RUNNABLE): repeat against the maximal discrete
#   arithmetic extension T7~ of T7, predicted covolume ~0.44445746 (i.e.
#   covol(T7)/2), which would put m009/m010 at index 6 in T7~. Requires
#   its own verified presentation -- not sourced yet. Do not guess it as
#   "T7 plus one more relator" without a citation.
#
#############################################################################

SetInfoLevel(InfoWarning, 1);

########################################################################
# 1. PRESENTATION -- NOT YET FILLED IN
########################################################################

# TODO: replace this stub with the verified d=-7 generators from
# Grunewald-Schwermer Table (Trans. AMS 335(1), 1993, pp. 47-78).
# The script intentionally errors out below rather than guessing.

F := FreeGroup("A", "B", "U");  # placeholder names only -- verify against source
gens := GeneratorsOfGroup(F);
A := gens[1];; B := gens[2];; U := gens[3];;

rels := [
    # TODO -- SOURCE-VERIFIED RELATOR 1 (Grunewald-Schwermer, d=-7 row)
    # TODO -- SOURCE-VERIFIED RELATOR 2
    # TODO -- ... copy every relator in that row, do not omit any
];

if Length(rels) = 0 then
    Print("FATAL: no verified relators entered. This script is a skeleton ",
          "and must not be run against a guessed presentation. See the ",
          "header comment for the required source.\n");
    QUIT_GAP(1);
fi;

T7 := F / rels;
tg := GeneratorsOfGroup(T7);

Print("T7 presentation loaded (", Length(rels), " relators)\n");

########################################################################
# 2. PERIPHERAL SUBGROUP -- NOT YET FILLED IN
########################################################################

# TODO: source-verified words in A,B,U giving the two generators of the
# cusp stabilizer P_infinity = Z^2 (translations by 1 and (1+sqrt(-7))/2).
# Needed for the cusp-count computation in section 6.

p1 := fail;;  # TODO
p2 := fail;;  # TODO

if p1 = fail or p2 = fail then
    Print("FATAL: peripheral generators not entered. Cusp counts in ",
          "section 6 will be meaningless without them.\n");
    QUIT_GAP(1);
fi;

########################################################################
# 3. TORSION REPRESENTATIVES -- NOT YET FILLED IN
########################################################################

# TODO: one representative word per relevant conjugacy class of maximal
# finite cyclic subgroup / elliptic element in T7, sourced from
# Grunewald-Schwermer. Do not assume only order-2/order-3 elements exist
# without checking the source table.

torsionReps := [
    # TODO -- SOURCE-VERIFIED elliptic representative(s)
];

if Length(torsionReps) = 0 then
    Print("FATAL: no torsion representatives entered. The index-3 control ",
          "check in section 8 cannot run without them.\n");
    QUIT_GAP(1);
fi;

########################################################################
# 4. LOW-INDEX ENUMERATION
########################################################################

lis := LowIndexSubgroupsFpGroup(T7, 6);
Print("Number of conjugacy classes index <= 6: ", Length(lis), "\n");

idx3 := Filtered(lis, H -> Index(T7, H) = 3);
idx6 := Filtered(lis, H -> Index(T7, H) = 6);
Print("Index 3 classes: ", Length(idx3), "\n");
Print("Index 6 classes: ", Length(idx6), "\n");

########################################################################
# 5. COSET-ACTION TORSION TEST
#
# Deliberately uses the coset action rather than a generic
# IsTorsionFree(H) call, which is not reliable for an arbitrary
# finite-index subgroup of an infinite finitely presented group: t is
# conjugate into H iff its permutation on H\G has a fixed point.
########################################################################

IsTorsionFreeByCosetAction := function(G, H, tors)
    local cosets, act, t, pt;
    cosets := RightCosets(G, H);
    act := ActionHomomorphism(G, cosets, OnRight);
    for t in tors do
        for pt in [1 .. Length(cosets)] do
            if pt ^ Image(act, t) = pt then
                return false;
            fi;
        od;
    od;
    return true;
end;

########################################################################
# 6. CUSP COUNT FROM DOUBLE COSETS H\G/P
#
# #{cusps of H} = |H\G/P|; P-orbits on H\G give exactly the double
# cosets, more rigorous here than inferring cusp count from H_1.
########################################################################

NumberOfCusps := function(G, H, periphGens)
    local cosets, act, Pperm, orbs;
    cosets := RightCosets(G, H);
    act := ActionHomomorphism(G, cosets, OnRight);
    Pperm := Group(List(periphGens, g -> Image(act, g)));
    orbs := Orbits(Pperm, [1 .. Length(cosets)]);
    return Length(orbs);
end;

########################################################################
# 7. ABELIANIZATION
########################################################################

HomologyInvariants := function(H)
    local iso, HFp;
    iso := IsomorphismFpGroup(H);
    HFp := Image(iso);
    return AbelianInvariants(HFp);  # GAP: 0 marks an infinite cyclic factor
end;

########################################################################
# 8. STAGE 1 CONTROL: INDEX 3 -- expect torsion-free = false, every time
########################################################################

Print("\n=== INDEX 3 CONTROL (expect torsion-free=false for all) ===\n");
for H in idx3 do
    Print("index=3  torsion-free=", IsTorsionFreeByCosetAction(T7, H, torsionReps), "\n");
od;
# If GAP reports any index-3 class as torsion-free: STOP. That means the
# presentation, torsion representatives, or the coset-action test itself
# has an error -- do not proceed to Stage 2 interpretation until resolved.

########################################################################
# 9. STAGE 1 CONTROL: INDEX 6 CLASSIFICATION (volume ~5.333, NOT m009/m010)
########################################################################

Print("\n=== INDEX 6 CLASSIFICATION (control only -- wrong volume for m009/m010) ===\n");
results := [];
for H in idx6 do
    if IsTorsionFreeByCosetAction(T7, H, torsionReps) then
        Add(results, rec(
            index := 6,
            cusps := NumberOfCusps(T7, H, [p1, p2]),
            H1 := HomologyInvariants(H)
        ));
        Print("index=6  cusps=", results[Length(results)].cusps,
              "  H1=", results[Length(results)].H1, "\n");
    fi;
od;

Print("\nDone with Stage 1 (control run against ordinary T7).\n");
Print("Stage 2 (the actual m009/m010 target search, against the maximal\n");
Print("arithmetic extension T7~) requires its own verified presentation,\n");
Print("not yet sourced -- do not attempt it by guessing from this one.\n");
