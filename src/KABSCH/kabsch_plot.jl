include(joinpath(dirname(@__FILE__), "..", "KABSCH", "kabsch.jl")) 
include(joinpath(dirname(@__FILE__), "..", "PDB", "pdb.jl")) 
include(joinpath(dirname(@__FILE__), "..", "PLOT", "plot.jl"))

using Kabsch
using PDB
using MatrixPlot

structure = get_structure("examples/data/2HHB.pdb")
chains = get_chains(structure)

alpha_1 = chains[1]
alpha_2 = chains[3]

beta_1 = chains[2]
beta_2 = chains[4]

#matrices_plot(alpha_1, alpha_2)
#matrices_plot(beta_1, beta_2)

#matrices_plot(alpha_1, kabsch(alpha_1, alpha_2))
matrices_plot(beta_1, kabsch(beta_1, beta_2))