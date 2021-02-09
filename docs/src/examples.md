```@meta
EditURL = "<unknown>/literate/examples.jl"
```

# Examples

## Simple example

First we generate a small dataset by adding uniform noise to ``f(x)=|x|``

```@example examples
using Random, Distributions

n = 50
x = range(-5, 5; length=n)
dx = x[2] - x[1]

f_noisy = abs.(x) + rand(Uniform(-0.05, 0.05), n);
nothing #hide
```

then we call `TVRegDiff` using a regularization parameter of `α=0.2` for 100 iterations.

```@example examples
using NoiseRobustDifferentiation
include("../literate/plot_examples.jl") # hide

û = TVRegDiff(f_noisy, 100, 0.2; dx=dx);
nothing #hide
```

We compare the results to the true derivative ``u(x)=sign(x)`` and a naive implementation of finite differences.

```@example examples
û_FDM = diff(f_noisy) / dx  # FDM
plot_example_abs(abs, sign, x, f_noisy, û_FDM, û) # hide
```

# Examples from paper
Let's reconstruct the figures from Rick Chartrand's paper *"Numerical differentiation of noisy, non-smooth data"*.
The corresponding datasets can be found under `/docs/data`.

## Small-scale example
The small-scale example in the paper is a more noisy variant of our first example. We start by loading the data.

```@example examples
using CSV, DataFrames

file = CSV.File("../data/demo_small.csv")
df = DataFrame(file)
data = df.noisyabsdata
```

Applying finite differences leads to a noisy and inaccurate result that amplifies the noise:

```@example examples
plot_FDM(data) # hide

#A strongly regularized result is obtained by calling `TVRegDiff` with `α=0.2`.
û = TVRegDiff(data, 500, 0.2; scale="small", dx=0.01, ε=1e-6)
plot_TVRegDiff(data, û) # hide
```

Because of keyword argument defaults, this is equal to calling

```julia
û = TVRegDiff(data, 500, 0.2)
```

A better result is obtained after 7000 iterations, though differences are minimal.

```@example examples
û = TVRegDiff(data, 7000, 0.2)
plot_TVRegDiff(data, û) # hide
```

```@example examples
savefig("paper_small7000.svg") #!nb # hide
```

## Large-scale example
The data in this example was obtained from a whole-room calorimeter.

```@example examples
file = CSV.File("../data/demo_large.csv")
df = DataFrame(file)
data = df.largescaledata
```

Computing derivates using naive finite differences gives a useless result:

```@example examples
plot_demo_large_diff(data) # hide
```

Using `TVRegDiff` with `ε=1e-9`, we obtain a strongly regularized result. Larger values of ``\varepsilon`` improve conditioning and speed, while smaller values give more accurate results with sharper jumps.

```@example examples
û = TVRegDiff(data, 40, 1e-1; scale="large", precond="amg_rs", ε=1e-9)
plot_TVRegDiff_all(data, û) # hide
savefig("paper_large_all.png") #!nb #hide
plot_demo_large_TVReg(data, û) # hide
```

Therefore raising ``\varepsilon`` to `1e-7` gives a smoother result. However, jumps in the derivative are also smoothed away.

```@example examples
û = TVRegDiff(data, 40, 1e-1; scale="large", precond="amg_rs", ε=1e-7)
plot_demo_large_TVReg(data, û) # hide
```

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

