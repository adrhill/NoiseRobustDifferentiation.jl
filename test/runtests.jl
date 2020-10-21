using SafeTestsets

@safetestset "Test dataset" begin include("test_dataset.jl") end

# run tests using `]test TVRegDiff` 