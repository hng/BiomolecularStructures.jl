""" Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
    TODO
    - group to group alignments
"""
module MAFFT
export mafft, mafft_from_string, mafft_from_fasta, mafft_linsi, linsi, mafft_ginsi, ginsi, mafft_einsi, einsi, mafft_fftnsi, fftnsi, mafft_fftns, fftns, mafft_nwnsi, nwnsi, mafft_nwns, nwns, print_aligned_fasta, alignment_length, to_aminoacids

    using FastaIO
    using BioSeq

    " calls MAFFT and returns aligned FASTA
      fasta_in: path to FASTA file
      args: optional commandline arguments for MAFFT (array of strings) "
    function mafft(fasta_in::String, args=["--auto"])
        try success(`mafft --version`)
        catch
            error("MAFFT is not installed.")
        end

        fasta = readall(`mafft '--quiet' $args $fasta_in`)
        fr = readall(FastaReader(IOBuffer(fasta)))
        return fr
    end
    
    " calls MAFFT with the given FASTA string as input and returns aligned FASTA
      fasta_in: FASTA string
      args: optional commandline arguments for MAFFT (array of strings) "
    function mafft_from_string(fasta_in::String, args=["--auto"])
        # write to tempfile because mafft can not read from stdin
        tempfile_path, tempfile_io = mktemp()
        write(tempfile_io, fasta_in)
        close(tempfile_io)
        return mafft(tempfile_path, args)
    end

    " calls MAFFT with the given FASTA in FastaIO format
      fasta_in: FASTA in FastaIO format
      args: optional commandline arguments for MAFFT (array of strings) "
    function mafft_from_fasta(fasta_in, args=["--auto"])
        io = IOBuffer()
        writefasta(io, fasta_in)
        return mafft_from_string(takebuf_string(io), args)
    end

    # Accuracy-oriented methods

    """ L-INS-i (probably most accurate; recommended for <200 sequences;
           iterative refinement method incorporating local pairwise alignment
           information)
    """
    function mafft_linsi(fasta_in::String)
        return mafft(fasta_in, ["--localpair", "--maxiterate", "1000"])
    end
    const linsi = mafft_linsi

    """ G-INS-i (suitable for sequences of similar lengths; recommended for
           <200 sequences; iterative refinement method incorporating global
           pairwise alignment information)
    """
    function mafft_ginsi(fasta_in::String)
        return mafft(fasta_in, ["--globalpair", "--maxiterate", "1000"])
    end
    const ginsi = mafft_ginsi

    """ E-INS-i (suitable for sequences containing large unalignable regions;
           recommended for <200 sequences)
    """
    function mafft_einsi(fasta_in::String)
        return mafft(fasta_in, ["--ep", "0", "--genafpair", "--maxiterate", "1000"])
    end
    const einsi = mafft_einsi

    # Speed-oriented methods
    
    """ FFT-NS-i (iterative refinement method; two cycles only)
    """
    function mafft_fftnsi(fasta_in::String)
        return mafft(fasta_in, ["--retree", "2", "--maxiterate", "2"])
    end
    const fftnsi = mafft_fftnsi

    """ FFT-NS-2 (fast; progressive method)
    """
    function mafft_fftns(fasta_in::String)
        return mafft(fasta_in, ["--retree", "2", "--maxiterate", "0"])
    end
    const fftns = mafft_fftns

    """ NW-NS-i (iterative refinement method without FFT approximation; two
           cycles only) 
    """
    function mafft_nwnsi(fasta_in::String)
        return mafft(fasta_in, ["--retree", "2", "--maxiterate", "2", "--nofft"])
    end
    const nwnsi = mafft_nwnsi

    """ NW-NS-2 (fast; progressive method without the FFT approximation)
    """
    function mafft_nwns(fasta_in::String)
        return mafft(fasta_in, ["--retree", "2", "--maxiterate", "0", "--nofft"])
    end
    const nwns = mafft_nwns

    # helper methods for aligned FASTA

    function print_aligned_fasta(fasta)
        for f in fasta
            println(f[2])
        end
    end

    # returns the length of the alignment (FastaIO-format as input)
    function alignment_length(fasta)
        return length(first(fasta)[2])
    end
    
    # converts a FastaIO-formatted array into an array of BioSeq AminoAcid
    function to_aminoacids(fasta)
        aminoacids = Array{AminoAcid,1}[] 
        for f in fasta
            push!(aminoacids, aminoacid(f[2]))
        end
        return aminoacids
    end
end
