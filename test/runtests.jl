using SafeTestsets

@safetestset "Test dataset" begin include("test_dataset.jl") end
@safetestset "Test inputs" begin include("test_inputs.jl") end

# run tests using `]test TVRegDiff` 