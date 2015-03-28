# Modeller
This module provides simple Julia integration with [MODELLER](https://salilab.org/modeller/), a bioinformatics tool for comparative protein structure modelling.
You need to [install](https://salilab.org/modeller/download_installation.html) MODELLER locally on your computer in order to use this module.

## Exported functions

```julia
gen_modeller_script(name::String)
```

Generates Julia templates for MODELLER usage with Julia.

name: The name of the script (minus the extension). Possible values: "align2d", "build_profile", "compare", "evaluate_model", "model-single", "plot_profiles".

These scripts are based on the basic example scripts from Tutorial on the MODELLER website.
Scripts are generated in the current working directory. You can find all scripts that can be generated in `src/MODELLER/modeller-basic-example-julia`.

**Example:**

```julia
gen_modeller_script("build_profile")
```

This module also provides a few simple functions that provide common MODELLER tasks. These are again adapted from the MODELLER basic example. The given examples calls should work inside the modeller-basic-example directory. 

```julia
build_profile(;seq_database_file::String = "", seq_database_format::String="PIR", alignment_file::String = "", alignment_format::String = "PIR", output_name::String = "build_profile", output_profile_format::String="TEXT", output_alignment_format::String="PIR")
```

Note: this function is using keyword arguments

**Example:**

```julia
build_profile(seq_database_file="pdb_95.pir", alignment_file="TvLDH.ali") 
```

```julia
align2d(model_file::String, model_segment, model_align_codes::String, atom_files::String, align_file::String, align_codes::String, outputname::String)
```

**Example:**

```julia
align2d("1bdm.pdb", ("FIRST:A","LAST:A"), "1bdmA", "1bdm.pdb", "TvLDH.ali", "TvLDH", "TvLDH-1bdmA")
```

```julia
model_single(alnf::String, known_structure::String, seq::String)
```
alnf: path to alignment file

known_structure: path or name of known pdb structure

seq: sequence  

**Example:**

```julia
model_single("TvLDH-1bdmA.ali", "1bdmA", "TvLDH")
```

```julia
evaluate_model(pdbfile::String, outputfile::String = "")
```
pdbfile: path to pdb file

outputfile: optional path to output file. Defaults to pdbfile+".profile" 

**Example:**

```julia
evaluate_model("TvLDH.B99990002.pdb", "TvLDH.profile")
```

##References

  * N. Eswar, M. A. Marti-Renom, B. Webb, M. S. Madhusudhan, D. Eramian, M. Shen, U. Pieper, A. Sali. Comparative Protein Structure Modeling With MODELLER. Current Protocols in Bioinformatics, John Wiley & Sons, Inc., Supplement 15, 5.6.1-5.6.30, 2006.
  * M.A. Marti-Renom, A. Stuart, A. Fiser, R. Sánchez, F. Melo, A. Sali. Comparative protein structure modeling of genes and genomes. Annu. Rev. Biophys. Biomol. Struct. 29, 291-325, 2000.
  * A. Sali & T.L. Blundell. Comparative protein modelling by satisfaction of spatial restraints. J. Mol. Biol. 234, 779-815, 1993.
  * A. Fiser, R.K. Do, & A. Sali. Modeling of loops in protein structures, Protein Science 9. 1753-1773, 2000.
