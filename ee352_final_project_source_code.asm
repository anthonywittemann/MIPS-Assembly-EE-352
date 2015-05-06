# Cache Configuration: 1KB 2D array (64 sets which is 4 way set associative - each word entry is 4 bytes)
# Line Size: 4 bytes
# Associativity: set associative
# Data Size: 1 KB
# Replacement Policy: LRU
# Miss Penalty: 8 cycles

.data
totalHitRateMsg: .asciiz "\n\nTotal Hit Rate (The percentage of memory ops \n(i.e. lines in the trace file) that were hits): "
totalRuntimeMsg: .asciiz "\n\nTotal Runtime (total processor cycles assuming \nthat the last memory access was the last instruction of the program): "
avgMemAccessLatencyMsg: .asciiz "\n\nAverage Memory Access Latency \n(The average number of cycles needed to complete a memory access): "

space: .asciiz "  "
newLine: .asciiz "\n"
 
testingMsg: .asciiz "TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ----"
testingMsg1: .asciiz "TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 ****"
traceFileMsg: .asciiz "Memory Address Trace:\n"

missPenalty: .word 8

#totalHitRate: .word -1 = $t8
#totalRuntime: .word -1 = $t7
#avgMemAccessLatency: .word -1 = something we calculate at the end

data:    .word     0 : 256       # storage for 64x4 matrix of cache locations
         
         
.text
main:

li       $t0, 64        # $t0 = number of rows
li       $t1, 4         # $t1 = number of columns
move     $s0, $zero     # $s0 = row counter
move     $s1, $zero     # $s1 = column counter
move     $t2, $zero     # $t2 = the value to be stored
move 	 $t8, $zero	# $t8 = totalHits
move 	 $t4, $zero	# $t4 = totalMemCalls

#  Each loop iteration will store incremented $t1 value into next element of matrix.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)

### This program will simulate 1000 CPU cycles accessing cache *** *** This program will simulare 1000 CPU cycles accessing cache ### 
add $t7, $0, 0	# $t7 = 0 (number of cycles = 0)
##TODO: change back to 9999
li $t9, 9


while:     			# while:
bgt $t7, $t9, displayResults	# base case: if ($t7 == 0): we've completed all the cycles of the simulation
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
add $t7, $t7, 1		# totalRuntime++ (cycles)
add $t4, $t4, 1		# totalMemAccessCalls++
j while			# continue while loop


### SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** *** SUBROUTINES *** ***

# input: $t6 (nothing yet) 
# output: $t6 (random Mem address)
# generates a random 32 bit hexadeciaml memory address that the CPU needs to access 
generateMemAddress:
li $v0, 4
la $a0, testingMsg
syscall 		# get HERE?

## TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ ###
randomNumber:
	li $a0, 0 #seed random generation with 0
	li $a1, 0x7fffffff #setting upper bound to 2^32 -1
	li $v0, 42 ##prepare to syscall random generator
	syscall #random number is now stored in $a0
	la $t6, ($a0)
printAfterGeneratingNumber:	
	li $v0, 34
	syscall
	li  $a0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        li $v0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
        syscall


jr $ra
##_____________________________________________________________________________________________________________________



# input: $t6 (memory adddress) 
# output: $t5 (set in cache to store word in)
# takes a memory address and maps it to a set in cache by moding it by 64
mapToSetInCache:
li $s6, 64
div	$t6,$s6		#  Lo = $t5 / 64   (integer quotient)
mfhi	$t5		#  move quantity in special register Hi to $t5:   $t5 = Hi
li $v0, 1		# print out set that it maps to
add $a0, $t5, $0
syscall
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

# input: $t4 (number of memory calls), $t8 (number of hits) 
# output: $f0 avg mem access latency
# divides the number of hits by the number of memory calls
calcTotalHitRate:
sw   $t4, -88($fp)	#convert $t4 to float
lwc1 $f4, -88($fp)	
cvt.s.w $f1, $f4

sw   $t8, -88($fp)	#convert $t8 to float
lwc1 $f8, -88($fp)
cvt.s.w $f2, $f8

div.s $f12, $f2, $f1

ori $v0, $0, 2			# Display the hit rate	
syscall




li $v0, 4
la $a0, totalRuntimeMsg
syscall

ori $v0, $0, 1			# Display the total runtime ($t7 or num cycles)		
add $a0, $t7, $0	
syscall




li $v0, 4
la $a0, avgMemAccessLatencyMsg
syscall

# input: $t4 (number of memory calls), $t7 (number of cycles) 
# output: $f0 avg mem access latency
# divides the number of cycles by the number of memory calls
calcAvgMemAccessLatency:
sw   $t4, -88($fp)	#convert $t4 to float
lwc1 $f4, -88($fp)	
cvt.s.w $f1, $f4

sw   $t7, -88($fp)	#convert $t7 to float
lwc1 $f7, -88($fp)
cvt.s.w $f2, $f7

div.s $f12, $f2, $f1

ori $v0, $0, 2			# Display the average memory access latency	
syscall




####EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** ***
####---------------------------------------------------------------------------------------------------------------------------------

exit: 			#used for normal exit 
li $v0,10		# bye, bye
syscall
