" functions for Julia integration with Modeller (http://salilab.org/modeller/)
  adapted from the modeller example scripts
"

module Modeller
export  gen_modeller_script, build_profile, compare, model_single, evaluate_model, align2d, plot_profiles
    using PyCall
    using PyPlot

    # Generator for MODELLER julia scripts.
    # These scripts are based on the basic example scripts from the MODELLER website.
    # Scripts are generated in the current working directory
    # name: The name of the script (minus the extension), e.g. "build_profile"
    function gen_modeller_script(name::AbstractString)
       file = joinpath(dirname(@__FILE__), "..", "MODELLER/modeller-basic-example-julia", "$name.jl")
       if isfile(file)
          cp(file, "./$name.jl")
          println("Generated $name.jl MODELLER script") 
       end 
    end

    function build_profile(;seq_database_file::AbstractString = "", seq_database_format::AbstractString="PIR", sequence_file::AbstractString = "", sequence_format::AbstractString = "PIR", output_name::AbstractString = "build_profile", output_profile_format::AbstractString="TEXT", output_alignment_format::AbstractString="PIR")
        seq_database_file_out = string(seq_database_file, ".bin")

        pyinitialize()
        @pyimport modeller
        @pyimport _modeller
        mod_lib = _modeller.mod_libdir_get()
        modeller.log[:verbose]()
        env = modeller.environ()

        #-- Prepare the input files

        #-- Read in the sequence database
        sdb = modeller.sequence_db(env)
        sdb[:read](seq_database_file=seq_database_file, seq_database_format=seq_database_format,
                 chains_list="ALL", minmax_db_seq_len=(30, 4000), clean_sequences=true)

        #-- Write the sequence database in binary form
        sdb[:write](seq_database_file=seq_database_file_out, seq_database_format="BINARY",
                  chains_list="ALL")

        #-- Now, read in the binary database
        sdb[:read](seq_database_file=seq_database_file_out, seq_database_format="BINARY",
                 chains_list="ALL")

        #-- Read in the target sequence/alignment
        aln = modeller.alignment(env)
        aln[:append](file=sequence_file, alignment_format=sequence_format, align_codes="ALL")

        #-- Convert the input sequence/alignment into
        #   profile format
        prf = aln[:to_profile]()

        #-- Scan sequence database to pick up homologous sequences
        prf[:build](sdb, matrix_offset=-450, rr_file=string(mod_lib,"/blosum62.sim.mat"),
                  gap_penalties_1d=(-500, -50), n_prof_iterations=1,
                  check_profile=false, max_aln_evalue=0.01)

        #-- Write out the profile in text format
        prf[:write](file=string(output_name, ".prf"), profile_format=output_profile_format)

        #-- Convert the profile back to alignment format
        aln = prf[:to_alignment]()

        #-- Write out the alignment file
        aln[:write](file=string(output_name, ".ali"), alignment_format=output_alignment_format)

    end

    function compare(pdbs)
        @pyimport modeller

        env = modeller.environ()
        aln = modeller.alignment(env)
        for (pdb, chain) in pdbs
            m = modeller.model(env, file=pdb, model_segment=("FIRST:$chain", "LAST:$chain"))
            aln[:append_model](m, atom_files=pdb, align_codes=string(pdb, chain))
        end
        aln[:malign]()
        aln[:malign3d]()
        aln[:compare_structures]()
        aln[:id_table](matrix_file="family.mat")
        env[:dendrogram](matrix_file="family.mat", cluster_cut=-1.0)
    end

    function model_single(alnf::AbstractString, known_structure::AbstractString, seq::AbstractString)

        @pyimport modeller
        @pyimport modeller.automodel as am

        env = modeller.environ()
        a = am.automodel(env, alnfile=alnf,
              knowns=known_structure, sequence=seq,
              assess_methods=(am.assess[:DOPE],
                              #soap_protein_od.Scorer(),
                              am.assess[:GA341]))
        a[:starting_model] = 1
        a[:ending_model] = 5
        a[:make]()
    end

    function evaluate_model(pdbfile::AbstractString, outputfile::AbstractString = "")

        # check for optional argument output and set it to the first part of the name of the PDB file
        if outputfile == ""
            outputfile = string(pdbfile, ".profile")
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

   function align2d(model_file::AbstractString, model_segment, model_codes::AbstractString, atom_files::AbstractString, sequence_file::AbstractString, sequence_codes::AbstractString, outputname::AbstractString)
       @pyimport modeller

       env = modeller.environ()
       aln = modeller.alignment(env)
       mdl = modeller.model(env, file=model_file, model_segment=model_segment)
       aln[:append_model](mdl, align_codes=model_codes, atom_files=atom_files)
       aln[:append](file=sequence_file, align_codes=sequence_codes)
       aln[:align2d]()
       aln[:write](file=string(outputname, ".ali"), alignment_format="PIR")
       aln[:write](file=string(outputname, ".pap"), alignment_format="PAP")
    end
    
    function plot_profiles(alignment_file::AbstractString, template_profile::AbstractString, template_sequence::AbstractString, model_profile::AbstractString, model_sequence::AbstractString, plot_file::AbstractString = "dope_profile.png")

        @pyimport modeller

        function r_enumerate(seq)
            """Enumerate a sequence in reverse order"""
            # Note that we don"t use reversed() since Python 2.3 doesn"t have it
            num = pybuiltin(:len)(seq) - 1
            while num >= 0
                produce((num, get(seq, num)))
                num -= 1
            end
        end

        function get_profile(profile_file, seq)
            """Read `profile_file` into a Python array, and add gaps corresponding to
               the alignment sequence `seq`."""
            # Read all non-comment and non-blank lines from the file:
            f = open(profile_file)
            vals = Any[]
            for line in eachline(f)
                if line[1] != '#' && length(line) > 10
                    spl = split(line)
                    push!(vals, float(last(spl)))
                end
            end
            close(f)
            # Insert gaps into the profile corresponding to those in seq:
            taskAtr = @task r_enumerate(seq[:residues])
            for x in taskAtr
                n = x[1]
                res = x[2]
                for gap in range(1, res[:get_leading_gaps]())
                    # Julia arrays start from 1 so we have to add 1 to the position
                    insert!(vals, n+1, nothing)
                end
            end
            # Add a gap at position "0", so that we effectively count from 1:
            insert!(vals, 1, nothing)
            return vals
        end

        e = modeller.environ()
        a = modeller.alignment(e, file=alignment_file)

        template = get_profile(template_profile, get(a, template_sequence))
        model = get_profile(model_profile, get(a, model_sequence))

        # Plot the template and model profiles in the same plot for comparison:
        PyPlot.figure(1, figsize=(10,6))
        PyPlot.xlabel("Alignment position")
        PyPlot.ylabel("DOPE per-residue score")
        PyPlot.plot(model, color="red", linewidth=2, label="Model")
        PyPlot.plot(template, color="green", linewidth=2, label="Template")
        PyPlot.legend()
        PyPlot.savefig(plot_file, dpi=65)
    end
end
