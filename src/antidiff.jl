"""
Antidifferentiation operator
"""
function _antidiff(x::Array{<:Real,1}, dx::Real)
    cumsum(x) - 0.5 * (x .- x[1]) / dx
end

"""
Transpose of antidifferentiation operator
"""
function _antidiff_transpose(x::Array{<:Real,1}, dx::Real)
    [sum(x) / 2; (sum(x) .- cumsum(x) .- x / 2)][1:end-1] * dx
end