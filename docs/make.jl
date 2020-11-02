using Documenter
using TVDifferentiation

makedocs(
    sitename = "TVDifferentiation",
    format = Documenter.HTML(),
    modules = [TVDifferentiation]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
