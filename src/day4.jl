#=
day4:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-04
=#

import AoC

validEyeColours = ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"]

function validHeight(h)
    spec = match(r"^([0-9]+)(cm|in)$", h)
    if spec == nothing
        return false
    end

    value, unit = spec.captures
    value = parse(Int, value)
    if unit == "cm"
        return 150 ≤ value ≤ 193
    elseif unit == "in"
        return 59 ≤ value ≤ 76
    else
        return false
    end
end

matches(r,s) = match(r,s) != nothing

requiredFields = Dict(
"byr" => f -> matches(r"^[0-9]{4}$", f) && 1920 ≤ parse(Int, f) ≤ 2002,
"iyr" => f -> matches(r"^[0-9]{4}$", f) && 2010 ≤ parse(Int, f) ≤ 2020,
"eyr" => f -> matches(r"^[0-9]{4}$", f) && 2020 ≤ parse(Int, f) ≤ 2030,
"hgt" => validHeight,
"hcl" => f -> matches(r"^#[0-9a-f]{6}$", f),
"ecl" => f -> f ∈ validEyeColours,
"pid" => f -> matches(r"^[0-9]{9}$", f)
)

function databaseDump()
    dbEntries = []
    passportLines = []
    for line ∈ AoC.lines(4)
        if line == ""
            push!(dbEntries, Dict(map(l->tuple(split(l,":")...), passportLines)))
            passportLines = []
        else
            append!(passportLines, split(line))
        end
    end
    if length(passportLines) != 0
        push!(dbEntries, Dict(map(l->tuple(split(l,":")...), passportLines)))
    end
    dbEntries
end

function validEntry(e)
    for requiredField ∈ requiredFields
        fieldName, predicate = requiredField
        if !haskey(e, fieldName) || !predicate(e[fieldName])
            return false
        end
    end
    return true
end

@show databaseDump() |> ee -> filter(validEntry, ee) |> length
