module Kabsch
export calc_centroid, kabsch, rotate, rmsd, translate_points, kabsch_rmsd
	# Calculate root mean square deviation of two matrices A, B
	# http://en.wikipedia.org/wiki/Root-mean-square_deviation_of_atomic_positions
	function rmsd(A, B)
		RMSD = 0.0

		# D pairs of equivalent atoms
		D = size(A)[2]
		# N coordinates
		N = length(A)

		for i = 1:N
			RMSD += (A[i] - B[i])^2
		end
		return sqrt(RMSD / D)
	end

	# calculate a centroid of a matrix
	function calc_centroid(m)
		sum_m = sum(m,1)
		size_m = size(m)[2]

		return map(x -> x/size_m, sum_m)
	end
	
	# Translate P, Q so centroids are equal to the origin of the coordinate system
	# Translation der Massenzentren, so dass beide Zentren im Ursprung des Koordinatensystems liegen
	function translate_points(P, Q)
		# Calculate centroids P, Q
		# Die Massenzentren der Proteine
		centroid_p = calc_centroid(P)
		centroid_q = calc_centroid(Q)

		P = broadcast(-,P, centroid_p)
		Q = broadcast(-,Q, centroid_q)

		return P, Q
	end

	# Input: Two sets of points: P, Q as Nx3 Matrices (so)
	# returns optimal rotation matrix U
	function kabsch(P,Q)

		P, Q  = translate_points(P, Q)

		# Compute covariance matrix A
		A = *(P', Q)		

		# calculate SVD (singular value decomposition) of covariance matrix
		# http://de.wikipedia.org/wiki/Singul%C3%A4rwertzerlegunggo
		V, S, W = svd(A)

		# decide if rotation matrix needs correction (ensures right-handed coordinate system)
		d = det(V) * det(W)
		
		if d < 0.0
			S[end] = -S[end]
			V[:,end] = -V[:,end]
		end
		# calculate optimal rotation matrix U
		m = [1 0 0; 0 1 0; 0 0 d]
		U = *(*(W, m), V')
	
		return U, P
	end

	function rotate(P, Q)
		U, P = kabsch(P,Q)
		return *(P, U)
	end

	# directly return RMSD for matrices P, Q for convenience
	function kabsch_rmsd(P, Q)
		P_1, Q_1 = translate_points(P, Q)
		P = rotate(P, Q)
		return rmsd(P, Q_1)
	end
end