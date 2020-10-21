module TVRegDiff

using Plots
using SparseArrays

include("antidiff.jl")
include("cholinc.jl")
include("tvdiff.jl")

a = collect(1:6)
TVDiff(a, 2, 0.5, scale="small")

end # module 
