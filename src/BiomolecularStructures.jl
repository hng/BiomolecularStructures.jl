module BiomolecularStructures
	# include sub-modules
	include(joinpath(dirname(@__FILE__), "KABSCH/", "kabsch.jl"))	
	include(joinpath(dirname(@__FILE__), "PDB/", "pdb.jl"))	
	include(joinpath(dirname(@__FILE__), "PLOT/", "plot.jl"))	
	include(joinpath(dirname(@__FILE__), "WebBLAST/", "hit.jl"))	
	include(joinpath(dirname(@__FILE__), "WebBLAST/", "WebBLAST.jl"))	
	include(joinpath(dirname(@__FILE__), "MODELLER/", "modeller.jl"))	
	include(joinpath(dirname(@__FILE__), "MAFFT/", "mafft.jl"))	
end
