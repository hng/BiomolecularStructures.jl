using BiomolecularStructures.MatrixPlot
using Base.Test
A = [1.0 1.0 1.0; 1.0 1.0 1.0; 1.0 1.0 1.0]

x, y, z = matrix_prep(A)

@test x == [1.0, 1.0, 1.0]
@test y == [1.0, 1.0, 1.0]
@test z == [1.0, 1.0, 1.0]

P = [51.65 -1.90 50.07;
    50.40 -1.23 50.65;
    50.68 -0.04 51.54;
    50.22 -0.02 52.85]

Q = [51.30 -2.99 46.54;
     51.09 -1.88 47.58;
     52.36 -1.20 48.03;
     52.71 -1.18 49.38]

@test matrices_plot(P,Q) == true