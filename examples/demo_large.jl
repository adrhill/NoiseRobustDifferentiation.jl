"""
script to demonstrate small-scale example from paper Rick Chartrand, 
Numerical differentiation of noisy, nonsmooth data," ISRN
Applied Mathematics, Vol. 2011, Article ID 164564, 2011.
"""
using CSV, DataFrames

file = CSV.File("./data/large_demo_data.csv")
df = DataFrame(file)

## Smoother example
TVDiff(df.noisyabsdata, 40, 1e-1, scale="large", ε=1e-8, 
    plotflag=true, diagflag=true)

## Less smooth example## Smoother example
TVDiff(df.noisyabsdata, 40, 1e-3, scale="large", ε=1e-6, 
    plotflag=true, diagflag=true)   
