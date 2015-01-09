# BiomolecularStructures.jl

[![Build Status](https://travis-ci.org/hng/BiomolecularStructures.jl.svg?branch=master)](https://travis-ci.org/hng/BiomolecularStructures.jl) [![Coverage Status](https://coveralls.io/repos/hng/BiomolecularStructures.jl/badge.png)](https://coveralls.io/r/hng/BiomolecularStructures.jl)

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
usage: WebBLAST.jl [-f FASTA FASTA] [-s SEQUENCE] [-t THRESHOLD] [-h]
                   fasta_out

WebBLAST

positional arguments:
  fasta_out             FASTA output file

optional arguments:
  -f, --fasta FASTA FASTA
                        Sequences in FASTA format, Sequence #
  -s, --sequence SEQUENCE
                        Sequence as string
  -t, --threshold THRESHOLD
                        E-Value threshold (type: Float64, default:
                        0.0)
  -h, --help            show this help message and exit

```
### Examples

Sequence:
```julia WebBLAST/WebBLAST.jl -s MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY -t 0.000000000000000000000000000001 out.fasta```

FASTA:

```julia WebBLAST.jl -f fasta.txt 4```
