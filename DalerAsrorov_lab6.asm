# Title: 	Lab6 assignment - Processor Simulation with ALU operations
# Author: 	Daler Asrorov
# TA:		Sang 
# Due Date:	Nov. 13th, 2015 (11 AM)
# Date:		Nov 12th, 2015 (9PM)
.data
space: .asciiz " "
memOfInst:	.word 0x00221820, 0x00222024, 0x00222825, 0x00223022	# instruction memory
intRegFile:	.word 0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31	# intRegFile given

# load the counter to the first register and 
# load the memory of the instruction 
# into l1 
.text
	li $t0, 4				# load 4 into $t0
	la $t1, memOfInst			# memory address is loaded in the $t1

TriggerSimul:
	beqz $t0, EndSimul			# branch if $t0 is equal to the ending simulation
	lw $t2, ($t1)				# load the values for the further processing
	
	
	# Gathering and executing functions
	# and following the logic based on the 
	# provided data and operations.
	andi $t3, $t2, 0x003f 			# Obtaining the function for further processing 
	beq $t3, 0x00000020, ExecuteAdd		# Executing the add function 
	beq $t3, 0x00000024, ExecuteAnd		# Executing the And operation for getting two values to bind
	beq $t3, 0x00000025, ExecuteOr		# Executing the Or operation for 'Or'ing' the two values to bind
	beq $t3, 0x00000022, ExecuteSub		# Executing the subtraction for two values to subtract consisting content

######################################################
############### Execution implementations ############
###############*************************#############
#####################################################

# The following implementation of the add function
# gets the data binding together and making the 
# redex operation that stores the values into 
# registers and makes call to the memory 
# for storing and returning the data 
# that makes further coles    	    	
ExecuteAdd:
	srl $t3, $t2, 21		# store the initial integer for the follow function
	andi $t3, $t3, 0x001f		# returns true in case of the truth values
	
	# Shifts a register value left by the shift amount listed in the instruction 
	# and places the result in a third register. Zeroes are shifted in.
	sll $t3, $t3, 2			# shift the variables by the index (2)	
	la $t4, intRegFile		# load the value of the intRegFile method
	add $t4, $t4, $t3		# perform addition
	lw $t5, ($t4)			# load the address of the result to $t5
	
	srl $t3, $t2, 16
	######################
	# Adding tha address that 
	# is currently used
	# and store it into $t3		
	andi $t3, $t3, 0x001f		# perform and operation to the $t3
	sll $t3, $t3, 2			# Again, indexing (2)
	la $t4, intRegFile		# trigger and load the integFile method
	add $t4, $t4, $t3		# add it with the indexed register
	lw $t5, ($t4) 			# grabs register's value iiii l5	
	add $t5, $t5, $t6 		# perform more addition 
	srl $t3, $t2, 11		# shift the value to the right
	andi $t3, $t3, 0x001f		# perform and operation for this condition
	sll $t3, $t3, 2			# shift the position to the value
	la $t4, intRegFile		# intRegFile is loaded to the register
	add $t4, $t4, $t3		# add both variables for the final review
	sw $t5,($t4)			# storing values of the results
#	li $t5, $a3;
	j FinishAllInOperation			# call and jump to the end of operations
	
# The following implementation of the AND function
# gets the data binding together and making the 
# AND operation that stores the values into 
# registers and makes call to the memory 
# for storing and returning the data 
# that makes further calls 	
# AND operation returns true if both
# values are true; otherwise it 
# outputs FALSE.     	
ExecuteAnd:
	srl $t3, $t2, 21			# shift the given value to the right
	andi $t3, $t3, 0x001f			# perform the andi order for the function
	sll $t3, $t3, 2				# shift left logical to itself ($t3)
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t5, ($t4)
	
	srl $t3, $t2, 16
	andi $t3, $t3, 0x001f			# perform the andi order for the function
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t5, ($t4) #value of register
	
	and $t5, $t5, $t6 #and 
	
	srl $t3, $t2, 11
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	sw $t5,($t4)
	j FinishAllInOperation				# Essentially, end the operation
	

# The following implementation of the AND function
# gets the data binding together and making the 
# OR operation that stores the values into 
# registers and makes call to the memory 
# for storing and returning the data 
# that makes further calls 	
# OR operation returns true if at least
# one value is true; if bot values are FALSE,
# then it returns FALSE
ExecuteOr: 
	srl $t3, $t2, 21				# indexing and stuff again
	andi $t3, $t3, 0x001f				# storing the address to $t3
	sll $t3, $t3, 2					# shift left logical
	la $t4, intRegFile				# load the logical operation
	add $t4, $t4, $t3
	lw $t5, ($t4)
	
	srl $t3, $t2, 16
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t6, ($t4)
	
	or $t5, $t5, $t6
	

	srl $t3, $t2, 11
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	sw $t5,($t4)
	j FinishAllInOperation			# Essentially, end the operation
	

# The following implementation of the substraction function
# gets the data binding together and making the 
# subtraction operation that stores the values into 
# registers and makes call to the memory 
# for storing and returning the data 
# that makes further calls 	
# for subtraction 
ExecuteSub:
	srl $t3, $t2, 21
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t5, ($t4)
	
	srl $t3, $t2, 16
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t6, ($t4)
	
	sub $t5, $t5, $t6
	
	srl $t3, $t2, 11
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	sw $t5,($t4)
	j FinishAllInOperation				# Essentially, end the operation

# The following function indicates
# the end of the operation that 
# calls back to function 
# that initiates the simulation
# function
FinishAllInOperation:
	addi $t1, $t1, 4	# Adding the address counter by 4 
	subi $t0, $t0, 1	# Subtracting the holder of the total size
	j TriggerSimul		
	

######################################################
############# Ending simulation for review ###########
###############*************************#############
#####################################################

EndSimul: 
	jal DumpRegisters
	# The dump registers will load the values for the ouput
	# that will be shown to the user...	   
    	li $v0, 10                 # Quit the program after loading the value and making a call
    	syscall			   # Instant execution and carrot value returned	

########################################
########################################

# The Given function will 'dump' the 
# processed registers and output them
# to the user... 

DumpRegisters: 				# Given dumping function for outputing it into the console
	li $t0, 32			# Set a counter as the number of the registers (= 32).
	la $t1, intRegFile 		# Load the address of the integer register file 'intRegFile'.
Loop1:	lw $t2, ($t1)			# Load the value at $t0 into $t1.
	beqz $t0, LoopEnd1 			# Exit the loop.	
	add $a0,$t2,$0			# Taking over $t1 to another register, *---> $a0.
    	li $v0, 1      			# Output the value to the console for further review by the user.      
    	syscall				# Seperated by the syscall
    	la $a0, space			# Grab space and load it into the $a0 register
    	li $v0, 4     			# Output the values to the user as well...              
    	syscall				# Seperated by the syscall
	addi $t1, $t1, 4 		# Increment the address of the pointer to 'intRegFile'by 4.
	subi $t0, $t0, 1 		# Increment the address of 'theArray' by 4.
	j Loop1 				# jump throw that goes back to the re-called function
	
    	LoopEnd1:	jr $ra			# return the value out of the loop
    	
    	
    	
