#=
day13:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-13
=#

import AoC

module Part1

    using Test

    findEarliestTimestamp(file) = findEarliestTimestamp(parseFile(file))
    parseFile(name) = open(name) do file
        (parse(Int, readline(file)), parseBuss(readline(file)))
    end
    parseBuss(line) = parse.(Int, filter(item->item!="x", split(line,",")))

    nextBus(time, busses) = sort(busses; by=bus->bus-mod1(time,bus))[1]
    nextBus(name) = nextBus(parseFile(name)...)

    waitTime(time, bus) = (floor(Int, time / bus) + 1) * bus - time

    function busInfo(time, busses)
        bus = nextBus(time, busses)
        wait = waitTime(time, bus)
        return (bus, wait)
    end
    busInfo(name) = busInfo(parseFile(name)...)

    @test parseFile("src/day13-example-1.txt") == (939, [7,13,59,31,19])
    @test busInfo("src/day13-example-1.txt") == (59, 5)

end

@show (*)(Part1.busInfo("src/day13-input.txt")...)

module Part2

    using Test

    abstract type AbstractBus end
    struct AnyBus <: AbstractBus end
    struct Bus <: AbstractBus
        offset
        number
    end

    timeStep(bus::Bus) = bus.number
    timeStep(bus::AnyBus) = 1
    timeStepProduct(busses) = mapreduce(timeStep, *, busses)

    parseBus(offset, number) = number=="x" ? AnyBus() : Bus(offset, parse(Int, number))
    @test parseBus(3, "x") == AnyBus()
    @test parseBus(4, "6") == Bus(4, 6)

    readFile(name) = open(name) do f
        readline(f)
        s = split(readline(f), ",")
        return [parseBus(n-1, s[n]) for n in 1:length(s)]
    end

    competitionAnswer(name::AbstractString) = competitionAnswer(readFile(name))

    function competitionAnswer(times)
        time = 0

        for i in 1:length(times)
            while !isAnswer(time, times[1:i])
                time+=timeStepProduct(times[1:i-1])
            end
        end

        return time
    end

    function isAnswer(t, buses)
        for bus in buses
            if !isAnswerForBus(t, bus)
                return false
            end
        end
        return true
    end

    isAnswerForBus(t, bus::Bus) = (t + bus.offset) % bus.number == 0
    isAnswerForBus(t, bus::AnyBus) = true

    @test competitionAnswer([Bus(0,2), Bus(1,3)]) == 2
    @test competitionAnswer([Bus(0,2), Bus(1,3), Bus(2,5)]) == 8
    @test competitionAnswer([Bus(0,17), AnyBus(), Bus(2,13), Bus(3,19)]) == 3417
    @test competitionAnswer("src/day13-example-1.txt") == 1068781

end

println("Starting...")
@show Part2.competitionAnswer("src/day13-input.txt")