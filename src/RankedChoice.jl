module RankedChoice

export Poll, vote!, votes, rounds

#-----------------------------------------------------------------------------# Poll
struct Poll
    prompt::String
    candidates::Vector{String}
    ballots::Vector{Vector{Int}}
end
Poll(prompt::String, candidates::Vector{String}) = Poll(prompt, candidates, Vector{Int}[])

vote!(p::Poll, v::AbstractVector{Int}) = (push!(p.ballots, v); p)

function vote!(p::Poll, v::AbstractVector{String})
    @assert all(c -> c in p.candidates, v)
    vote!(p, findfirst.(isequal.(v), p.candidates))
end

function votes(p::Poll, set = Set(1:length(p.candidates)))
    map(p.ballots) do x
        i = findfirst(j -> j in set, x)
        isnothing(i) ? nothing : x[i]
    end
end

function rounds(p::Poll)
    n = length(p.candidates)
    set = Set(1:n)
    out = Vector{Int}[]
    for _ in 1:n
        vts = votes(p, set)
        counts = [sum(vts .== i) for i in 1:n]
        push!(out, counts)
        any(counts .> length(vts) / 2) && break
        _mincount = minimum(counts[i] for i in set)
        for loser in findall(counts .== _mincount)
            delete!(set, loser)
        end
    end
    return out
end


end
