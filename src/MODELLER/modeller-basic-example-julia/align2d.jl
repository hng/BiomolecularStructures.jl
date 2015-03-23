using PyCall
@pyimport modeller

env = modeller.environ()
aln = modeller.alignment(env)
mdl = modeller.model(env, file="1bdm", model_segment=("FIRST:A","LAST:A"))
aln[:append_model](mdl, align_codes="1bdmA", atom_files="1bdm.pdb")
aln[:append](file="TvLDH.ali", align_codes="TvLDH")
aln[:align2d]()
aln[:write](file="TvLDH-1bdmA.ali", alignment_format="PIR")
aln[:write](file="TvLDH-1bdmA.pap", alignment_format="PAP")
