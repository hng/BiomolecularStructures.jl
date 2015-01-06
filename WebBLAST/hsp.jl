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

	qseq::AminoAcid
	hseq::AminoAcid
	midline::AminoAcid
end