module Kabsch
export calc_centroid, kabsch, rotate, rmsd, translate_points, kabsch_rmsd
	# Calculate root mean square deviation of two matrices A, B
	# http://en.wikipedia.org/wiki/Root-mean-square_deviation_of_atomic_positions
	function rmsd(A, B)
		A = convert(Array{Float32,2},A)
		B = convert(Array{Float32,2},B)
		RMSD = 0.0

		# D pairs of equivalent atoms
		D = size(A)[1]
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
		size_m = size(m)[1]
	
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

		return P, Q, centroid_p, centroid_q
	end

	# Input: Two sets of points: reference, coords as Nx3 Matrices (so)
	# returns optimally rotated matrix 
	function kabsch(reference,coords)

		original_coords = coords

		coords, reference, centroid_p, centroid_q  = translate_points(coords, reference)
		co1 = coords
		ref = reference

		# Compute covariance matrix A
		A = *(coords', reference)		

		# Calculate Singular Value Decomposition (SVD) of A
		u, d, vt = svd(A)

		# Calculate the optimal rotation matrix
		rotation = *(vt, u')
		rotation  = rotation'

		# check for reflection
		if det(rotation) < 0.0
			vt[:,3] = -vt[:,3]
			rotation = *(vt', u)
			rotation = rotation'
		end
		

		# calculate the transformation
		transformation = broadcast(-, centroid_q, *(centroid_p, rotation))

		# calculate the optimally rotated matrix and then actually transform it
		superimposed = broadcast(+, transformation, *(original_coords, rotation))

		return superimposed

	end

	# directly return RMSD for matrices P, Q for convenience
	function kabsch_rmsd(P, Q)
		superimposed = kabsch(P,Q)
		return rmsd(P,superimposed)
	end
end