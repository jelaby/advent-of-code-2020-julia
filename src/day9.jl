#=
day9:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-09
=#

import AoC
using Test


function findNumberNotFromPreamble(message; preambleLength=25)
    for i in (preambleLength+1):length(message)
        previous25 = message[(i-preambleLength):i-1]
        if message[i] ∉ (a + b for a in previous25, b in previous25)
            return message[i]
        end
    end
end

function findWeaknessBlock(message, target)
    for i in 1:length(message)
        for j in i+1:length(message)
            if sum(message[i:j]) == target
                return message[i:j]
            end
        end
    end
    return nothing
end

@test findWeaknessBlock(parse.(Int, AoC.exampleLines(9,1)), 127) == [15,25,47,40]

function findWeakness(message; preambleLength=25)
    target = findNumberNotFromPreamble(message; preambleLength=preambleLength)
    block = findWeaknessBlock(message, target)
    return minimum(block) + maximum(block)
end

@test findNumberNotFromPreamble(AoC.exampleInts(9,1); preambleLength=5) == 127
@time @show findNumberNotFromPreamble(AoC.ints(9))

@test findWeakness(AoC.exampleInts(9,1); preambleLength=5) == 62
@time @show findWeakness(AoC.ints(9))
