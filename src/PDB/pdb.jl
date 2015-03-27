# sudo apt-get install python-dev
# sudo apt-get install python-pip
# sudo pip install biopython
# sudo apt-get install numpy | unless you want to compile it..
# julia: Pkg.add("PyCall")
module PDB
export get_structure, get_chains, structure_to_matrix, export_pdb

using PyCall
@pyimport Bio.PDB as pdb
@pyimport Bio.PDB.StructureBuilder as struc
@pyimport Bio.PDB.Atom as atomObject

# get a structure from a PDB File
function get_structure(filename::String)
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

function export_pdb(matrix::Array{Float64,2}, filename::String)
	lines = String[]

	for i in 1:size(matrix)[1]
		line = rpad("", 80, " ")
		line[1,5] = "ATOM  "
		line[13,2] = "CA"
		println(line)
        i_test = string(i)
        for s in range(1, (5 - length(i_test)))
            i_test = string(" ", i_test)
        end
		line = string("ATOM  ", i_test, " CA ", "VAL", " A ", " 1 ", " ", matrix[i,:][1], " ", matrix[i,:][2], " ", matrix[i,:][3], " ", 1.0, " ", 0.0, " C\n")
		push!(lines, line)
	end


	f = open(filename, "w")
	write(f,lines)
	close(f)
end

end
