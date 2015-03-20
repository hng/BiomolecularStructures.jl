# sudo apt-get install python-dev
# sudo apt-get install python-pip
# sudo pip install biopython
# sudo apt-get install numpy | unless you want to compile it..
# julia: Pkg.add("PyCall")
module PDB
export get_structure, get_chains, structure_to_matrix

using PyCall
@pyimport Bio.PDB as pdb

# get a structure from a PDB File
function get_structure(filename::String)
	# using QUIET to supress discontinous chains warning
	pdbparser = pdb.PDBParser(QUIET = 1)

	# parse the file
	structure = pdbparser[:get_structure](filename, filename)
	return structure
end

# get chains from structure
function get_chains(structure)
	chains = structure[:get_chains]()

	chainMatrices = Any[]

	for c in chains
		push!(chainMatrices,structure_to_matrix(c))
	end

	return chainMatrices
end

# Read in a PDB file and return a matrix of C_Alpha atom coordinates
function structure_to_matrix(structure)
	

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

end