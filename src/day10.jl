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

function combinationsUntyped(values, current, target, cache=Dict())
    return get!(cache, current) do
        if isempty(values)
            return 1
        end

        return sum(combinationsUntyped(values[i+1:end], values[i], target, cache)
                for i in 1:min(3,length(values))
                    if current + 3 ≥ values[i])
    end
end
combinationsUntyped(values) = combinationsUntyped(sort(values), 0, maximum(values) + 3)

function combinations(values::Vector{T}, current::T, target::T, cache::Dict{T,T}=Dict{T,T}()) where T
    return get!(cache, current) do
        if isempty(values)
            return 1
        end

        return sum(combinations(values[i+1:end], values[i], target, cache)
                for i in 1:min(3,length(values))
                    if current + 3 ≥ values[i])
    end
end

combinations(values) = combinations(sort(values), 0, maximum(values) + 3)

function combinationsForLoop(values::Vector{T}, current::T, target::T, cache::Dict{T,T}=Dict{T,T}()) where T
    return get!(cache, current) do
        if isempty(values)
            return 1
        end

        total = 0
        for i in 1:min(3,length(values))
            if current + 3 ≥ values[i]
                total += combinationsForLoop(values[i+1:end], values[i], target, cache)
            end
        end

        return total
    end
end

combinationsForLoop(values) = combinationsForLoop(sort(values), 0, maximum(values) + 3)

function combinations2(values)
    values = sort(values);

    previous = [1,0,0]

    for i in 1:length(values)
        combinations = 0

        for b in 1:3
            if values[i-b] + 3 ≥ values[i]
                combinations += previous[b]
            else
                break
            end
        end

        for b in 3:-1:2
            previous[b] = previous[b-1]
        end
        previous[1] = combinations
    end

    return previous[1]
end

function combinations3(values)
    values = sort(values);

    prev1,prev2,prev3 = 1,0,0

    for i in 1:length(values)
        combinations = 0

        value = values[i]
        if values[i-1] + 3 ≥ value
            combinations += prev1

            if values[i-2] + 3 ≥ value
                combinations += prev2

                if values[i-3] + 3 ≥ value
                    combinations += prev3
                end
            end
        end

        prev1,prev2,prev3 = combinations,prev1,prev2
    end

    return prev1
end

implementations = [combinationsUntyped, combinations, combinationsForLoop, combinations2, combinations3]
for c in implementations
@show c
@test c([1,2,3]) == 4
@test c(AoC.exampleInts(10,1)) == 8
@test c(AoC.exampleInts(10,2)) == 19208
end

@time input = AoC.ints(10)
for c in implementations
@show c, c(input)
@time for _ in 1:10000 c(input) end
end