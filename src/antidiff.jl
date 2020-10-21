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
    sum(x) * ones(length(x) + 1) - [sum(x) / 2; cumsum(x) .- x / 2] * dx
end