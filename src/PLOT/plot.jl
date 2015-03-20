module MatrixPlot
using PyPlot
export matrices_plot

function matrix_prep(A)
	x = Float64[]
	y = Float64[]
	z = Float64[]
	for i=1:size(A,1)
		xyz = A[i,:]
		push!(x,xyz[1])
		push!(y,xyz[2])
		push!(z,xyz[3])
	end

	return x, y, z
end

function matrices_plot(P,Q)
	
	pygui(true)
	x, y, z = matrix_prep(P)
	scatter3D(x, y, z, color="red")
	x, y, z = matrix_prep(Q)
	scatter3D(x, y, z, color="green")
	readline()
end
end