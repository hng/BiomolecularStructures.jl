# Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
module MAFFT
export mafft, mafft_from_string, print_aligned_fasta

    using FastaIO

    function mafft(fasta_in::String)
        try success(`mafft -v`)
        catch
            error("MAFFT is not installed.")
        end

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

    function print_aligned_fasta(fasta)
        for f in fasta
            println(f[2])
        end
    end
end
