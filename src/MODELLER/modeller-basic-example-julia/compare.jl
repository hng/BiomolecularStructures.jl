using PyCall
@pyimport modeller

env = modeller.environ()
aln = modeller.alignment(env)
for (pdb, chain) in (("1b8p", "A"), ("1bdm", "A"), ("1civ", "A"),
                     ("5mdh", "A"), ("7mdh", "A"), ("1smk", "A"))
    m = modeller.model(env, file=pdb, model_segment=("FIRST:$chain", "LAST:$chain"))
    aln[:append_model](m, atom_files=pdb, align_codes=string(pdb, chain))
end
aln[:malign]()
aln[:malign3d]()
aln[:compare_structures]()
aln[:id_table](matrix_file="family.mat")
env[:dendrogram](matrix_file="family.mat", cluster_cut=-1.0)
