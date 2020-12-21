#=
day21:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-21
=#

module Part1

    using Test, AoC

    struct Input
        ingredients
        allergens
    end

    parseinput(ingredients, allergens) = Input(split(ingredients, " "), split(allergens, ", "))
    parseinput(line) = parseinput(match(r"(.*) \(contains (.*)\)", line).captures...)

    function safefoods(inputs)

        allergenIngredients = Dict()
        allIngredients = Set()

        for input in inputs
            push!(allIngredients, input.ingredients...)
            for allergen in input.allergens
                possibilities = get(allergenIngredients, allergen) do
                    Set(input.ingredients)
                end
                allergenIngredients[allergen] = possibilities ∩ input.ingredients
            end
        end

        @show allMaybeAllergenic = reduce(∪, values(allergenIngredients))

        return setdiff(allIngredients, allMaybeAllergenic)
    end

    function safecount(inputs)
        safe = safefoods(inputs)

        total = 0
        for input in inputs
            total += length(input.ingredients ∩ safe)
        end
        return total;
    end

    @test AoC.exampleLines(21,1) .|> parseinput |> safefoods == Set(["kfcds", "nhms", "sbzzf", "trh"])
    @test AoC.exampleLines(21,1) .|> parseinput |> safecount == 5

    export parseinput, safefoods, safecount

end

using AoC, .Part1

@show AoC.lines(21) .|> parseinput |> safecount
