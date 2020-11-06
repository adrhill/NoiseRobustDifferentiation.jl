# NoiseRobustDifferentiation.jl

Julia reimplementation of *Total Variation Regularized Numerical Differentiation* (TVDiff) based on [Rick Chartrand's original MATLAB code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) with small changes and tests from [Simone Sturniolo's Python reimplementation](https://github.com/stur86/tvregdiff).

```@contents
Pages = ["index.md", "examples.md"]
```

## Functions
```@docs
TVRegDiff(data::Array{<:Real,1}, iter::Int, α::Real; kwargs...)
```

## Differences to MATLAB Code
### Conjugate gradient method
The [original code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) uses MATLAB's inbuilt function `pcg()`, which implements the preconditioned conjugate gradients method (PCG). This code uses the cojugate gradients method (CG) from [IterativeSolvers.jl](https://github.com/JuliaMath/IterativeSolvers.jl). 
Refer to the [implementation details](https://juliamath.github.io/IterativeSolvers.jl/dev/linear_systems/cg/#Implementation-details-1) for a brief discussion of differences between both methods.

Since the CG method from IterativeSolvers.jl allows for preconditioners, most of the options from [Preconditioners.jl](https://github.com/mohamed82008/Preconditioners.jl) are implemented using default parameters.

### New parameters
- `precond`: Method used for preconditioning.
- `cg_tol`: Tolerance used in conjugate gradient method.

### Other differences
- added missing factor `dx` in definitons of `A` and `Aᵀ` for scale `"large"`.

## Citation
Please cite the following paper if you use this code in published work:
> Rick Chartrand, "Numerical differentiation of noisy, nonsmooth data," ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. 