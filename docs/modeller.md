# Modeller
This module provides simple Julia integration with [MODELLER](https://salilab.org/modeller/), a bioinformatics tool for comparative protein structure modelling.
You need to [install](https://salilab.org/modeller/download_installation.html) MODELLER locally on your computer in order to use this module.

## Dependencies

  * Julia Packages
    * PyCall
    * PyPlot
  * [MODELLER](https://salilab.org/modeller/download_installation.html)

## Exported functions

#### gen_modeller_script

```julia
gen_modeller_script(name::String)
```

Generates Julia templates for MODELLER usage with Julia.

**name:** The name of the script (minus the extension). Possible values: "align2d", "build_profile", "compare", "evaluate_model", "model-single", "plot_profiles".

These scripts are based on the basic example scripts from  the [tutorial](https://salilab.org/modeller/tutorial/basic.html) on the MODELLER website.
Scripts are generated in the current working directory. You can find all scripts that can be generated in `src/MODELLER/modeller-basic-example-julia`.

**Example:**

```julia
gen_modeller_script("build_profile")
```
### Functions for MODELLER integration with Julia

This module also provides a few simple functions that provide common MODELLER tasks. These are again adapted from the MODELLER basic example. The given examples calls should work inside the modeller-basic-example directory. These functions can be used as building blocks or starting points for more sophisticated workflows.

#### build_profile

```julia
build_profile(;seq_database_file::String = "", seq_database_format::String="PIR", sequence_file::String = "",
sequence_format::String = "PIR", output_name::String = "build_profile", output_profile_format::String="TEXT", output_alignment_format::String="PIR")
```

Searches a given sequence database for a given sequence (file) and writes hits to a profile and a alignment file with the given name/path and format.

Note: this function is using keyword arguments.

#### compare

```julia
compare(pdbs)
```
Prints out a table with the similarities between the given structures and a dendrogram.

**pdbs:** Array of pairs of pdb-files and chains that should be compared.

#### align2d

```julia
align2d(model_file::String, model_segment, model_align_codes::String, atom_files::String, sequence_file::String, sequence_codes::String, outputname::String)
```

Aligns a structure model (pdb) with a sequence. Writes the alignment to <outputname>.ali in PIR format and to <outputname>.pap in PAP format.

**model_file:** the file of the structure model

**model_segment:** the segment of the model to be used, e.g. ``('FIRST:A','LAST:A')``

**model_align_codes:** the code name of the structure. e.g. "1bdmA" for "1bdm:A"

**atom_files:** path to the model pdb file

**sequence_file:** path to the sequence file

**sequence_codes:** the code name of the structure, e.g. "TvLDH"

**outputname:** name of the files that ``align2d()`` creates.

#### model_single

```julia
model_single(alnf::String, known_structure::String, seq::String)
```
**alnf:** path to alignment file

**known_structure:** path or name of known pdb structure

**seq:** sequence  

#### evaluate_model

```julia
evaluate_model(pdbfile::String, outputfile::String = "")
```
**pdbfile:** path to pdb file

**outputfile:** optional path to output file. Defaults to pdbfile+".profile" 

#### plot_profiles

```julia
plot_profiles(alignment_file::String, template_profile::String, template_sequence::String, model_profile::String, model_sequence::String, plot_file::String = "dope_profile.png")
```

Plots a two profiles with data from a corresponding alignment file (for both structures).

**alignment_file:** path to alignment file

**template_profile:** path to profile that was used as the template

**template_profile:** sequence name from *template_profile* that should be used

**model_profile:** path to model profile 

**model_profile:** sequence name from *model_profile* that should be used

**plot_file:** (optional) path where created plot should be saved. Default: dope_profile.png

## Usage / Usecase
This usecase is again based on the [tutorial](https://salilab.org/modeller/tutorial/basic.html) on the MOELLER website. You should download the corresponding files and call the julia functions with the julia interactive prompt inside the tutorial example folder.

```julia
julia> build_profile(seq_database_file="pdb_95.pir", sequence_file="TvLDH.ali") 
```

Searches the sequence database ``pdb_95.pir`` for the sequence(s) in the sequence file ``TvLDH.ali``. Creates a profile (``build_profile.prf"``) and an alignment file with the database matches (``build_profile.ali``) in the current folder.

After looking at the output we can do a comparision between the hits that seem to be especially promising (e.g. low e-value of the alignment):

```julia
julia> compare((("1b8p", "A"), ("1bdm", "A"), ("1civ", "A"),
                     ("5mdh", "A"), ("7mdh", "A"), ("1smk", "A")))
```

After selecting a good structure for modelling (here: 1bdm:A) we first have to align our sequence with this structure:

```julia
julia> align2d("1bdm.pdb", ("FIRST:A","LAST:A"), "1bdmA", "1bdm.pdb", "TvLDH.ali", "TvLDH", "TvLDH-1bdmA")
```

We can then use the alignment file that ``align2d()``created, the template structure and our sequence to calculate a 3D model with MODELLER:

```julia
julia> model_single("TvLDH-1bdmA.ali", "1bdmA", "TvLDH")
```

If several models have been created we can use the ``evaluate_model()`` function in order to pick the best model:

```julia
julia> evaluate_model("TvLDH.B99990002.pdb", "TvLDH.profile")
```

With ``plot_profile()`` we can then plot the profile that ``evaluate_model()`` creates:

```julia
julia>  plot_profiles("TvLDH-1bdmA.ali", "1bdmA.profile", "1bdmA", "TvLDH.profile", "TvLDH")
```

##References

  * N. Eswar, M. A. Marti-Renom, B. Webb, M. S. Madhusudhan, D. Eramian, M. Shen, U. Pieper, A. Sali. Comparative Protein Structure Modeling With MODELLER. Current Protocols in Bioinformatics, John Wiley & Sons, Inc., Supplement 15, 5.6.1-5.6.30, 2006.
  * M.A. Marti-Renom, A. Stuart, A. Fiser, R. Sánchez, F. Melo, A. Sali. Comparative protein structure modeling of genes and genomes. Annu. Rev. Biophys. Biomol. Struct. 29, 291-325, 2000.
  * A. Sali & T.L. Blundell. Comparative protein modelling by satisfaction of spatial restraints. J. Mol. Biol. 234, 779-815, 1993.
  * A. Fiser, R.K. Do, & A. Sali. Modeling of loops in protein structures, Protein Science 9. 1753-1773, 2000.
