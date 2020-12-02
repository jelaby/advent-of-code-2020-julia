#=
day1:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-01
=#

import AoC

expenses = parse.(Int, AoC.lines(1))

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

@show findn((*), (args...) -> sum(args) == 2020, expenses, 2)
@show findn((*), (args...) -> sum(args) == 2020, expenses, 3)
