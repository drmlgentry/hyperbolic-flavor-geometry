from sage.all import gap

gap.eval('F := FreeGroup("a","b");;')
gap.eval('a := F.1;; b := F.2;;')
gap.eval('Grp := F/[a*a*b*a^-1*b^-1*a*a*b^-1*a^-1*b];;')
print('Grp defined')

print('AbelianInvariants:', gap.eval('AbelianInvariants(Grp)'))

gap.eval('hom1 := MaximalAbelianQuotient(Grp);;')
gap.eval('Ab := Image(hom1);;')
print('Ab structure:', gap.eval('StructureDescription(Ab)'))
print('Ab gens:', gap.eval('GeneratorsOfGroup(Ab)'))

gap.eval('Ab2gens := List(GeneratorsOfGroup(Ab), g -> g^2);;')
gap.eval('hom2 := NaturalHomomorphismByNormalSubgroup(Ab, Subgroup(Ab, Ab2gens));;')
gap.eval('Ab2 := Image(hom2);;')
print('Ab2 (=Ab/2Ab) structure:', gap.eval('StructureDescription(Ab2)'))

gap.eval('fullhom := CompositionMapping(hom2, hom1);;')
gap.eval('Grp2 := Kernel(fullhom);;')
print('Index [Grp:Grp2]:', gap.eval('Index(Grp, Grp2)'))

print('Grp2 gens:', gap.eval('GeneratorsOfGroup(Grp2)'))
print('num Grp2 gens:', gap.eval('Length(GeneratorsOfGroup(Grp2))'))
for i in range(1, int(gap.eval('Length(GeneratorsOfGroup(Grp2))'))+1):
    print(f'  gen {i}:', gap.eval(f'GeneratorsOfGroup(Grp2)[{i}]'))
