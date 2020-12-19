#=
day19:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-19
=#

module Part1

    using Test

    function readrules(file)
        protorules = Dict{Int, Rule}()
        while true
            line = readline(file)
            if line == ""
                break
            end
            push!(protorules, protorulepair(line))
        end
        return resolve(protorules)
    end

    abstract type Rule; end
    struct LiteralRule <: Rule
        text::AbstractString
    end
    struct ProtoRefRule <: Rule
        key::Int
    end
    struct ConcatRule <: Rule
        rules::Vector{Rule}
    end
    ConcatRule(itr) = ConcatRule(Vector{Rule}(itr))
    struct OptionRule <: Rule
        rules::Vector{Rule}
    end
    OptionRule(itr) = OptionRule(Vector{Rule}(itr))

    function protorulepair(s)
        @show s
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
                return ConcatRule(protorule.(parts))
            end
        else
            return OptionRule(protorule.(options))
        end
    end

    literalrule(part) = LiteralRule(part[2:length(part)-1])
    protorefrule(part) = ProtoRefRule(parse(Int, part))

    struct MatchResult
        matches::Bool
        remainder::AbstractString
    end

    resolve(rules::Dict) = resolve(rules[0], rules)
    resolve(rule::LiteralRule, rules) = rule
    resolve(rule::OptionRule, rules) = OptionRule([resolve(r, rules) for r in rule.rules])
    resolve(rule::ConcatRule, rules) = ConcatRule([resolve(r, rules) for r in rule.rules])
    resolve(rule::ProtoRefRule, rules) = resolve(rules[rule.key], rules)

    mid(s, start) = length(s) ≥ start ? s[start:end] : ""

    function match(rule::LiteralRule, text)
        matches = startswith(text, rule.text)
        if matches
            return MatchResult(matches, mid(text, length(rule.text) + 1))
        else
            return MatchResult(matches, text)
        end
    end
    function match(rule::OptionRule, text)
        for r in rule.rules
            result = match(r, text)
            if result.matches
                return result
            end
        end
        return MatchResult(false, text)
    end
    function match(rule::ConcatRule, text)
        remainder = text
        for r in rule.rules
            result = match(r, remainder)
            if !result.matches
                return MatchResult(false, text)
            end
            remainder = result.remainder
        end
        return MatchResult(true, remainder)
    end

    countmatches(rule, file) = count(eachline(file)) do line
        result = match(rule, line)
        return result.matches && result.remainder == ""
    end

    checkfile(filename::AbstractString) = open(checkfile, filename)
    function checkfile(file)
        rule = readrules(file)
        return countmatches(rule, file)
    end


    @test checkfile("src/day19-example-1.txt") == 2

end

@show Part1.checkfile("src/day19-input.txt")