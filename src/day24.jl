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

    adjacents(coord) = adjacents(coord...)
    function adjacents(x,y)
        return [
            move(:e, x,y),
            move(:w, x,y),
            move(:se, x,y),
            move(:sw, x,y),
            move(:ne, x,y),
            move(:nw, x,y),
        ]
    end
    @test adjacents(0,0) == [(1,0),(-1,0),(1,-1),(0,-1),(1,1),(0,1)]

    function livingart(tiles, rounds)

        for day in 1:rounds
            nextTiles = Dict{Tuple{Int,Int}, Tile}()

            tilesToCheck = Set{Tuple{Int,Int}}()
            push!(tilesToCheck, keys(tiles)...)
            for x in keys(tiles)
                a = adjacents(x)
                push!(tilesToCheck, a...)
            end

            for coord in tilesToCheck
                tile = get(tiles, coord, white)
                adjacentTiles = adjacents(coord) .|> a->get(tiles, a, white)
                adjacentBlackTiles = count(t->t==black, adjacentTiles)
                if tile == black && 0 < adjacentBlackTiles < 3
                    nextTiles[coord] = black
                elseif tile == white && adjacentBlackTiles == 2
                    nextTiles[coord] = black
                end
            end

            tiles = nextTiles

        end

        return tiles

    end

    export parseline, runinstructions, black, white, livingart
end

using Test, AoC, .Part1

@test AoC.exampleLines(24,1) .|> parseline |> runinstructions |> f -> count(t->t==black, values(f)) == 10
@test (AoC.exampleLines(24,1) .|> parseline |> runinstructions |> f -> livingart(f, 1) |> f -> count(t->t==black, values(f))) == 15
@test (AoC.exampleLines(24,1) .|> parseline |> runinstructions |> f -> livingart(f, 100) |> f -> count(t->t==black, values(f))) == 2208
println("Starting...")
@show @time AoC.lines(24) .|> parseline |> runinstructions |> f -> count(t->t==black, values(f))
@show @time AoC.lines(24) .|> parseline |> runinstructions |> f -> livingart(f, 100) |> f -> count(t->t==black, values(f))

