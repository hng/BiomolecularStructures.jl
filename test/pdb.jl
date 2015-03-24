using PyCall
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