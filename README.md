# NoiseRobustDifferentiation.jl

| **Documentation**                                                               | **Build Status**                          | **Code Coverage**               |
|:-------------------------------------------------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url] | [![Build Status][ci-img]][ci-url]         | [![][codecov-img]][codecov-url] |


Julia reimplementation of *Total Variation Regularized Numerical Differentiation* (TVDiff).

Based on [Rick Chartrand's original Matlab code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) and [Simone Sturniolo's Python reimplementation](https://github.com/stur86/tvregdiff).

## Examples
This package exports a single function `tvdiff`. 

It works on noisy data without suppressing jump discontinuities:
![](https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/paper_small7000.svg)

and also on large datasets:
![](https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/paper_large_all.png)

[More examples can be found in the documentation.](https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/examples/)

## Installation
To install this package and its dependencies, open the Julia REPL and run 
```julia
julia> ]add NoiseRobustDifferentiation
```

## Citation
Please cite the following paper if you use this code in published work:
> Rick Chartrand, "Numerical differentiation of noisy, nonsmooth data," ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. 

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://adrhill.github.io/NoiseRobustDifferentiation.jl/stable/

[docs-latest-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-latest-url]: https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/

[ci-img]: https://github.com/adrhill/NoiseRobustDifferentiation.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/adrhill/NoiseRobustDifferentiation.jl/actions?query=workflow%3ACI

[codecov-img]: https://codecov.io/gh/adrhill/NoiseRobustDifferentiation.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/adrhill/NoiseRobustDifferentiation.jl