.data
# --------------------------------------------------------------------------------------------
# Name: Daler Asrorov
# Assignment: Lab 5
# --------------------------------------------------------------------------------------------
# The lab takes the user inputs as 1s and outputs the output as the time set from the time the 
# interrupt was handled. As the result, the output should be something like 
# Print Asked : 1 time. Time is 01:11:21:36 ...     
# --------------------------------------------------------------------------------------------
#
KeyboardData: .word 0xffff0004
KeybordStatus: .word 0xffff0000

.text

# Triggering interrupt with the help of Keyborad Data and Keyboard Status dependencies
# that will control the program's flow depending on the status that is initiated with
# every input of the user. 
.macro triggerInterrupt			# Trigger the interrupt handler with... 
	lw $t5, KeyboardData		# keyboard data stored in the variable t2
	lw $t3, KeybordStatus		# and keyboard status stored in the veriable t3
	
	# using the specified function for more advanced
	# processing to utilize the least amount of time
	# using multiple registers.....
	mfc0 $a0, $12			
	ori $a0, 0xff11			
	mtc0 $a0, $12			
	lui $t0, 0xFFFF
	
	# method ori used for the 
	# extension of the variable
	# which is an immediate value 						
	ori $a0, $0, 2
	# storing the initial location content
	# to $a0 will help us determine the user's
	# state of inputs 
	sw $a0, 0($t0)		
.end_macro 

.macro trueLoop
	addi $s3, $0, 0 
# with the help of the lops and macros
# I am able to start the loop and 
# initiate the counter of seconds 
# comparing the first fariables	
	loop:
	    addi $s3, $s3, 1
	    bge $s3, 4, secondsPlusPlus # Rechange the clock speed to specific target
	    j loop
.end_macro

############################################################
################## MAIN FUNCTION ###########################
############################################################
main:
	# before adding the information to registers 
	# we initialize them to 
	triggerInterrupt
	
	####################################################
	# initiating the variables
   	addi $s1, $0, 1 
   	addi $t7, $0, 0 	# variable used for days
   	addi $t6, $0, 0 	# variable used for hours
   	addi $s4, $0, 0		# variable used for minutes
   	addi $s7, $0, 0 	# variablue used for seconds
   	addi $s5, $0, 0 	# Navigation flag is initiated to zero
   	
   	#******* triger the loop that evaulates the required data ******#
   	trueLoop
   	#******* load and print the terminating service...
   	li   $v0, 10   # The terminating service will be explicit in here...
   	syscall        # terminate normally

############################################################
################### MAIN FUNCTION ENDS #####################
############################################################

#---------------------------------------------------------#

############################################################
######## seconds++, minutes++, hours++, and days++ #########
############################################################

###############################################
# The following method increases the seconds 
# variable by one and points to the next vari-
# able in the memory scope... Then it switches
# to the minutes 
###############################################
secondsPlusPlus:
	addi $s3, $0, 0		# increamenting the pointer and stuff...
	addi $s7, $s7, 1	# adding one to the seconds variable
	beq $s7, 60, minutesPlusPlus
	trueLoop

###############################################
# The following method increases the minutes 
# variable by one and points to the next vari-
# able in the memory scope... Then it switches
# to the hours 
###############################################
minutesPlusPlus:
	addi $s7, $0, 0		# increamenting the pointer and stuff...
	addi $s4, $s4, 1	# adding one to the nubytes variable
	beq $s4, 60, hoursPlusPlus
	trueLoop

###############################################
# The following method increases the hours 
# variable by one and points to the next vari-
# able in the memory scope... Then it switches
# to the days. 
###############################################		
hoursPlusPlus:
	addi $s4, $0, 0		# increamenting the pointer and stuff...
	addi $t6, $t6, 1	# adding one to the nubytes variable
	beq $t6, 24, daysPlusPlus
	trueLoop

###############################################
# The following method increases the days 
# variable by one and points to the next vari-
# able in the memory scope... Then it triggers
# the output exception
###############################################		
daysPlusPlus:
	addi $t6, $0, 0
	addi $t7, $t7, 1			# increasing days...
	beq $t7, 20, triggerOutputExc 	# adding one to the nubytes variable
	trueLoop
 
