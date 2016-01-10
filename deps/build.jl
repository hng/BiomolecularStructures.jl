using BinDeps
using Conda

Conda.add("biopython")

# matplotlib
ENV["PYTHON"]=""
Pkg.build("PyCall")

@linux_only begin
	run(`sudo -A apt-get install mafft`)
	run(`sudo -A apt-get install python-biopython`)
end