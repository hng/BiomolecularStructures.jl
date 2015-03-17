# sudo apt-get install python-dev
# sudo apt-get install python-pip
# sudo pip install biopython
# sudo apt-get install numpy | unless you want to compile it..
# julia: Pkg.add("PyCall")
using PyCall
@pyimport Bio.PDB as pdb

# Read in a PDB file and return a matrix of C_Alpha atom coordinates
function pdb_to_c_alpha_matrix(filename::String)
	pdbparser = pdb.PDBParser()

	# parse the file
	structure = pdbparser[:get_structure](filename, filename)

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

