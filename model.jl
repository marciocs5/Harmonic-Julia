include("graph.jl")
include("set.jl")

using JuMP
using Gurobi


function repFormulation(g::myGraph)
    env = Gurobi.Env()
    #md = Model(solver = GurobiSolver(TimeLimit=params.maxtime,MIPGap=params.tolgap,CliqueCuts=0, CoverCuts=0, FlowCoverCuts=0,FlowPathCuts=0,MIRCuts=0,NetworkCuts=0,GomoryPasses=0,NodeLimit=params.maxnodes))
    md = Model(solver = GurobiSolver())
    h = N2(g)

    #variables
    @variable(md, x[i=1:g.n, j=1:g.n; !hasEdge(h, i, j) ] , Bin)

    #representative constraint
    for v in 1:h.n
        lst = [u for u in 1:g.n if (!hasEdge(h, u, v))]
        @constraint(md, sum(x[y, v] for y in lst) >= 1)
    end


    #stable set constraints
    for v in 1:h.n
        for u in toList(getAnti(h, v))
            @constraint(md, x[v,u] <=  x[v,v])
            for w in toList(getAnti(h, v))
                if(w!= u && hasEdge(h, u, w))
                    @constraint(md, x[v,u] + x[v,w] <= x[v,v])
                end
            end
        end
    end

    #edge restriction for diferent vertices
    for v in 1:h.n
        for u in v+1:h.n
            for v1 in toList(getAnti(h, v))
                for v2 in toList(getAnti(h, v))
                    if (v1 < v2) & (v1 != u) & (v2 != u)
                        for u1 in toList(getAnti(h, u))
                            for u2 in toList(getAnti(h, u))
                                if (u1 < u2) & (u1 != v) & (u2 != v) & (u1 != v1) & (u1 != v2) & (u2 != v1) & (u2 != v2)

                                    if hasEdge(g, v1, u1) & hasEdge(g, v2, u2)
                                        @constraint(md, x[v,v1] + x[v,v2] + x[u,u1] + x[u,u2] <= 3)
                                    end

                                end
                            end
                        end
                    end
                end
            end
        end
    end

    #objective function
    @objective(md, Min, sum(x[i, i] for i = 1:g.n))

    return md
end


function BCFormulation(g::myGraph)
    env = Gurobi.Env()
    #md = Model(solver = GurobiSolver(TimeLimit=params.maxtime,MIPGap=params.tolgap,CliqueCuts=0, CoverCuts=0, FlowCoverCuts=0,FlowPathCuts=0,MIRCuts=0,NetworkCuts=0,GomoryPasses=0,NodeLimit=params.maxnodes))
    md = Model(solver = GurobiSolver())
    h = N2(g)

    #variables
    @variable(md, x[i=1:g.n, j=1:g.n; !hasEdge(h, i, j) ] , Bin)

    #representative constraint
    for v in 1:h.n
        lst = [u for u in 1:g.n if (!hasEdge(h, u, v))]
        @constraint(md, sum(x[y, v] for y in lst) >= 1)
    end


    #stable set constraints
    for v in 1:h.n
        for u in toList(getAnti(h, v))
            @constraint(md, x[v,u] <=  x[v,v])
            for w in toList(getAnti(h, v))
                if(w!= u && hasEdge(h, u, w))
                    @constraint(md, x[v,u] + x[v,w] <= x[v,v])
                end
            end
        end
    end

    #edge restriction for diferent vertices
    for v in 1:h.n
        for u in v+1:h.n
            for v1 in toList(getAnti(h, v))
                for v2 in toList(getAnti(h, v))
                    if (v1 < v2) & (v1 != u) & (v2 != u)
                        for u1 in toList(getAnti(h, u))
                            for u2 in toList(getAnti(h, u))
                                if (u1 < u2) & (u1 != v) & (u2 != v) & (u1 != v1) & (u1 != v2) & (u2 != v1) & (u2 != v2)

                                    if hasEdge(g, v1, u1) & hasEdge(g, v2, u2)
                                        @constraint(md, x[v,v1] + x[v,v2] + x[u,u1] + x[u,u2] <= 3)
                                    end

                                end
                            end
                        end
                    end
                end
            end
        end
    end

    #objective function
    @objective(md, Min, sum(x[i, i] for i = 1:g.n))


    usercuts = 0


    function STABsep(cb)
        TOL = 0.01
        x_val = getvalue(x)
        println(x_val)
        #@addusercut(cb, y + x <= 3)
    end

    addcutcallback(md, STABsep)

    return md
end


#f = open("/home/marcio/Dropbox/WORK/code/Harmonic-Julia/grafo1.col")
#g = readGraph(f)
#printGraph(g)

#mdl = repFormulation(g)

#print(mdl)

#solve(mdl)

#bestsol = getobjectivevalue(mdl)
#bestbound = getobjbound(mdl)
#opengap = getobjgap(mdl)
#elapsedtime = getsolvetime(mdl)
#solvernodes = getnodecount(mdl)
#println("bestsol = ", bestsol)
#println("Elapsed = ", elapsedtime)
