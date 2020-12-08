#=
day8:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-08
=#

import AoC
using Test

struct Compooter
    program
    pointer
    accumulator
end

Compooter(program) = Compooter(program, 1, 0)

struct Instruction
    code
    argument
end

step(c::Compooter; pointer=c.pointer+1, accumulator=c.accumulator) = Compooter(c.program, pointer, accumulator)

execute(c::Compooter, ::Val{:nop}, arg) = step(c)
execute(c::Compooter, ::Val{:acc}, arg) = step(c; accumulator = c.accumulator + parse(Int, arg))
execute(c::Compooter, ::Val{:jmp}, arg) = step(c; pointer = c.pointer + parse(Int, arg))

execute(c::Compooter, i::Instruction) = execute(c, Val(Symbol(i.code)), i.argument)
execute(c::Compooter) = execute(c, c.program[c.pointer])

example = split("nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6", "\n")

instruction(op::AbstractString) = Instruction(split(op, " ")...)
program(program::Array{<:AbstractString}) = instruction.(program)

function programWhenLoopOccurs(program)
    computer = Compooter(program)
    visitedInstructions::Set{Int} = Set()

    while true
        if computer.pointer ∈ visitedInstructions
            return computer
        end
        push!(visitedInstructions, computer.pointer)
        computer = execute(computer)
    end
end


@test programWhenLoopOccurs(program(example)).accumulator == 5
@show programWhenLoopOccurs(program(AoC.lines(8))).accumulator