module TVRegDiff
using Plots
using LaTeXStrings

using LinearAlgebra
using SparseArrays
using Preconditioners
using Preconditioners: AbstractPreconditioner
using LinearOperators
using IterativeSolvers


include("plotting.jl")
include("tvdiff.jl")

# Small experiment for debugging here
using CSV, DataFrames

# file = CSV.File("./data/small_demo_data.csv")
# df = DataFrame(file)
# TVDiff(df.noisyabsdata, 500, 0.2, scale="large", 
#     ε=1e-6, dx=0.01, plot_flag=true, diag_flag=true)

file = CSV.File("./data/large_demo_data.csv")
df = DataFrame(file)
TVDiff(df.largescaledata, 40, 1e-3, scale="small", ε=1e-6, 
    plot_flag=true, diag_flag=true)

# x = collect(1:10)
# TVDiff(x, 1, 0.2, scale="large")

export TVDiff

end # module 
