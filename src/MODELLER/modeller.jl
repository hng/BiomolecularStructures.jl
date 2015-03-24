" functions for Julia integration with Modeller (http://salilab.org/modeller/)
  adapted from the modeller example scripts
"

module MODELLER
export model_single, gen_script
    using PyCall

    function model_single(alnf, know, seq)

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
end
