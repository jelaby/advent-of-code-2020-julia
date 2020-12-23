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
        cards = popfirst!.(hands)

        best = findmax(cards)[2]

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

module Part2

    using Test, AoC, .Main.Part1

    function playrecursiveround!(hands, previoushands=[])
        if hands ∈ previoushands
            return [hands[1], []]
        else
            cards = popfirst!.(hands)

            if count(CartesianIndices(hands) .|> (i -> length(hands[i]) < cards[i])) != 0
                best = findmax(cards)[2]
            else
                newhands = similar(hands)
                for i in CartesianIndices(hands)
                    newhands[i] = copy(hands[i][1:cards[i]])
                end
                best = findmax(length.(playrecursivegame!(newhands)))[2]
            end
            order = [cards[best], cards[3-best]]
            push!(hands[best], order...)

            return hands
        end
    end

    function playrecursivegame!(hands)
        @show :playrecursivegame!, hands
        previoushands = []
        while count(h->!isempty(h), hands) != 1
            if hands ∈ previoushands
                return [hands[1],[]]
            end
            push!(previoushands, deepcopy(hands))
            playrecursiveround!(hands, [])
        end
        return hands
    end

    @test AoC.exampleLines(22,1) |> parseinput |> playrecursivegame! |> winningscore == 291

    export playrecursivegame!

end

using AoC, .Part1, .Part2

println("Starting...")
@show AoC.lines(22) |> parseinput |> playgame! |> winningscore
println("Starting...")
@show AoC.lines(22) |> parseinput |> playrecursivegame! |> winningscore