if VERSION >= v"0.5-"
    using BaseTestDeprecated
    const Test = BaseTestDeprecated
else
    using Base.Test
end
include(joinpath(dirname(@__FILE__), "kabsch.jl"))
include(joinpath(dirname(@__FILE__), "plot.jl"))
include(joinpath(dirname(@__FILE__), "pdb.jl"))
include(joinpath(dirname(@__FILE__), "hit.jl"))
# mafft tests do not run reliably (especially with julia v0.5)
if VERSION < v"0.5-"
	#include(joinpath(dirname(@__FILE__), "mafft.jl"))
end
include(joinpath(dirname(@__FILE__), "webblast.jl"))
