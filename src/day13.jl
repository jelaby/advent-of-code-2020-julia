#=
day13:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-13
=#

import AoC
using Test


module Part1

    findEarliestTimestamp(file) = findEarliestTimestamp(parseFile(file))
    parseFile(name) = open(name) do file
        (parse(Int, readline(file)), parseTimes(readline(file)))
    end
    parseTimes(line) = parse.(Int, filter(item->item!="x", split(line,",")))

    nextBus(time, busses) = sort(busses; by=bus->bus-time%bus)[1]
    nextBus(name) = nextBus(parseFile(name)...)

end
@test Part1.parseFile("src/day13-example-1.txt") == (939, [7,13,59,31,19])
@test Part1.nextBus("src/day13-example-1.txt") == 59

@show Part1.nextBus("src/day13-input.txt")