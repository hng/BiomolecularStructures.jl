module BiomolecularStructures
	include(Pkg.dir("BiomolecularStructures", "src/WebBLAST", "WebBLAST.jl"))	

	include(Pkg.dir("BiomolecularStructures", "src/MAFFT", "mafft.jl"))	
end
