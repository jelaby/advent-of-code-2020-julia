#=
day25:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-25
=#




module Part1


    using Test, AoC

    function transform(subjectNumber, loopSize)
        part = subjectNumber % 20201227
        result = 1
        for bit in 1:floor(Int, log2(loopSize)) + 1
            if loopSize & (1<<(bit-1)) ≠ 0
                result = (result * part) % 20201227
            end
            part = (part ^ 2) % 20201227
        end
        return result
    end
    @test transform(7, 11) == 17807724
    @test transform(7, 8) == 5764801

    function recoverLoopSize(publicKey, subjectNumber)
        loopSize = 1
        waypoint = 1
        while transform(subjectNumber, loopSize) != publicKey
            if loopSize == waypoint
                @show loopSize
                waypoint = waypoint * 10
            end
            loopSize += 1
        end
        return loopSize
    end

    recoverEncryptionKey(doorKey, cardKey) = transform(doorKey, recoverLoopSize(cardKey, 7))

    @test recoverLoopSize(5764801, 7) == 8
    @test recoverLoopSize(17807724, 7) == 11

    @test recoverEncryptionKey(5764801, 17807724) == 14897079
    @test recoverEncryptionKey(17807724, 5764801) == 14897079

    export recoverEncryptionKey

end

using .Part1

println("Starting...")
@show recoverEncryptionKey(1717001, 523731)