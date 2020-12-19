#=
day19:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-19
=#

module Part1

    using Test

    function readprotorules(file)
        protorules = Dict{Int, Rule}()
        while true
            line = readline(file)
            if line == ""
                break
            end
            push!(protorules, protorulepair(line))
        end
        return protorules
    end

    abstract type Rule; end
    struct LiteralRule <: Rule
        text::AbstractString
    end
    struct ProtoRefRule <: Rule
        key::Int
    end
    struct RefRule <: Rule
        key::Int
        rules::Dict{Int, Rule}
    end
    struct ConcatRule <: Rule
        left::Rule
        right::Rule
    end
    struct OptionRule <: Rule
        rules::Vector{Rule}
    end
    OptionRule(itr) = OptionRule(Vector{Rule}(itr))

    function protorulepair(s)
        key,remainder = strip.(split(s, ":"; limit=2))
        return parse(Int, key) => protorule(remainder)
    end
    function protorule(s)
        options = strip.(split(s, "|"))
        if length(options) == 1
            parts = split(options[1], " ")
            if length(parts) == 1
                part = parts[1]
                if part[1]=='"'
                    return literalrule(part)
                else
                    return protorefrule(part)
                end
            else
                return concatrule(protorule.(parts))
            end
        else
            return OptionRule(protorule.(options))
        end
    end

    literalrule(part) = LiteralRule(part[2:length(part)-1])
    protorefrule(part) = ProtoRefRule(parse(Int, part))
    concatrule(parts) = length(parts) == 1 ? parts[1] : ConcatRule(parts[1], concatrule(parts[2:end]))

    function resolve(rules::Dict)
        result = Dict{Int, Rule}()
        for rulepair in rules
            push!(result, rulepair.first => resolve(rulepair.second, result))
        end
        return result[0]
    end

    resolve(rule::LiteralRule, target) = rule
    resolve(rule::OptionRule, target) = OptionRule([resolve(r, target) for r in rule.rules])
    resolve(rule::ConcatRule, target) = ConcatRule(resolve(rule.left, target), resolve(rule.right, target))
    resolve(rule::ProtoRefRule, target) = RefRule(rule.key, target)

    mid(s, start) = length(s) ≥ start ? s[start:end] : ""

    function match(rule::LiteralRule, text, ::Any)
        matches = startswith(text, rule.text)
        if matches
            return [mid(text, length(rule.text) + 1)]
        else
            return []
        end
    end
    function match(rule::RefRule, text, stack)
        return match(rule.rules[rule.key], text, stack)
    end
    function match(rule::OptionRule, text, stack)
        return rule.rules |> rules->map(r->match(r,text,stack), rules) |> results->vcat(results...)
    end

    function handleStack(f, d, stack::Vector{T}, entry::T) where T
        if any(x->x==entry, stack)
            return d
        else
            push!(stack, entry)
            try
                return f()
            finally
                pop!(stack)
            end
        end
    end

    function match(rule::ConcatRule, text, stack)
        handleStack([], stack, rule) do
            lhsremainders = match(rule.left, text, stack)
            return map(lhsremainders) do remainder
                return match(rule.right, remainder)
            end |> results->vcat(results...)
        end
    end
    match(rule, text) = match(rule, text, [])


    countmatches(rule, file) = count(eachline(file)) do line
        return any(r->r == "", match(rule, line))
    end

    checkfile(filename::AbstractString, extras=[]) = open(f->checkfile(f,extras), filename)
    function checkfile(file, extras=[])
        protorules = readprotorules(file)
        for pair in extras
            protorules[pair.first] = pair.second
        end
        rule = resolve(protorules)
        return countmatches(rule, file)
    end

    @test match(resolve(Dict(protorulepair.(["0: 1", "1: 2 | 2 1","2: \"a\""]))),"a") == [""]
    @test match(resolve(Dict(protorulepair.(["0: 1", "1: 2 | 2 1","2: \"a\""]))),"aa") ∋ ""
    @test match(resolve(Dict(protorulepair.(["0: 1", "1: 2 | 1 2","2: \"a\""]))),"aa") ∋ ""

    @test checkfile("src/day19-example-1.txt") == 2
    @test checkfile("src/day19-example-2.txt") == 3
    @test checkfile("src/day19-example-2.txt", protorulepair.(["8: 42 | 42 8", "11: 42 31 | 42 11 31"])) == 12

end

@show @time Part1.checkfile("src/day19-input.txt")
@show @time Part1.checkfile("src/day19-input.txt", Part1.protorulepair.(["8: 42 | 42 8", "11: 42 31 | 42 11 31"]))