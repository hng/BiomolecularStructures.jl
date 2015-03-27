using PyCall
using BiomolecularStructures.PDB
using Base.Test
struc = get_structure("2HHB.pdb")

# Extremely rudimentary test, basically do we get anything back from our PyCall?
@test isa(struc,PyObject)

chains = get_chains(struc)

# Are the chains there? We expect two alpha and two beta chains
@test length(chains) == 4

# Are there enough c_alpha atoms? With enough coordinates?
@test size(chains[1]) == (141,3)
@test size(chains[2]) == (146,3)
@test size(chains[3]) == (141,3)
@test size(chains[4]) == (146,3)

# PDB export test

P = [51.65 -1.90 50.07;
    50.40 -1.23 50.65;
    50.68 -0.04 51.54;
    50.22 -0.02 52.85]

f = open("pdb_export_test.pdb")
pdb_expected = readlines(f)

export_pdb(P, "pdb_exported_test.pdb")

#@test pdb_expected == 