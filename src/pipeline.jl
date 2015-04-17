using BiomolecularStructures.WebBLAST
using BiomolecularStructures.Kabsch
using BiomolecularStructures.Mafft
using BiomolecularStructures.Cluster
using Requests
using BiomolecularStructures.PDB
# 1. search for S_0 in PDB

# 2HHB - Human Deoxyhaemoglobin Alpha Chain
seq = "VLSPADKTNVKAAWGKVGAHAGEYGAEALERMFLSFPTTKTYFPHFDLSHGSAQVKGHGKKVADALTNAVAHVDDMPNAL
SALSDLHAHKLRVDPVNFKLLSHCLLVTLAAHLPAEFTPAVHASLDKFLASVSTVLTSKYR"

#seq = "MLEAQEEEEVGFPVRPQVPLRPMTYKAALDISHFLKEKGGLEGLIWSQRRQEILDLWIYHTQGYFPDWQNYTPGPGIRYP
#LTFGWCFKLVPVEPEKVEEANEGENNSLLHPMSLHGMEDAEKEVLVWRFDSKLAFHHMARELHPEYYKD"

# glucagon
#seq = "HSQGTFTSDYSKYLDSRRAQDFVQWLMNT"

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
	#print_fasta(mafft_from_string(fastastring))
end

# 3. Get PDBs  

structures = (String => Any)[]

for pdb in pdbs
  structures[pdb[1]] = get_structure(get_remote_pdb(pdb[1]))
end

# 4. Do something with the PDBs (Superimpose, etc)
# A sortable Array of tuples!
rmsd = (Float64,String)[]

to_be_clustered = Any[]

for struc in structures
	#println(get_chains(struc[2]))
	try
		m = get_chains(struc[2])[chain]
		# Use only structures with same number of atoms
		if size(m) == size(reference_structure)
			push!(rmsd, (kabsch_rmsd(reference_structure,m), struc[1]))
			push!(to_be_clustered, m)
		end
	catch
		warn(string("Structure has no chain:", chain))
	end
	
end
rmsd = sort!(rmsd)

println(rmsd)

# 5. Clustering

cluster_structures(to_be_clustered)