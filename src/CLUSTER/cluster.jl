# Clustering 

module Cluster
using BiomolecularStructures.Kabsch
using Clustering

export cluster_structures

function cluster_structures(structures)
	# Build up feature matrix
	n = length(structures)
	matrix = zeros(n,n)

	matrix = Float64[]

	for i in 1:n
		for structure in structures
			# push 'real' zeros to the matrix
			if structures[i] != structure
				push!(matrix, kabsch_rmsd(structures[i], structure))
			else
				push!(matrix, 0.0)
			end
		end

	end

	matrix = reshape(matrix, n, n)

	clusterResult = kmeans(matrix, 20)

	println(clusterResult.counts)
end
end