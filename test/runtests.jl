using SafeTestsets

@safetestset "TVRegDiff" begin
    @safetestset "scale small" begin include("TVRegDiff_small_test.jl") end
    @safetestset "scale large" begin include("TVRegDiff_large_test.jl") end
end
# run tests using `]test NoiseRobustDifferentiation` 