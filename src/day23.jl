#=
day23:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-23
=#





module Part1

    using Test

    concat(args) = reduce(*, args)

    playgame(cups::AbstractString, rounds) = playgame([cups...], rounds) .|> string |> concat
    playgame(cups::AbstractVector{<:AbstractChar}, rounds) = playgame([parse(Int, String([cup])) for cup in cups], rounds)
    #playgame(cups::AbstractVector{AbstractString}, rounds) = playgame([parse(Int, cup) for cup in cups], rounds)
    function playgame(cups::AbstractVector{Int}, rounds)
        current = 1
        for round in 1:rounds
            @show (cups, current) = playround(cups, current)
        end
        return [cups[mod1(i + findfirst(i->i==1, cups) ,length(cups))] for i in 1:length(cups)-1]
    end

    function playround(cups, current)
        ncups = length(cups)
        result = similar(cups)
        currentcup = cups[current]

        ∔(a,b) = mod1(a+b, ncups)

        picked = [cups[mod1(i,ncups)] for i in current+1:current+3]

        destinationcup = mod1(currentcup - 1, ncups)
        while destinationcup ∈ picked
            destinationcup = mod1(destinationcup - 1, ncups)
        end

        destination = findfirst(cup -> cup == destinationcup, cups)



        result[current] = cups[current]
        rindex = current ∔ 1
        sindex = current ∔ 4

        while cups[sindex] != destinationcup
            result[rindex] = cups[sindex]
            rindex = rindex ∔ 1
            sindex = sindex ∔ 1
        end

        result[rindex] = cups[sindex]
        rindex = rindex ∔ 1
        sindex = sindex ∔ 1

        for cup in picked
            result[rindex] = cup
            rindex = rindex ∔ 1
        end

        while rindex != current
            result[rindex] = cups[sindex]
            rindex = rindex ∔ 1
            sindex = sindex ∔ 1
        end

        return result, current ∔ 1
    end


    export playgame

    @test playgame("389125467", 10) == "92658374"
    @test playgame("389125467", 100) == "67384529"

end

using .Part1

@show playgame("467528193", 100)