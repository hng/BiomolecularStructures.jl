# JuliaPDB


## Dependencies
```julia
Pkg.add("Requests")

Pkg.add("LightXML")

Pkg.add("FastaIO")

Pkg.add("ArgParse")
```

## WebBLAST

An Julia API to call the BLAST Web API of NCBI and EBI.
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
