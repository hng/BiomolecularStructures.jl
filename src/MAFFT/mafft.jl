#= Julia Wrapper for MAFFT (http://mafft.cbrc.jp/alignment/software/)
=#
module Mafft
export mafft, mafft_from_string, mafft_from_fasta, mafft_profile, mafft_profile_from_string, mafft_profile_from_fasta, print_fasta, alignment_length, to_aminoacids

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
       preconfiguration: optional commandline arguments for MAFFT (array of strings)
    =#
    function mafft(fasta_in::AbstractString, preconfiguration=:default)
        try success(`mafft --version`)
        catch
            error("MAFFT is not installed.")
        end

        fasta = readall(`mafft '--quiet' $(eval(preconfiguration)) $fasta_in`)
        fr = readall(FastaReader(IOBuffer(fasta)))
        return fr
    end
    
    #= calls MAFFT with the given FASTA string as input and returns aligned FASTA
       fasta_in: FASTA string
       preconfiguration: optional commandline arguments for MAFFT (array of strings) 
    =#
    function mafft_from_string(fasta_in::AbstractString, preconfiguration=:default)
        # write to tempfile because mafft can not read from stdin
        tempfile_path, tempfile_io = mktemp()
        write(tempfile_io, fasta_in)
        close(tempfile_io)
        return mafft(tempfile_path, preconfiguration)
    end

    #= calls MAFFT with the given FASTA in FastaIO format
       fasta_in: FASTA in FastaIO format
       preconfiguration: optional commandline arguments for MAFFT (array of strings)
    =#
    function mafft_from_fasta(fasta_in, preconfiguration=:default)
        io = IOBuffer()
        writefasta(io, fasta_in)
        return mafft_from_string(takebuf_string(io), preconfiguration)
    end

    #= Group-to-group alignments with input as paths to FASTA files
       group1 and group2 have to be files with alignments
    =#
    function mafft_profile(group1::AbstractString, group2::AbstractString)
        try success(`mafft --version`)
        catch
            error("MAFFT is not installed.")
        end

        fasta = readall(`mafft '--quiet' --maxiterate 1000 --seed $group1 --seed $group2 /dev/null`)
        fr = readall(FastaReader(IOBuffer(fasta)))
        return fr
    end

    #= Group-to-group alignments with input strings in FASTA format
       group1 and group2 have to be strings with alignments in FASTA format
    =#
    function mafft_profile_from_string(group1::AbstractString, group2::AbstractString)
        # write to tempfiles because mafft can not read from stdin
        tempfile1_path, tempfile1_io = mktemp()
        write(tempfile1_io, group1)
        close(tempfile1_io)

        tempfile2_path, tempfile2_io = mktemp()
        write(tempfile2_io, group2)
        close(tempfile2_io)

        return mafft_profile(tempfile1_path, tempfile2_path)
    end

    #= Group-to-group alignments with input in FastaIO format
       group1 and group2 have to be in FastaIO format and have to be alignments
    =#
    function mafft_profile_from_fasta(group1, group2)
        io = IOBuffer()
        writefasta(io, group1)
        group1_string = takebuf_string(io)
        writefasta(io, group2)
        group2_string = takebuf_string(io)

        return mafft_profile_from_string(group1_string, group2_string)
    end

    # helper methods for aligned FASTA

    function print_fasta(fasta)
        for f in fasta
            println(">", f[1])
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
