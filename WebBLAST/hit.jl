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
	hseq::Array{AminoAcid,1}
	midline::Array{AminoAcid,1}

	
	
end

type Hit
	hit_num::Int
	id::String
	def::String
	accession::String
	len::Int
	
	hsps::Array{Hsp, 1}
end

