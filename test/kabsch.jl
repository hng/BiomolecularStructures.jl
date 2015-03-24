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

T1, T2, centroid_p1, centroid_p2 = translate_points(P, Q)

# (bad) lazy test if translated matrices are OK ("collisions" obviously can exist)
@test_approx_eq_eps sum(T1) -2.2828578949e-05 1e-4
@test_approx_eq_eps sum(T2) 1.09672546387e-05 1e-4

c_1 = [ 50.73750305  -0.79750001  51.27750397]
c_2 = [ 51.86499786  -1.81249988  47.88249969]

@test_approx_eq_eps centroid_p1[1] c_1[1] 1e-4
@test_approx_eq_eps centroid_p1[2] c_1[2] 1e-4
@test_approx_eq_eps centroid_p1[3] c_1[3] 1e-4

@test_approx_eq_eps rmsd(P,Q) 3.87845580529 1e-4

@test_approx_eq_eps kabsch_rmsd(P,Q) 0.00304375026351 1e-5

structure = get_structure("2HHB.pdb")
chains = get_chains(structure)

alpha_1 = chains[1]
alpha_2 = chains[3]

beta_1 = chains[2]
beta_2 = chains[4]

@test_approx_eq_eps kabsch_rmsd(alpha_1,alpha_2) 0.230038710566 1e-6

@test_approx_eq_eps kabsch_rmsd(beta_1,beta_2) 0.251379745334 1e-6