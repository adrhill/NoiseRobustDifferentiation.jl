module TVRegDiff

using Plots
using LinearAlgebra
using SparseArrays
using Preconditioners
using Preconditioners: AbstractPreconditioner
using LinearOperators
using IterativeSolvers

include("antidiff.jl")
include("tvdiff.jl")

a = collect(1:6)
TVDiff(a, 500, 0.2, scale="small")

export TVDiff

end # module 
