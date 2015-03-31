# WebBLAST

API for Julia to call the BLAST Web API of NCBI and EBI.

## Exported functions

#### webblast

```julia
webblast(provider::String, sequence::String, threshold::Float64, cached=false)
```

Calls the the API of the given provider to search for a protein sequence and returns all hits within a E-Value threshold.

**provider** A provider for a BLAST REST API, e.g. NCBI/EBI BLAST. Default "ncbi" (EBI to be implemented), "ncbi" searches for the sequence in the PDB.

**sequence** The sequence to search for.

**cached** Default ```false```, results can be cached, for example during development.