# Title: 	Lab4 assignment - Bubble sort & Stack and get input
# Author: 	Daler Asrorov
# Description:	1) Bubblesort the positive numbers in 'theArray' in ascending order 
#		2) and push the sorted positive numbers on 'theStack', the smallest first.
# Date:
.data
space: 		.asciiz " "

.align 4
theArray: 	.space  24
d
kbddata: .word 0xffff0004 #received data
kbdstatus: .word 0xffff0000 #received if 1
sendData: .word 0xffff000c #send data
sendStatus: .word 0xffff0008 #can send if 1
.text
main:   
	lw $t0, kbddata
	lw $t1, kbdstatus
	lw $k0, sendData
	lw $k1, sendStatus
	
	mfc0 $a0, $12			# read from the status register
	ori $a0, 0xff11			# enable all interrupts
	mtc0 $a0, $12			# write back to the status register
	lui $t0, 0xFFFF			# $t0 = 0xFFFF0000;
	ori $a0, $0, 2				# enable keyboard interrupt
	sw $a0, 0($t0)			# write back to 0xFFFF0000;
	
	
	la $a1, theArray
	
	j here
	li $v0, 10  	# Exit the program.   
    	syscall 
here: 
	bgtz $s0, sort
	bgtz $s1, print
	j here				# stay here forever

	li $v0, 10				# exit,if it ever comes here
	syscall
	
finish:	
	li $v0, 10				# exit,if it ever comes here
	syscall

sort: 
	addi $s0, $zero, 0
	
BubbleSort:
	####################
	# WRITE YOUR CODE HERE!
	####################
	la  $t0, theArray      # Copy the base address of your array into $t1
    	addi $t0, $t0, 20    # 4 bytes per int * 10 ints = 40 bytes                              
outterLoop:             # Used to determine when we are done iterating over the Array
	add $t1, $0, $0     # $t1 holds a flag to determine when the list is sorted
    	la  $a0, theArray      # Set $a0 to the base address of the Array
innerLoop:                  # The inner loop will iterate over the Array checking if a swap is needed
   	lw  $t2, 0($a0)         # sets $t0 to the current element in array
   	lw  $t3, 4($a0)         # sets $t1 to the next element in array
   	bltz $t3, continue
   	slt $t5, $t3, $t2      # $t5 = 1 if $t0 < $t1
    	beq $t5, $0, continue   # if $t5 = 1, then swap them
    	add $t1, $0, 1          # if we need to swap, we need to check the list again
    	sw  $t2, 4($a0)         # store the greater numbers contents in the higher position in array (swap)
    	sw  $t3, 0($a0)         # store the lesser numbers contents in the lower position in array (swap)
continue:
    	addi $a0, $a0, 4            # advance the array to start at the next location from last time
    	bne  $a0, $t0, innerLoop    # If $a0 != the end of Array, jump back to innerLoop
    	bne  $t1, $0, outterLoop    # $t1 = 1, another pass is needed, jump back to outterLoop	
	
			
	
	
	
	addi $s1, $zero, 1
	la $ra here
	jr $ra
	



	
.ktext 0x80000180				# kernel code starts here
	
	
	lw $s2, 0($t1)
	bgtz $s2, getInput

    	

getInput:
	lw $t5, 4($t0) #read received data
	addi $t3, $zero, 10
	beq $t5, $t3, putInput
	
	add $a0, $zero, $t5
    	
	mul $t8, $t8, 10
	andi $t5,$t5,0x0F


	add $t8, $t8, $t5
	eret

	
putInput:
	sw $t8, 0($a1)
	
	addi $a1, $a1, 4
	addi $t6, $t6, 1
	addi $s5, $zero, 5
	li $t8, 0
	beq $t6, $s5, endread 
	eret
    	
	
endread:
	addi $s5,$zero, -1
	sw $s5, 0($a1)
	addi $s0, $zero, 1
	eret
	
		
	
	



print:
	la $t8, theArray
Cont1:	lw $t9, ($t8)	 # Load the value at $t0 into $t1.
	bltz $t9, ExitPrintArray # Exit the loop.
	
	add $a0,$t9,$0	# Move $t1 to $a0.
    		li $v0, 1     	# Print string.               
    	syscall

    	la $a0, space	# Load a space:  " ".
    	li $v0, 4     	# Print string.               
    	syscall
    	
    	
    
	
	addi $t8,$t8,4	# Increment the address of 'theArray' by 4.
	j Cont1 	# Jump to 'Cont1'.
	
ExitPrintArray:
	li $v0, 10				# exit,if it ever comes here
	syscall
	


