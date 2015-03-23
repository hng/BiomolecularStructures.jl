" functions for Julia integration with Modeller (http://salilab.org/modeller/)
  adapted from the modeller example scripts
"

module MODELLER
export model_single
    using PyCall

    @pyimport modeller
    @pyimport modeller.automodel as am

    function model_single(alnf, know, seq)
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

end
