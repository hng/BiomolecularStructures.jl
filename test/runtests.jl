if VERSION >= v"0.5-"
    using BaseTestDeprecated
    const Test = BaseTestDeprecated
else
    using Base.Test
end
include(Pkg.dir("BiomolecularStructures", "test", "kabsch.jl"))
include(Pkg.dir("BiomolecularStructures", "test", "plot.jl"))
include(Pkg.dir("BiomolecularStructures", "test", "pdb.jl"))
include(Pkg.dir("BiomolecularStructures", "test", "hit.jl"))
# mafft tests do not run reliably in v0.5
if VERSION < v"0.5-"
	include(Pkg.dir("BiomolecularStructures", "test", "mafft.jl"))
end
include(Pkg.dir("BiomolecularStructures", "test", "webblast.jl"))
