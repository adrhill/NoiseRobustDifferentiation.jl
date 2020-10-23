using TVRegDiff
using Test

@testset "TVRegDiff.jl" begin
    include("../examples/demo_small.jl")
    include("../examples/demo_large.jl")
end

