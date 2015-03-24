# PDB Utilities

The PDB module provides utility functions to deal with [PDB (Protein Data Bank)](https://www.wwpdb.org/documentation/file-format) files by thinly wrapping [BioPython's PDB Parser](http://biopython.org/wiki/Main_Page).

## Exported functions

```julia get_structure(filename::String)```

Parses a PDB file and returns a structure PyObject.

```get_chains(structure::PyObject)```

Gets the chains of protein structure from a BioPython PyObject and returns an Array of Array{Float64,2} matrices.

```structure_to_matrix(structure::PyObject)```

Converts a BioPython structure to a Array{Float64,2} matrix.