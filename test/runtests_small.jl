using Random
using Statistics
using Test

# Include testing functions
include("test_dimensions.jl")
include("test_symbolic_functions.jl")
include("test_demo_large.jl")

_testset_output_dim("small")
_testset_symbolic_functions("small", ["simple", "none"], ["abs", "square"])

@testset "Broken inputs" begin
    @test_throws ArgumentError tvdiff([0, 1, 2], 1, 0.1; scale="small", precond="bad_input")
    @test_throws ArgumentError tvdiff(
        [0, 1, 2], 1, 0.1; scale="small", diff_kernel="bad_input"
    )
    @test_throws MethodError tvdiff([0, 1, 2], 1, 0.1; scale="sm4ll")
    @test_throws DimensionMismatch tvdiff(
        [0, 1, 2], 1, 0.1; u_0=[1, 2, 3, 4, 5], scale="small"
    )
end
