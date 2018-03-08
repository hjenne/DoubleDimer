#!/usr/bin/python


#M2 = Matrix([[8, 4, 4, 2, 4], [4, 8, 2, 4, 2], [4, 2, 8, 4, 2], [2, 4, 4, 8, 4], [4, 2, 2, 4, 8]])

#E2 = Matrix([[8, 4, 4, 2, 4,2], [4, 8, 2, 4, 2,4], [4, 2, 8, 4, 2,4], [2, 4, 4, 8, 4,2], [4, 2, 2, 4, 8,4]])


#F2 = Matrix([[8, 4, 4, 2, 4,2, 3*4, 3*4, 3*2, 3*2, 3*2, 3*2, 3*2, 3*4, 3*2], [4, 8, 2, 4, 2,4, 3*4, 3*2, 3*2, 3*4, 3*2, 3*2, 3*4, 3*2, 3*2], [4, 2, 8, 4, 2,4, 3*2, 3*4, 3*2, 3*2, 3*4, 3*4, 3*2, 3*2, 3*2], [2, 4, 4, 8, 4,2, 3*2, 3*2, 3*2, 3*4, 3*2, 3*4, 3*2, 3*2, 3*4], [4, 2, 2, 4, 8,4, 3*2, 3*2, 3*4, 3*2, 3*2, 3*2, 3*2, 3*4, 3*4]])

#M2small = Matrix([[4, 2], [2, 4]])

#F2small = Matrix([[4, 2, 6],[2,4, 6]])

#print M2small.inverse()*F2small


#print M2.inverse()*F2

#SetPartitions(n).list() returns the pairings as a set of sets, so this
#function converts sets of sets to lists of lists
#Input: A partition as a set of sets
#Returns a partition as a list of lists
def setofsets_to_listoflists(P):
	L = []
	for part in P:
		L.append(list(part))
	return L

#Checks if a pairing is an odd-even pairing. Returns True if it is, and returns  False if it's not
def is_odd_even(L):
	for i in range(len(L)):
		a = L[i][0]
		b = L[i][1]
		if ((b-a) % 2) == 0:
			return False
	return True

#Generate lists of all odd-even pairings, planar pairings, and nonplanar pairings on 2n elements
#Input: n, where we want all odd-even pairings on 2n elements
def gen_odd_even_pairings(n):
	oddeven = []
	planar = []
	nonplanar = []
	P = Permutations(n).list()
	for i in range(len(P)):
		oddeven.append([])
		for j in range(n):
			oddeven[i].append([2*j+1, 2*P[i][j]])
	for i in range(len(oddeven)):
		p = SetPartition(oddeven[i])
		if p.is_noncrossing():
			planar.append(oddeven[i])
		else: 
			nonplanar.append(oddeven[i])
	return oddeven, planar, nonplanar

#Example: 
#oddeven, planar, nonplanar = gen_odd_even_pairings(3)
#print planar
#print nonplanar


	
#Generate list of pairings on 2n elements that are not odd-even
#Input: n, where we want pairings on 2n elements that are not odd-even
def gen_notoddeven_pairings(n):
	notoddevenpairings = []
	listofpairings = SetPartitions(2*n, [2]*n).list() #Make a list of partitions of the integers from 1 to n
	for p in listofpairings: 
		if is_odd_even(setofsets_to_listoflists(p))== False:
			pnew = setofsets_to_listoflists(p)
			notoddevenpairings.append(pnew)
	return notoddevenpairings

#print gen_notoddeven_pairings(4)

#P1 and P2 are pairings, given as lists of lists
def find_loops_in_meander(P1, P2):
	transclosure = SetPartition(P1).sup(SetPartition(P2))
	return len(transclosure.shape())

#Example:
#print find_loops_in_meander([[1,2],[3, 4], [5, 6]],[[1,2],[3, 6], [5, 4]] ) #2
#print find_loops_in_meander([[1,2],[3, 4], [5, 6]],[[1,2],[3, 4], [5, 6]] ) #3
#print find_loops_in_meander([[1,2],[3, 4], [5, 6]],[[1,3],[2,5], [4, 6]] ) #1

def make_meander_matrix(n):
	oddeven, planar, nonplanar = gen_odd_even_pairings(n)
	r = len(planar) #Rows and columns are indexed by planar pairings
	matrix = {}
	for i in range(r):
		for j in range(r):
			loops = find_loops_in_meander(planar[i], planar[j])
			matrix[(i, j)] = 2^loops
	M = Matrix(r, r, matrix)
	return M

#print make_meander_matrix(3)

def make_extended_meander_matrix(n):
	A = make_meander_matrix(n)
	oddeven, planar, nonplanar = gen_odd_even_pairings(n)
	r = len(planar) #Rows are indexed by planar pairings
	c = len(nonplanar) #Columns are indexed by all odd even pairings
	matrix = {}
	for i in range(r):
		for j in range(c):
			loops = find_loops_in_meander(planar[i], nonplanar[j])
			matrix[(i, j)] = 2^loops
	B = Matrix(r, c, matrix)
	M = A.augment(B)
	return M


#print make_extended_meander_matrix(4)


def make_super_extended_meander_matrix(n):
	A = make_extended_meander_matrix(n)
	oddeven, planar, nonplanar = gen_odd_even_pairings(n)
	notoddeven = gen_notoddeven_pairings(n)
	#print notoddeven
	r = len(planar)
	c = len(notoddeven)
	matrix = {}
	for i in range(r):
		for j in range(c):
			loops = find_loops_in_meander(planar[i], notoddeven[j])
			matrix[(i, j)] = 2^loops
	B = Matrix(r, c, matrix)
	M = A.augment(B)
	return M

M2 = make_meander_matrix(5)
#print M2
F2 = make_super_extended_meander_matrix(6)

print M2.inverse()*F2
