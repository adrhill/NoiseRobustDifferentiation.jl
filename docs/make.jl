using Documenter
using NoiseRobustDifferentiation

makedocs(;
    modules=[NoiseRobustDifferentiation],
    sitename="NoiseRobustDifferentiation.jl",
    authors="Adrian Hill",
    format=Documenter.HTML(; prettyurls=get(ENV, "CI", "false") == "true", assets=String[]),
    pages=["Home" => "index.md", "Examples" => "examples.md"],
)

deploydocs(;
    repo="github.com/adrhill/NoiseRobustDifferentiation.jl.git",
    devbranch="main",
)
