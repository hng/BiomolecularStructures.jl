using BinDeps
using Conda

Conda.add("biopython")

# matplotlib
ENV["PYTHON"]=""
Pkg.build("PyCall")

@BinDeps.setup

deps = [
	mafft = library_dependency("mafft")
	cmake = library_dependency("cmake")
]

provides(AptGet, Dict{Any,Any}("mafft" => mafft, "cmake" => cmake))