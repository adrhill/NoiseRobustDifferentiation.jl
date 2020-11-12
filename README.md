# NoiseRobustDifferentiation.jl

| **Documentation**                       | **Build Status**                          | **Code Coverage**               |
|:---------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-latest-img]][docs-latest-url] | [![Build Status][travis-img]][travis-url] | [![][codecov-img]][codecov-url] |


Julia reimplementation of *Total Variation Regularized Numerical Differentiation* (TVRegDiff).

Based on [Rick Chartrand's original Matlab code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) and [Simone Sturniolo's Python reimplementation](https://github.com/stur86/tvregdiff).

## Examples
`TVRegDiff` works on noisy data without suppressing jump discontinuities
![](https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/paper_small7000.svg)

and also works on large datasets
![](https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/paper_large_all.svg)

[More examples can be found in the documentation.](https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/examples/)

## Citation
Please cite the following paper if you use this code in published work:
> Rick Chartrand, "Numerical differentiation of noisy, nonsmooth data," ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. 


[docs-latest-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-latest-url]: https://adrhill.github.io/NoiseRobustDifferentiation.jl/dev/

[travis-img]: https://travis-ci.com/adrhill/NoiseRobustDifferentiation.jl.svg?branch=main
[travis-url]: https://travis-ci.com/github/adrhill/NoiseRobustDifferentiation.jl

[codecov-img]: https://codecov.io/gh/adrhill/NoiseRobustDifferentiation.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/adrhill/NoiseRobustDifferentiation.jl