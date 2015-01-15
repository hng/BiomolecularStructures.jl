# sudo apt-get install python-dev
# sudo apt-get install python-pip
# sudo pip install biopython
# sudo apt-get install numpy | unless you want to compile it..
# julia: Pkg.add("PyCall")
using PyCall
@pyimport Bio.PDB as pdb

pdbparser = pdb.PDBParser()

structure = pdbparser[:get_structure]("test", "test.pdb")

for atom in structure[:get_atoms]()
	println(atom[:get_coord]())
end