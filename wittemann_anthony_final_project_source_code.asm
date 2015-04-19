# Cache Configuration:
.data
lineSizeMsg: .asciiz "\n\nSpecify the line size for the cache in bytes. \nThis should always be a non-negative power of 2 (i.e. 1,2,4,8,etc): "
associativityMsg: .asciiz "\n\nSpecify the associativity of the cache. \nA value of 1 implies a direct-mapped cache, while a 0 value implies fully-associative. \nShould always be a non-negative power of 2: "
dataSizeMsg: .asciiz "\n\nSpecify the total size of the data in the cache. \nThis does not include the size of any overhead (such as tag size). \nIt should be specified in KB and be a non-negative power of 2. \nFor example, a value of 64 means a 64KB cache: "
replacementPolicyMsg: .asciiz "\n\nSpecify the replacement policy to be used. \nShould be either 0 for random replacement or 1 for LRU. No other values are valid: "
missPenaltyMsg: .asciiz "\n\nSpecify the number of cycles penalized on a cache miss. \nMay be any positive integer: "

.text
main:

#### GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** *** GET INPUT *** ***
####------------------------------------------------------------------------------------------------------------------------------

li $v0, 4
la $a0, lineSizeMsg
syscall #ask for line size
li $v0,5
syscall #read in value
add $t0,$v0,$zero #move to $t0

#TODO check if valid input

li $v0, 4
la $a0, associativityMsg
syscall #ask for associativity
li $v0,5
syscall #read in value
add $t1,$v0,$zero #move to $t1

#TODO check if valid input

li $v0, 4
la $a0, replacementPolicyMsg
syscall #ask for replacement policy
li $v0,5
syscall #read in value
add $t2,$v0,$zero #move to $t2

#TODO check if valid input

li $v0, 4
la $a0, dataSizeMsg
syscall #ask for data size
li $v0,5
syscall #read in value
add $t3,$v0,$zero #move to $t3

#TODO check if valid input

li $v0, 4
la $a0, missPenaltyMsg
syscall #ask for miss penalty
li $v0,5
syscall #read in value
add $t4,$v0,$zero #move to $t4

#TODO check if valid input











####EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** ***
####---------------------------------------------------------------------------------------------------------------------------------
li $v0,10		# bye, bye
syscall