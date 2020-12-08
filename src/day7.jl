#=
day7:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-07
=#

import AoC
using Test

exampleLines = split("light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.", "\n")

example2Lines = split("shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.", "\n")

function requireMatch(r, s)
    matches = match(r, s)
    if matches == nothing
        error(s * " does not match " * r)
    end
    return matches
end

parseContainsRule(rule) = requireMatch(r"(\d+) (.*) bags?", rule) |> c -> (c.captures[2] => parse(Int,c.captures[1]))
parseContainsRules(rules::Array) = Dict(parseContainsRule.(rules))
parseContainsRules(rules) = match(r"no other bags", rules) ≠ nothing ? Dict() : parseContainsRules(split(rules, ", "))
@test parseContainsRules(["2 shiny gold bags", "9 faded blue bags"]) == Dict("shiny gold"=>2, "faded blue"=>9)
@test parseContainsRules("no other bags") == Dict()
@test parseContainsRules("2 shiny gold bags, 9 faded blue bags") == Dict("shiny gold"=>2, "faded blue"=>9)

parseRule(rule) = requireMatch(r"(.*) bags contain (.*)\.", rule) |>
    m -> (m.captures[1] => parseContainsRules(m.captures[2]))
@test parseRule("muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.") == ("muted yellow" => Dict("shiny gold"=>2, "faded blue"=>9))
parseRules(rules::Array) = Dict(parseRule.(rules))
@test parseRules([
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags."
]) == Dict(
    "bright white" => Dict("shiny gold"=>1),
    "muted yellow" => Dict("shiny gold"=>2, "faded blue"=>9)
)



isBagInRule(rules, candidate, yourBag) = count([child.first == yourBag || isBagInRule(rules, child.first, yourBag) for child in rules[candidate]]) ≠ 0
countHoldersFor(rules::Dict, yourBag) = count([isBagInRule(rules, rule.first, yourBag) for rule in rules])
countHoldersFor(rules::Array, yourBag) = countHoldersFor(parseRules(rules), yourBag)
@test countHoldersFor(exampleLines, "shiny gold") == 4

@show countHoldersFor(AoC.lines(7), "shiny gold")


countBagsIn(rules::Dict, yourBag) = isempty(rules[yourBag]) ? 0 : sum(child -> child.second * countBagsIncluding(rules, child.first), rules[yourBag])
countBagsIncluding(rules::Dict, yourBag) = 1+countBagsIn(rules, yourBag)
countBagsIn(rules::Array, yourBag) = countBagsIn(parseRules(rules), yourBag)
@test countBagsIn(example2Lines, "shiny gold") == 126

@show countBagsIn(AoC.lines(7), "shiny gold")