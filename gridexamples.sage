#!/usr/bin/python

import numpy as np
from copy import deepcopy

var('q')

#Add edge weights to G
def add_edge_weights(G):
	if G.is_bipartite() == False:
		print "G is not bipartite"
	for e in G.edges():
		if e[0][1] - e[1][1] == 0:
			G.set_edge_label(e[0], e[1], 1)
		else:
			G.set_edge_label(e[0], e[1], q^(e[0][0]))
	return G

#TEST of add_edge_weights
#G = graphs.GridGraph([3, 2])
#G.weighted(True)
#G = add_edge_weights(G) 
#print G.edges()
#print G.show()

#Returns the vertices on the outer face of an m x n grid graph. 
#Lists the vertices in order that you get when you start in the upper left hand
#corner and go CCW around the face. 
def outer_face_list(m, n):
	outerfacelist = []
	for k in range(m): #Append vertices on the left edge
		outerfacelist.append((k, 0))
	for k in range(1,n): #Append vertices on the bottom edge
		outerfacelist.append((m-1, k)) #Append vertices on the right edge
	for k in reversed(range(m-1)):
		outerfacelist.append((k, n-1))
	for k in reversed(range(1, n-1)):
		outerfacelist.append((0, k))
	return outerfacelist

#TESTS of outer_face_list
#print outer_face_list(3, 2) #Should print [(0, 0), (1, 0), (2, 0), (2, 1), (1, 1), (0, 1)]
#print outer_face_list(2, 3) #Should print [(0, 0), (1, 0), (1, 1), (1, 2), (0, 2), (0, 1)]
#print outer_face_list(2, 4) #Should print [(0, 0), (1, 0), (1, 1), (1, 2), (1, 3), (0, 3), (0, 2), (0, 1)]
#print outer_face_list(4,2) #Should print [(0, 0), (1, 0), (2, 0), (3, 0), (3, 1), (2, 1), (1, 1), (0, 1)]
#print outer_face_list(4, 6) #Should print [(0, 0), (1, 0), (2, 0), (3, 0), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (2, 5), (1, 5), (0, 5), (0, 4), (0, 3), (0, 2), (0, 1)]
#print outer_face_list(5,3) #Should print [(0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (3, 2), (2, 2), (1, 2), (0, 2), (0, 1)]


#Returns a list of nodes (vertices on the outer face numbered 1,...,n in counterclockwise order)
#Inputs: An m x n grid graph G, the dimensions of G,
#and a dictionary indicating how the nodes should be colored
#0 is white, 1 is black
#For example, the dictionary {1: 0, 2: 0, 3: 1, 4: 1}
#indicates that the node list should consist of four nodes, and nodes 1 and 2 should be white
#and nodes 3 and 4 should be black. 
def node_list(G, m, n, coloring):
	nodelist = []
	outerfacelist = outer_face_list(m, n) #The list of vertices on the outer face of G
	bipartitecoloring = G.bipartite_color() #The bipartite coloring of G
	nodecolorlist = coloring.values() #The list of the colors of the nodes, in ascending order based on the node labels
	print nodecolorlist #Check that this order is consistent with the coloring dictionary
	j = 0
	for i in range(len(nodecolorlist)):
		nodecolor = nodecolorlist[i] #The color of the ith node
		while bipartitecoloring[outerfacelist[j]] != nodecolor: #If the node on the outer face isn't the same as the node color, go to the next node on the outer face
			j = j+1 #If the node list you asked for isn't possible, you'll get an indexing error when j gets too big
		if bipartitecoloring[outerfacelist[j]] == nodecolor: #Once it finds the correct j, check that it actually is equal to the nodecolor
			nodelist.append(outerfacelist[j])
			j = j+1 #And increment j by 1
		else:
			print "something went wrong"
	return nodelist

#TESTS of node_list
#G = graphs.GridGraph([4, 4])
#G.show()
#print node_list(G, 4, 5, {1:1, 2:1, 3:0, 4:0}) #Should return [(1, 0), (3, 0), (3, 1), (3, 3)]
#print node_list(G, 5, 5, {1:1, 2:0, 3:1, 4:0}) #Should return [(0, 0), (1, 0), (2, 0), (3, 0)]
#print node_list(G, 5, 5, {1:0, 2:1, 3:0, 4:1}) #Should return [(1, 0), (2, 0), (3, 0), (4, 0)]
#print node_list(G, 5, 4, {1:0, 2:0, 3:1, 4:1, 5:0, 6:1}) #Should return [(0, 0), (2, 0), (3, 0), (4, 1), (4, 2), (4, 3)]
#print node_list(G, 5, 4, {6:1, 1:0, 3:1, 4:1, 2:0, 5:0}) #Should be same as above because it doesn't matter what order the dictionary is in
#print node_list(G, 4, 4, {1:0, 2:0, 3:0, 4:1, 5:1, 6:1}) #Should return [(0, 0), (2, 0), (3, 1), (3, 2), (2, 3), (0, 3)]
#print node_list(G, 4, 4, {1:0, 2:0, 3:0, 4:1, 5:1, 6:1, 7:1, 8:0}) #Should get IndexError: list index out of range because there aren't enough vertices on the outer face to get eight nodes with this coloring

