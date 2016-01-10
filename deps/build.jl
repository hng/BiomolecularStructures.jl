using BinDeps
# matplotlib
ENV["PYTHON"]=""
Pkg.build("PyCall")

@linux_only begin
	run(`sudo -A apt-get install mafft`)
	run(`sudo -A apt-get install python-biopython`)
end