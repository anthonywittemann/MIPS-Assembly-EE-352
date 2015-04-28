#TODO 
#1 - implement set associative LRU
#2 - refactor to create variables for input data instead of $t0-$t4 -- might take too much time & not worth
#3 - implement other 5 cases for EC


# Cache Configuration:
.data
lineSizeMsg: .asciiz "\nSpecify the line size for the cache in bytes. \nThis should always be a non-negative power of 2 (i.e. 1,2,4,8,etc): "
associativityMsg: .asciiz "\nSpecify the associativity of the cache. \nA value of 1 implies a direct-mapped cache, while a 0 value implies fully-associative. \nShould always be a non-negative power of 2: "
dataSizeMsg: .asciiz "\nSpecify the total size of the data in the cache. \nThis does not include the size of any overhead (such as tag size). \nIt should be specified in KB and be a non-negative power of 2. \nFor example, a value of 64 means a 64KB cache: "
replacementPolicyMsg: .asciiz "\nSpecify the replacement policy to be used. \nShould be either 0 for random replacement or 1 for LRU. No other values are valid: "
missPenaltyMsg: .asciiz "\nSpecify the number of cycles penalized on a cache miss. \nMay be any positive integer: "
invalidInputMsg: .asciiz "\nInvalid Input. Program will exit"

totalHitRateMsg: .asciiz "\nTotal Hit Rate (The percentage of memory ops \n(i.e. lines in the trace file) that were hits): "
totalRuntimeMsg: .asciiz "\nTotal Runtime (total processor cycles assuming \nthat the last memory access was the last instruction of the program): "
avgMemAccessLatencyMsg: .asciiz "\nAverage Memory Access Latency \n(The average number of cycles needed to complete a memory access): "

fullyAssociativeLRUMsg: .asciiz "\nSimulating a Fully Associate LRU Cache..."
setAssociativeLRUMsg: .asciiz "\nSimulating a Set Associate LRU Cache..."
directMappingLRUMsg: .asciiz "\nSimulating a Direct Mapping LRU Cache..."
fullyAssociativeRndMsg: .asciiz "\nSimulating a Fully Associate Random Replacement Cache..."
setAssociativeRndMsg: .asciiz "\nSimulating a Set Associate Random Replacement Cache..."
directMappingRndMsg: .asciiz "\nSimulating a Direct Mapping Random Replacement Cache..."

space: .asciiz "  "

 
testingMsg: .asciiz "TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ----"
testingMsg1: .asciiz "TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 ****"

totalHitRate: .word -1
totalRuntime: .word -1
avgMemAccessLatency: .word -1

.text
main:

#### GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** ***
####-------------------------------------------------------------------------------------------------------------------------------
add $s2, $s2, 2		# $s2 = 2; //$s2 will be the divisor in the calculations of whether input is a power of 2


li $v0, 4
la $a0, lineSizeMsg
syscall 		# ask for line size
li $v0,5
syscall 		# read in value
blt $v0, $0, exit	# check if less than 0
jal isPowerOf2		# check if a power of 2	
add $t0,$v0,$zero 	# $t0 = line size

li $v0, 4
la $a0, associativityMsg
syscall 		#ask for associativity
li $v0,5
syscall 		#read in value
blt $v0, $0, exit	# check if less than 0
jal isPowerOf2		# check if a power of 2
add $t1,$v0,$zero 	# $t1 = associativity

li $v0, 4
la $a0, dataSizeMsg
syscall 		#ask for data size
li $v0,5
syscall 		#read in value
blt $v0, $0, exit	# check if less than 0
jal isPowerOf2		# check if a power of 2
add $t2,$v0,$zero 	# $t2 = data size

li $v0, 4
la $a0, replacementPolicyMsg
syscall 		#ask for replacement policy
li $v0,5
syscall 		#read in value
bne $v0, $0, isEqualTo1 # check if 0 or 1
makeReplacementVariable:	 
add $t3,$v0,$zero 	# $t3 = replacement policy

li $v0, 4
la $a0, missPenaltyMsg
syscall 		#ask for miss penalty
li $v0,5
syscall 		#read in value
blt $v0, $0, exit	# check if less than 0
add $t4,$v0,$zero 	# $t4 = miss penalty





##check for LRU ($t3 = 1) or Random ($t3 = 0) 
beq $t3, $0, randomReplacement
b LRU

