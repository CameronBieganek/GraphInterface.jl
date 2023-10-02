

# GraphInterface.jl

GraphInterface.jl defines an abstract interface for undirected and directed graphs in Julia.
The interface described in this repository is a proposal for the interface in Graphs.jl version
2.0.


## The `AbstractGraph` interface

An object satisfies the `AbstractGraph` interface if it subtypes `AbstractGraph` and implements
the following methods:

Base methods:
- `empty`
  - `empty(g::AbstractGraph)` must return a graph of the same type as `g` that contains no
    vertices or edges.

GraphInterface methods:
- `vertices`
- `edges`
- `neighbors`
- `add_vertex!`
- `add_edge!`
- `rem_vertex!`
- `rem_edge!`

Further information on the requirements of the above methods can be found in the docstrings.
In particular, the iterators returned by `vertices` and `edges` must have methods for the
following functions:

- `Base.length`
- `Base.eltype`
- `Base.in`

GraphInterface also provides an abstract edge type, `AbstractEdge`. It is required that
`eltype(edges(g))` must be a subtype of `AbstractEdge`. To test for the existence of a vertex
`v` or an edge `e` in the graph `g`, one can use `v in vertices(g)` or `e in edges(g)`,
respectively.


## Edge weights

An object that satisfies the `AbstractGraph` interface must have a public `weight` property
via which one can get and set edge weights. The interface for this property is as follows:

- Given a graph `g` and an edge `e`, get the weight of edge `e` via `g.weight[e]`.
- Given a graph `g` and an edge defined by the vertices `u` and `v`, get the edge weight
  via `g.weight[u, v]`.
- Given a graph `g`, an edge `e`, and a weight `w`, set the weight of edge `e` via
  `g.weight[e] = w`.
- Given a graph `g`, an edge defined by the vertices `u` and `v`, and a weight `w`, set the
  edge weight via `g.weight[u, v] = w`.


## Directed graphs

So far, the `AbstractGraph` interface has only been fully developed for undirected graphs.
Adding directed graphs to the interface would likely involve adding a few more methods to the
interface, such as `is_directed`, `in_neighbors`, and `out_neighbors`.


## Discussion

Graphs that implement the `AbstractGraph` interface must allow any vertex type. The vertex type
for a graph object `g` can be determined from `eltype(vertices(g))` (there is a convenience method
for this called `vertex_type`). This type can, of course, be `Any` if the graph implementer
so chooses.

Vertex and edge metadata are not needed for writing generic graph algorithms, so they are
explicitly excluded from the `AbstractGraph` interface. Graph types are, of course, free to
implement their own interface for metadata if they so choose.

All graphs that implement the `AbstractGraph` interface are mutable, since they all must implement
`add_vertex!`, `add_edge!`, `rem_vertex!`, and `rem_edge!` and must have mutable edge weights.

During the development of this interface, multigraphs and hypergraphs were considered, but it
was decided that including support for multigraphs and hypergraphs in this interface was too
complicated for the time being.


## Example

The [GraphTypes.jl](https://github.com/CameronBieganek/GraphTypes.jl) package implements the
`Graph` type, which is an undirected graph that satisfies the `AbstractGraph` interface described
in this repository. Below is a Julia REPL session with an example of using the `Graph`:

```julia
julia> using GraphTypes

julia> g = Graph{Char}()
Graph:
    Vertex type: Char
    Number of vertices: 0
    Number of edges: 0

julia> add_vertex!(g, 'a')
Graph:
    Vertex type: Char
    Number of vertices: 1
    Number of edges: 0

julia> add_edge!(g, 'b', 'c')
Graph:
    Vertex type: Char
    Number of vertices: 3
    Number of edges: 1

julia> add_edge!(g, Edge("cd"))
Graph:
    Vertex type: Char
    Number of vertices: 4
    Number of edges: 2

julia> collect(vertices(g))
4-element Vector{Char}:
 'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)
 'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)
 'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)
 'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)

julia> collect(edges(g))
2-element Vector{Edge{Char}}:
 c -- d
 b -- c

julia> 'a' in vertices(g)
true

julia> Edge("bc") in edges(g)
true

julia> g.weight['b', 'c']
1.0

julia> neighbors(g, 'c')
Neighbors: {d, b}

julia> e = first(edges(g))
Edge:
    c -- d

julia> u, v = e;

julia> u
'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)

julia> v
'd': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)
```
