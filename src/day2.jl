#=
day2:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-02
=#

using StatsBase

struct PasswordSpec
    min::Int
    max::Int
    char::AbstractChar
    password::AbstractString
end

function PasswordSpec(min::AbstractString, max::AbstractString, char::AbstractString, password::AbstractString)
    PasswordSpec(parse(Int, min), parse(Int, max), char[1], password)
end

function PasswordSpec(line)
    PasswordSpec(match(r"^(\d+)-(\d+)\s+(\w):\s*(\w+)$", line).captures...)
end

passwords = open("src/day2-input.txt") do file
    readlines(file) |> l -> PasswordSpec.(l)
end

function checkPassword(spec :: PasswordSpec)
    return spec.min <= get(countmap(spec.password), spec.char, 0) <= spec.max
end

(+)(checkPassword.(passwords)...)