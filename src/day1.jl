#=
day1:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-01
=#

using AdventOfCode

expenses = parse.(Int, day(1).lines)

function findn(f, predicate, a, n, imax = length(a), values=())
    if n == 0
        if predicate(values...)
            return f(values...)
        else
            return nothing
        end
    end
    for i = 1:imax
        result = findn(f, predicate, a, n-1, i - 1, (values..., a[i]))
        if result != nothing
            return result
        end
    end
    return nothing
end

@show findn((*), (args...) -> +(args...) == 2020, expenses, 2)
@show findn((*), (args...) -> +(args...) == 2020, expenses, 3)
