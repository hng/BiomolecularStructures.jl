# Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
using FastaIO

function mafft(fasta_in)
	fasta = readall(`mafft '--auto' '--quiet' $fasta_in`)
	fr = readall(FastaReader(IOBuffer(fasta)))
	return fr
end

# Usage
# mafft("examples/fasta/il4.fasta")
