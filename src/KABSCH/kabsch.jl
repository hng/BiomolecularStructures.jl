module Kabsch
export calc_centroid, kabsch
	# calculate a centroid of a matrix
	function calc_centroid(m)
		sum_m = sum(m,1)
		size_m = size(m)[2]

		return map(x -> x/size_m, sum_m)
	end

	# Input: Two sets of Points: P, Q as Nx3 Matrices
	# Zwei Proteinstrukturen P, Q mit je N Atomen
	function kabsch(P,Q)
		
		# Calculate centroids P, Q
		# Die Massenzentren der Proteine
		centroid_p = calc_centroid(P)
		centroid_q = calc_centroid(Q)

		# Translate P, Q so centroids are equal to the origin of the coordinate system
		# Translation der Massenzentren, so dass beide Zentren im Ursprung des Koordinatensystems liegen
		P = broadcast(-,P, centroid_p)
		Q = broadcast(-,Q, centroid_q)

		# Compute covariance matrix A
		A = *(P', Q)		

		# calculate SVD (singular value decomposition) of covariance matrix
		V, S, W = svd(A)
		
		# decide if rotation matrix needs correction (ensures right-handed coordinate system)

		d = det(V) * det(W)
		
		if d < 0.0
			S[end] = -S[end]
			V[:end] = -V[:end]
		end
		# calculate optimal rotation matrix U
		m = [1 0 0; 0 1 0; 0 0 d]
		U = *(*(W, m), V')
		
		return U
	end
end