
module GraphInterface

export add_edge!,
    add_edges!,
    add_vertex!,
    add_vertices!,
    edges,
    neighbors,
    rem_edge!,
    rem_edges!,
    rem_vertex!,
    rem_vertices!,
    vertices

function vertices end

function edges end

function neighbors end

function add_vertex! end

function add_vertices!(g, vs)
    for v in vs
        add_vertex!(g, v)
    end
end

function add_edge! end

function add_edges!(g, es)
    for e in es
        add_edge!(g, e)
    end
end

function rem_vertex! end

function rem_vertices!(g, vs)
    for v in vs
        rem_vertex!(g, v)
    end
end

function rem_edge! end

function rem_edges!(g, es)
    for e in es
        rem_edge!(g, e)
    end
end

end
