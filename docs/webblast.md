# WebBLAST

API for Julia to call the BLAST Web API of [NCBI](http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastHome).

## Exported functions

#### webblast

```julia
webblast(sequence::String, threshold::Float64=0.005, provider::Symbol=:ncbi, cached=false)
```
Calls the the API of the given provider to search for a protein sequence and returns all hits within a E-Value threshold.

**sequence** The sequence to search for.

**threshhold** threshold for the E-value of hits to be returned. Default is 0.005.

**provider** A provider for a BLAST REST API, e.g. NCBI/EBI BLAST. Default ``:ncbi` (EBI to be implemented), "ncbi" searches for the sequence in the PDB.

**cached** Default ```false```, results can be cached, for example during development.
