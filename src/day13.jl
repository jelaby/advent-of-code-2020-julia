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

    nextBus(time, busses) = sort(busses; by=bus->bus-mod1(time,bus))[1]
    nextBus(name) = nextBus(parseFile(name)...)

    waitTime(time, bus) = (floor(Int, time / bus) + 1) * bus - time

    function busInfo(time, busses)
        bus = nextBus(time, busses)
        wait = waitTime(time, bus)
        return (bus, wait)
    end
    busInfo(name) = busInfo(parseFile(name)...)

end
@test Part1.parseFile("src/day13-example-1.txt") == (939, [7,13,59,31,19])
@test Part1.busInfo("src/day13-example-1.txt") == (59, 5)

@show (*)(Part1.busInfo("src/day13-input.txt")...)

module Part2

    abstract type AbstractTime end
    struct MissingTime <: AbstractTime end
    struct Time <: AbstractTime
        offset
        time
    end
    max(a::Time, b::Time) = a.time > b.time ? a : b
    max(a::MissingTime, b::Time) = b
    max(a::Time, b::MissingTime) = a
    max(a::MissingTime, b::MissingTime) = a

    isPresent(::Time) = true
    isPresent(::MissingTime) = false

    parseTime(offset, t)::AbstractTime = t=="x" ? MissingTime() : Time(offset, parse(Int, t))

    readFile(name) = open(name) do f
        readline(f)
        s = split(readline(f), ",")
        return [parseTime(n-1, s[n]) for n in 1:length(s)]
    end

    competitionAnswer(name::AbstractString; kwargs...) = competitionAnswer(readFile(name); kwargs...)

    product(args) = reduce(*, args)
    timeStep(time::Time) = time.time
    timeStep(time::MissingTime) = 1
    timeStepProduct(times) = mapreduce(timeStep, *, times)

    function competitionAnswer(times::Array; hint=0)

        time = times[1].time

        for i in 2:length(times)
            while !isAnswer(time, times[1:i])
                time+=timeStepProduct(times[1:i-1])
            end
        end

        return time
    end

    function isAnswer(t, times)
        for time in times
            if !arrivesAt(time, t)
                return false
            end
        end
        return true
    end

    arrivesAt(t, time::Time) = (t + time.offset) % time.time == 0
    arrivesAt(t, time::MissingTime) = true

    using Test

@test Part2.parseTime(3, "x") == Part2.MissingTime()
@test Part2.parseTime(4, "6") == Part2.Time(4, 6)
@test Part2.competitionAnswer([Time(0,2), Time(1,3)]) == 2
@test Part2.competitionAnswer([Time(0,2), Time(1,3), Time(2,5)]) == 8
@test Part2.competitionAnswer([Time(0,17), MissingTime(), Time(2,13), Time(3,19)]) == 3417
@test Part2.competitionAnswer("src/day13-example-1.txt"; hint=1000000) == 1068781

end


println("Starting...")
@show Part2.competitionAnswer("src/day13-input.txt"; hint=100000000000000)