#!/usr/bin/python

import numpy as np

#Generates all black/white pairings, given a list of black nodes and a list of white nodes
def gen_black_white_pairings(blacknodes, whitenodes):
	if len(blacknodes) != len(whitenodes):
		print "Error: the number of black nodes and white nodes is not the same"
	blackwhite = []
	B = sorted(blacknodes)
	W = Permutations(whitenodes).list()
	for i in range(len(W)):
		blackwhite.append([])
	for i in range(len(W)):
		for j in range(len(B)):
			blackwhite[i].append([B[j], W[i][j]])
	return blackwhite

#Examples
#print gen_black_white_pairings([1, 2], [3,4]) #[[[1, 3], [2, 4]], [[1, 4], [2, 3]]]
#print gen_black_white_pairings([1, 2, 4], [3,5,6]) #[[[1, 3], [2, 5], [4, 6]], [[1, 3], [2, 6], [4, 5]], [[1, 5], [2, 3], [4, 6]], [[1, 5], [2, 6], [4, 3]], [[1, 6], [2, 3], [4, 5]], [[1, 6], [2, 5], [4, 3]]]
#print gen_black_white_pairings([1, 2, 3], [4, 5, 6]) #[[[1, 4], [2, 5], [3, 6]], [[1, 4], [2, 6], [3, 5]], [[1, 5], [2, 4], [3, 6]], [[1, 5], [2, 6], [3, 4]], [[1, 6], [2, 4], [3, 5]], [[1, 6], [2, 5], [3, 4]]]


#Finds the sign of a black-white pairing
def find_sign(P):
	perm = []
	L = np.array(P)[:,1] #The permutation
	#print L
	O = sorted(L)
	#print O
	for i in range(len(L)):
		perm.append(O.index(L[i]) + 1)
	#print perm
	return Permutation(perm).sign()


#Checks that the conjecture holds for a black-white pairing, given as a list of lists
def check_conjecture(P):
	RHS = (-1)^(SetPartition(P).number_of_crossings())
	#print RHS
	productlist = []
	for i in range(len(P)):
		a = P[i][0] #The black node in the pairing
		b = P[i][1] #The white node in the pairing
		if (a - b) % 2 == 1: #If a and b have different parity
			productlist.append((-1)^((abs(a-b)-1)/2))
		elif (a % 2 == 0) and (b % 2 == 0):
			productlist.append((-1)^((abs(a-b)-2)/2))
		elif (a % 2 == 1) and (b % 2 == 1): 
			productlist.append((-1)^(abs(a-b)/2))
	LHS = find_sign(P)*np.prod(productlist)
	#print find_sign(P)
	#print productlist
	if LHS == RHS:
		return True
	else:
		return False


#lst = gen_black_white_pairings([1, 2, 3], [4, 5, 6])
#for p in lst:
	#print check_conjecture(p)

print check_conjecture([[1, 2], [3,4], [5,8], [6,7]])

#SetPartitions(n).list() returns the pairings as a set of sets, so this
#function converts sets of sets to lists of lists
#Input: A partition as a set of sets
#Returns a partition as a list of lists
def setofsets_to_listoflists(P):
	L = []
	for part in P:
		L.append(sorted(list(part)))
	return L


def check_all(n):
	if n % 2 == 1:
		print "Error: n is odd"
	for s in Subsets(range(1,n+1), n/2):
		blacknodes = list(s)
		whitenodes = list(set(range(1, n+1)) - set(s))
		lst = gen_black_white_pairings(blacknodes, whitenodes)
		for p in lst:
			print check_conjecture(p)
	return None
	
def check_all_pairings(n):
	if n % 2 == 1:
		print "Error: n is odd"
	for s in SetPartitions(n, [2]*int(n/2)):
		#print s
		#print setofsets_to_listoflists(s)
		print check_conjecture(setofsets_to_listoflists(s))
	return None



check_all_pairings(14)
