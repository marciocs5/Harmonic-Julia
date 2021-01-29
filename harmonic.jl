include("graph.jl")
include("set.jl")
include("model.jl")

mutable struct Param
    filein::String
    fileout::String
end

function readParam(x)
    return Param(x[1], x[2])
end

pm = readParam(ARGS)

print(pm)

fin = open(pm.filein)
fout = open(pm.fileout, "a")

g = readGraph(fin)
printGraph(g)
close(fin)

mdl = repFormulation(g)

print(mdl)

solve(mdl)

bestsol = getobjectivevalue(mdl)
bestbound = getobjbound(mdl)
#opengap = getobjgap(mdl)
elapsedtime = getsolvetime(mdl)
solvernodes = getnodecount(mdl)
println("bestsol = ", bestsol)
println("Elapsed = ", elapsedtime)

write(fout, pm.filein)
write(fout, ";$bestsol;$bestbound;$elapsedtime;$solvernodes \n")
close(fout)
