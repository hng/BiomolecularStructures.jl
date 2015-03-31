module WebBLAST
  require("ArgParse")

  using ArgParse
  using FastaIO
  using HttpCommon
  using Requests
  using LightXML
  using BioSeq

  # include types, web interfaces
  
  include(Pkg.dir("BiomolecularStructures", "src/WebBLAST", "hit.jl")) 
  include(Pkg.dir("BiomolecularStructures", "src/WebBLAST", "ncbi_blast.jl")) 
  include(Pkg.dir("BiomolecularStructures", "src/WebBLAST", "ebi_blast.jl")) 

  export webblast

  function parse_commandline()
      s = ArgParseSettings(description = "WebBLAST")

      @add_arg_table s begin
          "--fasta", "-f"
              nargs = 2
              help = "Sequences in FASTA format, Sequence #"
          "--sequence", "-s"
              help = "Sequence as string"
              arg_type = String
          "--threshold", "-t"
              help = "E-Value threshold"
              arg_type = Float64
              default = 0.0

          "fasta_out"
              help = "FASTA output file"
              required = true
              arg_type = String
        end
    
    return parse_args(s)
  end

  # reads a sequence from a FASTA file
  function read_sequence(args) 
    if length(args["fasta"]) >= 2

      try
        fasta = FastaReader(args["fasta"][1])
        name = ""
        seq = ""
        try
          for i in range(1,int(args["fasta"][2]))
            name, seq = readentry(fasta)
          end
          
        catch 
          error("Error parsing arguments. Check 'em!")
        end
        return seq
      catch GZError
        error("File not found")
      end

    end

    if args["sequence"] != ""
      return args["sequence"]
    end

  end

  # save results as fasta file
  function save_as_fasta(results, filename)
    data = {}
    for result in results
      push!(data, fastarepresentation(result))
    end

    writefasta(filename, data)
  end

  function main()
    
    args = parse_commandline()
    seq = read_sequence(args)


    threshold = args["threshold"]

    info("Searching for sequence: $(seq)")

    rid, rtoe = ncbi_blast_put(seq)
    info("rid: $(rid)")
    if ncbi_blast_search_info(rid)
      results =  ncbi_blast_get_results(rid, threshold)
      save_as_fasta(results, args["fasta_out"])
    end
  end

  #main()

  function webblast(provider::String, sequence::String, threshold::Float64, cached=false)
      info("Searching for sequence: $(sequence)")

      # try to use cached version
      if cached
        # create cache if not present
        if !isdir(Pkg.dir("BiomolecularStructures", ".cache")) 
          mkdir(Pkg.dir("BiomolecularStructures", ".cache"))
        end
        # return the cached results
        cached_result_filename = Pkg.dir("BiomolecularStructures", ".cache", base(16,hash(sequence)))
        if isreadable(cached_result_filename)
          f = open(cached_result_filename, "r")
          return deserialize(f)
        end
      end

      
      if provider == "ncbi"
        rid, rtoe = ncbi_blast_put(sequence)
        info("NCBI rid: $(rid)")
        if ncbi_blast_search_info(rid)
          results = ncbi_blast_get_results(rid, threshold)

          # cache the results
          if cached
            f = open(cached_result_filename, "w")
            serialize(f, results)
          end
          return results
        end
    end
  end

end
