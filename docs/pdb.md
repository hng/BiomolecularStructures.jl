# PDB Utilities

The PDB module provides utility functions to deal with [PDB (Protein Data Bank)](https://www.wwpdb.org/documentation/file-format) files by thinly wrapping [BioPython's PDB Parser](http://biopython.org/wiki/Main_Page).

## Exported functions

```julia
get_structure(filename::String)
```

Parses a PDB file and returns a structure PyObject.

```julia
get_chains(structure::PyObject)
```

Gets the chains of protein structure from a BioPython PyObject and returns an Array of Array{Float64,2} matrices.

```julia
structure_to_matrix(structure::PyObject)
```

Converts a BioPython structure to a Array{Float64,2} matrix.

```julia
export_to_pdb(residueName::String,chainID::String,matrix::Array{Float64,2}, filename::String)
```

Exports a matrix of C<sub>&alpha;</sub> atomic coordinates to a PDB File. As of now, it produces files as defined in the [PDB specification](http://deposit.rcsb.org/adit/docs/pdb_atom_format.html) (Section ATOM) with one minor difference: The atom name is right-aligned, because Formatting.jl does not center-aligning replacing (yet). This isn't in the specification, but [some descriptions](http://cupnet.net/tag/pdb/) include it.