####^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
####SUBROUTINES *** *** *** SUBROUTINES *** *** *** SUBROUTINES *** *** *** SUBROUTINES *** *** *** SUBROUTINES *** *** ***
####vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

LRU:
##check for set Associate LRU
##check if $t1 == 0 then fully     or     $t1 == 1 then direct mapping     else it's set associative
beq $t1, $0, fullyAssociativeLRU
li $t7, 1
beq $t1, $t7, directMappingLRU
b setAssociativeLRU


randomReplacement:
##go to 
##check if $t1 == 0 then fully     or     $t1 == 1 then direct mapping     else it's set associative
beq $t1, $0, fullyAssociativeRnd
li $t7, 1
beq $t1, $t7, directMappingRnd
b setAssociativeRnd


# LRU REPLACEMENT *** *** LRU REPLACEMENT *** *** LRU REPLACEMENT *** *** LRU REPLACEMENT *** *** LRU REPLACEMENT *** ***
####You ONLY NEED to implement set associative cache with LRU replacement policy. *** SET ASSOCIATIVE CACHE WITH LRU REPLACEMENT POLICY
####---------------------------------------------------------------------------------------------------------------------------------
setAssociativeLRU:	#TODO IMPORTANT
li $v0, 4
la $a0, setAssociativeLRUMsg
syscall 		


####can go in any cache unit, least recently used replacement scheme
####---------------------------------------------------------------------------------------------------------------------------------
fullyAssociativeLRU:
li $v0, 4
la $a0, fullyAssociativeLRUMsg
syscall 		


####can go in any cache unit, least recently used replacement scheme
####---------------------------------------------------------------------------------------------------------------------------------
directMappingLRU:
li $v0, 4
la $a0, directMappingLRUMsg
syscall 


# RANDOM REPLACEMENT *** *** RANDOM REPLACEMENT *** *** RANDOM REPLACEMENT *** *** RANDOM REPLACEMENT *** *** RANDOM REPLACEMENT *** ***
####maps from memory to cache set directly, random replacement scheme
####---------------------------------------------------------------------------------------------------------------------------------
setAssociativeRnd:
li $v0, 4
la $a0, setAssociativeRndMsg
syscall 



####can go in any cache unit, random replacement scheme
####---------------------------------------------------------------------------------------------------------------------------------
fullyAssociativeRnd:
li $v0, 4
la $a0, fullyAssociativeRndMsg
syscall 

####maps from memory to cache directly, random replacement scheme
####---------------------------------------------------------------------------------------------------------------------------------
directMappingRnd:
li $v0, 4
la $a0, directMappingRndMsg
syscall 




####called after a replacement policy input != 0, checks if equal to 1
isEqualTo1:
li $s0, 1
beq $v0, $s0, makeReplacementVariable
j exit

####Checks is $v0 is a power of 2 *** *** *** Checks is $v0 is a power of 2 *** *** *** Checks is $v0 is a power of 2 *** *** 
####---------------------------------------------------------------------------------------------------------------------------------
isPowerOf2:     	# while:
beq $v0, 1, return	# base case: if $v0 = 1, then valid input
div $v0, $s2		# else: $v0 /= 2
mflo $v0		# $v0 = quotient
mfhi $10		# $10 = remainder
bne $10, $0, exit	# base case: if remainder != 0, invalid input
j isPowerOf2		# continue while loop
return:
jr $ra	


####RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** ***
####---------------------------------------------------------------------------------------------------------------------------------
displayResults:
li $v0, 4
la $a0, totalHitRateMsg
syscall

ori $v0, $0, 1			# Display the total hit rate
lw $s0, totalHitRate	
add $a0, $s0, $0	
syscall

li $v0, 4
la $a0, totalRuntimeMsg
syscall

ori $v0, $0, 1			# Display the total runtime	
lw $s0, totalRuntime	
add $a0, $s0, $0	
syscall

li $v0, 4
la $a0, avgMemAccessLatencyMsg
syscall

ori $v0, $0, 1			# Display the average memory access latency	
lw $s0, avgMemAccessLatency
add $a0, $s0, $0 #TODO - test if this works
syscall


####EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** ***
####---------------------------------------------------------------------------------------------------------------------------------
exit:
li $v0, 4
la $a0, invalidInputMsg
syscall
li $v0,10		# bye, bye
syscall
