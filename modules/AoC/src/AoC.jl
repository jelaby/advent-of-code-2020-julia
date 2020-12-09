"""
# module AdventOfCode

- Julia version: 
- Author: Paul.Mealor
- Date: 2020-12-02

# Examples

```jldoctest
julia>
```
"""
module AoC

    export lines, exampleLines
    export ints, exampleInts

    lines(day) = open(readlines, "src/day" * string(day) * "-input.txt")
    exampleLines(day, n) = open(readlines, "src/day" * string(day) * "-example-" * string(n) * ".txt")

    ints(day) = lines(day) |> ll -> parse.(Int, ll)
    exampleInts(day, n) = exampleLines(day, n) |> ll -> parse.(Int, ll)
end