using NoiseRobustDifferentiation
using Random
using Statistics
using Test

using Plots
using LaTeXStrings

function _eval_large_noisy(f, u; iter=1, precond="amg_rs", rng_seed=0)
    n = 1000
    x = range(-5, 5, length=n)
    dx = x[2] - x[1]
    
    # add noise to data
    rng = MersenneTwister(rng_seed)
    data = f.(x) + 0.05 * (rand(rng, n) .- 0.5)
    
    # use TVRegDiff
    û = TVRegDiff(data, iter, 0.1, dx=dx, scale="large", precond=precond) 

    return rmse = √(mean(abs2.(û - u.(x))))
end

@testset "dimensions" begin
    n = 20
    data = collect(range(-1, 1, length=n))
    û = TVRegDiff(data, 1, 0.2, scale="large")

    @test length(û) == n # output dim should equal input dim
end

@testset "preconditioners" begin
    for precond in ["cholesky","diagonal","amg_rs","amg_sa","none"]
        @testset "$precond" begin
            @testset "abs" begin
                @test _eval_large_noisy(abs, sign, precond=precond, iter=2) < 0.3
                @test _eval_large_noisy(abs, sign, precond=precond, iter=10) < 0.2
            end
            @testset "sigmoid" begin
                σ(x) = exp(x) / (1 + exp(x))
                dσdx(x) = σ(x) - exp(2 * x) / (1 + exp(x)^2)

                @test _eval_large_noisy(σ, dσdx, precond=precond, iter=2) < 0.3
                @test _eval_large_noisy(σ, dσdx, precond=precond, iter=10) < 0.2   
            end
            @testset "sin" begin
                @test _eval_large_noisy(sin, cos, precond=precond, iter=2) < 0.3
                @test _eval_large_noisy(sin, cos, precond=precond, iter=10) < 0.2
            end     
        end
    end
end