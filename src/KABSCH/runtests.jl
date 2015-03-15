include(Pkg.dir("BiomolecularStructures", "src/KABSCH", "kabsch.jl")) 
using Base.Test
using Kabsch

# julia uses MATLAB-style syntax for matrices
#P = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]

#Q = [32.419 28.213 22.759; 35.584 24.836 25.296; 35.251 27.985 24.691]

#Q = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]
centroid = calc_centroid(P)
P = [0.1 0.2 0.3; 0.5 -0.5 -0.3; 0.2 -0.3 8.3]
@test_approx_eq_eps centroid[1] 0.266667 1e-4
@test_approx_eq_eps centroid[2] -0.199999 1e-4
@test_approx_eq_eps centroid[3] 2.766666666666667 1e-4

P = [1 2 3; 4 5 6; 7 8 9]
Q = [9 8 7; 6 5 4; 3 2 1]


println(rotate(P, Q))