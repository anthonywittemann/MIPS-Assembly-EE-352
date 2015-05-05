# Cache Configuration: 1KB 2D array (64 sets which is 4 way set associative - each word entry is 4 bytes)



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
exit:			#used for invalid input
li $v0, 4
la $a0, invalidInputMsg
syscall

exit1: 			#used for normal exit 
li $v0,10		# bye, bye
syscall
