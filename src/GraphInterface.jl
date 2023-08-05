
module GraphInterface

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

end
