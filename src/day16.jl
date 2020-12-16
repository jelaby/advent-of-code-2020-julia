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

    incorrectTicketValues(lines::Array) = incorrectTicketValues(parseInput(lines))
    incorrectTicketValues(input::Input) = filter(vcat(input.tickets...)) do value
        for field in input.fields
            for range in field.ranges
                if value ≥ range[1] && value ≤ range[2]
                    return false
                end
            end
        end
        return true
    end

    @test incorrectTicketValues(exampleLines(16,1)) == [4,55,12]
    @test sum(incorrectTicketValues(exampleLines(16,1))) == 71

end

using AoC
@show sum(Part1.incorrectTicketValues(lines(16)))