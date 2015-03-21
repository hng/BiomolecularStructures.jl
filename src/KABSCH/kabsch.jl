module Kabsch
export calc_centroid, kabsch, rotate, rmsd, translate_points, kabsch_rmsd, correct_reflection
	# Calculate root mean square deviation of two matrices A, B
	# http://en.wikipedia.org/wiki/Root-mean-square_deviation_of_atomic_positions
	function rmsd(A::Array{Float64,2}, B::Array{Float64,2})

		RMSD::Float64 = 0.0

		# D pairs of equivalent atoms
		D::Int64 = size(A)[1]::Int64
		# N coordinates
		N::Int64 = length(A)::Int64

		for i::Int64 = 1:N
			RMSD += (A[i]::Float64 - B[i]::Float64)^2
		end
		return sqrt(RMSD / D)
	end

	# calculate a centroid of a matrix
	function calc_centroid(m::Array{Float64,2})

		sum_m::Array{Float64,2} = sum(m,1)
		size_m::Int64 = size(m)[1]
	
		return map(x -> x/size_m, sum_m)
	end
	
	# Translate P, Q so centroids are equal to the origin of the coordinate system
	# Translation der Massenzentren, so dass beide Zentren im Ursprung des Koordinatensystems liegen
	function translate_points(P::Array{Float64,2}, Q::Array{Float64,2})
		# Calculate centroids P, Q
		# Die Massenzentren der Proteine
		centroid_p::Array{Float64,2} = calc_centroid(P)
		centroid_q::Array{Float64,2} = calc_centroid(Q)
		
		P = broadcast(-,P, centroid_p)
		
		Q = broadcast(-,Q, centroid_q)

		return P, Q, centroid_p, centroid_q
	end

	# corrects possible reflection
	function correct_reflection(rotation::Array{Float64,2}, vt_z::Array{Float64,1})
		if det(rotation) < 0.0
			vt_z = -vt_z
		end
		return vt_z
	end

	# Input: Two sets of points: reference, coords as Nx3 Matrices (so)
	# returns optimally rotated matrix 
	function kabsch(reference::Array{Float64,2},coords::Array{Float64,2})

		original_coords::Array{Float64,2} = coords

		coords::Array{Float64,2}, reference::Array{Float64,2}, centroid_p::Array{Float64,2}, centroid_q::Array{Float64,2}  = translate_points(coords, reference)
		co1::Array{Float64,2} = coords
		ref::Array{Float64,2} = reference

		# Compute covariance matrix A
		A::Array{Float64,2} = *(coords', reference)		

		# Calculate Singular Value Decomposition (SVD) of A
		u::Array{Float64,2}, d::Array{Float64,1}, vt::Array{Float64,2} = svd(A)

		# check for reflection
		vt[:,3] = correct_reflection(*(vt, u'), vt[:,3])
		
		# Calculate the optimal rotation matrix
		rotation::Array{Float64,2} = *(vt, u')
		rotation = rotation'

		# calculate the transformation
		transformation::Array{Float64,2} = broadcast(-, centroid_q, *(centroid_p, rotation))

		# calculate the optimally rotated matrix and then actually transform it
		superimposed::Array{Float64,2} = broadcast(+, transformation, *(original_coords, rotation))

		return superimposed

	end

	# directly return RMSD for matrices P, Q for convenience
	function kabsch_rmsd(P::Array{Float64,2}, Q::Array{Float64,2})
		return rmsd(P,kabsch(P,Q))
	end
end