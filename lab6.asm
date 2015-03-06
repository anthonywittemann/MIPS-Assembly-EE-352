.data
msg1:.asciiz "Give a number: "
.text
.globl main
main:

li $v0,4
la $a0,msg1
syscall #print msg
li $v0,5
syscall #read an int
add $a0,$v0,$zero #move to $a0

jal fib #call fib

add $a0,$v0,$zero
li $v0,1
syscall

li $v0,10
syscall

fib:
#a0=y
#if (y==0) return 1;
#if (y==1) return 1;
#else return( fib(y-1)+fib(y-2) );

