"""
script to demonstrate small-scale example from paper Rick Chartrand, 
Numerical differentiation of noisy, nonsmooth data," ISRN
Applied Mathematics, Vol. 2011, Article ID 164564, 2011.
"""
using CSV, DataFrames

file = CSV.File("./data/small_demo_data.csv")
df = DataFrame(file)

"""
    noisyabsdata = absdata + 0.05 * randn( size( absdata ) ); 
results vary slightly with different random instances
"""
TVDiff(df.noisyabsdata, 500, 0.2, scale="small", preconditioner="none", 
    ε=1e-6, dx=0.01, plotflag=true, diagflag=true)

"""
defaults mean that 
    u = TVDiff(df.noisyabsdata, 500, 0.2 ); 
would be the same.
Best result obtained after 7000 iterations, though difference is minimal.
Set last input to `false` to turn off diagnostics.
"""
