using BiomolecularStructures.WebBLAST
using BiomolecularStructures.Mafft
using Requests
using BiomolecularStructures.PDB
# 1. search for S_0 in PDB

#seq = "MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY"

#=seq = "MKKQLKYCFF SLFVSLSSIL SSCGSTTFVL ANFESYISPL LLERVQEKHP LTFLTYPSNE
KLINGFANNT YSVAVASTYA VSELIERDLL SPIDWSQFNL KKSSSSSDKV NNASDAKDLF
IDSIKEISQQ TKDSKNNELL HWAVPYFLQN LVFVYRGEKI SELEQENVSW TDVIKAIVKH
KDRFNDNRLV FIDDARTIFS LANIVNTNNN SADVNPKEDG IGYFTNVYES FQRLGLTKSN
LDSIFVNSDS NIVINELASG RRQGGIVYNG DAVYAALGGD LRDELSEEQI PDGNNFHIVQ
PKISPVALDL LVINKQQSNF QKEAHEIIFD LALDGADQTK EQLIKTDEEL GTDDEDFYLK
GAMQNFSYVN YVSPLKVISD PSTGIVSSKK NNAEMKSKQM STDQMTSEKE FDYYTETLKA
LLEKEDSAEL NENEKKLVET IKKAYTIEKD SSIRWNQLVE KPISPLQRSN LSLSWLDFKL
HWW" =#

seq = "QIKDLLVSSSTDLDTTLVLVNAIYFKGMWKTAFNAEDTREMPFHVTKQESKPVQMMCMNNSFNVATLPAE
KMKILELPFASGDLSMLVLLPDEVSDLERIEKTINFEKLTEWTNPNTMEKRRVKVYLPQMKIEEKYNLTS
VLMALGMTDLFIPSANLTGISSAESLKISQAVHGAFMELSEDGIEMAGSTGVIEDIKHSPESEQFRADHP
FLFLIKHNPTNTIVYFGRYWSP"

threshold = 0.005


results = webblast(seq, threshold, :ncbi, true)


# PDB IDs and Chain IDs
pdbs = (AbstractString,AbstractString)[]

fastastring = ""
for result in results
	fasta = fastarepresentation(result)
	
	accession = split(result.accession, "_")

	push!(pdbs, (convert(AbstractString,accession[1]), convert(AbstractString,accession[2])))

	fastastring = string(fastastring, ">", fasta[1], "\n", fasta[2], "\n")
end

# 2. Run MAFFT on results
if length(results) > 0
	print_fasta(mafft_from_string(fastastring))
end

# 3. Get PDBs  

structures = Any[]

for pdb in pdbs
  push!(structures, get_structure(get_remote_pdb(pdb[1])))
end

# 4. Do something with the PDBs (Superimpose, etc)
for struc in structures
	m = structure_to_matrix(struc)
	println(size(m))
end
