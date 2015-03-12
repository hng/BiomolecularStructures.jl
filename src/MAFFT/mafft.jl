# Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
using FastaIO

function mafft(fasta_in::String)
	fasta = readall(`mafft '--auto' '--quiet' $fasta_in`)
	fr = readall(FastaReader(IOBuffer(fasta)))
	return fr
end

function mafft_from_string(fasta_in::String)
    # write to tempfile because mafft can not read from stdin
    tempfile_path, tempfile_io = mktemp()
    write(tempfile_io, fasta_in)
    close(tempfile_io)
	return mafft(tempfile_path)
end
