include(Pkg.dir("BiomolecularStructures", "src/KABSCH", "kabsch.jl")) 
include(Pkg.dir("BiomolecularStructures", "src/PDB", "pdb.jl")) 
using Base.Test
using Kabsch
using PDB
# julia uses MATLAB-style syntax for matrices
#P = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]

#Q = [32.419 28.213 22.759; 35.584 24.836 25.296; 35.251 27.985 24.691]

#Q = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]

P = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]
centroid = calc_centroid(P)
@test_approx_eq_eps centroid[1] 0.266667 1e-4
@test_approx_eq_eps centroid[2] -0.199999 1e-4
@test_approx_eq_eps centroid[3] 2.766666666666667 1e-4

P = [1 2 3; 4 5 6; 7 8 9]
Q = [9 8 7; 6 5 4; 3 2 1]

@test_approx_eq_eps rmsd(P,Q) 8.94427191 1e-4

@test_approx_eq_eps kabsch_rmsd(P,Q) 2.4323767778e-15 1e-6

structure = get_structure("examples/data/2HHB.pdb")
chains = get_chains(structure)

alpha_1 = chains[1]

alpha_2 = chains[3]

beta_1 = chains[2]
beta_2 = chains[4]

println("RMSD for Alpha chains of HUMAN DEOXYHAEMOGLOBIN (PDB ID: 2HHB)")
println("Naive RMSD:")
println(rmsd(alpha_1,alpha_2))
println("RMSD after Kabsch:")
println(kabsch_rmsd(alpha_1,alpha_2))

println("RMSD for Beta chains of HUMAN DEOXYHAEMOGLOBIN (PDB ID: 2HHB)")
println("Naive RMSD:")
println(rmsd(beta_1,beta_2))
println("RMSD after Kabsch:")
println(kabsch_rmsd(beta_1,beta_1))