
module GraphInterface


export AbstractGraph,
    AbstractDirectedEdge,
    AbstractEdge,
    AbstractUndirectedEdge,
    add_edge!,
    add_edges!,
    add_vertex!,
    add_vertices!,
    add_weighted_edges!,
    edge_type,
    edges,
    ne,
    neighbors,
    nv,
    rem_edge!,
    rem_edges!,
    rem_vertex!,
    rem_vertices!,
    set_weight!,
    vertex_type,
    vertices,
    weight


"""
    AbstractGraph

An abstract type representing a graph. The vertex type and edge type of a graph `g` can be
retrieved with `vertex_type(g)` and `edge_type(g)`, respectively. The methods that must be
implemented to satisfy the `AbstractGraph` interface are the following:

`Base` methods:
- `empty`

`GraphInterface` methods:
- `vertices`
- `edges`
- `neighbors`
- `add_vertex!`
- `add_edge!`
- `rem_vertex!`
- `rem_edge!`

In addition, a graph `g` that satisfies the `AbstractGraph` interface must have a `weight`
property that supports `Base.getindex` and `Base.setindex!`. Thus, the weight of an edge
in `g` can be set using `g.weight[u, v] = w`, and the weight can be retrieved via
`g.weight[u, v]`, where `u` and `v` are vertices.
"""
abstract type AbstractGraph end


"""
    AbstractEdge

An abstract type representing an edge in a graph. The vertices connected by the edge can be
retrieved via iteration, so if `e` is an edge, than the connected vertices can be retrieved
via `u, v = e`.
"""
abstract type AbstractEdge end


"""
    AbstractUndirectedEdge

An abstract type representing an undirected edge in a graph. For an undirected edge, the order
in which the connected vertices is specified is immaterial. So, for instance, if
`Edge <: AbstractUndirectedEdge`, then we must have `Edge(1, 2) == Edge(2, 1)`.
"""
abstract type AbstractUndirectedEdge <: AbstractEdge end


"""
    AbstractDirectedEdge

An abstract type representing a directed edge in a graph. For a directed edge, the order in
which the connected vertices is specified is important. So, for instance, if
`DiEdge <: AbstractDirectedEdge`, then `DiEdge(1, 2) != DiEdge(2, 1)`.
"""
abstract type AbstractDirectedEdge <: AbstractEdge end


"""
    vertices(g::AbstractGraph)

Create an iterator that iterates all the vertices in the graph `g`. The number of vertices in
`g` can be obtained by applying `Base.length` to the vertex iterator, e.g. `length(vertices(g))`,
and the vertex type for `g` can be obtained by applying `Base.eltype` to the vertex iterator,
e.g. `eltype(vertices(g))`.

To test whether the graph `g` contains the vertex `v`, apply `Base.in`, e.g. `v in vertices(g)`.
"""
function vertices end


"""
    edges(g::AbstractGraph)

Create an iterator that iterates all the edges in the graph `g`. The number of edges in `g` can
be obtained by applying `Base.length` to the edge iterator, e.g. `length(edges(g))`, and the edge
type for `g` can be obtained by applying `Base.eltype` to the edge iterator,
e.g. `eltype(edges(g))`. The element type of `edges(g)` is guaranteed to be a
subtype of `AbstractEdge`.

To test whether the graph `g` contains the edge `e`, apply `Base.in`, e.g. `e in edges(g)`.
"""
function edges end


"""
    neighbors(g::AbstractGraph, v)

Create an iterator over all the neighbors of the vertex `v` in the graph `g`.
"""
function neighbors end


"""
    nv(g::AbstractGraph)

Get the number of vertices in the graph `g`. This is a convenience method provided by
`GraphInterface` that is defined as `nv(g::AbstractGraph) = length(vertices(g))`.
"""
nv(g::AbstractGraph) = length(vertices(g))


"""
    ne(g::AbstractGraph)

Get the number of edges in the graph `g`. This is a convenience method provided by
`GraphInterface` that is defined as `ne(g::AbstractGraph) = length(edges(g))`.
"""
ne(g::AbstractGraph) = length(edges(g))


"""
    vertex_type(g::AbstractGraph)

Get the vertex type for the graph `g`. This is a convenience method provided by
`GraphInterface` that is defined as `vertex_type(g::AbstractGraph) = eltype(vertices(g))`.
"""
vertex_type(g::AbstractGraph) = eltype(vertices(g))


"""
    edge_type(g::AbstractGraph)

Get the edge type for the graph `g`. This is a convenience method provided by
`GraphInterface` that is defined as `edge_type(g::AbstractGraph) = eltype(edges(g))`.
"""
edge_type(g::AbstractGraph) = eltype(edges(g))


"""
    add_vertex!(g::AbstractGraph, v)

If the vertex `v` is not in the graph `g`, then add it to `g`, otherwise do nothing. This is
guaranteed to succeed as long as the following is true:

```julia
isequal(convert(vertex_type(g), v), v)
```

Thus, `v` must be convertible to the vertex type of graph `g` *and* the result of the conversion
must be `isequal` to `v`. Thus, if `g` has vertex type `Int`, then `add_vertex!(g, 'a')` will
fail, because `isequal(97, 'a')` returns `false`.

Returns the graph `g` (after adding `v`).
"""
function add_vertex! end


