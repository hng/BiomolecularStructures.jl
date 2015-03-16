# Kabsch Algorithm

The Kabsch algorithm computes the optimal rotation matrix for two sets of points so that the RMSD (Root mean squared deviation) is minimal.

## Example

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
## Functions

### `rmsd(A, B)`

Calculates the root mean square deviation of two matrices A and B in using the following formula:

![RMSD formula][rmsd-formula]

### `calc_centroid(m)`

Returns the centroid of a matrix m.

### `translate_points(P, Q)`

Translates two matrices P, Q so that their centroids are the origin of the coordinate system.

### `kabsch(P,Q)`

Calculates the optimal rotation matrix of two matrices P, Q.
Using `translate_points` it shifts the matrices' centroids to the origin of the coordinate system, then computes the covariance matrix A:

![Covariance Formula][cov-formula]

Next is the singular value decomposition of A:

![SVD formula][svd-formula]

It's possible that the rotation matrix needs correction (basically flipping the sign of each element of the matrix):

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