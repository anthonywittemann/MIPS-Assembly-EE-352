
# declare global so programmer can see actual addresses.
.globl welcome
.globl prompt
.globl sumText

#  Data Area
.data

welcome:
	.asciiz " This program converts Celsius to Fahrenheit \n\n"

prompt:
	.asciiz " Enter an integer Celsius temperature: "

sumText: 
	.asciiz " \n F = "

coldText:
	.asciiz "\nBrrrr!!!\n"

hotText:
	.asciiz "\nIt's SWELTERING!\n"

#Text Area (i.e. instructions)
.text

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

	# if (F < 60), printf ("Brrr!!\n");
	slti $t0, $s0, 60
	beq $t0, $0, after
	ori $v0, $0, 4
	la $a0, coldText
	syscall
	j after2  # this makes it an else if - skip the else statement
after:	
	# else if (F >= 90) printf("It's SWELTERING!\n");
	slti $t0, $s0, 90
	bne $t0, $0, after2
	ori $v0, $0, 4
	la $a0, hotText
	syscall
after2:	
	#instead of exit ask if continue main
	j main1
	
	# Exit
	ori     $v0, $0, 10
	syscall
