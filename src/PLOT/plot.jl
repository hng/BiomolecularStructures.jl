module MatrixPlot
using PyPlot
export matrices_plot

# convert a matrix to PyPlot format
function matrix_prep(A::Array{Float64,2})
	x::Array{Float64,1} = Float64[]
	y::Array{Float64,1} = Float64[]
	z::Array{Float64,1} = Float64[]
	for i=1:size(A,1)
		xyz = A[i,:]
		push!(x,xyz[1])
		push!(y,xyz[2])
		push!(z,xyz[3])
	end

	return x, y, z
end
# Plot a 3D scatterplot of two matrices
function matrices_plot(P::Array{Float64,2},Q::Array{Float64,2})
	
	pygui(true)
	x::Array{Float64,1}, y::Array{Float64,1}, z::Array{Float64,1} = matrix_prep(P)
	scatter3D(x, y, z, color="red")
	x::Array{Float64,1}, y::Array{Float64,1}, z::Array{Float64,1} = matrix_prep(Q)
	scatter3D(x, y, z, color="green")
	readline()
end
end