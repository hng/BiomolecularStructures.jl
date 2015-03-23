using PyCall

@pyimport modeller
@pyimport modeller.automodel as am

env = modeller.environ()
a = am.automodel(env, alnfile="TvLDH-1bdmA.ali",
              knowns="1bdmA", sequence="TvLDH",
              assess_methods=(am.assess[:DOPE],
                              #soap_protein_od.Scorer(),
                              am.assess[:GA341]))
a[:starting_model] = 1
a[:ending_model] = 5
a[:make]()
