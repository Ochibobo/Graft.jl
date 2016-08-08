################################################# FILE DESCRIPTION #########################################################

# This file contains graph algorithms.

################################################# IMPORT/EXPORT ############################################################
export
# Traversals
bfs, bfs_list, bfs_tree, bfs_subgraph

################################################# BFSLIST ##################################################################

""" Standard BFS implementation that returns a parent vector """
function bfs(g::Graph, seed::Vector{Int}, hopend::Number=Inf)
   N = nv(g)

   parvec = fill(-1, N)
   parvec[seed] = 0

   Q = sizehint!(copy(seed), N)
   Q_ = size
   adj = sizehint!(Int[], N)

   nhops = 1

   lsize = length(seed)
   lcount = 0

   while !isempty(Q) && nhops <= hopend
      u = shift!(Q)

      # Visit u's adjacencies
      for v in fadj!(g, u, adj)

         # If v hasn't been visited, visit it
         if parvec[v] == -1
            parvec[v] = u
            push!(Q, v)
         end
      end

      lcount += 1

      if lcount == lsize
         lsize = length(Q)
         lcount = 0
         nhops += 1
      end
   end

   return parvec
end

bfs(g::Graph, seed::AbstractVector, nhops::Number=Inf) = bfs(g, collect(seed), nhops)
bfs(g::Graph, seed::Int, nhops::Number=Inf) = bfs(g, Int[seed], nhops)

################################################# BFSLIST ##################################################################

""" Get the list of vertices at a certain distance from the seed """
function bfs_list(g::Graph, seed::Vector{Int}, hopstart::Int=1, hopend::Number=Inf)
   N = nv(g)
   vs = sizehint!(Vector{Int}(0), N)

   visited = falses(N)
   visited[seed] = true

   Q = sizehint!(copy(seed), N)
   adj = sizehint!(Vector{Int}(0), N)

   nhops = 1

   lsize = length(seed)
   lcount = 0

   # Visit one entire level of level_size elements
   while !isempty(Q) && nhops <= hopend
      u = shift!(Q)

      # Visit u's adjacencies
      for v in fadj!(g, u, adj)
         # If v hasn't been visited, visit it
         if !visited[v]
            visited[v] = true

            # Return v if it's in the hoprange
            if nhops >= hopstart
               push!(vs, v)
            end
            push!(Q, v)
         end
      end

      lcount += 1

      if lcount == lsize
         lsize = length(Q)
         lcount = 0
         nhops += 1
      end
   end

   return vs
end

bfs_list(g::Graph, seed::AbstractVector, hopstart::Int=1, hopend::Number=Inf) = bfs_list(g, collect(seed), hopstart, hopend)
bfs_list(g::Graph, seed::Int, hopstart::Int=1, hopend::Number=Inf) = bfs_list(g, [seed], hopstart, hopend)


################################################# BFSTREE ###############################################################

function bfs_tree(g::Graph, seed::Int, hopend::Number=Inf)
   parvec = bfs(g, seed, hopend)

   us = sizehint!(Int[], nv(g))
   vs = sizehint!(Int[], nv(g))

   for v in eachindex(parvec)
      u = parvec[v]
      if u > 0
         push!(us, u)
         push!(vs, v)
      end
   end
   vlist = vcat(seed, vs)
   eit = EdgeIter(length(us), us, vs)

   subgraph(g, vlist, eit)
end

################################################# BFSSUBGRAPH #############################################################

function bfs_subgraph(g::Graph, seed::Int, hopend::Number)
   vs = unshift!(bfs_list(g, seed, 1, hopend), seed)
   subgraph(g, vs)
end
