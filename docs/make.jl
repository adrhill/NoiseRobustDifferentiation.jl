using Documenter
using TVRegDiff

makedocs(
    sitename = "TVRegDiff",
    format = Documenter.HTML(),
    modules = [TVRegDiff]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
