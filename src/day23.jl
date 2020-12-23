#=
day23:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-23
=#





module Part1

    using Test
    using Printf
    import Dates

    mutable struct Cup
        value::Int
        next::Union{Cup, Nothing}
    end
    Cup(value) = Cup(value, nothing)

    concat(args) = reduce(*, args)

    playgame(cups::AbstractString, rounds) = playgame([cups...], rounds) .|> string |> concat
    playgame(cups::AbstractVector{<:AbstractChar}, rounds) = playgame([parse(Int, String([cup])) for cup in cups], rounds)
    #playgame(cups::AbstractVector{AbstractString}, rounds) = playgame([parse(Int, cup) for cup in cups], rounds)
    playgame(cups, rounds) = playgame!(copy(cups), rounds)
    function playgame!(cups::AbstractVector{Int}, rounds)
        starttime = Dates.now()
        milestone = 1

        firstCup = Cup(cups[1])
        currentCup = firstCup
        cupOne = nothing
        for i in 2:length(cups)
            nextCup = Cup(cups[i])
            currentCup.next = nextCup
            currentCup = nextCup
            if cups[i] == 1
                cupOne = nextCup
            end
        end
        currentCup.next = firstCup

        cupRefs = similar(cups, Cup)
        currentCup = firstCup
        for i in 1:length(cups)
            cupRefs[currentCup.value] = currentCup
            currentCup = currentCup.next
        end

        current = firstCup
        ncups = length(cups)

        for round in 1:rounds
            if round == milestone
                t = Dates.now()
                elapsed = t - starttime
                estimate = elapsed * floor(Int, length(cups)/round)
                println(@sprintf "Round %i (%s of %s)" round Dates.canonicalize(Dates.CompoundPeriod(floor(elapsed, Dates.Second(1)))) Dates.canonicalize(Dates.CompoundPeriod(floor(estimate, Dates.Second(1)))))
                milestone*=2
                @time current = playround!(current, ncups, cupRefs)
            else
                current = playround!(current, ncups, cupRefs)
            end
        end
        result = similar(cups, min(length(cups) - 1, 20))
        cup = cupOne.next
        for i in CartesianIndices(result)
            result[i] = cup.value
            cup = cup.next
        end
        return result
    end

    function playround!(current::Cup, ncups::Int, cupRefs::Vector{Cup}) :: Cup
        picked = [current.next.value, current.next.next.value, current.next.next.next.value]
        firstPicked = current.next

        nextCup = current.next.next.next.next

        destinationcup = mod1(current.value - 1, ncups)
        while destinationcup ∈ picked
            destinationcup = mod1(destinationcup - 1, ncups)
        end

        current.next = nextCup

        nextCup = cupRefs[destinationcup]

        afterCup = nextCup.next
        nextCup.next = firstPicked
        firstPicked.next.next.next = afterCup

        return current.next
    end


    export playgame

    @test playgame("389125467", 10) == "92658374"
    @test playgame("389125467", 100) == "67384529"

    playgame2(cups::AbstractString, ncups, rounds) = playgame2([cups...], ncups, rounds)
    playgame2(cups::AbstractVector{<:AbstractChar}, ncups, rounds) = playgame2([parse(Int, String([cup])) for cup in cups], ncups, rounds)
    function playgame2(numbers, ncups, rounds)
        cups = similar(numbers, ncups)
        for i = 1:length(numbers)
            cups[i] = numbers[i]
        end
        for i = length(numbers)+1:ncups
            cups[i] = i
        end
        return playgame!(cups, rounds)
    end

    export playgame2

end

using .Part1

@show playgame("467528193", 100)
println("Test:")
@show reduce(*, @show playgame2("467528193", 1000000, 2)[1:2])
println("Run:")
@show reduce(*, playgame2("467528193", 1000000, 10000000)[1:2])