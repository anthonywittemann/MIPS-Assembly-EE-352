.data
space: 		.asciiz ":"
newLine: .asciiz "\n"
printAsked: .asciiz "Print Asked : "
times: .asciiz " times. "
.align 4

howManyTimes: .space 4
second: .space 4
minute: .space 4
hour: .space 4
maxHour: .space 4

kbddata: .word 0xffff0004 #received data
kbdstatus: .word 0xffff0000 #received if 1

.text
main:   
	lw $t0, kbddata
	lw $t1, kbdstatus
	
	addi $s6, $zero, 0

	mfc0 $a0, $12			# read from the status register
	ori $a0, 0xff11			# enable all interrupts
	mtc0 $a0, $12			# write back to the status register
	lui $t0, 0xFFFF			# $t0 = 0xFFFF0000;
	ori $a0, $0, 2				# enable keyboard interrupt
	sw $a0, 0($t0)			# write back to 0xFFFF0000;
	
	addi $s3, $zero, 1
	
	
	la $s1, maxHour
	la $a1, second
	la $a2, minute
	la $a3, hour
	
	sw $zero, ($a1)   
	sw $zero, ($a2)
	sw $zero, ($a3)
	la $s5, howManyTimes
	sw $zero, ($s5)
	
	j loop
	li $v0, 10  	   
    	syscall 
loop: 
	
	beqz $s6, loop
	
	addi $s4, $zero, 0
countLoop:
	addi $s4, $s4, 1
	bge $s4, $s3, incrementSecond

	j countLoop				

	li $v0, 10				
	syscall
	
incrementSecond:
	lw $t9, ($a1)
	addi $t8, $zero, 59
	bge $t9, $t8, incrementMinute
	addi $t9, $t9, 1
	sw $t9, ($a1)

	j loop
	
incrementMinute:
	addi $t9, $zero, 0
	sw $t9, ($a1)
	lw $k0, ($a2)
	addi $t8, $zero, 59
	bge $k0, $t8, incrementHour
	addi $k0, $k0, 1
	sw $k0, ($a2)

	j loop
	
incrementHour:
	addi $k0, $zero, 0
	sw $k0, ($a2)
	lw $k1, ($a3)
	lw $t8, ($s1)
	addi $t8, $t8, -1
	bge $k1, $t8, resetToZero
	addi $k1, $k1, 1
	sw $k1, ($a3)

	j loop

resetToZero:
	addi $s6, $zero, 2
	teqi $s6, 2
	la $s5, howManyTimes
	lw $t5, ($s5)
	addi $t5, $zero, 0
	sw $t5, ($s5)
	j loop
reset:
	addi $k1, $zero, 0
	sw $k1, ($a3)
	addi $s6, $zero, 1
	eret
	
.ktext 0x80000180				# kernel code starts here
	
	
	lw $s2, 0($t1)
	beqz $s2, goBack
	beq $s6, 1, checkOne
	beqz $s6, getMaxHour
	beq $s6, 2, reset
	

	
	eret
	
goBack:
	eret

    	

getMaxHour:

	lw $t5, 4($t0) #read received data
	addi $t3, $zero, 10
	beq $t5, $t3, putMaxHour
	
	add $t3, $zero, $t5
    	
	mul $s5, $t8, 10
	andi $t5,$t5,0x0F


	add $t8, $t8, $t5
	eret

	
putMaxHour:
	sw $t8, ($s1)
	addi $s6, $zero, 1
	addi $t5, $zero, 0
	eret
    	
	

	

printTime:
	
	la $s5, howManyTimes
	lw $t5, ($s5)
	addi $t5, $t5, 1
	sw $t5, ($s5)
	
	la $a0, printAsked	
    	li $v0, 4     	# Print string.               
    	syscall
    	
    	add $a0,$t5,$0	# Move $t1 to $a0.
    	li $v0, 1     	# Print string.               
    	syscall
    	
    	la $a0, times	
    	li $v0, 4     	# Print string.               
    	syscall
	lw $t9, ($a1)	
	lw $t8, ($a2)	
	lw $t7, ($a3)	
	
	add $a0,$t7,$0	# Move $t1 to $a0.
    	li $v0, 1     	# Print string.               
    	syscall

    	
    	la $a0, space	# Load a space:  " ".
    	li $v0, 4     	# Print string.               
    	syscall
    	
    	add $a0,$t8,$0	# Move $t1 to $a0.
    	li $v0, 1     	# Print string.               
    	syscall
    	
    	la $a0, space	# Load a space:  " ".
    	li $v0, 4     	# Print string.               
    	syscall
    	
    	add $a0,$t9,$0	# Move $t1 to $a0.
    	li $v0, 1     	# Print string.               
    	syscall
    	
    	la $a0, newLine	# Load a space:  " ".
    	li $v0, 4     	# Print string.               
    	syscall
    	
    	
    

	eret
	
	

checkOne:
	lw $t5, 4($t0) #read received data
	addi $t3, $zero, 49
	beq $t5, $t3, printTime
	
	eret