# WebBLAST

An API for Julia to call the BLAST Web API of NCBI and EBI.
## Usage

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
## Examples

Sequence:
```julia WebBLAST/WebBLAST.jl -s MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY -t 0.000000000000000000000000000001 out.fasta```

FASTA:

```julia WebBLAST.jl -f fasta.txt 4```
