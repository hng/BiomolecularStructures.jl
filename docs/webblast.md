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

```julia
webblast(sequence::Array{AminoAcid,1}, threshold::Float64=0.005, provider::Symbol=:ncbi, cached=false)
```

Same as above but with an Array of BioSeq AminoAcid types as input.

## Types

``webblast`` returns an Array of Hit types, that are defined as:

```julia

type Hit
	hit_num::Int
	id::String
	def::String
	accession::String
	len::Int
	
	hsps::Array{Hsp,1}
end

type Hsp
	hsp_num::Int
	bitScore::Float64
	evalue::Float64
	queryFrom::Int
	queryTo::Int
	queryFrame::Int
	hitFrame::Int
	identity::Int
	positive::Int
	gaps::Int
	alignLen::Int

	qseq::Array{AminoAcid,1}
	qseq_str::String

	hseq::Array{AminoAcid,1}
	midline::Array{AminoAcid,1}
end
```
This type is an 1:1 adaption of the returned hits in the XML result of the NCBI BLAST web API. 

#### fastarepresentation

```julia
fastarepresentation(hit::Hit)
```
Returns a ``FastaIO`` style representation of the **hit**.


## Usecase

First we load a FASTA file with ``FastaIO``:

```julia
using FastaIO
fasta = readall(FastaReader("examples/fasta/il4.fasta"))
```

We can than use a sequence from the FASTA file to search BLAST. We choose the second sequence:

```julia
using BiomolecularStructures.WebBLAST
results = webblast(fasta[2][2])
```

FastaIO reads a FASTA file to an array where each sequence is saved as a tuppel of (``descriptio::String, sequence::String)``. Thats why we use ``fasta[2][2]`` to get the second sequence.
