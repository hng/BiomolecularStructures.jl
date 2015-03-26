" functions for Julia integration with Modeller (http://salilab.org/modeller/)
  adapted from the modeller example scripts
"

module Modeller
export model_single, gen_script, evaluate_model
    using PyCall


    # Generator for MODELLER julia scripts.
    # These scripts are based on the basic example scripts from the MODELLER website.
    # Scripts are generated in the current working directory
    # name: The name of the script (minus the extension), e.g. "build_profile"
    function gen_script(name::String)
       file = Pkg.dir("BiomolecularStructures", "src/MODELLER/modeller-basic-example-julia", "$name.jl")
       if isfile(file)
          cp(file, "./$name.jl")
          println("Generated $name.jl MODELLER script") 
       end 
    end

    function model_single(alnf::String, know, seq)

        @pyimport modeller
        @pyimport modeller.automodel as am

        env = modeller.environ()
        a = am.automodel(env, alnfile=alnf,
              knowns=know, sequence=seq,
              assess_methods=(am.assess[:DOPE],
                              #soap_protein_od.Scorer(),
                              am.assess[:GA341]))
        a[:starting_model] = 1
        a[:ending_model] = 5
        a[:make]()
    end

    function evaluate_model(pdbfile::String; outputfile::String)

        # check for optional argument output and set it to the first part of the name of the PDB file
        if !isdefined(:outputfile)
            outputfile = string(split(a,".")[1], ".profile")
        end

        @pyimport modeller
        @pyimport modeller.scripts as scripts
        @pyimport _modeller

        mod_lib = _modeller.mod_libdir_get()

        modeller.log[:verbose]()    # request verbose output
        env = modeller.environ()
        env[:libs][:topology][:read](file=string(mod_lib, "/top_heav.lib")) # read topology
        env[:libs][:parameters][:read](file=string(mod_lib, "/par.lib")) # read parameters

        # read model file
        mdl = scripts.complete_pdb(env, pdbfile)

        # Assess with DOPE:
        s = modeller.selection(mdl)   # all atom selection
        s[:assess_dope](output="ENERGY_PROFILE NO_REPORT", file=outputfile,
                  normalize_profile=true, smoothing_window=15)
    end
end