#Returns the weight of a matching, given a list of edges in the matching
def find_weight(L):
	edgelabels = []
	for i in range(len(L)):
		edgelabels.append(L[i][2])
	return np.prod(edgelabels)

#TESTS of find_weight
#Example 1
#G = graphs.GridGraph([3, 2])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#matching = list(G.perfect_matchings(labels=True))[1] 
#print matching #[((0, 0), (0, 1), 1), ((2, 0), (2, 1), q^2), ((1, 0), (1, 1), q)]
#print find_weight(matching) #q^3
#Example 2
#G = graphs.GridGraph([3, 4])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#matching = list(G.perfect_matchings(labels=True))[0] 
#print matching #[((0, 0), (0, 1), 1), ((0, 2), (1, 2), 1), ((0, 3), (1, 3), 1), ((1, 1), (2, 1), 1), ((1, 0), (2, 0), 1), ((2, 2), (2, 3), q^2)]
#print find_weight(matching) #q^2
#matching = list(G.perfect_matchings(labels=True))[1]
#print matching
#print find_weight(matching) #q^5


#Finds the weighted sum of all matchings of a graph
def Z(G):
	matchingweights = []
	for matching in G.perfect_matchings(labels=True):
		matchingweights.append(find_weight(matching))
	return sum(matchingweights)
	
#TESTS of Z(G):
#G = graphs.GridGraph([3, 2])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#print list(G.perfect_matchings(labels = True))
#print Z(G) #q^3 + q^2 + 1


#Given a graph G, a list of nodes nodelist,
#and a list S of node labels (i.e. [1, 3, 4])
#make the set S of vertices
def make_S(G, nodelist, S):
	Svertexlist = []
	for i in S:
		Svertexlist.append(nodelist[i-1])
	return Svertexlist


#Given a graph G, a list of nodes nodelist,
#and a list S of vertices, delete S from G
def delete_S(G, S):
	H = deepcopy(G)
	H.delete_vertices(S)
	return H

#TESTS of make_S and delete_S:
#Example 1
#G = graphs.GridGraph([4, 4])
#G.show()
#nodelist = node_list(G, 4, 4, {1:1, 2:1, 3:0, 4:0})
#print nodelist
#S = make_S(G, nodelist, [1, 3])
#print S
#H = delete_S(G, S)
#H.show()
#S = make_S(G, nodelist, [2,4])
#H = delete_S(G, S)
#H.show()
#Example 2
#G = graphs.GridGraph([5,5])
#G.show()
#nodelist = node_list(G, 5,5, {1:1, 2:0, 3:1, 4:0, 5:1, 6:0})
#print nodelist
#S= make_S(G, nodelist, [3, 4, 5, 6])
#print S
#H = delete_S(G, S)
#H.show()

def is_white(G, vertex):
	color = G.bipartite_color()[vertex]
	if color == 0:
		return True
	else:
		return False

def is_black(G, vertex):
	color = G.bipartite_color()[vertex]
	if color == 1:
		return True
	else:
		return False

#TESTS of is_white and is_black:
#G = graphs.GridGraph([4, 4])
#G.show()
#print is_white(G, (0, 0)) #True
#print is_white(G, (0, 3)) #False
#print is_black(G, (0, 0)) #False
#print is_black(G, (0, 3)) #True

#Return just the black nodes in a list
def black_only(G, nodelist):
	return [x for x in nodelist if is_black(G,x)]

#Return just the white nodes in a list
def white_only(G, nodelist):
	return [x for x in nodelist if is_white(G,x)]

#TESTS of white_only and black_only:	
#G = graphs.GridGraph([4, 4])
#G.show()
#print black_only(G, G.vertices()) #[(0, 1), (0, 3), (1, 0), (1, 2), (2, 1), (2, 3), (3, 0), (3, 2)]
#print white_only(G, G.vertices()) #[(0, 0), (0, 2), (1, 1), (1, 3), (2, 0), (2, 2), (3, 1), (3, 3)]


