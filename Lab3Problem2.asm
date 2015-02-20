#Write a MIPS Assembly code to sort these 10 numbers 
#(in problem # 1) in ascending order and print the result

.data
space: .asciiz " "
X: .word 31, 17, 92, 46, 172, 208, 13, 93, 65, 112 	#array of 10 elements
N: .word 10						#number of elements

.text
#implementatino of bubble sort
main:
    la  $t0, X      	# Copy the base address of array into $t0
    add $t0, $t0, 40    # 4 bytes per int * 10 ints = 40 bytes                              
outterLoop:             # Used to determine when we are done iterating over the Array
    add $t1, $0, $0     # $t1 holds a flag to determine when the list is sorted
    la  $a0, X      	# Set $a0 to the base address of the Array
innerLoop:                  # The inner loop will iterate over the Array checking if a swap is needed
    lw  $t2, 0($a0)         # sets $t2 to the current element in array
    lw  $t3, 4($a0)         # sets $t3 to the next element in array
    slt $t5, $t2, $t3       # $t5 = 1 if $t2 < $t3
    beq $t5, $0, continue   # if $t5 = 1, then swap them
    add $t1, $0, 1          # if we need to swap, we need to check the list again
    sw  $t2, 4($a0)         # store the greater numbers contents in the higher position in array (swap)
    sw  $t3, 0($a0)         # store the lesser numbers contents in the lower position in array (swap)
continue:
    addi $a0, $a0, 4            # advance the array to start at the next location from last time
    bne  $a0, $t0, innerLoop    # If $a0 != the end of Array, jump back to innerLoop
    bne  $t1, $0, outterLoop    # If $t1 != 1, loop again


li $t6, 36		#location of array = 36		

loop:	blt $t6, 0, finish	#if location <= 0 then finish
	lw $a0, X($t6)		#load current element of array to be printed
	li $v0, 1		#print integer
	syscall			#execute
	
	la $a0, space   	#load a space:  " "
    	li $v0, 4       	#print string               
    	syscall
	
	sub $t6, $t6, 4    	#Every 4 bytes there is an integer in the array
    	b loop       		#goto loop
	
finish:
li $v0, 10      #exit program   
syscall 
	
