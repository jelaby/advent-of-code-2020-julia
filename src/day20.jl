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
    body(i) = i.body

    function placesubimages(images)
        sideIdsToImages = Dict{Int, Vector{Image}}()
        imageIdsToImages = Dict{Int, Image}()
        for image in images
            imageIdsToImages[image.id] = image
            for sideId in [image.leftId, image.rightId, image.topId, image.bottomId]
                push!(get!(sideIdsToImages, sideId) do; Vector{Image}(); end, image)
                push!(get!(sideIdsToImages, reverseSideId(sideId)) do; Vector{Image}(); end, image)
            end
        end

        cornerIds = Set{Int}()
        corners = Set{Image}()
        for image in images
            imagesWithMatchingSides = Set{Int}()
            for sideId in [image.leftId, image.rightId, image.topId, image.bottomId]
                for matchingImage in sideIdsToImages[sideId]
                    push!(imagesWithMatchingSides, id(matchingImage))
                end
            end
            if length(imagesWithMatchingSides) == 3 # a corner matches itself and 2 others
                push!(cornerIds, id(image))
                push!(corners, image)
            end
        end

        tilesPerSide = floor(Int, sqrt(length(images)))

        result = Array{Image, 2}(undef, tilesPerSide, tilesPerSide)

        result[1,1] = transformToTopLeft([corners...][1], sideIdsToImages)

        for i = 1:size(result, 1)
            if i != 1
                tileAbove = result[i-1,1]
                previousEdgeId = tileAbove.bottomId
                nextTile = filter(image -> id(image) ≠ id(tileAbove), sideIdsToImages[previousEdgeId])[1]
                @show id.(sideIdsToImages[previousEdgeId])
                @test length(sideIdsToImages[previousEdgeId]) == 2
                nextTile = transformForTop(nextTile, previousEdgeId)
                result[i, 1] = nextTile
            end
            tileToLeft = result[i, 1]
            for j = 2:size(result, 2)
                previousEdgeId = tileToLeft.rightId
                nextTiles = filter(image -> id(image) ≠ id(tileToLeft), sideIdsToImages[previousEdgeId])
                nextTile = transformForLeft(nextTiles[1], previousEdgeId)
                result[i, j] = nextTile
                tileToLeft = nextTile
            end
        end

        return result
    end

    function rotateRight(body::AbstractArray{Bool, 2})
        return BitArray([body[size(body, 2) + 1 - j, i] for i in 1:size(body,1), j in 1:size(body, 2)])
    end
    @test rotateRight(BitArray([0 1 1;0 1 0;0 1 0])) == BitArray([0 0 0;1 1 1;0 0 1])

    function rotateRight(image::Image)
        Image(image.id, rotateRight(image.body))
    end

    function flipRight(body::AbstractArray{Bool, 2})
        return BitArray([body[i, size(body, 2) + 1 - j] for i in 1:size(body,1), j in 1:size(body, 2)])
    end
    @test flipRight(BitArray([0 1 1;0 1 0; 0 1 0])) == BitArray([1 1 0;0 1 0; 0 1 0])
    function flipRight(image::Image)
        Image(image.id, flipRight(image.body))
    end

    function flipOver(body::AbstractArray{Bool, 2})
        return BitArray([body[size(body, 1) + 1 - i, j] for i in 1:size(body,1), j in 1:size(body, 2)])
    end
    @test flipOver(BitArray([0 1 1;0 1 0; 0 1 0])) == BitArray([0 1 0;0 1 0; 0 1 1])

    function transformToTopLeft(image::Image, sideIdsToImages)
        for i = 1:4
            if length(sideIdsToImages[image.leftId]) == 1 && length(sideIdsToImages[image.topId]) == 1
                return image
            end
            image = rotateRight(image)
        end
        return image
    end

    sideIds(image) = [image.leftId, image.rightId, image.topId, image.bottomId]

    function transformForLeft(image::Image, leftSideId)
        for flip in 0:1
            for rotate in 0:3
                if image.leftId == leftSideId
                    return image
                end
                image = rotateRight(image)
            end
            image = flip == 0 ? flipRight(image) : flipOver(image)
        end
        error("Could not match image "*show(sideIds(image))*" to "*string(leftSideId)*"/"*string(topSideId))
    end

    function transformForTop(image::Image, topSideId)
        for flip in 0:1
            for rotate in 0:3
                if image.topId == topSideId
                    return image
                end
                image = rotateRight(image)
            end
            image = flip == 0 ? flipRight(image) : flipOver(image)
        end
        error("Could not match image "*show(sideIds(image))*" to "*string(leftSideId)*"/"*string(topSideId))
    end

    function corners(A)
        @show id.(A)
        return Set([
        A[1,1],
        A[size(A,1), 1],
        A[size(A,1),size(A,2)],
        A[1, size(A,2)]
        ])
    end

    product(iter) = reduce(*, iter)

    removeborder(image) = image[2:size(image,1)-1, 2:size(image,2)-1]

    function combineimages(images::AbstractArray{Image,2})
        images = images .|> body .|> removeborder
        partsize = size(images[1,1])
        origin = CartesianIndex(1,1)

        result = similar(images[1,1], partsize[1] * size(images,1), partsize[2] * size(images, 2))
        @show size(result)

        for i = 1:size(images, 1), j = 1:size(images, 1)
            copyto!(result, origin + CartesianIndex(partsize .* (i-1,j-1)):CartesianIndex(partsize .* (i,j)), images[i,j], origin:CartesianIndex(partsize))
        end

        @show size(result)
        return result
    end

    buildseamonster(image::AbstractArray{String, 1}) = [image[i][j]=='#' for i in 1:length(image), j in 1:length(image[1])]

    seamonster = buildseamonster([
    "                  # "
    "#    ##    ##    ###"
    " #  #  #  #  #  #   "])

    function subtractseamonsters(image::AbstractArray{Bool, 2})
        result = copy(image)
        monstersize = size(seamonster)
        monstercount = 0
        for i in 1:size(image,1)-size(seamonster,1), j in 1:size(image,2)-size(seamonster, 2)
            subimageindices = CartesianIndices((i:i+monstersize[1]-1,j:j+monstersize[2]-1))
            subimage = result[subimageindices]

            if subimage .& seamonster == seamonster
                subimage .&= .~seamonster
                copyto!(result, subimageindices, subimage, CartesianIndices(subimage))
                monstercount += 1
            end
        end
        @show monstercount
        return result
    end

    function roughness(image::AbstractArray{Bool, 2})
        result = count(image)
        for flip in 0:1
            for rotate in 0:3
                result = min(result, image |> subtractseamonsters |> count)
                image = rotateRight(image)
            end
            image = flip == 0 ? flipRight(image) : flipOver(image)
        end
        return result
    end

    @test placesubimages(parseSateliteMessage(AoC.exampleLines(20,1))) |> corners .|> id |> Set{Int} == Set{Int}([1951, 2971, 3079, 1171])
    @test product(placesubimages(parseSateliteMessage(AoC.exampleLines(20,1))) |> corners .|> id) == 20899048083289
    @test product(placesubimages(parseSateliteMessage(AoC.lines(20))) |> corners .|> id) == 29125888761511

    @test AoC.exampleLines(20,1) |> parseSateliteMessage |> placesubimages |> combineimages |> roughness == 273

end

using Main.Part1

@show Part1.product(Part1.placesubimages(Part1.parseSateliteMessage(AoC.lines(20))) |> Part1.corners .|> Part1.id)
@show @time AoC.lines(20) |> Part1.parseSateliteMessage |> Part1.placesubimages |> Part1.combineimages |> Part1.roughness
