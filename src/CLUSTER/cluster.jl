# Clustering 

module Cluster
using BiomolecularStructures.Kabsch
using Clustering

export cluster_structures

function cluster_structures(structures)
	distanceMatrix = build_distance_matrix(structures)

	

	bestSilhouetteAvg = 0.0
	bestK = 2
	bestClusterResult = nothing

	maxK = length(structures)-1

	for k in 2:maxK

		clusterResult = kmeans(distanceMatrix, k)

		silhouetteAverage = sum_kbn(silhouettes(clusterResult, distanceMatrix)) / length(distanceMatrix)
		println(silhouetteAverage)

		if bestSilhouetteAvg < silhouetteAverage
			bestSilhouetteAvg = silhouetteAverage
			bestK = k
			bestClusterResult = clusterResult
		end
	end
	
	println("best")
	println(bestSilhouetteAvg)
	println(string("best k:", bestK))

	println(bestClusterResult.assignments)

end

function build_distance_matrix(structures)
	# Build up feature matrix
	n = length(structures)

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

	return reshape(matrix, n, n)
end



end