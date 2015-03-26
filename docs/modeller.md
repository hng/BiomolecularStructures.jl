# Modeller

## Exported functions

``
    function gen_script(name::String)``

Generates Julia scripts for MODELLER.
name: The name of the script (minus the extension), e.g. "build_profile"
These scripts are based on the basic example scripts from the MODELLER website.
Scripts are generated in the current working directory. You can find all scripts that can be generated in src/MODELLER/modeller-basic-example-julia .
