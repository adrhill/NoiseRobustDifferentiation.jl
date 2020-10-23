module TVRegDiff
using Plots
using LaTeXStrings

using LinearAlgebra
using SparseArrays
using Preconditioners
using LinearOperators
using IterativeSolvers

include("plotting.jl")
include("tvdiff.jl")

export TVDiff

end # module 
