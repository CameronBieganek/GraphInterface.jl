
module GraphInterface

export add_edge!,
    add_edges!,
    add_vertex!,
    add_vertices!,
    add_weighted_edge!,
    add_weighted_edges!,
    edges,
    ne,
    neighbors,
    nv,
    rem_edge!,
    rem_edges!,
    rem_vertex!,
    rem_vertices!,
    vertices

function vertices end

function edges end

function neighbors end

ne(g) = length(edges(g))
nv(g) = length(vertices(g))

function nv end

function add_vertex! end

function add_vertices!(g, vs)
    for v in vs
        add_vertex!(g, v)
    end
    g
end

function add_weighted_edge! end

add_edge!(g, u, v) = add_weighted_edge!(g, u, v, 1.0)

function add_edges!(g, es)
    for e in es
        add_edge!(g, e)
    end
    g
end

function add_weighted_edges!(g, weighted_edges)
    for (u, v, w) in weighted_edges
        add_weighted_edge!(g, u, v, w)
    end
    g
end

function rem_vertex! end

function rem_vertices!(g, vs)
    for v in vs
        rem_vertex!(g, v)
    end
    g
end

function rem_edge! end

function rem_edges!(g, es)
    for e in es
        rem_edge!(g, e)
    end
    g
end

end
