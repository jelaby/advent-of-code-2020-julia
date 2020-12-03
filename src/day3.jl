#=
day3:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-03
=#

import AoC
toBoolean(c) = c == '#'
toBooleans(s) = toBoolean.(s)

lines = AoC.lines(3)

height = length(lines)
width = length(lines[1])

@show (height, width)

function countCollisions(right::Int,down)::Int
    trees = 0
    for i::Int = 1:height/down
        @show ((i-1) * down + 1,(((i-1) * right) % width) + 1)
        trees += lines[((i-1) * down) + 1][(((i-1) * right) % width) + 1] == '#'
    end
    return trees
end

@show countCollisions(3,1)
@show countCollisions(1,1) * countCollisions(3,1) * countCollisions(5,1) * countCollisions(7,1) * countCollisions(1,2)
