using BinDeps
@BinDeps.setup

deps = [
	mafft = library_dependency("mafft"),
	biopython = library_dependency("python-biopython")
]

provides(AptGet,
	{"mafft" => mafft})

provides(AptGet,
	{"python-biopython" => biopython})

@BinDeps.install