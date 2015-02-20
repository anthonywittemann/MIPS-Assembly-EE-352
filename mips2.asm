.data
space: .asciiz " "
X: .word 31, 17, 92, 46, 172, 208, 13, 93, 65, 112
N: .word 10

.text
main:   la $a0, X       #$a0=load address of array X
    lw $a1, N       #$a1=10  --number elements
    jal readArray  #call readArray
    li $v0, 10      #exit program   
    syscall 

readArray:
    li $t0, 0       #$t0=0
    li $t1, 0       #$t1=0
buc:    bge $t0, $a1, final #if  $t0 >= $a1 then goto final
    lw $a0, X($t1) #$a0 = X(i)
    li $v0, 1       #Print integer              
    syscall

    la $a0, space   #load a space:  " "
    li $v0, 4       #print string               
    syscall

    addi $t1, $t1, 4    #Every 4 bytes there is an integer in the array
    addi $t0, $t0, 1    #$t0=$t0+1
    b buc       #goto buc
final:  
    jr $ra      #return