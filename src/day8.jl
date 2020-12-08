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
    state
end

Compooter(program) = Compooter(program, 1, 0, :running)

struct Instruction
    code::Symbol
    argument::AbstractString
end
Instruction(code::AbstractString, argument::AbstractString) = Instruction(Symbol(code), argument)

function step(c::Compooter; pointer=c.pointer+1, accumulator=c.accumulator, state=c.state)
    if 1 ≤ pointer ≤ length(c.program)
        Compooter(c.program, pointer, accumulator, state)
    else
        Compooter(c.program, pointer, accumulator, :completed)
    end
end

execute(c::Compooter, ::Val{:nop}, arg) = step(c)
execute(c::Compooter, ::Val{:acc}, arg) = step(c; accumulator = c.accumulator + parse(Int, arg))
execute(c::Compooter, ::Val{:jmp}, arg) = step(c; pointer = c.pointer + parse(Int, arg))

execute(c::Compooter, i::Instruction) = execute(c, Val(i.code), i.argument)
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

function runProgram(program)
    computer = Compooter(program)
    visitedInstructions::Set{Int} = Set()

    while computer.state == :running
        if computer.pointer ∈ visitedInstructions
            return step(computer; state=:looped)
        end
        push!(visitedInstructions, computer.pointer)
        computer = execute(computer)
    end

    return computer
end


@test runProgram(program(example)).accumulator == 5
@test runProgram(program(example)).state == :looped
@time @show runProgram(program(AoC.lines(8))).accumulator

example2 = split("nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6", "\n")

function fixProgram(program)
    for i = 1:length(program)
        if program[i].code == :jmp
            modifiedProgram = [program...]
            modifiedProgram[i] = Instruction(:nop, program[i].argument)
        elseif program[i].code == :nop
            modifiedProgram = [program...]
            modifiedProgram[i] = Instruction(:jmp, program[i].argument)
        else
            modifiedProgram = nothing
        end
        if modifiedProgram ≠ nothing
            computer = runProgram(modifiedProgram)
            if computer.state == :completed
                return computer
            end
        end
    end
    error("Program cannot run")
end

@test fixProgram(program(example2)).accumulator == 8
@time @show fixProgram(program(AoC.lines(8))).accumulator