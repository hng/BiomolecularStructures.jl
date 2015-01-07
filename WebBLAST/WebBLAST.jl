module WebBLAST
  require("ArgParse")

  using ArgParse
  using FastaIO
  using HttpCommon
  using Requests
  using LightXML
  using BioSeq

  # include types, web interfaces
  
  include("hit.jl")

  include("ncbi_blast.jl")
  include("ebi_blast.jl")

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

  main()

end