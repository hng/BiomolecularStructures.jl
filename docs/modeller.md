# Modeller

## Exported functions

``
    gen_script(name::String)``

Generates Julia scripts for MODELLER.
name: The name of the script (minus the extension), e.g. "build_profile"
These scripts are based on the basic example scripts from the MODELLER website.
Scripts are generated in the current working directory. You can find all scripts that can be generated in src/MODELLER/modeller-basic-example-julia .


`` align2d(model_file::String, model_segment, model_align_codes::String, atom_files::String, align_file::String, align_codes::String, outputname::String)``

**Example:**

``align2d("1bdm", ("FIRST:A","LAST:A"), "1bdmA", "1bdm.pdb", "TvLDH.ali", "TvLDH", "TvLDH-1bdmA")``
