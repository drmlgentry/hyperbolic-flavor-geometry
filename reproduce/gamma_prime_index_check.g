# Check the index [Gamma_009 : Gamma'] where Gamma' = <a^2, b^2, ab, ba>
# using the actual SnapPy presentation for m009.
#
# SnapPy: generators ['a','b'], relators ['aabABaaBAb']
# (uppercase = inverse of the corresponding lowercase generator)

F := FreeGroup("a", "b");;
a := F.1;; b := F.2;;

# relator word: a a b A B a a B A b
r := a^2 * b * a^-1 * b^-1 * a^2 * b^-1 * a^-1 * b;;

G := F / [r];;
Print("G presentation built. Generators: ", GeneratorsOfGroup(G), "\n");

aG := GeneratorsOfGroup(G)[1];;
bG := GeneratorsOfGroup(G)[2];;

Gprime := Subgroup(G, [aG^2, bG^2, aG*bG, bG*aG]);;

Print("Attempting Index(G, Gamma') ...\n");
idx := Index(G, Gprime);;
Print("[Gamma_009 : Gamma'] = ", idx, "\n");
