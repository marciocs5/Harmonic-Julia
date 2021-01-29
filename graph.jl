include("set.jl")

mutable struct myGraph
    n::Integer
    edges::Array{myBitSet}

    function myGraph(x)
        vec = [myBitSet(x) for i = 1:x]
        return new(x, vec)
    end
end

function readGraph(f)
    g = myGraph(0)
    for l in eachline(f)
        println(l)

        q = split(l, " ")

        #for i in 1:length(q)
        #    println(q[i])
        #end

        a = q[1]
        if a == "p"

            #println("OK!")

            n = parse(Int64, q[3])
            g = myGraph(n)
        elseif a == "e"
            addEdge(g, parse(Int64, q[2]), parse(Int64, q[3]))
        else
        end
    end
    return g
end

function addEdge(g::myGraph, v, u)
    add(g.edges[v], u)
    add(g.edges[u], v)
end

function removeEdge(g::myGraph, v, u)
    remove(g.edges[v], u)
    remove(g.edges[u], v)
end

function hasEdge(g::myGraph, v, u)
    return isIn(g.edges[v], u)
end

function degree(g::myGraph, v)
    return g.edges[v].count()
end

function getNeig(g::myGraph, v)
    p = myBitSet(g.n)
    myCopy(g.edges[v], p)
    p.elems[v] = false
    return p
end

function getAnti(g::myGraph, v)
    p = myBitSet(g.n)
    compl(g.edges[v], p)
    p.elems[v] = false
    return p
end

function printGraph(g::myGraph)
    println("Grafo com |V(G)|=", g.n)
    for i = 1:g.n
        print("N(", i, ") = ")
        printSet(g.edges[i])
    end
end

function N2(g::myGraph)
    h = myGraph(g.n)

    for i = 1:g.n
        for j = 1:g.n
            for k = 1:g.n
                if hasEdge(g, i, j) & hasEdge(g, j, k) & (i != j) & (j != k) & (i != k)
                    addEdge(h, i, k)
                end
            end
        end
    end
    return h
end

#f = open("/home/marcio/Dropbox/WORK/code/Harmonic-Julia/grafo1.col")
#g = readGraph(f)
#printGraph(g)
#h = N2(g)
#printGraph(h)
