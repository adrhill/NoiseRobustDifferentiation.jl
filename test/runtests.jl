using NoiseRobustDifferentiation
using Test

@testset "tvdiff" begin
    @testset "scale=\"small\"" begin
        include("runtests_small.jl")
    end
    @testset "scale=\"large\"" begin
        include("runtests_large.jl")
    end
end
