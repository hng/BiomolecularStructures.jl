# sudo apt-get install python-dev
# sudo apt-get install python-pip
# sudo pip install biopython
# sudo apt-get install numpy | unless you want to compile it..
# julia: Pkg.add("PyCall")
module PDB
export get_structure, get_chains, structure_to_matrix, export_to_pdb, get_remote_pdb

using PyCall
using Formatting
@pyimport Bio.PDB as pdb

# get a structure from a PDB File
function get_structure(filename::AbstractString)
	# using QUIET to supress discontinous chains warning
	pdbparser = pdb.PDBParser(QUIET = 1)

	# parse the file
	structure = pdbparser[:get_structure](filename, filename)
	return structure
end

# get chains from structure
function get_chains(structure::PyObject)
	chains = structure[:get_chains]()

	chainMatrices = Any[]

	for c in chains
		push!(chainMatrices,structure_to_matrix(c))
	end

	return chainMatrices
end

# Read in a PDB file and return a matrix of C_Alpha atom coordinates
function structure_to_matrix(structure::PyObject)
	atoms = structure[:get_atoms]()
	# Filter out C_Alpha atoms
	atoms = filter(x -> x[:get_name]() == "CA", atoms) 
	# Get the coordinates
	atoms = map(x -> x[:get_coord](), atoms)

	n = length(atoms)

	# initialize an empty Nx3 matrix
	matrix = zeros(n,3)

	# fill it
	for i in 1:n
		matrix[i,:] = [atoms[i][1] atoms[i][2] atoms[i][3]]
	end

	matrix = reshape(matrix,n,3)

	return matrix
end

# Export a matrix of C_alpha atom coordinates to a PDB file
function export_to_pdb(residueName::AbstractString,chainID::AbstractString,matrix::Array{Float64,2}, filename::AbstractString)
	lines = AbstractString[]

	atomExpr = FormatExpr("{: <6}{: >5} {: >4}{: <1}{: >3} {: <1}{: >4}{: <1}   {: >8}{: >8}{: >8}{: >6}{: >6}      {: <4}{: >2}{: <2}\n")

	for i in 1:size(matrix)[1]
		line = format(atomExpr, "ATOM", i, "CA", " ", residueName, chainID, "1", " ", matrix[i,:][1], matrix[i,:][2], matrix[i,:][3], 1.0, 0.0, "A1", "C", " ")
		
		push!(lines, line)
	end

	f = open(filename, "w")
	write(f,lines)
	close(f)

	return lines
end

# Get a PDB file by ID from rcsb.org
function get_remote_pdb(id::AbstractString)
	# create cache if not present
	if !isdir(Pkg.dir("BiomolecularStructures", ".cache")) 
		mkdir(Pkg.dir("BiomolecularStructures", ".cache"))
	end
	filename = Pkg.dir("BiomolecularStructures", ".cache", id)
	# check if PDB isn't already cached
	if !isreadable(filename)
		data = get("http://www.rcsb.org/pdb/files/" * id * ".pdb")
		f = open(filename, "w")
		write(f, data.data)
	end	
	return filename
end

end