####################################################
####################################################
############ The ++ section is over... #############
####################################################
####################################################  

#--------------------------------------------------# 
 
####################################################
####################################################
########### The Handler Section ####################
####################################################
####################################################  	
  	 	 	
.ktext 0x80000180
   	# handle exception in case of the trap
   	# provide the counter reset a
   	bge $s5, 3, setCounterToZero
	lw $s2, 0($t5)
	bne $s2, 49, fastExit # 49 is for ASCII representation of 1
   	jal cOutputAll
   	beqz $0, exit

exit:   
   	mfc0 $k0,$14   # Coprocessor 0 register $14 has address of trapping instruction
   	addi $k0,$k0,4 # Add 4 to point to next instruction
   	mtc0 $k0,$14   # Store new address back into $14
   	beq $0, $0, fastExit
fastExit:
   	eret           # Error return; set PC to value in $14


####################################################
####################################################
############# Output Everything ####################
####################################################
####################################################  
cOutputAll:
	# output the current time
	la $a0, PrintAskedPrompt
	jal outputString
	add $a0, $0, $s1
	jal printInitialDigitsBRRR
	la $a0, NumberOfTimesPropmpt
	jal outputString
	
	# print days to the user
	jal oD
	la $a0, putColonInString
	jal outputString
	
	# print hours to the user
	jal oH
	la $a0, putColonInString
	jal outputString
	
	# print minutes to the user
	jal oM
	la $a0, putColonInString
	jal outputString
	
	# print seconds to the user
	jal oS
	la $a0, NumberOfLinesOutput
	jal outputString
	
	# counter ++ setting the value 
	# to the next stage 
	# for the ongoing ouput and stuff...
	addi $s1, $s1, 1
	beqz $0, exit
	
triggerOutputExc:
	# Set counter exception flag
	addi $s5, $0, 5
	# Throw Exception
	teq $0, $0
	
setCounterToZero:
	addi $t7, $0, 0
	addi $t6, $0, 0
	addi $s4, $0, 0
	addi $s7, $0, 0
	
	# The exception flag is given the 
	# original value and sent back to 
	# the state of counting...
	add $s5, $0, $0
	trueLoop


#################################################	
# The output is triggered and set back
# To the next one so it could print out everything
#################################################	
outputString:
	li $v0, 4		# load value for printing
	syscall			# syscall for the trap
	jr $ra			# jr to execute
	
printInitialDigitsBRRR:
	li $v0, 1
	syscall
	jr $ra
	
oD:
	# provide the days calucation 
	# to the given variable 
	# and print it out
	add $a0, $s0, $t7
	add $t1, $ra, $0
	
	# the intial values printed
	jal printInitialDigitsBRRR
	jr $t1
	
oH:
	# provide the hours calucation 
	# to the given variable 
	# and print it out
	add $a0, $s0, $t6
	add $t1, $ra, $0
	
	# the intial values printed
	jal printInitialDigitsBRRR
	jr $t1
	
oM:
	# provide the minutes calucation 
	# to the given variable 
	# and print it out
	add $a0, $s0, $s4
	add $t1, $ra, $0
	
	# the intial values printed
	jal printInitialDigitsBRRR
	
	## jal
	jr $t1
	
oS:
	# provide the seconds calucation 
	# to the given variable 
	# and print it out
	add $a0, $s0, $s7
	add $t1, $ra, $0
	
	# the intial values printed
	jal printInitialDigitsBRRR
	jr $t1
.kdata	

# Setting up the necessary variablees for 
# the output and giving it fixed values 
# that will be prompted after each input 
# of the user... 1, 1, 1, 1, 1, etc.....

MAXIMAL_COUNTER: .double 120 			# The maximal counter that is set for each set of transactions.
PrintAskedPrompt:   .asciiz "Print Asked: "	# Prints the prompt ---> Print Asked
putColonInString:   .asciiz ":"			# Column printed ---> :
NumberOfTimesPropmpt:   .asciiz " time. Time is "   # Prints the prompt ---> time. Time is (followed by the time here)
NumberOfLinesOutput:   .asciiz "\n"		 # Prints out the new line

