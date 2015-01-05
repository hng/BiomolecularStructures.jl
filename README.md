# JuliaPDB


## Dependencies

```julia
Pkg.add("Requests")
Pkg.add("LightXML")
Pkg.add("FastaIO")
Pkg.add("ArgParse")
Pkg.add("BioSeq")
```

or just start the install script:

```julia install.jl```

## WebBLAST

An API for Julia to call the BLAST Web API of NCBI and EBI.
### Usage

```
usage: WebBLAST [-f FASTA FASTA] [-s SEQUENCE] [-h]

WebBLAST

optional arguments:
  -f, --fasta FASTA FASTA
                        Sequences in FASTA formatSequence #
  -s, --sequence SEQUENCE
                        Sequence as string
  -h, --help            show this help message and exit

```
### Examples

Sequence:
```julia WebBLAST.jl -s MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY```

FASTA:

```julia WebBLAST.jl -f fasta.txt 4```
