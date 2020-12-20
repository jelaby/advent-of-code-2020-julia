#=
day20:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-20
=#

using AoC

module Part1

    using Test
    import AoC

    struct Image
        id::Int
        body::AbstractArray{Bool,2}
        leftId::Int
        rightId::Int
        topId::Int
        bottomId::Int
        Image(id, body) = new(id, body, calculateSides(body)...)
    end
    Image(id, body::Array{AbstractString, 1}) = Image(id, BitArray(body[j][i] == '#' for i in 1:length(body[1]), j in 1:length(body)))

    function calculateSide(body::BitArray{1})
        # hah!
        return body.chunks[1]
    end
    function reverseSideId(sideId)
        result = 0
        for i in 0:9
            result += ((sideId >> i) & 1) << (9-i)
        end
        return result
    end
    @test reverseSideId(1) == 512
    @test reverseSideId(512) == 1
    @test reverseSideId(2) == 256
    @test reverseSideId(256) == 2

    function calculateSides(body::AbstractArray{Bool, 2})
        return (
            calculateSide(body[:,1]), # left
            calculateSide(body[:,size(body, 2)]), # right
            calculateSide(body[1,:]), # top
            calculateSide(body[size(body, 1),:]) # bottom
        )
    end

    @enum Mode idmode bodymode
    function parseSateliteMessage(lines)
        mode = idmode
        body = AbstractString[]
        id = nothing
        images = Image[]
        if lines[end] != ""
            lines = [lines..., ""]
        end
        for line in lines
            if mode == idmode
                id = parse(Int, match(r"Tile (\d+):", line).captures[1])
                mode = bodymode
            elseif mode == bodymode
                if line != ""
                    push!(body, line)
                else
                    push!(images, Image(id, body))
                    body = AbstractString[]
                    id = nothing
                    mode = idmode
                end
            end
        end
        return images
    end

    id(i) = i.id

    function reconstructimage(images)
        sideIdsToImages = Dict{Int, Vector{Image}}()
        for image in images
            for sideId in [image.leftId, image.rightId, image.topId, image.bottomId]
                push!(get!(sideIdsToImages, sideId) do; Vector{Image}(); end, image)
                push!(get!(sideIdsToImages, reverseSideId(sideId)) do; Vector{Image}(); end, image)
            end
        end
        @show sideIdsToImages

        cornerIds = Set{Int}()
        for image in images
            imagesWithMatchingSides = Set{Int}()
            for sideId in [image.leftId, image.rightId, image.topId, image.bottomId]
                for matchingImage in sideIdsToImages[sideId]
                    push!(imagesWithMatchingSides, id(matchingImage))
                end
            end
            if length(imagesWithMatchingSides) == 3 # a corner matches itself and 2 others
                push!(cornerIds, id(image))
            end
        end

        return cornerIds
    end


    @test reconstructimage(parseSateliteMessage(AoC.exampleLines(20,1))) == Set{Int}([1951, 2971, 3079, 1171])
    @test reduce(*, reconstructimage(parseSateliteMessage(AoC.exampleLines(20,1)))) == 20899048083289

end


@show reduce(*, Part1.reconstructimage(Part1.parseSateliteMessage(AoC.lines(20))))
