using BinDeps
@BinDeps.setup

deps = [
	mafft = library_dependency("mafft")
]

provides(AptGet,
	{"mafft" => mafft})

@BinDeps.install