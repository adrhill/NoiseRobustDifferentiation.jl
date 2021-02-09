using Documenter, Literate
using NoiseRobustDifferentiation

## Use Literate.jl to generate docs and notebooks of examples
list_of_examples = ["examples.jl"]
for example in list_of_examples
    Literate.markdown( # markdown for Documenter.jl
        joinpath(@__DIR__, "literate", example),
        joinpath(@__DIR__, "src");
        documenter=true,
    )
    Literate.notebook( # markdown for Documenter.jl
        joinpath(@__DIR__, "literate", example),
        joinpath(@__DIR__, "notebooks"),
    )
end

## Build docs
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
