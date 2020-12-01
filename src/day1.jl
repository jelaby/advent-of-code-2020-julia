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
            return (i,j)
        end
    end
    throw(ErrorException("Not found"))
end

(i,j) = findpair(expenses, (x,y) -> x + y == 2020)

@show (i,j), expenses[i], expenses[j]
@show expenses[i] * expenses[j]

function findtriple(a, predicate :: Function)
    for i = 1:lastindex(a), j = 1:i, k = 1:j
        if predicate(a[i],a[j],a[k])
            return (i,j,k)
        end
    end
    throw(ErrorException("Not found"))
end

(i,j,k) = findtriple(expenses, (x,y,z) -> x + y + z == 2020)

@show (i,j,k), expenses[i], expenses[j], expenses[k]
@show expenses[i] * expenses[j] * expenses[k]
