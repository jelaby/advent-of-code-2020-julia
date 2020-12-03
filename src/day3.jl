#=
day3:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-03
=#

import AoC

lines = AoC.lines(3)

height = length(lines)
width = length(lines[1])

@show (height, width)

function countCollisions(rightstride, downstride)::Int
    trees = 0
    for i::Int = 0:height / downstride - 1
        right = 1 + ((i * rightstride) % width)
        down = 1 + (i * downstride)
        trees += lines[down][right] == '#'
    end
    return trees
end

@show countCollisions(3,1)
@show countCollisions(1,1) * countCollisions(3,1) * countCollisions(5,1) * countCollisions(7,1) * countCollisions(1,2)
