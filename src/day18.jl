#=
Day18:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-18
=#

module Part1

    using Test




    function chomps(line)
        while(!isempty(line) && line[1] == ' ')
            line = line[2:end]
        end
        return line
    end

    function parseLine(line)
        line = chomps(line)
        return consumeBracket(line)[1]
    end

    function consumeOperand(line)
        line = chomps(line)
        if line[1] == '('
            return consumeBracket(line[2:end])
        else
            return consumeNumber(line)
        end
    end

    function consumeNumber(line)
        line = chomps(line)
        space = 1
        while space ≤ length(line) && '0' ≤ line[space] ≤ '9'
            space += 1
        end
        return parse(Int, line[1:space-1]), line[space:end]
    end


    function consumeBracket(line)
        line = chomps(line)
        stack = nothing
        @show stack, line
        while !isempty(line)
            char1 = line[1]
            if char1 == '*'
                rhs,line = consumeOperand(line[2:end])
                stack = stack * rhs
            elseif char1 == '+'
                rhs,line = consumeOperand(line[2:end])
                stack = stack + rhs
            elseif char1 == ')'
                if length(line) > 1
                    line = line[2:end]
                else
                    line = ""
                end
                return stack, line
            else
                stack,line = consumeOperand(line)
            end
            line = chomps(line)
            @show stack, line
        end
        return stack, ""
    end

    @test parseLine("1 + 2 * 3 + 4 * 5 + 6") == 71
    @test parseLine("2 * 3 + (4 * 5)") == 26
    @test parseLine("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632

end

module Part2

    using Test

    abstract type Expr; end

    struct Value <: Expr
        value::Int
    end

    struct Multiplication <: Expr
    end
    struct Addition <: Expr
        left::Expr
        right::Expr
    end
    struct Bracket <: Expr
        content::Expr
    end

    function chomps(line)
        while(!isempty(line) && line[1] == ' ')
            line = line[2:end]
        end
        return line
    end

    function parseLine(line)
        line = chomps(line)
        return consumeBracket(line)[1]
    end

    function consumeOperand(line)
        line = chomps(line)
        if line[1] == '('
            return consumeBracket(line[2:end])
        else
            return consumeNumber(line)
        end
    end

    function consumeNumber(line)
        line = chomps(line)
        space = 1
        while space ≤ length(line) && '0' ≤ line[space] ≤ '9'
            space += 1
        end
        return parse(Int, line[1:space-1]), line[space:end]
    end

    value(lhs, ::Multiplication, rhs) = lhs * rhs

    function evaluate(stack)
        while length(stack) ≠ 1
            rhs,op,lhs = pop!(stack),pop!(stack),pop!(stack)
            push!(stack, value(lhs,op,rhs))
        end
        return pop!(stack)
    end

    function consumeBracket(line)
        line = chomps(line)
        stack = []
        @show stack, line
        while !isempty(line)
            char1 = line[1]
            if char1 == '*'
                push!(stack, Multiplication())
                line = line[2:end]
            elseif char1 == '+'
                rhs,line = consumeOperand(line[2:end])
                push!(stack, pop!(stack) + rhs)
            elseif char1 == ')'
                if length(line) > 1
                    line = line[2:end]
                else
                    line = ""
                end
                return evaluate(stack), line
            else
                operand,line = consumeOperand(line)
                push!(stack, operand)
            end
            line = chomps(line)
            @show stack, line
        end
        return evaluate(stack), ""
    end

    @test parseLine("2 + 3 * 4") == 20
    @test parseLine("2 * 3 + 4") == 14
    @test parseLine("1 + 2 * 3 + 4 * 5 + 6") == 231
    @test parseLine("1 + (2 * 3) + (4 * (5 + 6))") == 51
    @test parseLine("2 * 3 + (4 * 5)") == 46
    @test parseLine("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340

end

using AoC
@show sum(Part1.parseLine.(lines(18)))
@show sum(Part2.parseLine.(lines(18)))
