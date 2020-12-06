#=
day6:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-06
=#

import AoC
using Test

function group(lines) :: Vector{Vector{String}}
    result::Vector{Vector{String}} = []
    acc::Vector{String} = []
    for l in lines
        if l == ""
            if !isempty(acc)
                result = push!(result, acc)
            end
            acc = []
        else
            acc = push!(acc, l)
        end
    end
    if !isempty(acc)
        push!(result, acc)
    end
    return result
end

@test group(["ab", "cd", "", "def", "g"]) == [["ab","cd"], ["def", "g"]]

function countAnswers(group :: Vector{String})
    return length(∪(group...))
end

@test countAnswers(["ab", "ad"]) == 3

function countAnswersProperly(group :: Vector{String})
    return length(∩(group...))
end

@test countAnswersProperly(["ab", "ad"]) == 1

function countAllAnswers(lines)
    return sum(countAnswers.(lines) )
end

@test countAllAnswers(group([
"abc"
""
"a"
"b"
"c"
""
"ab"
"ac"
""
"a"
"a"
"a"
"a"
""
"b"
])) == 11

function countAllAnswersProperly(lines)
    return sum(countAnswersProperly.(lines) )
end

@test countAllAnswersProperly(group(["abc" "" "a" "b" "c" "" "ab" "ac" "" "a" "a" "a" "a" "" "b"])) == 6

@show countAllAnswers(group(AoC.lines(6)))
@show countAllAnswersProperly(group(AoC.lines(6)))
