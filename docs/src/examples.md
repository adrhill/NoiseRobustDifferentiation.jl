# Examples

## Simple example

First we generate a small dataset by adding uniform noise to ``f(x)=|x|``

```@example abs_small
n = 50 
x = range(-5, 5, length=n)
dx = x[2]-x[1]

f = abs.(x)
f_noisy = f + 0.05 * (rand(n) .- 0.5)
; nothing # hide
```

and then call `TVRegDiff` using a regularization parameter of `α=0.2` for 10 iterations

```@example abs_small
using NoiseRobustDifferentiation
using Plots # hide
include("plot_example.jl") # hide

û = TVRegDiff(f_noisy, 100, 0.2, dx=dx)
nothing # hide
```

We compare the results to the true derivative ``u(x)=sign(x)`` and naive finite differences using `diff(f) / dx`.
```@example abs_small
u = sign.(x) # true derivative
û_diff = diff(f_noisy) / dx  # FDM

append!(û_diff, NaN) # hide
plot_example(x, f, f_noisy, u, û_diff, û) # hide
plot!(legend=:bottomright) # hide
savefig("abs_small.svg"); nothing # hide
```

![](abs_small.svg)

## Examples from paper
Let's now reconstruct the figures from Rick Chartrand's paper *"Numerical differentiation of noisy, nonsmooth data"*.
The corresponding datasets can be found under `/docs/data`.

### Small-scale example
The small-scale example in figure 1 is a more noisy variant of our first example.

```@example paper_small
using NoiseRobustDifferentiation
using CSV, DataFrames
using Plots # hide

file = CSV.File("../data/demo_small.csv")
df = DataFrame(file)

TVRegDiff(df.noisyabsdata, 500, 0.2, scale="small", ε=1e-6, dx=0.01, plot_flag=true)
savefig("paper_small.svg"); nothing # hide
```

![](paper_small.svg)

Defaults mean that calling

```julia
u = TVRegDiff(df.noisyabsdata, 500, 0.2)
```

would have the same results.

A better result is obtained after 7000 iterations, though differences are minimal.

```@example paper_small
TVRegDiff(df.noisyabsdata, 7000, 0.2, scale="small", ε=1e-6, dx=0.01, plot_flag=true)
savefig("paper_small7000.svg"); nothing # hide
```

![](paper_small7000.svg)

### Large-scale example

First we use parameters that lead to a very smooth result: notably a high regularization parameter `α=1e-1`.
This should resemble figure 9.

```@example paper_large
using NoiseRobustDifferentiation
using CSV, DataFrames
using Plots # hide

file = CSV.File("../data/demo_large.csv")
df = DataFrame(file)

TVRegDiff(df.largescaledata, 40, 1e-1, scale="large", precond="diagonal", ε=1e-8, plot_flag=true)
savefig("paper_large_smooth.svg"); nothing # hide
```

![](paper_large_smooth.svg)


A less smooth example – similar to figure 8 – can be obtained by lowering the regularization parameter to `α=1e-3`.

```@example paper_large
TVRegDiff(df.largescaledata, 40, 1e-3, scale="large", precond="diagonal", ε=1e-6, plot_flag=true)
savefig("paper_large_jump.svg"); nothing # hide
```

![](paper_large_jump.svg)
