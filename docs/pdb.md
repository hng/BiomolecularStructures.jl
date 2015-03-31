# PDB Utilities

The PDB module provides utility functions to deal with [PDB (Protein Data Bank)](https://www.wwpdb.org/documentation/file-format) files by thinly wrapping [BioPython's PDB Parser](http://biopython.org/wiki/Main_Page).

## Exported functions

### get_structure
```julia
get_structure(filename::String)
```
Parses a PDB file and returns a structure PyObject.

*filename* Path/Filename of a PDB file.

### get_chains
```julia
get_chains(structure::PyObject)
```

Gets the chains of a protein structure from a BioPython PyObject and returns an Array of Array{Float64,2} matrices of C<sub>&alpha;</sub> atomic coordinates.

**structure** A protein structure.

### structure_to_matrix
```julia
structure_to_matrix(structure::PyObject)
```

Converts a BioPython structure to a Array{Float64,2} matrix of C<sub>&alpha;</sub> atomic coordinates.

**structure** A protein structure

### export_pdb (experimental)

```julia
export_to_pdb(residueName::String,chainID::String,matrix::Array{Float64,2}, filename::String)
```

Exports a matrix of C<sub>&alpha;</sub> atomic coordinates to a PDB File. As of now, it produces files as defined in the [PDB specification](http://deposit.rcsb.org/adit/docs/pdb_atom_format.html) (Section ATOM) with one minor difference: The atom name is right-aligned, because Formatting.jl does not support center-aligning (yet). This isn't in the specification, but [some descriptions](http://cupnet.net/tag/pdb/) include it.

**residueName** residue name to write to the file

**chainID** chain ID (e.g. "A", "B", "C"..)

**matrix** the matrix to export.

**filename** Path/filename to export to.

### get_remote_pdb
```julia
get_remote_pdb(id::String)
```

Downloads and caches a PDB from [rcsb.org](http://www.rcsb.org/)

**id** a PDB ID