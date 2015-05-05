# Cache Configuration: 1KB 2D array (64 sets which is 4 way set associative - each word entry is 4 bytes)
# Line Size: 4 bytes
# Associativity: set associative
# Data Size: 1 KB
# Replacement Policy: LRU
# Miss Penalty: 4 cycles

.data
totalHitRateMsg: .asciiz "\nTotal Hit Rate (The percentage of memory ops \n(i.e. lines in the trace file) that were hits): "
totalRuntimeMsg: .asciiz "\nTotal Runtime (total processor cycles assuming \nthat the last memory access was the last instruction of the program): "
avgMemAccessLatencyMsg: .asciiz "\nAverage Memory Access Latency \n(The average number of cycles needed to complete a memory access): "

space: .asciiz "  "
 
testingMsg: .asciiz "TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ---- TESTING ----"
testingMsg1: .asciiz "TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 **** TESTING1 ****"

totalHitRate: .word -1
totalRuntime: .word -1
avgMemAccessLatency: .word -1

.text
main:







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
