module JuliaPDB
	include(Pkg.dir("JuliaPDB", "src/WebBLAST", "WebBLAST.jl"))	

	include(Pkg.dir("JuliaPDB", "src/MAFFT", "mafft.jl"))	
end
