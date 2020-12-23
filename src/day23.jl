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

    concat(args) = reduce(*, args)

    playgame(cups::AbstractString, rounds) = playgame([cups...], rounds) .|> string |> concat
    playgame(cups::AbstractVector{<:AbstractChar}, rounds) = playgame([parse(Int, String([cup])) for cup in cups], rounds)
    #playgame(cups::AbstractVector{AbstractString}, rounds) = playgame([parse(Int, cup) for cup in cups], rounds)
    playgame(cups, rounds) = playgame!(copy(cups), rounds)
    function playgame!(cups::AbstractVector{Int}, rounds)
        starttime = Dates.now()
        milestone = 1
        current = 1
        for round in 1:rounds
            if round == milestone
                t = Dates.now()
                elapsed = t - starttime
                estimate = elapsed * floor(Int, length(cups)/round)
                println(@sprintf "Round %i (%s of %s)" round Dates.canonicalize(Dates.CompoundPeriod(floor(elapsed, Dates.Second(1)))) Dates.canonicalize(Dates.CompoundPeriod(floor(estimate, Dates.Second(1)))))
                milestone*=2
            end
            current = playround!(cups, current)
        end
        @show :complete
        return [cups[mod1(i + findfirst(i->i==1, cups) ,length(cups))] for i in 1:min(length(cups) - 1, 20)]
    end

    function playround!(cups, current)
        ncups = length(cups)
        currentcup = cups[current]

        ∔(a::Int,b::Int) = mod1(a+b, ncups)

        picked = [cups[mod1(i,ncups)] for i in current+1:current+3]

        destinationcup = mod1(currentcup - 1, ncups)
        while destinationcup ∈ picked
            destinationcup = mod1(destinationcup - 1, ncups)
        end

        rindex = current ∔ 1
        sindex = current ∔ 4

        while cups[sindex] != destinationcup
            cups[rindex] = cups[sindex]
            rindex = rindex ∔ 1
            sindex = sindex ∔ 1
        end

        cups[rindex] = cups[sindex]
        rindex = rindex ∔ 1
        sindex = sindex ∔ 1

        for cup in picked
            cups[rindex] = cup
            rindex = rindex ∔ 1
        end

        return current ∔ 1
    end


    export playgame

    @test playgame("389125467", 10) == "92658374"
    @test playgame("389125467", 100) == "67384529"

    playgame2(cups::AbstractString, ncups, rounds) = playgame2([cups...], ncups, rounds) .|> string |> concat
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
@show reduce(*, playgame2("467528193", 1000000, 2)[1:2])
println("Run:")
@show reduce(*, playgame2("467528193", 1000000, 10000000)[1:2])