# Kabsch Algorithm

The Kabsch algorithm computes the optimal rotation matrix for two sets of points so that the RMSD (Root mean squared deviation) is minimal.

## Functions

### `rmsd(A, B)`

Calculates the root mean square deviation of two matrices A and B using the following formula:

: <math>
\begin{align}
\mathrm{RMSD}(\mathbf{v}, \mathbf{w}) & = \sqrt{\frac{1}{n}\sum_{i=1}^{n} \|v_i - w_i\|^2} \\
& = \sqrt{\frac{1}{n}\sum_{i=1}^{n} 
      (({v_i}_x - {w_i}_x)^2 + ({v_i}_y - {w_i}_y)^2 + ({v_i}_z - {w_i}_z)^2})
\end{align}
</math>

### `calc_centroid(m)`

Returns the centroid of a matrix m.

### `translate_points(P, Q)`

Translates two matrices P, Q so that their centroids are the origin of the coordinate system.

### `kabsch(P,Q)`

Calculates the optimal rotation matrix of two matrices P, Q.
Using `translate_points` it shifts the matrices' centroids to the origin of the coordinate system, then computes the covariance matrix A:

Next is the singular value decomposition of A:

It's possible that the rotation matrix needs correction (basically flipping the sign of each element of the matrix):

Finally the optimal rotation matrix U is calculated and returned together with the matrix P.