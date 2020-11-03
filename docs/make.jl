using Documenter
using NoiseRobustDifferentiation

makedocs(
    sitename = "NoiseRobustDifferentiation",
    format = Documenter.HTML(),
    modules = [NoiseRobustDifferentiation]
)

deploydocs(
    repo = "github.com/adrhill/NoiseRobustDifferentiation.jl.git",
    devbranch ="main",
    branch = "gh-pages",
)
