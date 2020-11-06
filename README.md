# NoiseRobustDifferentiation.jl

| **Documentation**                       | **Build Status**                          | **Code Coverage**                                                  |
|:---------------------------------------:|:-----------------------------------------:|:------------------------------------------------------------------:|
| [![][docs-latest-img]][docs-latest-url] | [![Build Status][travis-img]][travis-url] | [![][coveralls-img]][coveralls-url][![][codecov-img]][codecov-url] |


Julia reimplementation of *Total Variation Regularized Numerical Differentiation* (TVDiff) based on [Rick Chartrand's original Matlab code](https://sites.google.com/site/dnartrahckcir/home/tvdiff-code) with tests from [Simone Sturniolo's Python reimplementation](https://github.com/stur86/tvregdiff).

## Citation
Please cite the following paper if you use this code in published work:
> Rick Chartrand, "Numerical differentiation of noisy, nonsmooth data," ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. 


[docs-latest-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-latest-url]: https://juliaphysics.github.io/Measurements.jl/dev/

[travis-img]: https://travis-ci.com/adrhill/NoiseRobustDifferentiation.jl.svg?branch=main
[travis-url]: https://travis-ci.com/github/adrhill/NoiseRobustDifferentiation.jl

[coveralls-img]: https://coveralls.io/repos/github/adrhill/NoiseRobustDifferentiation.jl/badge.svg?branch=main
[coveralls-url]: https://coveralls.io/github/adrhill/NoiseRobustDifferentiation.jl?branch=main

[codecov-img]: https://codecov.io/gh/adrhill/NoiseRobustDifferentiation.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/adrhill/NoiseRobustDifferentiation.jl