# Title: 	Lab7 assignment - Processor Simulation Part II
# Author: 	Daler Asrorov
# Due Date:	Nov. 20th, 2015 (11 AM.)
# Date:		11/20/2015
.data
space: .asciiz " "
instructionMemory:	.word 0x8d410000, 0x8d420004, 0x14220003, 0x00221820, 0x00222024, 0x00222825, 0x00223022, 0x20c70064
			# LW; LW; BNE; 
			# ADD $3,$1,$2; AND $4,$1,$2; OR $5,$1,$2; SUB $6,$1,$2;
			# ADDI
intRegFile:		.word 0,1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31
dataMemory:		.word 20,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
	la $t0, dataMemory
	la $t1, intRegFile
	sw $t0, 40($t1) 
	
	

	li $t0, 8
	la $t1, instructionMemory
Begin:
	
	beqz $t0, EndTest
	lw $t2, ($t1)
	
	srl $t3, $t2, 26
	andi $t3, $t3, 0x003f
	beq $t3, 35, load
	beq $t3, 5, branchEqual
	beq $t3, 8, addImmideate
	beq $t3, 0, aluOperation
	
aluOperation:	
	#if using ALU 
	andi $t3, $t2, 0x003f #get function
	
	beq $t3, 0x00000020, ExecuteADD
	beq $t3, 0x00000024, ExecuteAND
	beq $t3, 0x00000025, ExecuteOR
	beq $t3, 0x00000022, Sub


GetSource:
	srl $t3, $t2, 21
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t5, ($t4)
	jr $ra

GetTarget:

	srl $t3, $t2, 16
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	lw $t6, ($t4) #value of register
	jr $ra
	
	
GetTargetNonAlu:
	srl $t3, $t2, 16
	andi $t3, $t3, 0x001f
	add $t6, $zero, $t3 #value of register
	jr $ra
	
WriteBack:
	srl $t3, $t2, 11
	andi $t3, $t3, 0x001f
	sll $t3, $t3, 2
	la $t4, intRegFile
	add $t4, $t4, $t3
	sw $t5,($t4)
    	jr $ra
 
    	
   	
load:
	jal GetSource
	jal GetTargetNonAlu
	addi $t7, $zero, 0
	andi $t7, $t2, 0xffff
	add $t7, $t7, $t5
	lw $s1,	($t7)
	sll $t6, $t6, 2
	la $t4, intRegFile
	add $t4, $t4, $t6
	sw $s1,($t4)
	j EndOperation
	
branchEqual:
	
jal GetSource   #branch equal
	jal GetTarget
	bne  $t5, $t6, branch
	
	j EndOperation
branch:
	addi $t7, $zero, 0
	andi $t7, $t2, 0xffff
	add $s1, $t7, $zero
	sll $t7, $t7, 2
	add $t1, $t1, $t7
	sub $t0, $t0, $s1

	j Begin
	
	
addImmideate:	
	jal GetSource
	jal GetTargetNonAlu
	addi $t7, $zero, 0
	andi $t7, $t2, 0xffff
	add $t5, $t5, $t7
	
	sll $t6, $t6, 2
	la $t4, intRegFile
	add $t4, $t4, $t6
	sw $t5,($t4)
	j EndOperation
ExecuteADD:

	jal GetSource
	jal GetTarget
	add $t5, $t5, $t6 		# implementation of add function
	jal WriteBack
	
	j EndOperation    	
ExecuteAND:
	jal GetSource
	jal GetTarget
	and $t5, $t5, $t6 
	jal WriteBack
	j EndOperation
Sub:
	jal GetSource
	jal GetTarget
	sub $t5, $t5, $t6
	jal WriteBack
	j EndOperation
	
ExecuteOR: 
	jal GetSource
	jal GetTarget
	or $t5, $t5, $t6
	jal WriteBack
	j EndOperation
	



EndOperation:
	addi $t1, $t1, 4
	subi $t0, $t0, 1
	j Begin
	

EndTest:
	jal DumpRegisters
    	li $v0, 10                 # Exit program.  
    	syscall

DumpRegisters: # Dump the registers on the screen.
	li $t0, 32 # Set a counter as the number of the registers (= 32).
	la $t1, intRegFile # Load the address of the integer register file 'intRegFile'.
Loop1:	lw $t2, ($t1)	 # Load the value at $t0 into $t1.
	beqz $t0, LoopEnd1 # Exit the loop.
	
	add $a0,$t2,$0	# Move $t1 to $a0.
    	li $v0, 1      	# Print integer.              
    	syscall

    	la $a0, space	# Load a space:  " ".
    	li $v0, 4     	# Print string.               
    	syscall
	
	addi $t1, $t1, 4 # Increment the address of the pointer to 'intRegFile'by 4.
	subi $t0, $t0, 1	# Increment the address of 'theArray' by 4.
	j Loop1 	# Jump to 'Cont1'.
	
    	LoopEnd1:	jr $ra		#return