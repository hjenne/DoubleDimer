#!/usr/bin/python

#Makes a grid graph
G = graphs.GridGraph([5, 7])

print G.show()

print G.vertices()

print G.edges()

print G.is_bipartite()

#Figure out how to add edge weights

#Figure out how to make a set of nodes, given the dimensions of the grid

#It would be nice to easily make node sets that have different properties, i.e. one that
#has nodes 1 and 2 white, then nodes 3 and 4 black, etc. 

#Figure out how to compute Z(G\S) so that you can more easily do examples. 
