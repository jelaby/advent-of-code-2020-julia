#=
day11:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-11
=#


import AoC
using Test

@enum SeatState floor=Int('.') empty=Int('L') occupied=Int('#')
SeatState(s::AbstractChar) = SeatState(Int(s))
isOccupied(seat::SeatState) = seat == occupied
isFloor(seat::SeatState) = seat == floor
isEmpty(seat::SeatState) = seat == empty

seatPlan(plan::Vector) = [SeatState(plan[i][j]) for i in 1:length(plan), j in 1:length(plan[1])]
@test seatPlan([".L","#."]) == [floor empty;occupied floor]

string(seat::SeatState) = String(Uint8(seat))
string(plan::Array{SeatState}) = (*)(string.(plan))

offsets=[CartesianIndex(x,y) for x in -1:1, y in -1:1 if x ≠ 0 || y ≠ 0]

countOccupied(plan, i) = count(o->isOccupied(get(plan, i+o, floor)), offsets)
@test countOccupied([occupied occupied occupied;occupied occupied occupied], CartesianIndex(1,2)) == 5

function calculateSeat(seat::SeatState, plan, i)
    if isFloor(seat)
        return floor
    elseif isEmpty(seat) && countOccupied(plan, i) == 0
        return occupied
    elseif isOccupied(seat) && countOccupied(plan, i) ≥ 4
        return empty
    else
        return seat
    end
end

function calculateOccupation(plan::Array)
    newPlan = copy(plan)
    for i in CartesianIndices(plan)
        newPlan[i] = calculateSeat(plan[i], plan, i)
    end
    return newPlan
end
@test calculateOccupation([empty empty; empty empty]) == [occupied occupied;occupied occupied]
@test calculateOccupation([occupied occupied; occupied occupied]) == [occupied occupied;occupied occupied]
@test calculateOccupation([occupied occupied occupied; occupied occupied occupied]) == [occupied empty occupied;occupied empty occupied]
@test calculateOccupation(seatPlan(AoC.exampleLines(11,1))) == seatPlan(AoC.exampleLines(11,2))
@test calculateOccupation(seatPlan(AoC.exampleLines(11,2))) == seatPlan(AoC.exampleLines(11,3))

function findSteadyState(plan)
    newPlan = calculateOccupation(plan)
    if (plan == newPlan)
        return plan
    else
        return findSteadyState(newPlan)
    end
end

occupiedSeats(plan::Vector) = count(isOccupied, findSteadyState(seatPlan(plan)))

println("Testing...")
@test occupiedSeats(["."]) == 0
@test occupiedSeats(["L"]) == 1
@test occupiedSeats(["#"]) == 1
@test occupiedSeats(["..",".."]) == 0
@test occupiedSeats(AoC.exampleLines(11,1)) == 37
println("Starting...")
@show @time occupiedSeats(AoC.lines(11))