#CAREFUL: This only works if the outer face of the graph has 2 mod 4 edges
#Finds the sign of the entries in the matrix from Lemma 3.2
#If vertex1 and vertex2 are nodes (vertices on the outerface of G)
#then the sign of the matrix entry X_{vertex1, vertex2} should be -1 if
#the number of edges between vertex1 and vertex2 + 1 is 0 mod 4, and 1 if
#the number of edges between vertex1 and vertex2 + 1 is 2 mod 4.
def find_sign(outerfacelist, vertex1, vertex2):
	i = outerfacelist.index(vertex1)
	j = outerfacelist.index(vertex2)
	if (abs(i - j) + 1) % 4 == 0:
		return -1
	elif (abs(i - j) + 1) % 4 == 2:
		return 1


#Example
#G = graphs.GridGraph([5,4])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#outerfacelist = outer_face_list(5, 4)
#print outerfacelist
#nodelist = node_list(G, 5, 4, {1:1, 2:1, 3:0, 4:0, 5:1, 6:1, 7:0, 8:0})
#print nodelist #[(1, 0), (3, 0), (4, 0), (4, 2), (4, 3), (2, 3), (1, 3), (0, 2)]
#print find_sign(outerfacelist, (1,0), (1,3)) #row corresponding to 1, column corresponding to 7 should have + sign
#print find_sign(outerfacelist, (3,0), (4,0)) #row corresponding to 2, column corresponding to 3 should have + sign
#print find_sign(outerfacelist, (3,0), (4, 2)) #row corresponding to 2, column corresponding to 4 should have - sign
#print find_sign(outerfacelist, (3,0), (0, 2)) #row corresponding to 2, column corresponding to 8 should have + sign
#print find_sign(outerfacelist, (4, 3),(4, 0)) #-1
#print find_sign(outerfacelist, (4, 3), (4,2)) #+1
#print find_sign(outerfacelist, (4, 3),(0,2)) #1
#print find_sign(outerfacelist, (2, 3), (4, 0)) #+1
#print find_sign(outerfacelist, (2, 3), (4, 2)) #-1
#print find_sign(outerfacelist, (2, 3), (0, 2)) #-1



#Inputs: A graph G, a list of nodes made using node_list (this is a list of vertices)
#and a list S of node labels (i.e. [1, 3, 4]) or a list S of nodes (i.e. (1, 0), (1, 1),..)
#and labels, indicating which list is given
def make_lemma32_matrix(G, outerfacelist, nodelist, S, labels=True):
	matrix = {}
	if labels == True:
		Svertexlist = make_S(G, nodelist, S)
	elif labels == False:
		Svertexlist = S
	#print Svertexlist
	rowlist = black_only(G, nodelist) #Rows correspond to black nodes
	columnlist = white_only(G, nodelist) #Columns correspond to white nodes
	for r in range(len(rowlist)):
		vertexi = rowlist[r]
		for c in range(len(columnlist)):
			vertexj = columnlist[c]
			#print vertexi
			#print vertexj
			if (vertexi in Svertexlist and vertexj in Svertexlist) or (vertexi not in Svertexlist and vertexj not in Svertexlist):
				H = delete_S(G, [vertexi, vertexj])
				i = nodelist.index(vertexi) + 1
				j = nodelist.index(vertexj) + 1
				sgn = find_sign(outerfacelist, vertexi, vertexj)
				#if ((i - j) % 2 ) == 1: 
				#	sgn = ((-1)^((abs(i-j) -1)/2))
				#elif (i % 2 == 1) and (j % 2 == 1): 
				#	sgn = ((-1)^(abs(i-j)/2))
				#elif (i % 2 == 0) and (j % 2 == 0): 
				#	sgn = ((-1)^((abs(i-j)-2)/2))
				matrix[(r, c)] = sgn*Z(H)
	m = len(rowlist)
	M = Matrix(m, m, matrix)
	#print M
	return det(M)


#EXAMPLE 1
#G = graphs.GridGraph([2,3])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#nodelist = node_list(G, 2, 3, {1:1, 2:0, 3:1, 4:0})
#print nodelist #[(1, 0), (1, 1), (1, 2), (0, 2)]
#print make_lemma32_matrix(G, nodelist, [1, 2]) #q + 1
#Svertexlist is [(1, 0), (1, 1)]
#rowlist is [(1, 0), (1, 2)]
#columnlist is [(1, 1), (0, 2)]
#Matrix is [[1,0],[0, q + 1]]
#EXAMPLE 2
#G = graphs.GridGraph([4,2])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#nodelist = node_list(G, 4,2, {1:1, 2:0, 3:1, 4:0, 5:1, 6:0})
#print nodelist #[(1, 0), (2, 0), (3, 0), (3, 1), (2, 1), (1, 1)]
#print make_lemma32_matrix(G, nodelist, [1, 2])
#Svertexlist is [(1, 0), (2, 0)]
#rowlist is [(1, 0), (3, 0), (2, 1)]
#columnlist is [(2, 0), (3, 1), (1, 1)]
#Matrix is [[q^3, 0, 0], [0, q^3 + q^2 + 1,-1],[0,q + 1,q^3]]


