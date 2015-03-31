![Logo](assets/biom-logo.png)

# Documentation

The BiomolecularStructures package provides several Bioinformatics-related modules which can be used like this:

```julia
using BiomolecularStructures.<ModuleName>
```
e.g. 
```julia
using BiomolecularStructures.Kabsch
```

## Modules

The BiomolecularStructures package provides several Bioinformatics-related modules:

* WebBLAST - A module to communicate with the NCBI/EBI BLAST servers.
* Kabsch - Superimposing protein structures
* PDB - Utility functions for parsing PDB files
* Plot - Rudimentary plotting of matrices of atomic coordinates
* Mafft - Julia API for multisequence alignment with MAFFT
* Modeller - Functions and scripts to use MODELLER with Julia
* Cluster -

## Example pipeline

See [```src/pipeline.jl```](https://github.com/hng/BiomolecularStructures/blob/master/src/pipeline.jl) for a sketch of a pipeline that runs several of the package's modules.

<hr />
<small>A [Bioinformatics WS 2014/15](https://www.uni-due.de/zmb/members/hoffmann/overview.shtml) course project by Simon Malischewski, Henning Schumann, Philipp Gerling, Simon Leßmann. Supervision by [Prof. Dr. Daniel Hoffmann](https://www.uni-due.de/zmb/members/hoffmann/overview.shtml).</small>