module WebBLAST

  using FastaIO
  using HttpCommon
  using Requests
  import Requests: get, post, put, delete, options
  using LightXML
  using BioSeq

  # include types, web interfaces
  
  include(joinpath(dirname(@__FILE__), "hit.jl")) 
  include(joinpath(dirname(@__FILE__), "ncbi_blast.jl")) 
  include(joinpath(dirname(@__FILE__), "ebi_blast.jl")) 

  export webblast

    
  # searches webblast for fasta and returns results as Hit types
  function webblast(sequence::AbstractString, threshold::Float64=0.005, provider::Symbol=:ncbi, cached=false)
      info("Searching for sequence: $(sequence)")

      # try to use cached version
      if cached
        # create cache if not present
        if !isdir(joinpath(dirname(@__FILE__), "..", "..", ".cache")) 
          mkdir(joinpath(dirname(@__FILE__), "..", "..", ".cache"))
        end
        # return the cached results
        cached_result_filename = joinpath(dirname(@__FILE__), "..", "..", ".cache", base(16,hash(sequence)))
        if isreadable(cached_result_filename)
          f = open(cached_result_filename, "r")
          return deserialize(f)
        end
      end

      
      if provider == :ncbi
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

  # webblast with BioSeq AminoAcid Array as input
  function webblast(sequence::Array{AminoAcid,1}, threshold::Float64=0.005, provider::Symbol=:ncbi, cached=false)
    return webblast(convert(ASCIIString, sequence), threshold, provider, cached)
  end

end