def check_lemma32(G, outerfacelist, nodelist, S,labels = True):
	if labels==True:
		Svertexlist = make_S(G, nodelist, S)
	elif labels == False:
		Svertexlist = S
	#print Svertexlist
	Scomplement = list(set(nodelist) - set(Svertexlist))
	H = delete_S(G, Svertexlist)
	I = delete_S(G, Scomplement)
	m = len(nodelist)/2
	LHS = Z(H)*Z(I)*(Z(G))^(m-2)
	RHS = make_lemma32_matrix(G, outerfacelist, nodelist, Svertexlist,labels=False)
	print "LHS:"
	print LHS.expand()
	print "RHS:"
	print RHS.expand()
	if bool(LHS.expand() == RHS.expand()):
		return True
	elif bool(LHS.expand() == -RHS.expand()):
		return "LHS = -RHS"
	else:
		return False

#EXAMPLE 1
#G = graphs.GridGraph([2,3])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#nodelist = node_list(G, 2, 3, {1:1, 2:0, 3:1, 4:0})
#print nodelist #[(1, 0), (1, 1), (1, 2), (0, 2)]
#print check_lemma32(G, nodelist, [1, 2])
#EXAMPLE 2
#G = graphs.GridGraph([4,2])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
#nodelist = node_list(G, 4,2, {1:1, 2:0, 3:1, 4:0, 5:1, 6:0})
#print nodelist #[(1, 0), (2, 0), (3, 0), (3, 1), (2, 1), (1, 1)]
#print check_lemma32(G, nodelist, [1, 2])


#Checks if a list of vertices is balanced
def is_balanced(G, lst):
	blacknumber = len(black_only(G, lst))
	whitenumber = len(white_only(G, lst))
	if blacknumber == whitenumber:
		return True
	else: 
		return False

#Example: 
#G = graphs.GridGraph([2,3])
#print is_balanced(G, [(1, 0), (1, 1)]) #True
#print is_balanced(G, [(1, 0), (1, 1), (1, 2), (0, 2)]) #True
#print is_balanced(G, [(1, 0), (1, 2)]) #False


def find_all_balanced_subsets(G, nodelist):
	balancedsubsets = []
	balancedsubsets.append([]) #Empty list is always balanced
	for s in Subsets(nodelist):
		if len(s) % 2 == 0 and len(s) > 0:
			if is_balanced(G, list(s)):
				balancedsubsets.append(list(s))
	return balancedsubsets
	
#Example 1:
#G = graphs.GridGraph([2,3])
#G.show()
#nodelist = node_list(G, 2, 3, {1:1, 2:0, 3:1, 4:0})
#print nodelist
#print find_all_balanced_subsets(G, nodelist)
#Example 2:
#G = graphs.GridGraph([4,2])
#G.show()
#nodelist = node_list(G, 4,2, {1:1, 2:0, 3:1, 4:0, 5:1, 6:0})
#print nodelist #[(1, 0), (2, 0), (3, 0), (3, 1), (2, 1), (1, 1)]
#print find_all_balanced_subsets(G, nodelist)


def check_lemma32_allsubsets(G, outerfacelist, nodelist):
	balancedsubsets = find_all_balanced_subsets(G, nodelist)
	for S in balancedsubsets:
		print S
		print [nodelist.index(x) + 1 for x in S]
		print check_lemma32(G, outerfacelist, nodelist, S, labels=False)
	return None


#Example without odd-even assumption
G = graphs.GridGraph([5,4])
G.show()
G.weighted(True)
G = add_edge_weights(G) 
outerfacelist = outer_face_list(5, 4)
nodelist = node_list(G, 5, 4, {1:1, 2:1, 3:0, 4:0, 5:1, 6:1, 7:0, 8:0})
print nodelist
print check_lemma32_allsubsets(G, outerfacelist, nodelist)
#print check_lemma32(G, outerfacelist, nodelist, [1,7],labels = True)



#G = graphs.GridGraph([4,4])
#G.show()
#nodelist = [(1, 0), (3, 0), (3,3), (1,3),(0, 3),(0,2)]
#Slist = make_S(G, nodelist, [2, 3, 4, 5])
#H = delete_S(G, Slist)
#H.show()
#print len(list(H.perfect_matchings()))
#for matching in H.perfect_matchings(labels=True):
	#K = deepcopy(H)
	#for e in K.edges():
	#	if e not in matching:
	#		K.delete_edge(e)
	#K.show()



#G = graphs.GridGraph([4,2])
#G.show()
#G.weighted(True)
#G = add_edge_weights(G) 
##nodelist = node_list(G, 4, 2, {1:1, 2:0, 3:1, 4:0, 5:1, 6:0})
#print nodelist
#print check_lemma32(G, nodelist, [1, 2, 4, 5],labels = True)


