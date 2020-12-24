#=
day24:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-24
=#


module Part1

    using Test

    mid(s, first) = length(s) < first ? "" : s[first:end]

    function parseline(line)
        result = Symbol[]

        while !isempty(line)
            if line[1] ∈ ['e', 'w']
                push!(result, Symbol(line[1]))
                line = mid(line, 2)
            else
                push!(result, Symbol(line[1:2]))
                line = mid(line, 3)
            end
        end
        return result
    end

    move(::Val{:e}, x, y) = (x+1, y)
    move(::Val{:w}, x, y) = (x-1, y)
    move(::Val{:se}, x, y) = (x+1-mod(y,2), y-1)
    move(::Val{:sw}, x, y) = (x-mod(y,2), y-1)
    move(::Val{:ne}, x, y) = (x+1-mod(y,2), y+1)
    move(::Val{:nw}, x, y) = (x-mod(y,2), y+1)
    move(dir, x, y) = move(Val(dir), x, y)

    @test move(:e, 0, 0) == (1,0)
    @test move(:w, 0, 0) == (-1,0)
    @test move(:se, 0, 0) == (1,-1)
    @test move(:sw, 0, 0) == (0,-1)
    @test move(:se, 0, 1) == (0,0)
    @test move(:sw, 0, 1) == (-1,0)
    @test move(:se, 0, -1) == (0,-2)
    @test move(:sw, 0, -1) == (-1,-2)
    @test move(:ne, 0, 0) == (1,1)
    @test move(:nw, 0, 0) == (0,1)
    @test move(:ne, 0, 1) == (0, 2)
    @test move(:nw, 0, 1) == (-1,2)
    @test move(:ne, 0, -1) == (0,0)
    @test move(:nw, 0, -1) == (-1,0)

    function walk(commands)
        x,y = 0,0
        for command in commands
            x,y = move(command, x, y)
        end
        return (x,y)
    end

    @enum Tile white black

    flip(::Val{white}) = black
    flip(::Val{black}) = white
    flip(tile) = flip(Val(tile))

    function runinstructions(recipe)
        result = Dict{Tuple{Int,Int}, Tile}()
        for commands in recipe
            pos = walk(commands)
            tile = get(result, pos, white)
            result[pos] = flip(tile)
        end
        return result
    end

    export parseline, runinstructions, black, white
end

using Test, AoC, .Part1

@test AoC.exampleLines(24,1) .|> parseline |> runinstructions |> f -> count(t->t==black, values(f)) == 10
println("Starting...")
@show AoC.lines(24) .|> parseline |> runinstructions |> f -> count(t->t==black, values(f))

