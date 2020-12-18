#=
Day17:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-17
=#




module Part1
    using AoC
    using Test

    extend(I::CartesianIndex, ndims) = CartesianIndex(extend(Tuple(I), ndims))
    function extend(I::Tuple, ndims)
        result = fill(1, ndims)
        for i in 1:size(I,1)
            result[i] = I[i]
        end
        return Tuple(result)
    end
    @test extend((2,3), 3) == (2,3,1)
    @test extend((2,3,4,5), 7) == (2,3,4,5,1,1,1)

    function addBorder(A::AbstractArray{T}, border, dimensions) where T
        resultSize = ones(Int, dimensions)
        for i in 1:length(size(A))
            resultSize[i] = size(A)[i]
        end
        resultSize = Tuple(resultSize)

        border = Tuple(fill(border, dimensions))

        resultSize = resultSize .+ 2 .* border

        result = falses(resultSize)
        border = CartesianIndex(border)
        for i in CartesianIndices(A)
            resultIndex = extend

            result[extend(i, dimensions) + border] = A[i]
        end
        return result
    end
    pocketDimension(lines::Vector, turnHint, dimensions=3)::BitArray = addBorder(BitArray([lines[i][j] =='#' for i=1:length(lines), j=1:length(lines[1])]), turnHint, dimensions)

    @test pocketDimension(["#"],1)[2,2,2] == true
    for i in CartesianIndex(1,1,1):CartesianIndex(3,3,3)
        @test pocketDimension(["#"],1)[i] == (Tuple(i) == (2,2,2))
    end

    function simulate(D::BitArray, rounds)
        target = falses(size(D))
        one = CartesianIndex(Tuple(ones(Int, ndims(D))))

        for round in 1:rounds
            @show round

            for I in CartesianIndices(D)
                neighbours=count(D[filter(i->checkbounds(Bool, D, i), (I-one):(I+one))])

                if D[I]
                    target[I] = 3 ≤ neighbours ≤ 4
                else
                    target[I] = neighbours == 3
                end
            end

            target,D = D,target

        end
        return D
    end


    @test simulate(BitArray(Bool[0 0 0;0 0 1; 0 1 1]), 1) == BitArray(Bool[0 0 0;0 1 1;0 1 1])
    @test count(simulate(pocketDimension(exampleLines(17,1),6), 6)) == 112

end

using AoC

@show @time count(Part1.simulate(Part1.pocketDimension(lines(17),6,2), 6))
@show @time count(Part1.simulate(Part1.pocketDimension(lines(17),6), 6))
@show @time count(Part1.simulate(Part1.pocketDimension(lines(17),6,4), 6))
