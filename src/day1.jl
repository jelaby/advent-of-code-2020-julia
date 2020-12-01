#=
day1:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-01
=#

expenses = open("src/day1-input.txt") do file
    readlines(file) |> l -> parse.(Int, l)
end

function findpair(a, predicate :: Function)
    for i = 1:lastindex(a), j = 1:i
        if predicate(a[i],a[j])
            return  (i,j)
        end
    end
    throw(ErrorException("Not found"))
end

(i,j) = findpair(expenses, (x,y) -> x + y == 2020)

expenses[i] * expenses[j]