using RankedChoice
using Test
using Random

@testset "RankedChoice.jl" begin
    @testset "Simple" begin
        poll = Poll("Favorite Color", ["Red", "Green", "Blue", "Yellow", "Orange", "Purple"])
        for i in 1:10^6
            vote!(poll, randperm(6))
        end
    end
end
