using NoiseRobustDifferentiation
using Random
using Statistics
using Test

function _eval_noisy(f, u; iter=1, rng_seed=0)
    n = 50 
    x = range(-5, 5, length=n)
    
    # add noise to data
    rng = MersenneTwister(rng_seed)
    data = f.(x) + (rand(rng, n) .- 0.5) * 0.05

    # use TVRegDiff
    û = TVRegDiff(data, iter, 0.2, scale="small",  
            plot_flag=true, diag_flag=false)

    return rmse = √(mean(abs2.(û - u.(x))))
end

@testset "dimensions" begin
    n = 20
    data = collect(range(-1, 1, length=n))
    û = TVRegDiff(data, 1, 0.2, scale="small",  
            plot_flag=false, diag_flag=false)

    @test length(û) == n # output dim equals input dim
end

@testset "symbolic functions" begin
    @testset "abs" begin
        @test _eval_noisy(abs, sign) < 0.3
        @test _eval_noisy(abs, sign, iter=10) < 0.2
    end
    @testset "sigmoid" begin
        σ(x) = exp(x)/(1+exp(x))
        dσdx(x) = σ(x) - exp(2*x)/(1+exp(x)^2)

        @test _eval_noisy(σ, dσdx) < 0.3
        @test _eval_noisy(σ, dσdx, iter=10) < 0.2    
    end
    @testset "sin" begin
        @test _eval_noisy(sin, cos) < 0.3
        @test _eval_noisy(sin, cos, iter=10) < 0.2
    end
end