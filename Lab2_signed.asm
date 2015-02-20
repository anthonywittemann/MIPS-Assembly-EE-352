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

#add 2 signed numbers
li	$t0, 11	
li	$t1, 5		#  $t1 = 5   ("load immediate")
li, $v0, 1		# print int functino
move $a0, $t1		# load $t1 into $a0 to be printed
syscall

add $a0, $t1, $t0	#  $a0 = $t1 + $t0;   add as signed (2's complement) integers
syscall
