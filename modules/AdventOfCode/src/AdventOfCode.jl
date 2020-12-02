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

    using HTTP

    struct Day
        lines
    end

    function day(n)
        lines = HTTP.open(:GET, "https://adventofcode.com/2020/day/" * string(n) * "/input") do io
            readlines(io)
        end

        return Day(lines)
    end

end