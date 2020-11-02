using Documenter
using TVDifferentiation

makedocs(
    sitename = "TVDifferentiation",
    format = Documenter.HTML(),
    modules = [TVDifferentiation]
)

deploydocs(
    repo = "github.com/adrhill/TVDifferentiation.jl.git",
)
