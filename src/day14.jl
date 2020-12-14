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

using Printf

@printf "%i" mapreduce(e->e.second, +, Part1.run(lines(14)).mem)
