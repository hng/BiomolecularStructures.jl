using PyCall
using PyPlot

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
a = modeller.alignment(e, file="TvLDH-1bdmA.ali")

template = get_profile("1bdmA.profile", get(a, "1bdmA"))
model = get_profile("TvLDH.profile", get(a, "TvLDH"))

# Plot the template and model profiles in the same plot for comparison:
figure(1, figsize=(10,6))
xlabel("Alignment position")
ylabel("DOPE per-residue score")
plot(model, color="red", linewidth=2, label="Model")
plot(template, color="green", linewidth=2, label="Template")
legend()
savefig("dope_profile.png", dpi=65)
