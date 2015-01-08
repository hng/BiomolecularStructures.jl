# Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
using FastaIO

function mafft(fasta_in)
	fasta = readall(`mafft '--auto' '--quiet' $fasta_in`)
	
	#FastaIO doesn't do strings, we work around this with a temporary file
	fasta_tmp = tempname()

	f = open(fasta_tmp, "w")
	write(f, fasta)

	fr = readall(FastaReader(fasta_tmp))

	rm(fasta_tmp)

	return fr
end

# Usage
# mafft("examples/ex2")