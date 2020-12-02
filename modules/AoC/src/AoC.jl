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

    export lines

    lines(day::Int) = open(readlines, "src/day" * string(day) * "-input.txt")
end