"""
    add_vertices!(g::AbstractGraph, vs)

Add the vertices in the iterator `vs` to the graph `g`. This is a convenience method provided
by `GraphInterface` that works by repeatedly applying `add_vertex!` to the contents of `vs`.

Returns the graph `g` (after adding the vertices `vs`).
"""
function add_vertices!(g::AbstractGraph, vs)
    for v in vs
        add_vertex!(g, v)
    end
    g
end


"""
    add_edge!(g::AbstractGraph, u, v[, w::Number=1])

If the edge that connects the vertices `u` and `v` is not in the graph `g`, then add it to `g`,
with an edge weight of `w`, otherwise do nothing. This is guaranteed to succeed, as long as
the following is true for `u` (and similarly for `v`):

```julia
isequal(convert(vertex_type(g), u), u)
```

Thus, `u` must be convertible to the vertex type of graph `g` *and* the result of the conversion
must be `isequal` to `u`. Thus, if `g` has vertex type `Int`, then `add_edge!(g, 'a', 'b')` will
fail, because `isequal(97, 'a')` returns `false`.

If the vertices `u` and `v` are not in `g`, then they will be added to `g`.

Returns the graph `g` (after adding the edge connecting `u` and `v`).

----

    add_edge!(g::AbstractGraph, e[, w::Number=1])

If the edge `e` is not in the graph `g`, then add it to `g`, with an edge weight of `w`,
otherwise do nothing. The edge `e` must be of type `edge_type(g)`. If the vertices connected by
the edge `e` are not in `g`, then they will be added to `g`.

Returns the graph `g` (after adding the edge `e`).
"""
function add_edge! end


"""
    add_edges!(g::AbstractGraph, es)

Add the edges in the iterator `es` to the graph `g`, each with an edge weight of 1.
The element type of the iterator must be the same as the edge type for the graph,
i.e. `eltype(es) == edge_type(g)`. This is a convenience method provided by `GraphInterface`
that works by repeatedly applying `add_edge!` to the contents of `es`.

Returns the graph `g` (after adding the edges `es`).
"""
function add_edges!(g::AbstractGraph, es)
    for e in es
        add_edge!(g, e)
    end
    g
end


"""
    add_weighted_edges!(g::AbstractGraph, es)

Add the edges in the iterator `es` to the graph `g`. The elements of the iterator `es` must
themselves be iterators that return `u, v, w`, where `u` and `v` are vertices and `w` is the
edge weight. This is a convenience method provided by `GraphInterface` that works by repeatedly
applying `add_edge!` to the contents of `es`.

Returns the graph `g` (after adding the edges `es`).

# Examples

```julia
julia> add_weighted_edges!(g, [(1, 10, 3.4), (4, 7, 2.1)])
```
"""
function add_weighted_edges!(g::AbstractGraph, weighted_edges)
    for (u, v, w) in weighted_edges
        add_edge!(g, u, v, w)
    end
    g
end


"""
    rem_vertex!(g::AbstractGraph, v)

If the vertex `v` is in the graph `g`, then remove it from `g` (along with any edges that were
connected to `v`), otherwise do nothing.

Returns the graph `g` (after removing `v`).
"""
function rem_vertex! end


"""
    rem_vertices!(g::AbstractGraph, vs)

Remove the vertices in `vs` from the graph `g`. This is a convenience method provided by
`GraphInterface` that works by repeatedly applying `rem_vertex!` to the contents of `vs`.

Returns the graph `g` (after removing the vertices `vs`).
"""
function rem_vertices!(g::AbstractGraph, vs)
    for v in vs
        rem_vertex!(g, v)
    end
    g
end


"""
    rem_edge!(g::AbstractGraph, u, v)

If the edge that connects the vertices `u` and `v` is in the graph `g`, then remove it from `g`,
otherwise do nothing.

Returns the graph `g` (after removing the edge connecting `u` and `v`).

----

    rem_edge!(g::AbstractGraph, e)

If the edge `e` is in the graph `g`, then remove it from `g`, otherwise do nothing.
The edge `e` must be of type `edge_type(g)`.

Returns the graph `g` (after removing the edge `e`).
"""
function rem_edge! end


"""
    rem_edges!(g::AbstractGraph, es)

Remove the edges in `es` from the graph `g`. The elements of `es` must be of type `edge_type(g)`.
This is a convenience method provided by `GraphInterface` that works by repeatedly applying
`rem_edge!` to the contents of `es`.
"""
function rem_edges!(g::AbstractGraph, es)
    for e in es
        rem_edge!(g, e)
    end
    g
end


"""
    weight(g::AbstractGraph, u, v)

Get the weight of the edge that connects the vertices `u` and `v` in the graph `g`. Edge
weights must be subtypes of `Number`. For an undirected graph, `weight(g, u, v) == weight(g, v, u)`
must be true.

----

    weight(g::AbstractGraph, e)

Get the weight of the edge `e` in the graph `g`. The edge `e` must be of type `edge_type(g)`.
Edge weights must be subtypes of `Number`.
"""
function weight end


"""
    set_weight!(g::AbstractGraph, u, v, w::Number)

Set to `w` the weight of the edge that connects the vertices `u` and `v` in the graph `g`.

Returns the weight `w`.

----

    set_weight!(g::AbstractGraph, e, w::Number)

Set to `w` the weight of the edge `e` in the graph `g`. The edge `e` must be of type
`edge_type(g)`.

Returns the weight `w`.
"""
function set_weight! end


end
