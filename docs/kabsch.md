# Kabsch Algorithm

The Kabsch algorithm computes the optimal rotation matrix for two sets of points so that the RMSD (Root mean squared deviation) is minimal. In Bioinformatics this applies to superimposing the C_Alpha atomic coordinates of two protein structures. 

The following excerpt of the PDB(link) file of human deoxyhaemoglobin(link) shows part of the alpha chain of the structure. The C_alpha atomic coordinates shown can be used to construct a reference matrix which together with a another matrix of coordinates (constructed the same way) serve as the input of the algorithm.

```
[...]
ATOM     17  **CA**  SER A   3      **12.286  19.774   7.034**  1.00 27.60           C  
ATOM     18  C   SER A   3      13.529  20.322   6.334  1.00 30.36           C  
ATOM     19  O   SER A   3      13.995  19.754   5.344  1.00 27.40           O  
ATOM     20  CB  SER A   3      12.719  19.060   8.326  1.00 23.83           C  
ATOM     21  OG  SER A   3      13.844  18.245   8.107  1.00 29.07           O  
ATOM     22  N   PRO A   4      14.075  21.454   6.786  1.00 37.36           N  
ATOM     23  **CA**  PRO A   4      **15.285  22.042   6.167**  1.00 39.58           C  
ATOM     24  C   PRO A   4      16.466  21.103   6.290  1.00 21.30           C  
ATOM     25  O   PRO A   4      17.288  21.019   5.368  1.00 32.82           O  
ATOM     26  CB  PRO A   4      15.637  23.315   6.942  1.00 45.84           C  
ATOM     27  CG  PRO A   4      14.398  23.603   7.765  1.00 43.31           C  
ATOM     28  CD  PRO A   4      13.513  22.346   7.796  1.00 38.50           C  
ATOM     29  N   ALA A   5      16.484  20.391   7.438  1.00 22.62           N  
ATOM     30  **CA**  ALA A   5      **17.533  19.415   7.651**  1.00 26.71           C 
[...]
```

## Usage / Example

Define two matrices P, Q:
```julia
P = [1 2 3; 4 5 6; 7 8 9]
Q = [9 8 7; 6 5 4; 3 2 1]
```

RMSD the normal way:

```julia
rmsd(P, Q)
8.94427190999916
```
After rotation with the optimal rotation matrix:
```
kabsch_rmsd(P, Q)
1.6616296724220897e-15 (~ 0)
``` 
## Exported functions

### `rmsd(A, B)`

Calculates the root mean square deviation of two matrices A and B in using the following formula:

![RMSD formula][rmsd-formula]

### `calc_centroid(m)`

Returns the centroid of a matrix m.

### `translate_points(P, Q)`

Translates two matrices P, Q so that their centroids are the origin of the coordinate system.

### `kabsch(reference::Array{Float64,2},coords::Array{Float64,2})`

Calculates the optimal rotation matrix of two matrices P, Q.
Using `translate_points` it shifts the matrices' centroids to the origin of the coordinate system, then computes the covariance matrix A:

![Covariance Formula][cov-formula]

Next is the singular value decomposition of A:

![SVD formula][svd-formula]

It's possible that the rotation matrix needs correction

![Sign correction formula][correction-formula]

We check if d is < 0.0, if so, we flip the sign(s).

Finally the optimal rotation matrix U is calculated

![Optimal rotation matrix U][optu-formula]



and returned together with the matrix P.

### `rotate(P, Q)`

peforms the actual rotation

### `kabsch_rmsd(P,Q)`
Directly returns the RMSD after rotation for convenience.


[rmsd-formula]: http://upload.wikimedia.org/math/2/4/6/24612ddd0afbb048bb37093de3ac88fa.png "RMSD Formula"
[cov-formula]: http://upload.wikimedia.org/math/c/b/8/cb8ca6c9c787b2d8a0fd2bf3daad5a0f.png "Covariance matrix formula"
[svd-formula]: http://upload.wikimedia.org/math/4/3/d/43dd92d762ec8b8acf2a5e299b90038a.png "SVD Formula"
[correction-formula]: http://upload.wikimedia.org/math/6/c/6/6c68ceda711c032f1f90b7bf03d38cae.png "Sign correction formula"
[optu-formula]: http://upload.wikimedia.org/math/1/e/d/1ed72885bd9cd4105593aea62883e5a7.png "Optimal rotation matrix U"