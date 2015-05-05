# Cache Configuration: 1KB 2D array (64 sets which is 4 way set associative - each word entry is 4 bytes)
# Line Size: 4 bytes
# Associativity: set associative
# Data Size: 1 KB
# Replacement Policy: LRU
# Miss Penalty: 4 cycles

.data
totalHitRateMsg: .asciiz "\n\nTotal Hit Rate (The percentage of memory ops \n(i.e. lines in the trace file) that were hits): "
totalRuntimeMsg: .asciiz "\n\nTotal Runtime (total processor cycles assuming \nthat the last memory access was the last instruction of the program): "
avgMemAccessLatencyMsg: .asciiz "\n\nAverage Memory Access Latency \n(The average number of cycles needed to complete a memory access): "

space: .asciiz "  "
newLine: .asciiz "\n"
 
testingMsg: .asciiz "TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ----"
testingMsg1: .asciiz "TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 ****"
traceFileMsg: .asciiz "Memory Address Trace:\n"

totalHitRate: .word -1
totalRuntime: .word -1
avgMemAccessLatency: .word -1

.text
main:

### This program will simulate 1000 CPU cycles accessing cache *** *** This program will simulare 1000 CPU cycles accessing cache ### 
add $t7, $0, 10	# $t7 = 1000 (number of cycles = 1000)
##TODO: change back to 10000

while:     		# while:
beq $t7, $0, exit	# base case: if ($t7 == 0): we've completed all the cycles of the simulation
jal generateMemAddress
li $v0, 4
la $a0, newLine
syscall 
jal mapToSetInCache
li $v0, 4
la $a0, newLine
syscall 
jal checkIfSetInCache
li $v0, 4
la $a0, newLine
syscall 
sub $t7, $t7, 1		# $t7--
j while			# continue while loop




### SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** ***

# input: $t6 (nothing yet) 
# output: $t6 (random Mem address)
# generates a random hexadeciaml memory address from 0 to 2^32-1
generateMemAddress:
li $v0, 4
la $a0, testingMsg
syscall 		# get HERE?

## TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ ###
randomNumber:
	li $a0, 0 #seed random generation with 0
	li $a1, 0x7fffffff #setting upper bound to 63 inclusive
	li $v0, 42 ##prepare to syscall random generator
	syscall #random number is now stored in $a0
	la $t6, ($a0)
printAfterGeneratingNumber:	
	li $v0, 34
	syscall
	li  $a0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        li $v0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall
##_____________________________________________________________________________________________________________________

jr $ra

mapToSetInCache:
li $v0, 4
la $a0, testingMsg1
syscall 		# get HERE?
jr $ra

checkIfSetInCache:
li $v0, 4
la $a0, testingMsg
syscall 		# get HERE?
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
add $a0, $s0, $0 
syscall


####EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** ***
####---------------------------------------------------------------------------------------------------------------------------------

exit: 			#used for normal exit 
li $v0,10		# bye, bye
syscall
