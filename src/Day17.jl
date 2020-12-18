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

    function setDimension(A, dimensions)
        resultDims = extend(size(A), dimensions)
        origin = Tuple(ones(Int, dimensions))
        result = similar(A, resultDims)
        for I in CartesianIndices(A)
            result[extend(I, dimensions)] = A[I]
        end
        return result
    end
    pocketDimension(lines::Vector, turnHint, dimensions=3)::BitArray = setDimension(BitArray([lines[i][j] =='#' for i=1:length(lines), j=1:length(lines[1])]), dimensions)

    @test pocketDimension(["#"],1) == ones(1,1,1)

    function simulate(D::BitArray, rounds)
        oneT = Tuple(ones(Int, ndims(D)))
        one = CartesianIndex(oneT)
        two = one+one

        for round in 1:rounds
            @show round
            target = falses(size(D) .+ 2 .* oneT)

            for I in CartesianIndices(target)
                neighbours=count(D[filter(i->checkbounds(Bool, D, i) && D[i], (I-two):(I))])

                if D[I-one]
                    target[I] = 3 ≤ neighbours ≤ 4
                else
                    target[I] = neighbours == 3
                end
            end

            D = target

        end
        return D
    end


    @test simulate(BitArray(Bool[0 0 0;0 0 1; 0 1 1]), 1)[2:4,2:4] == BitArray(Bool[0 0 0;0 1 1;0 1 1])
    @test count(simulate(pocketDimension(exampleLines(17,1),6), 6)) == 112

end

using AoC

@show @time count(Part1.simulate(Part1.pocketDimension(lines(17),6,2), 6))
@show @time count(Part1.simulate(Part1.pocketDimension(lines(17),6), 6))
@show @time count(Part1.simulate(Part1.pocketDimension(lines(17),6,4), 6))
