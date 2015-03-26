module BiomolecularStructures
	# include sub-modules
	include(Pkg.dir("BiomolecularStructures", "src/KABSCH/", "kabsch.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/PDB/", "pdb.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/PLOT/", "plot.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/WebBLAST/", "hit.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/WebBLAST/", "WebBLAST.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/MODELLER/", "modeller.jl"))	
	include(Pkg.dir("BiomolecularStructures", "src/MAFFT/", "mafft.jl"))	
end
