#Anthony Wittemann Lab 4

# declare global so programmer can see actual addresses.
.globl welcome
.globl prompt
.globl sumText
.globl conversionQuestion
.globl welcome1
.globl prompt1
.globl sumText1

.data
CForFC:
    .asciiz " \n input “CF”(celsius to fahrenheit) or “FC”(Fahrenheit to celsius)"  
answer:
    .space 256

again:
    .asciiz " \n Again (y or n)? " 
    
welcome1:
	.asciiz " \n This program converts Fahrenheit to Celsius \n\n"

prompt1:
	.asciiz " \n Enter an integer Fahrenheit temperature: "

sumText1: 
	.asciiz " \n C = "

welcome:
	.asciiz " \n This program converts Celsius to Fahrenheit \n\n"

prompt:
	.asciiz " \n Enter an integer Celsius temperature: "

sumText: 
	.asciiz " \n F = "

.text 
conversionQuestion: 
    li  $v0, 4  	#ask if CF or FC
    la  $a0, CForFC  
    syscall
    
    la  $a0, answer
    li  $a1, 3
    li  $v0, 8
    syscall

    lb  $t4, 0($a0)
    
    beq $t4, 'C', main	#go to convert C->F
    beq $t4, 'F', main1	#go to convert F->C
    j conversionQuestion
    
    #convert C->F
main:
	# Display welcome
	ori $v0, $0, 4
	la $a0, welcome
	syscall

	# Display prompt
	ori     $v0, $0, 4
	la $a0, prompt			
	syscall

	# Read 1st integer
	ori     $v0, $0, 5
	syscall

	# C is in $v0	
	addi $t0, $0, 9
	mult $t0, $v0
	mflo $t0    # 9*C
	addi $t1, $0, 5
	div $t0, $t1
	mflo $t0    # 9*C/5
	addi $s0, $t0, 32   # 9*C/5+32

	# Display the sum text
	ori     $v0, $0, 4
	la $a0, sumText			
	syscall
	
	# Display the result
	ori     $v0, $0, 1			
	add 	$a0, $s0, $0	 
	syscall
	
	#instead of exit ask if continue main
	j continue
	
	
    #convert F->C
main1:
	# Display welcome
	ori $v0, $0, 4
	la $a0, welcome1
	syscall

	# Display prompt
	ori     $v0, $0, 4
	la $a0, prompt1			
	syscall

	# Read 1st integer
	ori     $v0, $0, 5
	syscall

	# F is in $v0			#(F-32) * 5 / 9
	addi $t1, $0, 9		#t1 = 9
	addi $t0, $0, 5		#t0 = 5
	addi $s0, $0, 32	#s0 = 32
	
	sub $v0, $v0, $s0	#F-32
	
	mult $t0, $v0
	mflo $t0    # 5*(F-32)

	div $t0, $t1
	mflo $t0    # 5*(F-32)/9

	# Display the sum text
	ori     $v0, $0, 4
	la $a0, sumText1			
	syscall
	
	# Display the result
	ori     $v0, $0, 1			
	add 	$a0, $t0, $0	 
	syscall
	
	#instead of exit ask if continue main
	j continue
	
continue:
    li  $v0, 4  
    la  $a0, again  
    syscall  

    la  $a0, answer
    li  $a1, 3
    li  $v0, 8
    syscall

    lb  $t4, 0($a0)

    beq $t4, 'y', conversionQuestion	#ask if CF or FC if continue

    li  $v0, 10 		#else quit
    syscall 