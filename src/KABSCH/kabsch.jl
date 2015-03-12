module Kabsch
export calc_centroid, kabsch
	# calculate a centroid of a 1-D array (vector)
	function calc_centroid(centroid)
		return map(x -> x/length(centroid),sum(centroid))
	end

	# Input: Two sets of Points: P, Q (Nx3 Matrices)
	function kabsch(P,Q)
		println(P)
		# Calculate centroids P, Q
		centroid_p = calc_centroid(P)
		centroid_q = calc_centroid(Q)

		# Translate P, Q so centroids are equal to the origin of the coordinate system
		p_trans = map(x -> x - centroid_p, P)
		q_trans = map(x -> x - centroid_q, Q)

		
		
	end
end