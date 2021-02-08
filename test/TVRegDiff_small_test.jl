using NoiseRobustDifferentiation
using Random
using Statistics
using Test

# Include testing functions
include("dimension_test.jl")
include("symbolic_function_test.jl")
include("demo_large_test.jl")

_testset_output_dim("small")
_testset_symbolic_functions("small", ["simple", "none"], ["abs", "square"])

@testset "Broken inputs" begin
    @test_throws ArgumentError TVRegDiff(
        [0, 1, 2], 1, 0.1; scale="small", precond="bad_input"
    )
    @test_throws ArgumentError TVRegDiff(
        [0, 1, 2], 1, 0.1; scale="small", diff_kernel="bad_input"
    )
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1; scale="sm4ll")
    @test_throws DimensionMismatch TVRegDiff(
        [0, 1, 2], 1, 0.1; u_0=[1, 2, 3, 4, 5], scale="small"
    )
end
