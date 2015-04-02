using BinDeps

@linux_only begin
	run(`sudo apt-get install mafft`)
end