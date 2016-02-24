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

The build script should take care of the BioPython dependency. Install MAFFT with `sudo apt-get install mafft` (or equivalent for other package managers) Modeller needs to be installed manually.

## Troubleshooting julia v0.5-dev

### Package fails to build

`ERROR: Build process failed.`

```
INFO: Building HttpParser
ERROR: Build process failed.
```

```
Connecting to cache.julialang.org (cache.julialang.org)|52.91.20.35|:443... connected.
ERROR: no certificate subject alternative name matches
	requested host name `cache.julialang.org'.
To connect to cache.julialang.org insecurely, use `--no-check-certificate'.
===============================[ ERROR: MbedTLS ]===============================

LoadError: failed process: Process(`wget -O /home/vagrant/.julia/v0.5/MbedTLS/deps/downloads/mbedtls-2.1.1-apache.tgz https://cache.julialang.org/https://tls.mbed.org/download/mbedtls-2.1.1-apache.tgz`, ProcessExited(5)) [5]
```

when building MbedTLS, download the file manually (change home directory) and then build the package:

`wget --no-check-certificate -O /home/vagrant/.julia/v0.5/MbedTLS/deps/downloads/mbedtls-2.1.1-apache.tgz https://cache.julialang.org/https://tls.mbed.org/download/mbedtls-2.1.1-apache.tgz`
`Pkg.build("BiomolecularStructures")`

Note: This a workaround, not a fix for MbedTLS

```
cmake command not found. installing cmake is required for building from source.
===============================[ ERROR: MbedTLS ]===============================

LoadError: failed process: Process(`./cmake_check.sh`, ProcessExited(1)) [1]
while loading /home/vagrant/.julia/v0.5/MbedTLS/deps/build.jl, in expression starting on line 69

================================================================================
```

Install cmake with `sudo apt-get install cmake`

### Pkg.test("BiomolecularStructures") failing

`ERROR: LoadError: LoadError: LoadError: LoadError: Failed to precompile PyPlot to /home/vagrant/.julia/lib/v0.5/PyPlot.ji`

This seems to be an issue of how precompilation of dependencies is handled (see this issue: https://github.com/JuliaLang/julia/issues/14193) and does not happen reliably. Try running julia with --precompiled=yes or try precompiling the failing modules manually, e.g. `Base.compilecache("Colors")`, `Base.compilecache("HttpCommon") and run `Pkg.test("BiomolecularStructures") again`

### MAFFT test fails under Ubuntu 12.04 LTS

If mafft does not work (e.g. the mafft.jl test) and you get this output:

correctly installed?
mafft binaries have to be installed in $MAFFT_BINARIES
or the /build/buildd/mafft-6.850/debian/mafft/usr/lib/mafft/lib/mafft directory.

... you have a broken package. This is fixed in newer Ubuntu LTS releases.

### Note about mafft tests

The mafft tests are disabled for v0.5 as i cannot get them to run reliably (tests fail or pass depending on unknown conditions).

## Changelog

### [0.1.1]

- julia v0.5 compatibility - note: unstable, using the package with v0.5 may require manual fixes, see troubleshooting

### [0.1.0]

- julia v0.4 compatibility

### [0.0.1]

- initial release

<hr />
<small>A [Bioinformatics WS 2014/15](https://www.uni-due.de/zmb/members/hoffmann/overview.shtml) course project by Simon Malischewski, Henning Schumann. Supervision by [Prof. Dr. Daniel Hoffmann](https://www.uni-due.de/zmb/members/hoffmann/overview.shtml).</small>
