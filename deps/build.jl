using BinDeps

@linux_only begin
	run(`sudo apt-get install mafft`)
	run(`sudo apt-get install python-biopython`)
end