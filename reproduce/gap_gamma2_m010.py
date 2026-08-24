from sage.all import gap

gap.eval('F := FreeGroup("a","b");;')
gap.eval('a := F.1;; b := F.2;;')
gap.eval('Grp := F/[a*a*b*a*b^-1*a*a*b^-1*a*b];;')
print('Grp defined (m010)')
print('AbelianInvariants:', gap.eval('AbelianInvariants(Grp)'))

gap.eval('hom1 := MaximalAbelianQuotient(Grp);;')
gap.eval('Ab := Image(hom1);;')
gap.eval('Ab2gens := List(GeneratorsOfGroup(Ab), g -> g^2);;')
gap.eval('hom2 := NaturalHomomorphismByNormalSubgroup(Ab, Subgroup(Ab, Ab2gens));;')
gap.eval('Ab2 := Image(hom2);;')
print('Ab2 structure:', gap.eval('StructureDescription(Ab2)'))

gap.eval('fullhom := CompositionMapping(hom2, hom1);;')
gap.eval('Grp2 := Kernel(fullhom);;')
print('Index [Grp:Grp2]:', gap.eval('Index(Grp, Grp2)'))
print('Grp2 gens:', gap.eval('GeneratorsOfGroup(Grp2)'))
