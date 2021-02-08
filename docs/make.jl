using Documenter
using NoiseRobustDifferentiation

makedocs(;
    sitename="NoiseRobustDifferentiation.jl",
    format=Documenter.HTML(),
    modules=[NoiseRobustDifferentiation],
    pages=["Home" => "index.md", "Examples" => "examples.md"],
)

deploydocs(;
    repo="github.com/adrhill/NoiseRobustDifferentiation.jl.git",
    devbranch="main",
    branch="gh-pages",
)
