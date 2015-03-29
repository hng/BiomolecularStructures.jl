using BiomolecularStructures.WebBLAST
using BiomolecularStructures.Mafft
using Requests
using BiomolecularStructures.PDB
# 1. search for S_0 in PDB

seq = "MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY"
threshold = 1.0e-30

info("Searching for sequence: $(seq)")

rid, rtoe = ncbi_blast_put(seq)
info("rid: $(rid)")
if ncbi_blast_search_info(rid)

  results =  ncbi_blast_get_results(rid, threshold)
 
  pdbs = (String,String)[]

  fastastring = ""
  for result in results
  	fasta = fastarepresentation(result)
  	
  	accession = split(result.accession, "_")

  	push!(pdbs, (convert(String,accession[1]), convert(String,accession[2])))

  	fastastring = string(fastastring, ">", fasta[1], "\n", fasta[2], "\n")
  end

  # 2. Run MAFFT on results

  println(mafft_from_string(fastastring))

  # 3. Get PDBs  
  for pdb in pdbs
  	if !isreadable(pdb[1])
  		data = get(string("http://www.rcsb.org/pdb/files/", pdb[1]))
  		f = open(Pkg.dir("BiomolecularStructures", ".pdbCache", pdb[1]), 'w')
  		write(f, data.data)
  	end
  	println(get_structure(pdb[1]))
  	
  end

  # 4. Superimpose PDBs (Best Hit as reference?)

  
end