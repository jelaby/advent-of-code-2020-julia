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

    function dangerousingredientlist(inputs)

        safe = safefoods(inputs)

        @show allAllergens = Set(reduce(∪, map(i->i.allergens, inputs)))
        allIngredients = Set(reduce(∪, map(i->i.ingredients, inputs)))

        allergenMap = Dict()

#=
        while length(allergenMap) != length(allAllergens)
            for input in inputs
                maybeUnsafe = setdiff(input.ingredients, safe)
                allergenCandidates = setdiff(input.allergens, keys(allergenMap))
                @show input, maybeUnsafe, allergenCandidates
                if length(maybeUnsafe) == 1 && length(allergenCandidates) == 1
                    allergenMap[allergenCandidates[1]] = maybeUnsafe[1]
                end
            end
            @show allergenMap
        end
        =#

        while length(allergenMap) != length(allAllergens)
        for allergen in allAllergens
            candidates = copy(allIngredients)
            for input in inputs
                if allergen ∈ input.allergens
                    candidates = candidates ∩ input.ingredients
                end
            end
            if length(candidates) == 1
                @show allergen, candidates
                allergenMap[allergen] = [candidates...][1]
                setdiff!(allIngredients, candidates)
            end
        end
        end

        return join([allergenMap[allergen] for allergen in sort([allAllergens...])], ",")


    end

    @test AoC.exampleLines(21,1) .|> parseinput |> safefoods == Set(["kfcds", "nhms", "sbzzf", "trh"])
    @test AoC.exampleLines(21,1) .|> parseinput |> safecount == 5
    @test AoC.exampleLines(21,1) .|> parseinput |> dangerousingredientlist == "mxmxvkd,sqjhc,fvjkl"

    export parseinput, safefoods, safecount, dangerousingredientlist

end

using AoC, .Part1

@show AoC.lines(21) .|> parseinput |> safecount
@show AoC.lines(21) .|> parseinput |> dangerousingredientlist