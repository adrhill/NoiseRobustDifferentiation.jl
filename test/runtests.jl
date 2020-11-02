using SafeTestsets

@safetestset "Scale small" begin include("scale_small_test.jl") end
@safetestset "Scale large" begin include("scale_large_test.jl") end

# run tests using `]test TVDifferentiation` 