using BinDeps
using Conda

Conda.add("biopython")

@BinDeps.setup

deps = [
	mafft = library_dependency("mafft")
	cmake = library_dependency("cmake")
]

provides(AptGet, Dict{Any,Any}("mafft" => mafft, "cmake" => cmake))