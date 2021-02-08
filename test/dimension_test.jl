function _testset_output_dim(scale)
    n = 20
    data = collect(range(-1, 1, length = n))
    û = TVRegDiff(data, 1, 0.2; scale = scale)

    @testset "Dimensions" begin
        @test length(û) == n # output dim should equal input dim
    end
end
