function _eval_function(f, u, scale, precond, diff_kernel; n=50, iter=1, α=0.1, rng_seed=0)
    x = range(-5, 5, length=n)
    dx = x[2] - x[1]
    
    # add noise to data
    rng = MersenneTwister(rng_seed)
    data = f.(x) + 0.05 * (rand(rng, n) .- 0.5)
    
    # use TVRegDiff
    û = TVRegDiff(data, iter, α, dx=dx, scale=scale, precond=precond, diff_kernel=diff_kernel) 

    return rmse = √(mean(abs2.(û - u.(x))))
end

function _test_symbolic_functions(scale, precond, diff_kernel)
    @testset "abs" begin
        @test _eval_function(abs, sign, scale, precond, diff_kernel, n=50, iter=2) < 0.3
        @test _eval_function(abs, sign, scale, precond, diff_kernel, n=50, iter=10) < 0.26
        @test _eval_function(abs, sign, scale, precond, diff_kernel, n=1000, iter=2) < 0.3
        @test _eval_function(abs, sign, scale, precond, diff_kernel, n=1000, iter=10) < 0.14
    end
    @testset "sigmoid" begin
        σ(x) = exp(x) / (1 + exp(x))
        dσdx(x) = σ(x) - exp(2 * x) / (1 + exp(x)^2)

        @test _eval_function(σ, dσdx, scale, precond, diff_kernel, n=50, iter=2) < 0.3
        @test _eval_function(σ, dσdx, scale, precond, diff_kernel, n=50, iter=10) < 0.17
        @test _eval_function(σ, dσdx, scale, precond, diff_kernel, n=1000, iter=2) < 0.3
        @test _eval_function(σ, dσdx, scale, precond, diff_kernel, n=1000, iter=10) < 0.17
    end
    @testset "sin" begin
        α=0.1 # use lower value for alpha
        @test _eval_function(sin, cos, scale, precond, diff_kernel, α=α, n=50, iter=2) < 0.3
        @test _eval_function(sin, cos, scale, precond, diff_kernel, α=α, n=50, iter=10) < 0.27
        @test _eval_function(sin, cos, scale, precond, diff_kernel, α=α, n=1000, iter=2) < 0.3
        @test _eval_function(sin, cos, scale, precond, diff_kernel, α=α, n=1000, iter=10) < 0.19
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