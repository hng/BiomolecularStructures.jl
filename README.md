![Logo](https://raw.githubusercontent.com/hng/BiomolecularStructures/master/docs/assets/biom-logo.png)

[![Build Status](https://travis-ci.org/hng/BiomolecularStructures.jl.svg?branch=master)](https://travis-ci.org/hng/BiomolecularStructures.jl) [![Coverage Status](https://coveralls.io/repos/hng/BiomolecularStructures.jl/badge.svg?branch=master)](https://coveralls.io/r/hng/BiomolecularStructures.jl?branch=master) [![Documentation Status](https://readthedocs.org/projects/biomolecularstructures/badge/?version=latest)](https://readthedocs.org/projects/biomolecularstructures/?badge=latest)

## Modules

The BiomolecularStructures package provides several Bioinformatics-related modules:

* WebBLAST - A module to communicate with the NCBI/EBI BLAST servers.
* Kabsch - Superimposing protein structures
* PDB - Utility functions for parsing PDB files
* Plot - Rudimentary plotting of matrices of atomic coordinates
* Mafft - Julia API for multisequence alignment with MAFFT
* Modeller - Functions and scripts to use MODELLER with Julia

## Binary Dependencies

* [BioPython](http://biopython.org/wiki/Main_Page)
* [MAFFT](http://mafft.cbrc.jp/alignment/software/)
* [Modeller](https://salilab.org/modeller/)

The build script should take care of the BioPython dependency and mafft. Modeller needs to be installed manually.

## Troubleshooting

# WARNING: MbedTLS had build errors.

Connecting to cache.julialang.org (cache.julialang.org)|52.91.20.35|:443... connected.
ERROR: no certificate subject alternative name matches
	requested host name `cache.julialang.org'.
To connect to cache.julialang.org insecurely, use `--no-check-certificate'.
===============================[ ERROR: MbedTLS ]===============================

LoadError: failed process: Process(`wget -O /home/vagrant/.julia/v0.5/MbedTLS/deps/downloads/mbedtls-2.1.1-apache.tgz https://cache.julialang.org/https://tls.mbed.org/download/mbedtls-2.1.1-apache.tgz`, ProcessExited(5)) [5]

Download the file manually and then build the package:

* wget --no-check-certificate -O /home/vagrant/.julia/v0.5/MbedTLS/deps/downloads/mbedtls-2.1.1-apache.tgz https://cache.julialang.org/https://tls.mbed.org/download/mbedtls-2.1.1-apache.tgz 
* Pkg.build("BiomolecularStructures")

Note: This a workaround, not a fix for MbedTLS

## MAFFT test fails

If mafft does not work (e.g. the mafft.jl test) and you get this output:

correctly installed?
mafft binaries have to be installed in $MAFFT_BINARIES
or the /build/buildd/mafft-6.850/debian/mafft/usr/lib/mafft/lib/mafft directory.

... you have a broken package. This is fixed in newer Ubuntu LTS releases.

## Changelog

### [0.1.0]

- julia v0.4 compatibility

### [0.0.1]

- initial release

<hr />
<small>A [Bioinformatics WS 2014/15](https://www.uni-due.de/zmb/members/hoffmann/overview.shtml) course project by Simon Malischewski, Henning Schumann. Supervision by [Prof. Dr. Daniel Hoffmann](https://www.uni-due.de/zmb/members/hoffmann/overview.shtml).</small>
