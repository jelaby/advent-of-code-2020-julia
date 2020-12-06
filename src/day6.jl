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

countAnswers(group) = length(∪(group...))
@test countAnswers(["ab", "ad"]) == 3

countAnswersProperly(group) = length(∩(group...))
@test countAnswersProperly(["ab", "ad"]) == 1

countAllAnswers(lines) = sum(countAnswers.(lines) )
@test countAllAnswers(group(["abc" "" "a" "b" "c" "" "ab" "ac" "" "a" "a" "a" "a" "" "b"])) == 11

countAllAnswersProperly(lines) = sum(countAnswersProperly.(lines) )
@test countAllAnswersProperly(group(["abc" "" "a" "b" "c" "" "ab" "ac" "" "a" "a" "a" "a" "" "b"])) == 6

@show countAllAnswers(group(AoC.lines(6)))
@show countAllAnswersProperly(group(AoC.lines(6)))
