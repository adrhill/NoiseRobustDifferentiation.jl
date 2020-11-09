using NoiseRobustDifferentiation
using Random
using Statistics
using Test

using Plots
using LaTeXStrings

# Include testing functions
include("dimension_test.jl")
include("symbolic_function_test.jl")

@testset "Dimensions" begin
    _test_output_dim("small")
end

@testset "Broken inputs" begin
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1, scale="small", precond="bad_input")
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1, scale="sm4ll")
    @test_throws DimensionMismatch TVRegDiff([0, 1, 2], 1, 0.1, u_0=[1,2,3,4,5], scale="small")
end

@testset "Preconditioners" begin
    for precond in ["simple","none"]
        _testset_symbolic_functions(precond, "small")
    end
end