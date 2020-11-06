using NoiseRobustDifferentiation
using Random
using Statistics
using Test

function _eval_small_noisy(f, u ; iter=1, precond="simple", rng_seed=0)
    n = 50 
    x = range(-5, 5, length=n)
    dx = x[2] - x[1]
    
    # add noise to data
    rng = MersenneTwister(rng_seed)
    data = f.(x) + (rand(rng, n) .- 0.5) * 0.05

    # use TVRegDiff
    û = TVRegDiff(data, iter, 0.2, dx=dx, scale="small", precond=precond)

    return rmse = √(mean(abs2.(û - u.(x))))
end

@testset "dimensions" begin
    n = 20
    data = collect(range(-1, 1, length=n))
    û = TVRegDiff(data, 1, 0.2, scale="small")

    @test length(û) == n # output should equal input dim
end

@testset "Broken inputs" begin
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1, scale="small", precond="bad_input")
    @test_throws ArgumentError TVRegDiff([0, 1, 2], 1, 0.1, scale="sm4ll")
    @test_throws DimensionMismatch TVRegDiff([0, 1, 2], 1, 0.1, u_0=[1,2,3,4,5], scale="small")
end

@testset "preconditioners" begin
    for precond in ["simple","none"]
        @testset "$precond" begin 
            @testset "abs" begin
                @test _eval_small_noisy(abs, sign, precond=precond, iter=1) < 0.3
                @test _eval_small_noisy(abs, sign, precond=precond, iter=10) < 0.25
            end
            @testset "sigmoid" begin
                σ(x) = exp(x) / (1 + exp(x))
                dσdx(x) = σ(x) - exp(2 * x) / (1 + exp(x)^2)

                @test _eval_small_noisy(σ, dσdx, precond=precond, iter=1) < 0.3
                @test _eval_small_noisy(σ, dσdx, precond=precond, iter=10) < 0.2  
            end
            @testset "sin" begin
                @test _eval_small_noisy(sin, cos, precond=precond, iter=1) < 0.3
                @test _eval_small_noisy(sin, cos, precond=precond, iter=10) < 0.25
            end
        end
    end
end