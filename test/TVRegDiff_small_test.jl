using NoiseRobustDifferentiation
using Random
using Statistics
using Test

function _eval_small_noisy(f, u ; iter=1, precond_flag=false, rng_seed=0)
    n = 50 
    x = range(-5, 5, length=n)
    dx = x[2] - x[1]
    
    # add noise to data
    rng = MersenneTwister(rng_seed)
    data = f.(x) + (rand(rng, n) .- 0.5) * 0.05

    # use TVRegDiff
    û = TVRegDiff(data, iter, 0.2, dx=dx, scale="small",  
            plot_flag=false, diag_flag=false,
            precond_flag=precond_flag)

    return rmse = √(mean(abs2.(û - u.(x))))
end

@testset "dimensions" begin
    n = 20
    data = collect(range(-1, 1, length=n))
    û = TVRegDiff(data, 1, 0.2, scale="small",  
            plot_flag=false, diag_flag=false)

    @test length(û) == n # output should equal input dim
end

for pf in [true, false]
    @testset "precondflag=$(pf)" begin
        @testset "abs" begin
            @test _eval_small_noisy(abs, sign, precond_flag=pf, iter=1) < 0.3
            @test _eval_small_noisy(abs, sign, precond_flag=pf, iter=10) < 0.25
        end
        @testset "sigmoid" begin
            σ(x) = exp(x) / (1 + exp(x))
            dσdx(x) = σ(x) - exp(2 * x) / (1 + exp(x)^2)

            @test _eval_small_noisy(σ, dσdx, precond_flag=pf, iter=1) < 0.3
            @test _eval_small_noisy(σ, dσdx, precond_flag=pf, iter=10) < 0.2  
        end
        @testset "sin" begin
            @test _eval_small_noisy(sin, cos, precond_flag=pf, iter=1) < 0.3
            @test _eval_small_noisy(sin, cos, precond_flag=pf, iter=10) < 0.25
        end
    end
end