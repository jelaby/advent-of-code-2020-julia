#=
day16:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-16
=#




module Part1

    using AoC
    using Test

    struct Input
        fields
        myTicket
        tickets
    end
    Base.:(==)(a::Input, b::Input) = a.fields == b.fields && a.myTicket == b.myTicket && a.tickets == b.tickets
    struct Field
        name::AbstractString
        ranges::Vector{Tuple{Int,Int}}
    end
    Base.:(==)(a::Field, b::Field) = a.name == b.name && a.ranges == b.ranges

    int(s) = parse(Int, s)

    function field(line)
        parts = match(r"(.*): (\d+)-(\d+) or (\d+)-(\d+)", line).captures
        return Field(parts[1], [(int(parts[2]),int(parts[3])),(int(parts[4]),int(parts[5]))])
    end

    function parseInput(input)
        fields = Vector{Field}()
        myTicket = nothing
        tickets = Vector{Vector{Int}}()

        mode=1
        for l in input
            if isempty(l)
                mode += 1
            elseif mode == 1
                push!(fields, field(l))
            elseif mode == 2
                mode = 3
            elseif mode == 3
                myTicket = int.(split(l, ","))
            elseif mode == 4
                mode = 5
            elseif mode == 5
                push!(tickets, int.(split(l, ",")))
            end
        end
        return Input(fields, myTicket, tickets)
    end
    @test [1,2] == [1,2]
    @test [(1,2),(3,4)] == [(1,2),(3,4)]
    @test Field("class", [(1,3),(5,7)]) == Field("class", [(1,3),(5,7)])
    @test parseInput(exampleLines(16,1)).fields == [Field("class", [(1,3),(5,7)]), Field("row", [(6,11),(33,44)]), Field("seat", [(13,40),(45,50)])]
    @test parseInput(exampleLines(16,1)).myTicket == [7,1,14]
    @test parseInput(exampleLines(16,1)).tickets == [[7,3,47], [40,4,50], [55,2,20], [38,6,12]]

    function matches(field, value)
        for range in field.ranges
            if value ≥ range[1] && value ≤ range[2]
                return true
            end
        end
        return false
    end

    incorrectTicketValues(lines::Array) = incorrectTicketValues(parseInput(lines))
    incorrectTicketValues(input::Input) = filter(vcat(input.tickets...)) do value
        for field in input.fields
            if matches(field, value)
                return false
            end
        end
        return true
    end

    @test incorrectTicketValues(exampleLines(16,1)) == [4,55,12]
    @test sum(incorrectTicketValues(exampleLines(16,1))) == 71

    export Input, Field, int, input, parseInput, incorrectTicketValues, matches

end

module Part2
    using Main.Part1
    using Test, AoC

    discardIncorrectTickets(input::Input) = filter(input.tickets) do ticket
        return isempty(filter(ticket) do value
            for field in input.fields
                if matches(field, value)
                    return false
                end
            end
            return true
        end)
    end
    @test discardIncorrectTickets(parseInput(exampleLines(16,1))) == [ [7,3,47] ]

    findFieldNames(input::Input) = findFieldNames(input.fields, discardIncorrectTickets(input))
    function findFieldNames(fields, tickets)
        candidates=similar(fields, Vector{Field})
        for i in CartesianIndices(fields)
            candidates[i] = copy(fields)
        end

        searching = true
        while searching
        for ticket in tickets
            for i in CartesianIndices(candidates)
                filter!(candidates[i]) do candidate
                    matches(candidate, ticket[i])
                end
            end
            resolved = vcat(filter(c->length(c)==1, candidates)...)
            if length(resolved) == length(candidates)
                searching = false
                break
            end
            for a in candidates
                if length(a) != 1
                    filter!(b -> b ∉ resolved, a)
                end
            end
        end
        end
        return Dict(candidates[i][1].name=>i for i in 1:length(candidates))
    end
    @test findFieldNames([Field("foo",[(1,2),(5,6)]), Field("bar",[(7,8)])], [[7,1], [8,2]]) == Dict("bar"=>1, "foo"=>2)
    @test findFieldNames([Field("foo",[(1,4)]), Field("bar",[(2,3)])], [[2,3], [1,2]]) == Dict("bar"=>2, "foo"=>1)

    departureFields(input) = filter(d->startswith(d.first, "departure"), findFieldNames(input))

    product(args) = reduce(*, args; init=1)

    part2Answer(input) = part2Answer(parseInput(input))
    part2Answer(input::Input) = product(
        (input.myTicket[n] for n in values(departureFields(input)))
    )
    @test part2Answer(exampleLines(16,1)) == 1

end

using AoC
input = Part1.parseInput(lines(16))
@show sum(Part1.incorrectTicketValues(lines(16)))
@show @time Part2.part2Answer(input)