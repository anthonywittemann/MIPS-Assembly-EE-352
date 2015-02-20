.text

#add 2 unsigned numbers
li	$t2, -12
li	$t3, 9
li, $v0, 1		# print int function
move $a0, $t2		#move the value to be printed into $a0 register
syscall


addu $a0, $t2, $t3
syscall
