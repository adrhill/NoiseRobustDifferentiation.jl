var documenterSearchIndex = {"docs":
[{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#Simple-example","page":"Examples","title":"Simple example","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"First we generate a small dataset by adding uniform noise to f(x)=x","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"n = 50 \nx = range(-5, 5, length=n)\ndx = x[2]-x[1]\n\nf = abs.(x)\nf_noisy = f + 0.05 * (rand(n) .- 0.5)\n; nothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"and then call TVRegDiff using a regularization parameter of α=0.2 for 10 iterations","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using NoiseRobustDifferentiation\nusing Plots # hide\ninclude(\"plot_example.jl\") # hide\n\nû = TVRegDiff(f_noisy, 10, 0.2, dx=dx, scale=\"small\")\nnothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"We compare the results to the true derivative u(x)=sign(x) and naive finite differences using diff(f) / dx.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"u = sign.(x) # true derivative\nû_diff = diff(f_noisy) / dx  # FDM\n\nappend!(û_diff, NaN) # hide\nplot_example(x, f, f_noisy, u, û_diff, û) # hide\nplot!(legend=:bottomright) # hide\nsavefig(\"abs_small.svg\"); nothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: )","category":"page"},{"location":"examples/#Examples-from-paper","page":"Examples","title":"Examples from paper","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Let's now reconstruct the figures from Rick Chartrand's paper \"Numerical differentiation of noisy, nonsmooth data\". The corresponding datasets can be found under /docs/data.","category":"page"},{"location":"examples/#Small-scale-example","page":"Examples","title":"Small-scale example","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"The small-scale example in figure 1 is a more noisy variant of our first example.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using NoiseRobustDifferentiation\nusing CSV, DataFrames\nusing Plots # hide\n\nfile = CSV.File(\"../data/demo_small.csv\")\ndf = DataFrame(file)\n\nTVRegDiff(df.noisyabsdata, 500, 0.2, scale=\"small\", ε=1e-6, dx=0.01, plot_flag=true)\nsavefig(\"paper_small.svg\"); nothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: )","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Defaults mean that calling","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"u = TVRegDiff(df.noisyabsdata, 500, 0.2 )","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"would have the same results.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"A better result is obtained after 7000 iterations, though differences are minimal.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"TVRegDiff(df.noisyabsdata, 7000, 0.2, scale=\"small\", ε=1e-6, dx=0.01, plot_flag=true)\nsavefig(\"paper_small7000.svg\"); nothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: )","category":"page"},{"location":"examples/#Large-scale-example","page":"Examples","title":"Large-scale example","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"First we use parameters that lead to a very smooth result: notably a high regularization parameter α=1e-1. This should resemble figure 9.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using NoiseRobustDifferentiation\nusing CSV, DataFrames\nusing Plots # hide\n\nfile = CSV.File(\"../data/demo_large.csv\")\ndf = DataFrame(file)\n\nTVRegDiff(df.largescaledata, 40, 1e-1, scale=\"large\", precond=\"diagonal\", ε=1e-8, plot_flag=true)\nsavefig(\"paper_large_smooth.svg\"); nothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: )","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"A less smooth example – similar to figure 8 – can be obtained by lowering the regularization parameter to α=1e-3.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"TVRegDiff(df.largescaledata, 40, 1e-3, scale=\"large\", precond=\"diagonal\", ε=1e-6, plot_flag=true)\nsavefig(\"paper_large_jump.svg\"); nothing # hide","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: )","category":"page"},{"location":"#NoiseRobustDifferentiation.jl","page":"Home","title":"NoiseRobustDifferentiation.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Julia reimplementation of Total Variation Regularized Numerical Differentiation (TVDiff) based on Rick Chartrand's original MATLAB code with small changes and tests from Simone Sturniolo's Python reimplementation.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"index.md\", \"examples.md\"]","category":"page"},{"location":"#Functions","page":"Home","title":"Functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"TVRegDiff(data::Array{<:Real,1}, iter::Int, α::Real; kwargs...)","category":"page"},{"location":"#NoiseRobustDifferentiation.TVRegDiff-Tuple{Array{var\"#s11\",1} where var\"#s11\"<:Real,Int64,Real}","page":"Home","title":"NoiseRobustDifferentiation.TVRegDiff","text":"TVRegDiff(data::Array{<:Real,1}, iter::Int, α::Real; kwargs...)\n\nArguments\n\ndata::Array{<:Real,1}:       Vector of data to be differentiated.\niter::Int:     Number of iterations to run the main loop.  A stopping   condition based on the norm of the gradient vector g   below would be an easy modification.  No default value.\nα::Real:       Regularization parameter.  This is the main parameter   to fiddle with.  Start by varying by orders of   magnitude until reasonable results are obtained.  A   value to the nearest power of 10 is usally adequate.   No default value.  Higher values increase   regularization strenght and improve conditioning.\n\nKeywords\n\nu_0::Array{<:Real,1}:             Initialization of the iteration.  Default value is the   naive derivative (without scaling), of appropriate   length (this being different for the two methods).   Although the solution is theoretically independent of   the intialization, a poor choice can exacerbate   conditioning issues when the linear system is solved.\nscale::String:   Scale of dataset, \"large\" or \"small\" (case insensitive).     Default is \"small\" .  \"small\"  has somewhat better    boundary behavior, but becomes unwieldly for very large datasets.     \"large\" has simpler numerics but   is more efficient for large-scale problems.  \"large\" is   more readily modified for higher-order derivatives,   since the implicit differentiation matrix is square.\nε::Real:       Parameter for avoiding division by zero.  Default value   is 1e-6.  Results should not be very sensitive to the   value.  Larger values improve conditioning and   therefore speed, while smaller values give more   accurate results with sharper jumps.\ndx::Real:      Grid spacing, used in the definition of the derivative   operators.  Default is 1 / length(data).\nprecond::String:     Select the preconditioner for the conjugate gradient method.   Default is 'none'.\nscale = \"small\":   While in principle precond=\"simple\" should speed things up,    sometimes the preconditioner can cause convergence problems instead,   and should be left to \"none\".\nscale = \"large\":   The improved preconditioners are one of the main features of the    algorithm, therefore using the default \"none\" is discouraged.   Currently, \"diagonal\",\"amg_rs\",\"amg_sa\", \"cholesky\"   are available.\ncg_tol::Real:         Tolerance used in conjugate gradient method. Default is 1e-4.\ncgmaxit::Int:   Maximum number of iterations to use in conjugate gradient optimisation.    Default is 100.\nplot_flag::Bool:       Flag whether to display plot at each iteration. Default is false.     Useful, but adds significant running time.\ndiag_flag::Bool:       Flag whether to display diagnostics at each iteration. Default is false.     Useful for diagnosing preconditioning problems. When tolerance is not met,   an early iterate being best is more worrying than a large relative residual.\n\nOutput\n\nu:             Estimate of the regularized derivative of data with    length(u) = length(data).\n\n\n\n\n\n","category":"method"},{"location":"#Differences-to-MATLAB-Code","page":"Home","title":"Differences to MATLAB Code","text":"","category":"section"},{"location":"#Conjugate-gradient-method","page":"Home","title":"Conjugate gradient method","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The original code uses MATLAB's inbuilt function pcg(), which implements the preconditioned conjugate gradients method (PCG). This code uses the cojugate gradients method (CG) from IterativeSolvers.jl.  Refer to the implementation details for a brief discussion of differences between both methods.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Since the CG method from IterativeSolvers.jl allows for preconditioners, most of the options from Preconditioners.jl are implemented using default parameters.","category":"page"},{"location":"#New-parameters","page":"Home","title":"New parameters","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"precond: Method used for preconditioning.\ncg_tol: Tolerance used in conjugate gradient method.","category":"page"},{"location":"#Other-differences","page":"Home","title":"Other differences","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"added missing factor dx in definitons of A and Aᵀ for scale \"large\".","category":"page"},{"location":"#Citation","page":"Home","title":"Citation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Please cite the following paper if you use this code in published work:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Rick Chartrand, \"Numerical differentiation of noisy, nonsmooth data,\" ISRN Applied Mathematics, Vol. 2011, Article ID 164564, 2011. ","category":"page"}]
}