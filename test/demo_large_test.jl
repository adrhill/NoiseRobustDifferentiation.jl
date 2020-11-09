function _testset_demo_large(data_demo_large, scale, precond)
    #= Perform primitive check for smoothness of derivative.
    If derivative û is smooth, elements of diff(û) should be small.
    Use parameter-sets from MATLAB examples. =#

    @testset "$precond" begin
        @test sum(abs.(diff(TVRegDiff(data_demo_large, 40, 1e-1, ε=1e-8, scale=scale, precond=precond)))) < 1e3
        @test sum(abs.(diff(TVRegDiff(data_demo_large, 40, 1e-3, ε=1e-6, scale=scale, precond=precond)))) < 1e3  
    end
end