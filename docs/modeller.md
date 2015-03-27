# Modeller

## Exported functions

```julia
gen_script(name::String)
```

Generates Julia scripts for MODELLER.
name: The name of the script (minus the extension), e.g. "build_profile"
These scripts are based on the basic example scripts from the MODELLER website.
Scripts are generated in the current working directory. You can find all scripts that can be generated in src/MODELLER/modeller-basic-example-julia .

```julia
build_profile(;seq_database_file::String = "", seq_database_format::String="PIR", alignment_file::String = "", alignment_format::String = "PIR", output_name::String = "build_profile", output_profile_format::String="TEXT", output_alignment_format::String="PIR")
```

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
