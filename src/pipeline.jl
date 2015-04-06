using BiomolecularStructures.WebBLAST
using BiomolecularStructures.Kabsch
using BiomolecularStructures.Mafft
using Requests
using BiomolecularStructures.PDB
# 1. search for S_0 in PDB

# 2HHB - Human Deoxyhaemoglobin Alpha Chain
seq = "VLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNAL
SALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYR"

chain = "A"

reference_structure = get_chains(get_structure(get_remote_pdb("2HHB")))[chain]

threshold = 0.005


results = webblast(seq, threshold, :ncbi, true)


# PDB IDs and Chain IDs
pdbs = (String,String)[]

fastastring = ""
for result in results
	fasta = fastarepresentation(result)
	
	accession = split(result.accession, "_")

	push!(pdbs, (convert(String,accession[1]), convert(String,accession[2])))

	fastastring = string(fastastring, ">", fasta[1], "\n", fasta[2], "\n")
end

# 2. Run MAFFT on results
if length(results) > 0
	print_fasta(mafft_from_string(fastastring))
end

# 3. Get PDBs  

structures = (String => Any)[]

for pdb in pdbs
  structures[pdb[1]] = get_structure(get_remote_pdb(pdb[1]))
end

# 4. Do something with the PDBs (Superimpose, etc)

rmsd = Any[]

for struc in structures
	m = get_chains(struc[2])[chain]
	# Use only structures with same number of atoms
	if size(m) == size(reference_structure)
		println(string(struc[1], " ",kabsch_rmsd(reference_structure,m)))
	end
end