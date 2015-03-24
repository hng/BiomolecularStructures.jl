using BiomolecularStructures.MatrixPlot

A = [1.0 1.0 1.0; 1.0 1.0 1.0; 1.0 1.0 1.0]

x, y, z = matrix_prep(A)

@test x == [1.0, 1.0, 1.0]
@test y == [1.0, 1.0, 1.0]
@test z == [1.0, 1.0, 1.0]