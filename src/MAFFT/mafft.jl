#= Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
    TODO
    - group to group alignments
=#
module Mafft
export mafft, mafft_from_string, mafft_from_fasta, mafft_profile, print_aligned_fasta, alignment_length, to_aminoacids

    using FastaIO
    using BioSeq

    # preconfigurations
    default = ["--auto"]   

    # Accuracy-oriented methods

    #= L-INS-i (probably most accurate; recommended for <200 sequences;
           iterative refinement method incorporating local pairwise alignment
           information)
    =#
    linsi = ["--localpair", "--maxiterate", "1000"]

    #= G-INS-i (suitable for sequences of similar lengths; recommended for
           <200 sequences; iterative refinement method incorporating global
           pairwise alignment information)
    =#
    ginsi = ["--globalpair", "--maxiterate", "1000"]    

    #= E-INS-i (suitable for sequences containing large unalignable regions;
           recommended for <200 sequences)
    =#
    einsi = ["--ep", "0", "--genafpair", "--maxiterate", "1000"]

    # Speed-oriented methods
    # FFT-NS-i (iterative refinement method; two cycles only)
    fftnsi = ["--retree", "2", "--maxiterate", "2"]
    
    # FFT-NS-2 (fast; progressive method) 
    fftns = ["--retree", "2", "--maxiterate", "0"]
   
    #= NW-NS-i (iterative refinement method without FFT approximation; two
           cycles only) 
    =#
    nwnsi = ["--retree", "2", "--maxiterate", "2", "--nofft"]

    # NW-NS-2 (fast; progressive method without the FFT approximation)
    nwns = ["--retree", "2", "--maxiterate", "0", "--nofft"]

    #= calls MAFFT and returns aligned FASTA
       fasta_in: path to FASTA file
       args: optional commandline arguments for MAFFT (array of strings)
    =#
    function mafft(fasta_in::String, args=:default)
        try success(`mafft --version`)
        catch
            error("MAFFT is not installed.")
        end

        fasta = readall(`mafft '--quiet' $(eval(args)) $fasta_in`)
        fr = readall(FastaReader(IOBuffer(fasta)))
        return fr
    end
    
    #= calls MAFFT with the given FASTA string as input and returns aligned FASTA
       fasta_in: FASTA string
       args: optional commandline arguments for MAFFT (array of strings) 
    =#
    function mafft_from_string(fasta_in::String, args=:default)
        # write to tempfile because mafft can not read from stdin
        tempfile_path, tempfile_io = mktemp()
        write(tempfile_io, fasta_in)
        close(tempfile_io)
        return mafft(tempfile_path, args)
    end

    #= calls MAFFT with the given FASTA in FastaIO format
       fasta_in: FASTA in FastaIO format
       args: optional commandline arguments for MAFFT (array of strings)
    =#
    function mafft_from_fasta(fasta_in, args=:default)
        io = IOBuffer()
        writefasta(io, fasta_in)
        return mafft_from_string(takebuf_string(io), args)
    end

    #= Group-to-group alignments
       group1 and group2 have to be files with alignments
    =#
    function mafft_profile(group1::String, group2::String)
        try success(`mafft --version`)
        catch
            error("MAFFT is not installed.")
        end

        fasta = readall(`mafft '--quiet' --maxiterate 1000 --seed $group1 --seed $group2 /dev/null`)
        fr = readall(FastaReader(IOBuffer(fasta)))
        return fr
    end

    # helper methods for aligned FASTA

    function print_aligned_fasta(fasta)
        aligned = String[]
        for f in fasta
            push!(aligned, f[2])
            println(f[2])
        end
        return aligned
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
