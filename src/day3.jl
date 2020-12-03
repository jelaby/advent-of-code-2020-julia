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
    right = 1
    for down = 1:downstride:height
        trees += lines[down][right] == '#'
        right = mod1(right + rightstride, width)
    end
    return trees
end

@show countCollisions(3,1)
@show countCollisions(1,1) * countCollisions(3,1) * countCollisions(5,1) * countCollisions(7,1) * countCollisions(1,2)
