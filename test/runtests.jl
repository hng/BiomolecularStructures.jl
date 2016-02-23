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
include(Pkg.dir("BiomolecularStructures", "test", "mafft.jl"))
include(Pkg.dir("BiomolecularStructures", "test", "webblast.jl"))
