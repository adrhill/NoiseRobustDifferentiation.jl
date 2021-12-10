# Examples

## Simple example

First we generate a small dataset by adding uniform noise to ``f(x)=|x|``

```@example abs_small
using Random, Distributions

n = 50 
x = range(-5, 5, length=n)
dx = x[2] - x[1]

f_noisy = abs.(x) + rand(Uniform(-0.05, 0.05), n)
; nothing # hide
```

then we call `tvdiff` using a regularization parameter of `α=0.2` for 100 iterations.

```@example abs_small
using NoiseRobustDifferentiation
include("plot_examples.jl") # hide

û = tvdiff(f_noisy, 100, 0.2, dx=dx)
nothing # hide
```

We compare the results to the true derivative ``u(x)=sign(x)`` and a naive implementation of finite differences.
```@example abs_small
û_FDM = diff(f_noisy) / dx  # FDM
plot_example_abs(abs, sign, x, f_noisy, û_FDM, û) # hide
savefig("abs_small.svg"); nothing # hide
```

![](abs_small.svg)

## Examples from paper
Let's reconstruct the figures from Rick Chartrand's paper *"Numerical differentiation of noisy, non-smooth data"*.

The corresponding datasets can be found under `/docs/data`.

### Small-scale example
The small-scale example in the paper is a more noisy variant of our first example. We start by loading the data.

```@example paper_small
using NoiseRobustDifferentiation
using CSV, DataFrames
include("plot_examples.jl") # hide

file = CSV.File("../data/demo_small.csv")
df = DataFrame(file)
data = df.noisyabsdata
plot_FDM(data) # hide
savefig("paper_small_fdm.svg"); nothing # hide
```

Applying finite differences leads to a noisy and inaccurate result that amplifies the noise:

![](paper_small_fdm.svg)

A strongly regularized result is obtained by calling `tvdiff` with `α=0.2`.

```@example paper_small
û = tvdiff(data, 500, 0.2, scale="small", dx=0.01, ε=1e-6)
plot_tvdiff(data, û) # hide
savefig("paper_small.svg"); nothing # hide
```

![](paper_small.svg)

Because of keyword argument defaults, this is equal to calling

```julia
û = tvdiff(data, 500, 0.2)
```

A better result is obtained after 7000 iterations, though differences are minimal.

```@example paper_small
û = tvdiff(data, 7000, 0.2)
plot_tvdiff(data, û) # hide
savefig("paper_small7000.svg")# hide
plot_tvdiff_all(data, û) # hide
savefig("paper_small_all.svg"); nothing # hide
```

![](paper_small7000.svg)

### Large-scale example

The data in this example was obtained from a whole-room calorimeter.

```@example paper_large
using NoiseRobustDifferentiation
using CSV, DataFrames
include("plot_examples.jl") # hide

file = CSV.File("../data/demo_large.csv")
df = DataFrame(file)
data = df.largescaledata
plot_demo_large_diff(data) # hide
savefig("paper_large_fdm.png"); nothing # hide
```

Computing derivates using naive finite differences gives a useless result:

![](paper_large_fdm.png)

Using `tvdiff` with `ε=1e-9`, we obtain a strongly regularized result. Larger values of ``\varepsilon`` improve conditioning and speed, while smaller values give more accurate results with sharper jumps.

```@example paper_large
û = tvdiff(data, 40, 1e-1, scale="large", precond="amg_rs", ε=1e-9)
plot_demo_large_TVReg(data, û) # hide
savefig("paper_large_jump.png") # hide
plot_tvdiff_all(data, û) # hide
savefig("paper_large_all.png"); nothing # hide
```

![](paper_large_jump.png)

Therefore raising ``\varepsilon`` to `1e-7` gives a smoother result. However, jumps in the derivative are also smoothed away.

```@example paper_large
û = tvdiff(data, 40, 1e-1, scale="large", precond="amg_rs", ε=1e-7)
plot_demo_large_TVReg(data, û) # hide
savefig("paper_large_smooth.png"); nothing # hide
```

![](paper_large_smooth.png)


