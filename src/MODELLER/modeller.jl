" functions for Julia integration with Modeller (http://salilab.org/modeller/)
  adapted from the modeller example scripts
"

module Modeller
export  gen_modeller_script, build_profile, model_single, evaluate_model, align2d
    using PyCall

    # Generator for MODELLER julia scripts.
    # These scripts are based on the basic example scripts from the MODELLER website.
    # Scripts are generated in the current working directory
    # name: The name of the script (minus the extension), e.g. "build_profile"
    function gen_modeller_script(name::String)
       file = Pkg.dir("BiomolecularStructures", "src/MODELLER/modeller-basic-example-julia", "$name.jl")
       if isfile(file)
          cp(file, "./$name.jl")
          println("Generated $name.jl MODELLER script") 
       end 
    end

    function build_profile(;seq_database_file::String = "", seq_database_format::String="PIR", alignment_file::String = "", alignment_format::String = "PIR", output_name::String = "build_profile", output_profile_format::String="TEXT", output_alignment_format::String="PIR")
        seq_database_file_out = string(split(seq_database_file, "."), ".bin")

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
        aln[:append](file=alignment_file, alignment_format=alignment_format, align_codes="ALL")

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

    function model_single(alnf::String, known_structure::String, seq::String)

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

    function evaluate_model(pdbfile::String, outputfile::String = "")

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

   function align2d(model_file::String, model_segment, model_align_codes::String, atom_files::String, align_file::String, align_codes::String, outputname::String)
       @pyimport modeller

       env = modeller.environ()
       aln = modeller.alignment(env)
       mdl = modeller.model(env, file=model_file, model_segment=model_segment)
       aln[:append_model](mdl, align_codes=model_align_codes, atom_files=atom_files)
       aln[:append](file=align_file, align_codes=align_codes)
       aln[:align2d]()
       aln[:write](file=string(outputname, ".ali"), alignment_format="PIR")
       aln[:write](file=string(outputname, ".pap"), alignment_format="PAP")
    end
end
