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

using CSV, DataFrames
file = CSV.File("./data/small_demo_data.csv")
df = DataFrame(file)

diff = TVDiff(df.noisyabsdata, 100, 0.2, scale="small", preconditioner="none", 
    ε=1e-6, dx=0.01, plot_flag=false, diag_flag=true)

# a = collect(1:6)
# TVDiff(a, 5, 0.2, scale="small")
# TVDiff(a, 500, 0.2, scale="small")

export TVDiff

end # module 
