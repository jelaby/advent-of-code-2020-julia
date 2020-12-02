#=
day2:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-02
=#

using StatsBase

struct PasswordSpec
    first::Int
    second::Int
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
    (spec.password[spec.first] == spec.char) ⊻ (spec.password[spec.second] == spec.char)
end

(+)(checkPassword.(passwords)...)