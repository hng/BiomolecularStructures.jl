using BinDeps


@linux_only begin
	run(`sudo -A apt-get install mafft`)
	run(`sudo -A apt-get install python-biopython`)
end