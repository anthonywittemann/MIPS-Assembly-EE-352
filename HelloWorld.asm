.data
string1: .asciiz "Hello World!\n"
string2: .asciiz "Anthony Wittemann\n"
.text
main: 
li $v0, 4 # specify Print String service
la $a0, string1 # output string
#la $a0, string2
syscall # call service