#=
day2:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-02
=#

using StatsBase, AdventOfCode

struct PasswordSpec
    first::Int
    second::Int
    char::AbstractChar
    password::AbstractString
end

PasswordSpec(min::AbstractString, max::AbstractString, char::AbstractString, password::AbstractString) =
    PasswordSpec(parse(Int, min), parse(Int, max), char[1], password)

PasswordSpec(line) = PasswordSpec(match(r"^(\d+)-(\d+)\s+(\w):\s*(\w+)$", line).captures...)

checkPasswordForSomeOtherCompany(spec :: PasswordSpec) = spec.first ≤ get(countmap(spec.password), spec.char, 0) ≤ spec.second
checkPassword(spec :: PasswordSpec) = (spec.password[spec.first] == spec.char) ⊻ (spec.password[spec.second] == spec.char)

passwords = PasswordSpec.(day(2).lines)

@show sum(checkPasswordForSomeOtherCompany, passwords)
@show sum(checkPassword, passwords)
