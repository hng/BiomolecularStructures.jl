include(Pkg.dir("BiomolecularStructures", "src/KABSCH", "kabsch.jl")) 
include(Pkg.dir("BiomolecularStructures", "src/PDB", "pdb.jl")) 
using Base.Test
using Kabsch
using PDB
# julia uses MATLAB-style syntax for matrices
P = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]
centroid = calc_centroid(P)
@test_approx_eq_eps centroid[1] 0.266667 1e-4
@test_approx_eq_eps centroid[2] -0.199999 1e-4
@test_approx_eq_eps centroid[3] 2.766666666666667 1e-4

P = [51.65 -1.90 50.07;
    50.40 -1.23 50.65;
    50.68 -0.04 51.54;
    50.22 -0.02 52.85]

Q = [51.30 -2.99 46.54;
     51.09 -1.88 47.58;
     52.36 -1.20 48.03;
     52.71 -1.18 49.38]

@test_approx_eq_eps rmsd(P,Q) 3.87845580529 1e-4

@test_approx_eq_eps kabsch_rmsd(P,Q) 0.00304375026351 1e-5

structure = get_structure("examples/data/2HHB.pdb")
chains = get_chains(structure)

alpha_1 = chains[1]
alpha_2 = chains[3]

beta_1 = chains[2]
beta_2 = chains[4]

@test_approx_eq_eps kabsch_rmsd(alpha_1,alpha_2) 0.230038710566 1e-6

@test_approx_eq_eps kabsch_rmsd(beta_1,beta_2) 0.251379745334 1e-6