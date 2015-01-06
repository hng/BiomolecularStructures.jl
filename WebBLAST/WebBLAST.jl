module WebBLAST
  require("ArgParse")

  using ArgParse

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
        end
    
    return parse_args(s)
  end

  function main()
    
    args = parse_commandline()
    seq = read_sequence(args)

    info("Searching for sequence: $(seq)")

    rid, rtoe = ncbi_blast_put(seq)

    info("rid: $(rid)")
    if ncbi_blast_search_info(rid)
      println(ncbi_blast_get_results(rid))
    end
  end

  main()

end