#Write a MIPS Code on MARS Simulator to add 2 Unsigned numbers.
#Check the values in the registers that you loaded.
#Check the values in the register after the add operation

#Write a MIPS code on MARS Simulator to add 2 Signed Numers
#Make one of the operands as negative.
#Check the values in the registers that you loaded.
#Check the values in the register after the add operation

#Write a MIPS code to subtract 2 Numbers using ‘add’ operation
#Hint : Use 2’s compliment Numbers

#signed + or -
#unsigned +

.text
main:

#add 2 signed numbers
li	$t0, 11	
li	$t1, 5		#  $t1 = 5   ("load immediate")
li, $v0, 1		# print int
move $a0, $t1
syscall

add $a0, $t1, $t0	#  $a0 = $t1 + $t0;   add as signed (2's complement) integers
syscall

#add 2 unsigned numbers
li	$t2, -12
li	$t3, 9
move $a0, $t2
syscall
addu $a0, $t2, $t3
syscall

li, $v1, 10
syscall