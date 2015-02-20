.data
string1: .asciiz "Anthony Wittemann\n"
.text
main: 

#li $t0, 10	# num loops
#move $s0, $zero	# loop counter

#loop: 	
#	li $v0, 4 		# specify Print String service
#	la $a0, string1 	# output string
#	add $s0, $s0, 1		# increment counter
#	#add $a0, $a0, 8		# increment output address (actually cuts off 8 characters from the output)
#	bne $s0, $t0, loop	# loop back if s0 != t0
	
	
loop:
li $v0, 4
la $a0, string1
syscall
addi $t0, $t0, 1
bne $t0, 10, loop

#still only outputs the string once with different addresses
#li $v0, 4 		# specify Print String service
#la $a1, string1 	# output string
#la $a2, string1 	# output string
#la $a3, string1 	# output string


syscall # call service (gets out)