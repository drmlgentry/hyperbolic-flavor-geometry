F := FreeGroup("A","B","U");;
gens := GeneratorsOfGroup(F);;
A := gens[1];; B := gens[2];; U := gens[3];;
rels := [ B^2, (B*A)^3, A*U*A^-1*U^-1, (B*A*U^-1*B*U)^2 ];;
T7 := F / rels;;
Print("T7 abelianization: ", AbelianInvariants(T7), "\n");

FB7 := FreeGroup("A","B","U","j");;
g := GeneratorsOfGroup(FB7);;
A2:=g[1];; B2:=g[2];; U2:=g[3];; j:=g[4];;
relsT := [ B2^2, (B2*A2)^3, A2*U2*A2^-1*U2^-1, (B2*A2*U2^-1*B2*U2)^2 ];;
relsExt := [ j^2, j*A2*j^-1*A2, j*B2*j^-1*B2, j*U2*j^-1*U2 ];;
B7 := FB7 / Concatenation(relsT, relsExt);;
Print("B7 abelianization: ", AbelianInvariants(B7), "\n");

bg := GeneratorsOfGroup(B7);;
T7sub := Subgroup(B7, [bg[1],bg[2],bg[3]]);;
Print("Index of <A,B,U> inside B7 (expect exactly 2): ", Index(B7, T7sub), "\n");
Print("Is <A,B,U> normal in B7 (expect true): ", IsNormal(B7, T7sub), "\n");

Print("Order of B7's B-image (expect 2): ", Order(bg[2]), "\n");
Print("Order of B7's (B*A)-image (expect 3): ", Order(bg[2]*bg[1]), "\n");
