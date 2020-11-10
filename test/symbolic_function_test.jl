function _eval_function(f, u, precond, scale; n=50, iter=1, α=0.1, rng_seed=0)
    x = range(-5, 5, length=n)
    dx = x[2] - x[1]
    
    # add noise to data
    rng = MersenneTwister(rng_seed)
    data = f.(x) + 0.05 * (rand(rng, n) .- 0.5)
    
    # use TVRegDiff
    û = TVRegDiff(data, iter, α, dx=dx, scale=scale, precond=precond) 

    return rmse = √(mean(abs2.(û - u.(x))))
end

function _test_symbolic_functions(scale, precond, diff_kernel)
    @testset "abs" begin
        @test _eval_function(abs, sign, precond, scale, n=50, iter=2) < 0.3
        @test _eval_function(abs, sign, precond, scale, n=50, iter=10) < 0.26
        @test _eval_function(abs, sign, precond, scale, n=1000, iter=2) < 0.3
        @test _eval_function(abs, sign, precond, scale, n=1000, iter=10) < 0.07
    end
    @testset "sigmoid" begin
        σ(x) = exp(x) / (1 + exp(x))
        dσdx(x) = σ(x) - exp(2 * x) / (1 + exp(x)^2)

        @test _eval_function(σ, dσdx, precond, scale, n=50, iter=2) < 0.3
        @test _eval_function(σ, dσdx, precond, scale, n=50, iter=10) < 0.16
        @test _eval_function(σ, dσdx, precond, scale, n=1000, iter=2) < 0.3
        @test _eval_function(σ, dσdx, precond, scale, n=1000, iter=10) < 0.16
    end
    @testset "sin" begin
        α=0.1 # use lower value for alpha
        @test _eval_function(sin, cos, precond, scale, α=α, n=50, iter=2) < 0.3
        @test _eval_function(sin, cos, precond, scale, α=α, n=50, iter=10) < 0.27
        @test _eval_function(sin, cos, precond, scale, α=α, n=1000, iter=2) < 0.3
        @test _eval_function(sin, cos, precond, scale, α=α, n=1000, iter=10) < 0.19
    end   
end

function _testset_symbolic_functions(scale, preconds, diff_kernels)
    @testset "Symbolic fcs" begin 
        for precond in preconds 
            @testset "$precond" begin
                for diff_kernel in diff_kernels
                    @testset "$diff_kernel" begin
                        _test_symbolic_functions(scale, precond, diff_kernel)
                    end
                end
            end
        end
    end
end