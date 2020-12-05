#=
day5:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-05
=#

import AoC
using Test, MLStyle

struct Seat
    row
    column
    id
end

charToBinary(spec::AbstractChar) = @match spec begin
        'F' || 'L' => '0'
        'B' || 'R' => '1'
        c => error("Unknown spec char " * c)
    end

toBinary(spec::AbstractString) = string(charToBinary.(c for c in spec)...)

@test toBinary("BFFFBBF") == "1000110"
@test toBinary("RLL") == "100"

specToNumber(spec) = parse(Int, toBinary(spec); base = 2)

@test specToNumber("BFFFBBF") == 70
@test specToNumber("RLL") == 4
@test specToNumber("RRR") == 7

function Seat(spec::AbstractString)
    row = specToNumber(spec[1:7])
    column = specToNumber(spec[8:10])
    id = row * 8 + column
    return Seat(row, column, id)
end

@test Seat("BFFFBBFRRR") == Seat(70,7,567)
@test Seat("FFFBBBFRRR") == Seat(14,7,119)
@test Seat("BBFFBBFRLL") == Seat(102,4,820)

ids = Seat.(AoC.lines(5)) |> l->getfield.(l, :id)

@show maximum(ids)
@show setdiff(minimum(ids):maximum(ids), ids)