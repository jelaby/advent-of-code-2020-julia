#=
day22:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-22
=#

module Part1

    using Test, AoC

    function parseinput(lines)
        if lines[end] != ""
            lines = [lines..., ""]
        end

        hands = []
        hand = []

        for line in lines
            if match(r"Player (\d+):", line) != nothing
                # nothing
            elseif line == ""
                push!(hands, hand)
                hand = []
            else
                push!(hand, parse(Int, line))
            end
        end

        return hands
    end

    function playround!(hands)
        @show cards = popfirst!.(hands)

        @show best = findmax(cards)[2]

        push!(hands[best], reverse(sort(cards))...)

        return hands
    end
    @test playround!([[9,2,6,3,1], [5,8,4,7,10]]) == [[2,6,3,1,9,5],[8,4,7,10]]

    function playgame!(hands)
        while count(h->!isempty(h), hands) != 1
            playround!(hands)
        end
        return hands
    end

    function winningscore(hands)
        findmax(hands .|> length)[2] |> n->hands[n] |> reverse |> enumerate .|> (pair -> (*)(pair...)) |> sum
    end

    @test AoC.exampleLines(22,1) |> parseinput |> playgame! |> winningscore == 306

    export parseinput, playgame!, winningscore

end

using AoC, .Part1

@show AoC.lines(22) |> parseinput |> playgame! |> winningscore
