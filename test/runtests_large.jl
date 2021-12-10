using Random
using Statistics
using Test

# Include testing functions
include("test_dimensions.jl")
include("test_symbolic_functions.jl")
include("test_demo_large.jl")

_testset_output_dim("large")
_testset_symbolic_functions(
    "large", ["amg_rs", "amg_sa", "cholesky", "diagonal", "none"], ["abs", "square"]
)
_testset_demo_large("large", ["amg_rs"], ["abs"])

@testset "Broken inputs" begin
    @test_throws ArgumentError tvdiff([0, 1, 2], 1, 0.1; scale="large", precond="bad_input")
    @test_throws ArgumentError tvdiff(
        [0, 1, 2], 1, 0.1; scale="large", diff_kernel="bad_input"
    )
    @test_throws MethodError tvdiff([0, 1, 2], 1, 0.1; scale="l4rge")
    @test_throws DimensionMismatch tvdiff(
        [0, 1, 2], 1, 0.1; u_0=[1, 2, 3, 4], scale="large"
    )
end
