#=
day12:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-12
=#

using Test
import AoC

north=[0,1]
east=[1,0]
south=[0,-1]
west=[-1,0]

left=[0 -1;1 0]
right=[0 1;-1 0]

struct Ship
    waypoint::Vector
    position::Vector
    Ship(waypoint::Vector, position::Vector) = new(waypoint, position)
end
Ship() = Ship([10,1], [0,0])

function rotate(ship, direction, degrees)
    waypoint = ship.waypoint
    for _ in 90:90:degrees
        waypoint = direction * waypoint
    end
    return Ship(waypoint, ship.position)
end

navigate(ship, direction, distance) = Ship(ship.waypoint + (distance * direction), ship.position)
navigate(ship, ::Val{:N}, arg) = navigate(ship, north, arg)
navigate(ship, ::Val{:E}, arg) = navigate(ship, east, arg)
navigate(ship, ::Val{:S}, arg) = navigate(ship, south, arg)
navigate(ship, ::Val{:W}, arg) = navigate(ship, west, arg)
navigate(ship, ::Val{:L}, arg) = rotate(ship, left, arg)
navigate(ship, ::Val{:R}, arg) = rotate(ship, right, arg)
navigate(ship, ::Val{:F}, arg) = Ship(ship.waypoint, ship.position + (arg * ship.waypoint))

instruction(t) = (Val(Symbol(t[1:1])), parse(Int, t[2:end]))

function navigate(lines)
    ship = Ship()
    for line in lines
        ship = navigate(ship, instruction(line)...)
    end
    return ship
end

manhattan(a) = sum(abs.(a))

@test navigate(AoC.exampleLines(12,1)).position == [214,-72]
@test manhattan(navigate(AoC.exampleLines(12,1)).position) == 286
@show manhattan(navigate(AoC.lines(12)).position)