# TVDifferentiation.jl


Documentation for TVDifferentiation.jl: a Julia reimplementation of *Total Variation Regularized Numerical Differentiation* (TVDiff) based on [Rick Chartrand's original Matlab code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) with tests from [Simone Sturniolo's Python reimplementation](https://github.com/stur86/tvregdiff).

```@contents
```

## Functions
```@docs
TVDiff(data::Array{<:Real,1}, iter::Int, α::Real; kwargs...)
```

## Citation
Please cite the following paper if you use this code in published work:
> Rick Chartrand, "Numerical differentiation of noisy, nonsmooth data," ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. 

## Index 

```@index
```