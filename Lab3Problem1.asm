#Write a MIPS Assembly code to find the maximum and minimum numbers 
#from a list of 10 whole numbers and then find their average.

.data
space: .asciiz " "
X: .word 31, 17, 92, 46, 172, 208, 13, 93, 65, 112 	#array of 10 elements
N: .word 10						#number of elements

.text
main:   la $a0, X       #$a0=load address of array X
    	lw $a1, N       #$a1=10  --number elements
    	
    	li $t2, 0	#max = 0
    	li $t3, 100	#min = 100
    	
    	jal readArray  #call readArray
    	li $v0, 10      #exit program   
    	syscall 
    	
    	
readArray:
    li $t0, 0       		#counter = 0
    li $t1, 0       		#location of array = 0
    
loop:    bge $t0, $a1, final 	#if  $t0 >= $a1 then goto final
    lw $a0, X($t1) 		#$a0 = X(i)
    
    blt $a0, $t3, new_min	#if X(i) < min
    j check_max
    new_min: move $t3, $a0		#min = X(i)
    j update_counter
    
    check_max:
    bgt $a0, $t2, new_max	#if X(i) > max
    j update_counter
    
    new_max: move $t2, $a0		#max = X(i)
    
    update_counter:
    addi $t1, $t1, 4    	#Every 4 bytes there is an integer in the array
    addi $t0, $t0, 1    	#counter ++
    b loop       		#goto loop
final:  
	li $v0, 1		#integer print
	move $a0, $t2		#load the max to be printed
	syscall			#execute the print

	la $a0, space   	#load a space:  " "
    	li $v0, 4       	#print string               
    	syscall
	
	li $v0, 1		#integer print
	move $a0, $t3		#load the min to be printed
	syscall			#execute the print
	
	la $a0, space   	#load a space:  " "
    	li $v0, 4       	#print string               
    	syscall

	add $t4, $t2, $t3	#sum = min + max
	div $t5, $t4, 2		#avg = sum / 2
	li $v0, 1		#integer print
	move $a0, $t5		#load the average to be printed
	syscall
    	jr $ra      		#return

	