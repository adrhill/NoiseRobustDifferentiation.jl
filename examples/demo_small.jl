# Script to demonstrate small-scale example from paper Rick Chartrand, 
# Numerical differentiation of noisy, nonsmooth data," ISRN
# Applied Mathematics, Vol. 2011, Article ID 164564, 2011.

using TVRegDiff
using CSV, DataFrames

file = CSV.File("./data/small_demo_data.csv")
df = DataFrame(file)

#=
Data was generated in Matlab using
    noisyabsdata = absdata + 0.05 * randn( size( absdata ) ); 
results vary slightly with different random instances
=#

TVDiff(df.noisyabsdata, 500, 0.2, scale="small", ε=1e-6, dx=0.01, 
    plot_flag=true, diag_flag=true)
    
#=
Defaults mean that 
    u = TVDiff(df.noisyabsdata, 500, 0.2 ); 
would be the same.
Best result obtained after 7000 iterations, though difference is minimal.
Set last input to `false` to turn off diagnostics. 
=#
