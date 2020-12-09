#=
day9:
- Julia version: 1.5.2
- Author: Paul.Mealor
- Date: 2020-12-09
=#

@show open(readlines,"src/day9-input.txt")|>l->parse.(Int,l)|>m->((m,t)->(filter(x->sum(m[x[1]:x[2]])==t,[(a,b) for a∈1:length(m)-1 for b∈a:length(m)])[1])|>x->m[x[1]:x[2]]|>x->minimum(x)+maximum(x))(m,m[filter(i->m[i]∉(m[a]+m[b] for a∈i-25:i-1,b∈i-25:i-1),26:length(m))[1]])
