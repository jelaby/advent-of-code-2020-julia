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


    function nthNumberSpoken(numbers::Array{T}, n::T) where T<:Number
        turns = zeros(T, max(n, numbers...) + 1)
        number::T = 0
        previousTurn::T = 0
        numbersLength = length(numbers)
        for i = 1:n ::T
            if i ≤ numbersLength
                number = numbers[i]
            else
                if previousTurn == 0
                    number = 0
                else
                    number = i - 1 - previousTurn
                end
            end

            previousTurn = turns[number+1]
            turns[number+1] = i
        end
        return number
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
@show @time Part1.nthNumberSpoken(lines(15), 30000000)
