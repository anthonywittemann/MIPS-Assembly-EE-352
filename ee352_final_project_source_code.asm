# Cache Configuration: 1KB 2D array (64 sets which is 4 way set associative - each word entry is 4 bytes)
# Line Size: 4 bytes
# Associativity: set associative
# Data Size: 1 KB
# Replacement Policy: LRU
# Miss Penalty: 8 cycles

# TODO make sure that the hits are truly hits (i.e. value from memory is also in the cache)

.data
totalHitRateMsg: .asciiz "\n\nTotal Hit Rate (The percentage of memory ops \n(i.e. lines in the trace file) that were hits): "
totalRuntimeMsg: .asciiz "\n\nTotal Runtime (total processor cycles assuming \nthat the last memory access was the last instruction of the program): "
avgMemAccessLatencyMsg: .asciiz "\n\nAverage Memory Access Latency \n(The average number of cycles needed to complete a memory access): "

space: .asciiz "  "
newLine: .asciiz "\n"
 
testingMsg: .asciiz "TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ----"
testingMsg1: .asciiz "TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 ****"
traceFileMsg: .asciiz "Memory Address Trace:\n"

fp1: .float 1.0

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
li $t9, 10000


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

## TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ TRACEFILE +++ +++ ###
randomNumber:
	li $a0, 0 #seed random generation with 0
	li $a1, 0x10000 #setting upper bound to 2^32 -1
	li $v0, 42 ##prepare to syscall random generator
	#la $t2, ($a0)
	syscall #random number is now stored in $a0
	la $t2, ($a0)
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
div	$t2,$s6		#  Lo = $t5 / 64   (integer quotient)
mfhi	$t5		#  move quantity in special register Hi to $t5:   $t5 = Hi
li $v0, 1		# print out set that it maps to
add $a0, $t5, $0
syscall
li $s6, 32
div $t2, $s6
mfhi $t3
jr $ra

checkIfSetInCache:
#$s1 is column counter
#$t1 is number of columns
#$t2 is value
mult $t5, $t1
mflo $s3
li $s1, -1
loopingOverRow:		#$s3 give us the index of the LRU column in the set
add 	$s1, $s1, 1
add      $s3, $s3, $s1  # $s3 += column counter
sll      $s3, $s3, 2  
beq 	$s1, 3, replaceCache 
lw 	$s4, data($s3)
li $s6, 32
div $s4, $s6
mfhi $s5
beq 	$t3, $s5, replaceCacheHit
bne  	$t3, $s5, loopingOverRow
jr $ra

replaceCache: #replace from the back of the column counter
add $t7, $t7, 5	#incur miss penalty
beq $s1, 0, endReplaceCache
sub $s4, $s3,1
sll $s4, $s4, 2
replaceCacheLoop:
lw $s5, data($s4)
sw $s5, data($s3)
la $s3, ($s4)
sub $s4, $s3,1
sll $s4, $s4, 2
sub $s1, $s1, 1
beq $s1, 0, replaceCacheLoop
endReplaceCache:
sw $t2, data($s3)
jr $ra		# fetch next memory address 

replaceCacheHit: #replace from the back of the column counter and report a hit
add $t8, $t8, 1 	#hitCount++
beq $s1, 0, endReplaceCacheHit
sub $s4, $s3,1
sll $s4, $s4, 2
replaceCacheLoopHit:
lw $s5, data($s4)
sw $s5, data($s3)
la $s3, ($s4)
sub $s4, $s3,1
sll $s4, $s4, 2
sub $s1, $s1, 1
beq $s1, 0, replaceCacheLoopHit
endReplaceCacheHit:
sw $t2, data($s3)
jr $ra			# fetch next memory address 
		

####RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** *** RESULTS *** ***
####---------------------------------------------------------------------------------------------------------------------------------
displayResults:



li $v0, 1	#print out total number of hits
add $a0, $t8, $0
syscall

li $v0, 4
la $a0, totalHitRateMsg
syscall

# input: $t4 (number of memory calls), $t8 (number of hits) 
# output: $f12 hit rate
# divides the number of hits by the number of memory calls
calcTotalHitRate:
sw   $t4, -88($fp)	#convert $t4 to float
lwc1 $f4, -88($fp)	
cvt.s.w $f1, $f4

sw   $t8, -88($fp)	#convert $t8 to float
lwc1 $f8, -88($fp)
cvt.s.w $f2, $f8


div.s $f12, $f2, $f1	# divide to get hit rate

l.s $f5, fp1
sub.s $f12, $f5, $f12

ori $v0, $0, 2		# Display the hit rate	
syscall




li $v0, 4
la $a0, totalRuntimeMsg
syscall

ori $v0, $0, 1		# Display the total runtime ($t7 or num cycles)		
add $a0, $t7, $0	
syscall




li $v0, 4
la $a0, avgMemAccessLatencyMsg
syscall

# input: $t4 (number of memory calls), $t7 (number of cycles) 
# output: $f12 avg mem access latency
# divides the number of cycles by the number of memory calls
calcAvgMemAccessLatency:
sw   $t4, -88($fp)	#convert $t4 to float
lwc1 $f4, -88($fp)	
cvt.s.w $f1, $f4

sw   $t7, -88($fp)	#convert $t7 to float
lwc1 $f7, -88($fp)
cvt.s.w $f2, $f7

div.s $f12, $f2, $f1

ori $v0, $0, 2		# Display the average memory access latency	
syscall




####EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** *** EXIT *** ***
####---------------------------------------------------------------------------------------------------------------------------------

exit: 			#used for normal exit 
li $v0,10		# bye, bye
syscall
