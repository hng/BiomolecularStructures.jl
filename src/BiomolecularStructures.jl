module BiomolecularStructures
	# include sub-modules
	include(Pkg.dir("BiomolecularStructures", "src/KABSCH/", "kabsch.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/PDB/", "pdb.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/PLOT/", "plot.jl"))	
end
