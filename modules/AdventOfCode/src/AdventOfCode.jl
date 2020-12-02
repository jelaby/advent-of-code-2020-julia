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
module AdventOfCode

    export Day, day

    struct Day
        lines
    end

    function day(n)
        lines = open("src/day" * string(n) * "-input.txt") do file
           readlines(file)
        end

        return Day(lines)
    end

end