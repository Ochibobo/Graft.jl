################################################# FILE DESCRIPTION #########################################################

# This file contains subtypes of the SparseGraph type. Subtypes of this type use n-dimensional arrays to store vertex and
# edge properties.

################################################# IMPORT/EXPORT ############################################################

""" Sparse Graph Interface that all graphs relying on NDSparse are required to adhere to """
abstract SparseGraph <: Graph

################################################# SPARSE GRAPH INTERFACE ###################################################

@interface data(g::SparseGraph)

@interface pmap(g::SparseGraph)

################################################ PROPERTIES INTERFACE ######################################################

listvprops(g::SparseGraph) = vprops(pmap(g))

listeprops(g::SparseGraph) = eprops(pmap(g))

function getvprop(g::SparseGraph, v::VertexID) # Messy
   vdata = data(g)[v, 0, :]
   [itovprop(pmap(g), t[3]) => vdata[t...] for t in vdata.indexes]
end

function getvprop(g::SparseGraph, v::VertexID, propid::PropID)
   data(g)[v, 0, propid]
end

function getvprop(g::SparseGraph, v::VertexID, propname::PropName)
   data(g)[v, 0, vproptoi(g.pmap, propname)]
end

function geteprop(g::SparseGraph, u::VertexID, v::VertexID)
   edata = data(g)[u, v, :]
   [itoeprop(pmap(g), t[3]) => edata[t...] for t in edata.indexes]
end

function geteprop(g::SparseGraph, u::VertexID, v::VertexID, propid::PropID)
   data(g)[u,v,propid]
end

function geteprop(g::SparseGraph, u::VertexID, v::VertexID, propname::PropName)
   data(g)[u, v, eproptoi(g.pmap, propname)]
end


function setvprop!{K<:PropName,V<:Any}(g::SparseGraph, v::VertexID, props::Dict{K,V})
   for (key,val) in props
      setvprop!(g, v, key, val)
   end
end

function setvprop!(g::SparseGraph, v::VertexID, propid::PropID, val::Any)
   setindex!(data(g), val, v, 0, propid)
   nothing
end

function setvprop!(g::SparseGraph, v::VertexID, propname::PropName, val::Any)
   setindex!(data(g), val, v, 0, vproptoi(g.pmap, propname))
   nothing
end

function seteprop!{K<:PropName,V<:Any}(g::SparseGraph, u::VertexID, v::VertexID, props::Dict{K,V})
   for (key,val) in props
      seteprop!(g, u, v, key, val)
   end
end

function seteprop!(g::SparseGraph, u::VertexID, v::VertexID, propid::PropID, val::Any)
   setindex!(data(g), val, u, v, propid)
   nothing
end

function seteprop!(g::SparseGraph, u::VertexID, v::VertexID, propname::PropName, val::Any)
   setindex!(data(g), val, u, v, eproptoi(g.pmap, propname))
   nothing
end

################################################ SPARSEGRAPH IMPLEMENTATIONS ###############################################

# Local Sparse Graph
include("sparse/localsparsegraph.jl")

# LightGraphs based Sparse Graph
include("sparse/lgsparsegraph.jl")
