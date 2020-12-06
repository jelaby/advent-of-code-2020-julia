#=
day6:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-06
=#

import AoC
using Test

function group(lines; delim="", T=eltype(lines)) :: Vector{Vector{T}}
    result::Vector{Vector{T}} = []
    acc::Vector{T} = []
    for l in lines
        if l == delim
            if !isempty(acc)
                push!(result, acc)
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
@test group(["ab", "cd", "", "def", "g"]; delim="cd") == [["ab"], ["", "def", "g"]]
@test group(["ab", "cd", "", "def", "g"]; T=AbstractString, delim="cd") == [["ab"], ["", "def", "g"]]
@test group([1,3,0,3,5]; delim=0) == [[1,3], [3,5]]
@test group("ab cd def g"; delim=' ') == [['a','b'], ['c','d'], ['d','e','f'], ['g']]
@inferred group(["ab", "cd", "", "def", "g"])
@inferred group([1,2,0,3,5])
@inferred Vector{Vector{AbstractString}} group(["ab", "cd", "", "def", "g"]; T=AbstractString)

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
