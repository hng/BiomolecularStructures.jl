using BioSeq
type Hsp
	hsp_num::Int
	bitScore::Float64
	evalue::Float64
	queryFrom::Int
	queryTo::Int
	queryFrame::Int
	hitFrame::Int
	identity::Int
	positive::Int
	gaps::Int
	alignLen::Int

	qseq::Array{AminoAcid,1}
	qseq_str::AbstractString

	hseq::Array{AminoAcid,1}
	midline::Array{AminoAcid,1}

	
	
end

type Hit
	hit_num::Int
	id::AbstractString
	def::AbstractString
	accession::AbstractString
	len::Int
	
	hsps::Array{Hsp,1}
end

function fastarepresentation(hit::Hit)
	fasta = ""

	for hsp in hit.hsps
		fasta = (hit.id, hsp.qseq_str)
	end
	return fasta
end

function check_threshold(threshold::Float64, hit::Hit)
	# check single hsp, for now
	for hsp in hit.hsps
		if hsp.evalue < threshold
			return true
		else
			return false
		end
	end
end