# Dependencies
```
Pkg.add("Requests")

Pkg.add("LightXML")

Pkg.add("FastaIO")
```
Usage:

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
<h2>Examples</h2>

Sequence:
```julia WebBLAST.jl -s MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY```

FASTA:

```julia WebBLAST.jl -f fasta.txt 4```
