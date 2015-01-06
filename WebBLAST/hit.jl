using BioSeq

type Hit
	hit_num::Int
	id::String
	def::String
	accession::String
	len::Int
	
	Hsps::Array{Hsp,1}
end

