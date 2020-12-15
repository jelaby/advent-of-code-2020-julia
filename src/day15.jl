#=
day15:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-15
=#

using AoC

module Part1
    using AoC
    using Test




    function nthNumberSpoken(numbers::Array{<:Number}, n, cache=Dict())
        get!(cache, n) do
            if (n ≤ length(numbers))
                return numbers[n]
            end

            turn = Dict()
            for m = 1:n-2
                turn[nthNumberSpoken(numbers,m, cache)] = m
            end
            turnSpoken = get(turn, nthNumberSpoken(numbers, n-1, cache), nothing)
            if isnothing(turnSpoken)
                return 0
            else
                return n - 1 - turnSpoken
            end
        end
    end

    nthNumberSpoken(numbers::AbstractString, n) = nthNumberSpoken(parse.(Int, split(numbers,",")), n)
    nthNumberSpoken(lines::Array{<:AbstractString}, n) = nthNumberSpoken(lines[1], n)

    @test nthNumberSpoken(exampleLines(15,1), 1) == 0
    @test nthNumberSpoken(exampleLines(15,1), 2) == 3
    @test nthNumberSpoken(exampleLines(15,1), 3) == 6
    @test nthNumberSpoken(exampleLines(15,1), 4) == 0
    @test nthNumberSpoken(exampleLines(15,1), 5) == 3
    @test nthNumberSpoken(exampleLines(15,1), 6) == 3
    @test nthNumberSpoken(exampleLines(15,1), 7) == 1
    @test nthNumberSpoken(exampleLines(15,1), 8) == 0
    @test nthNumberSpoken(exampleLines(15,1), 9) == 4
    @test nthNumberSpoken(exampleLines(15,1), 10) == 0

end

@show Part1.nthNumberSpoken(lines(15), 2020)