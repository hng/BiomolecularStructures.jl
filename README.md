# Dependencies
```
Pkg.add("Requests")

Pkg.add("LightXML")

Pkg.add("FastaIO")
```
Usage:

```
usage: blast_web_testing.jl [-f FASTA FASTA] [-s SEQUENCE] [-h]

Web Blast julia interface

optional arguments:
  -f, --fasta FASTA FASTA
                        Sequences in FASTA formatSequence #
  -s, --sequence SEQUENCE
                        Sequence as string
  -h, --help            show this help message and exit

```
<h2>Examples</h2>

Sequence:
```julia blast_web_testing.jl -s MNQLQQLQNPGESPPVHPFVAPLSYLLGTWRGQGEGEYPTIPSFRYGEEIRFSHSGKPVIAY```

FASTA:

```julia blast_web_testing.jl -f fasta.txt 4```
