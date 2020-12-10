#=
day10:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-10
=#

using Test, StatsBase
import AoC


differenceCount(values) = countmap(accumulate((acc,v) -> (push!(acc[1], v - acc[2]), v),  sort(values); init=([3],0))[end][1])

@test differenceCount(AoC.exampleInts(10,2))[1] == 22
@test differenceCount(AoC.exampleInts(10,2))[3] == 10

function part1(values)
    differences = differenceCount(values)
    return differences[1] * differences[3]
end

@show part1(AoC.ints(10))

function combinations(values, current, target, cache=Dict())
    return get!(cache, current) do
        if isempty(values)
            return 1
        end

        return sum(combinations(values[i+1:end], values[i], target, cache)
                for i in 1:min(3,length(values))
                    if current + 3 ≥ values[i])
    end
end

function combinations(values)
    values = sort(values)
    target = maximum(values) + 3
    return combinations(values, 0, target)
end

@test combinations([1,2,3]) == 4
@test combinations(AoC.exampleInts(10,1)) == 8
@test combinations(AoC.exampleInts(10,2)) == 19208

@show @time combinations(AoC.ints(10))