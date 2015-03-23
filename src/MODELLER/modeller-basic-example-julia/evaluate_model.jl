using PyCall

@pyimport modeller
@pyimport modeller.scripts as scripts
@pyimport _modeller

mod_lib = _modeller.mod_libdir_get()

modeller.log[:verbose]()    # request verbose output
env = modeller.environ()
env[:libs][:topology][:read](file=string(mod_lib, "/top_heav.lib")) # read topology
env[:libs][:parameters][:read](file=string(mod_lib, "/par.lib")) # read parameters

# read model file
mdl = scripts.complete_pdb(env, "TvLDH.B99990002.pdb")

# Assess with DOPE:
s = modeller.selection(mdl)   # all atom selection
s[:assess_dope](output="ENERGY_PROFILE NO_REPORT", file="TvLDH.profile",
              normalize_profile=true, smoothing_window=15)
