#=
day14:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-14
=#

using AoC

module Part1

    using Test
    using AoC

    mutable struct Compuper
        andMask::UInt64
        orMask::UInt64
        mem::Dict{Int,UInt64}
    end
    Compuper() = Compuper(0xffffffff, 0x00000000, Dict{Int, UInt64}())

    struct Command
        name::Symbol
        index::Union{Int,Nothing}
        arg
    end
    command(s::AbstractString) = match(r"^(\w+)(?:\[(\d+)\])?\s*=\s*(.*)$", s).captures |>
        parts -> Command(Symbol(parts[1]), isnothing(parts[2]) ? nothing : parse(Int, parts[2]), parts[3])

    function execute!(c::Compuper, ::Val{:mask}, ::Any, arg)
        c.andMask = parse(Int, replace(arg, r"X"=>"1"); base=2)
        c.orMask = parse(Int, replace(arg, r"X"=>"0"); base=2)
    end

    function execute!(c::Compuper, ::Val{:mem}, index, arg)
        value = (parse(UInt64, arg) & c.andMask) | c.orMask

        c.mem[index] = value
    end

    run(program::Vector) = run(command.(program))
    function run(program::Vector{Command})
        c = Compuper()
        for command in program
            execute!(c, Val(command.name), command.index, command.arg)
        end
        return c
    end

    @test run(exampleLines(14,1)).mem == Dict{Int, UInt64}(7=>101, 8=>64)
    @test mapreduce(e->e.second, +, run(exampleLines(14,1)).mem) == 165

end

module Part2

    using Test
    using AoC

    mutable struct Compuper
        floatMask::UInt64
        orMask::UInt64
        mem::Dict{Int,UInt64}
    end
    Compuper() = Compuper(0xffffffff, 0x00000000, Dict{Int, UInt64}())

    struct Command
        name::Symbol
        index::Union{Int,Nothing}
        arg
    end
    command(s::AbstractString) = match(r"^(\w+)(?:\[(\d+)\])?\s*=\s*(.*)$", s).captures |>
        parts -> Command(Symbol(parts[1]), isnothing(parts[2]) ? nothing : parse(Int, parts[2]), parts[3])

    function execute!(c::Compuper, ::Val{:mask}, ::Any, arg)
        c.floatMask = parse(UInt64, replace(replace(arg, r"[01]"=>"0"), r"X"=>"1"); base=2)
        c.orMask = parse(UInt64, replace(arg, r"X"=>"0"); base=2)
    end

    function execute!(c::Compuper, ::Val{:mem}, index, arg)

        value = parse(UInt64, arg)

        for i in applyMask(index, c.orMask, c.floatMask)
            c.mem[i] = value
        end
    end

    function spreadBits(bits, mask)
        value = 0
        offset = 0
        while bits != 0
            if (mask & 1) != 0
                value |= (bits & 1)<<offset
                bits = bits >> 1
            end
            offset += 1
            mask = mask >> 1
        end
        return value
    end
    @test spreadBits(0x00, 0x05) == 0x00
    @test spreadBits(0x01, 0x05) == 0x01
    @test spreadBits(0x02, 0x06) == 0x04
    @test spreadBits(0x03, 0x05) == 0x05
    @test spreadBits(0x00, 0x06) == 0x00
    @test spreadBits(0x01, 0x06) == 0x02
    @test spreadBits(0x02, 0x06) == 0x04
    @test spreadBits(0x03, 0x06) == 0x06

    applyMask(index, orMask, floatMask) =
        ((index & ~floatMask) | orMask | (spreadBits(n, floatMask))
            for n in 0:( 1<<(count_ones(floatMask)) ) - 1)
    @test [x for x in applyMask(42, 18, 33)] == [26, 27, 58, 59]

    run(program::Vector) = run(command.(program))
    function run(program::Vector{Command})
        c = Compuper()
        for command in program
            execute!(c, Val(command.name), command.index, command.arg)
        end
        return c
    end

    @test run(exampleLines(14,2)).mem == Dict{Int, UInt64}(16=>1, 17=>1, 18=>1, 19=>1, 24=>1, 25=>1, 26=>1, 27=>1, 58=>100, 59=>100)
    @test mapreduce(e->e.second, +, run(exampleLines(14,2)).mem) == 208

end

using Printf

println("Part 1...")
println(@sprintf "%i" mapreduce(e->e.second, +, Part1.run(lines(14)).mem))
println("Part 2...")
println(@sprintf "%i" mapreduce(e->e.second, +, Part2.run(lines(14)).mem))
