# NoiseRobustDifferentiation.jl

Julia reimplementation of *Total Variation Regularized Numerical Differentiation* (TVDiff).

Based on [Rick Chartrand's original Matlab code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) and [Simone Sturniolo's Python reimplementation](https://github.com/stur86/tvregdiff).

```@contents
Pages = ["index.md", "examples.md"]
```

## Installation
To install this package and its dependencies, open the Julia REPL and run 
```julia
julia> ]add NoiseRobustDifferentiation
```

Julia 1.5 is required.

## Functions
```@docs
tvdiff
```

## Differences to MATLAB Code
### Conjugate gradient method
The [original code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) uses MATLAB's inbuilt function `pcg()`, which implements the preconditioned conjugate gradients method (PCG). This code uses the conjugate gradients method (CG) from [IterativeSolvers.jl](https://github.com/JuliaMath/IterativeSolvers.jl). 
Refer to the [implementation details](https://juliamath.github.io/IterativeSolvers.jl/dev/linear_systems/cg/#Implementation-details-1) for a brief discussion of differences between both methods.

Since the CG method from IterativeSolvers.jl allows for preconditioners, most of the options from [Preconditioners.jl](https://github.com/mohamed82008/Preconditioners.jl) are implemented using default parameters.

### New parameters
- `precond`: Method used for preconditioning.
- `cg_tol`: Tolerance used in conjugate gradient method.

### Other differences
- `diag_flag` has been renamed to `show_diagn`
- removed plotting flag

## Citation
Please cite the following paper if you use this code in published work:
> Rick Chartrand, "Numerical differentiation of noisy, nonsmooth data," ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. 