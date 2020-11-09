using NoiseRobustDifferentiation
using Random
using Statistics
using Test

# Include testing functions
include("dimension_test.jl")
include("symbolic_function_test.jl")
include("demo_large_test.jl")

@testset "Dimensions" begin
    _test_output_dim("large")
end

@testset "Broken inputs" begin
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1, scale="large", precond="bad_input")
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1, scale="l4rge")
    @test_throws DimensionMismatch TVRegDiff([0, 1, 2], 1, 0.1, u_0=[1,2,3,4], scale="large")
end

@testset "Preconditioners" begin
    for precond in ["cholesky","diagonal","amg_rs","amg_sa","none"]
        _testset_symbolic_functions(precond, "large")
    end
end

@testset "Demo large" begin
    # Load data
    using CSV, DataFrames
    file = CSV.File("./data/demo_large.csv")
    data_large = DataFrame(file).largescaledata
    
    # Run tests
    for precond in ["cholesky","diagonal","amg_rs","amg_sa","none"]
        _testset_demo_large(data_large, "large", precond)
    end
end