# Title: 	Lab8 assignment - Cache Simulation
# Author: 	Daler Asrorov
# Due Date:	Dec. 4th, 2015 (11 AM.)
# Date:
.data
space: .asciiz " "
message: .asciiz "\nDirect Map: "
hitCountMessage: .asciiz "Hit count ======= "
missCountMessage: .asciiz ". Miss count ======= "
messageTwo: .asciiz "\n2 way associative: "
messageThree: .asciiz "\nFully Associative "
memoryAccess:	.word 0x8d410000, 0x0000ABC1, 0x8B410000, 0x0050ABC1, 0x8d410000, 0x00000000, 0x8d410005, 0x0900FF07 0x8d4100EE, 0x8700ABAB, 0x7bd10011, 0x6ab0ABEF, 0x77777778, 0x000AAA77, 0x8d499997, 0x889AAA0D, 0x1111111F, 0x0050ABC1, 0xCCDDEEFF, 0x11223344, 0x11889955, 0x96310968, 0xABCDEFAB, 0x11001100, 0x10101011, 0xBBAA2131, 0x0050ABC1, 0x11335533, 0x76543210, 0x22557799, 0x76543216, 0x13213245, 0x98105086, 0x97115470, 0x98182630, 0x98681883, 0xFFFFFFFF, 0x09097765, 0x8d410000, 0x0000ABC1,0xCCDDEEFF, 0x11223344, 0x66666666, 0x11001100, 0x78967666, 0x0050ABC1, 0x0050ABC1, 0x0050ABC1, 0xBBAA2131, 0xBBAA2131, 0x7bd10011, 0x7bd10011, 0x7bd10011, 0x7ad10011, 0x7bd10011, 0x7ad10011, 0x7bd1001F, 0x7bd1001F, 0x7bd1001F, 0x7bd1001F, 0xCCDDEEFE, 0xCCDDEEFE, 0xCCDDEEFE, 0x11001100, 0x11001100, 0x12001100, 0x12001100, 0x12001100, 0x12001101, 0x13001101, 0x7cd10011, 0x7bd10011, 0x8bd10012, 0x7ad10012, 0x7bd10011, 0x7ad10012, 0x7ad1001F, 0x7ad1001F, 0x7bd10012, 0x7bd10019
.align 4
cache: .space 256
initCacheAddress: .space 256

##############################################		
########### IMPLEMENTATION POINTS ############
##############################################

.text
		addi $t9, $zero, 0
		addi $t8, $zero, 0
	
		la $t1, initCacheAddress
		addi $t0, $t1, 256
		addi $a0, $zero, -99
	
		lp:
		sw $a0, ($t1)
		addi $t1, $t1, 4
		blt $t1, $t0, lp
	
		la $t1, memoryAccess
		addi $t0, $t1, 320
		directMap:
		lw $t2, ($t1)
		andi $t3, $t2, 0x003f 
		la $s0, initCacheAddress
		sll $t4, $t3, 2 		# shifting the values if needed
		add $s0, $s0, $t4 		# grabbing data nad pointing to specific location
	
		#check if it hits
		lw $s1, ($s0)
		beq $s1, $t2, incrementDirectMapHitRate #compare t3(address) s1(cache)
		j incrementDirectMapMissRate
		incrementDirectMapHitRate:
		addi $t9, $t9, 1
		addi $t1, $t1, 4 #next memory
		beq $t1, $t0, endDirectMap
		j directMap

		incrementDirectMapMissRate:
		addi $t8, $t8, 1
		sw $t2, ($s0)
		addi $t1, $t1, 4 #next memory
		beq $t1, $t0, endDirectMap
		j directMap
		endDirectMap:
	
##############################################

##############################################		
########## CACHE INITIALIZATION ##############
##############################################
	
		la $t1, initCacheAddress
		addi $t0, $t1, 256
		addi $a0, $zero, -99
secondIteration:
		sw $a0, ($t1)
		addi $t1, $t1, 4
		blt $t1, $t0, secondIteration

#Two way set
		la $t1, memoryAccess
		addi $k1, $zero, 0
		addi $k0, $zero, 0
		addi $t0, $t1, 320
twoWaySet:
		lw $t2, ($t1)  #memory to t2
		andi $t3, $t2, 0x001f #t3 is address 5 bits
	
	
		#check First Set
		la $s0, initCacheAddress
		sll $t4, $t3, 2 
		add $s0, $s0, $t4 #point to the location
	
		#check if it hits
		lw $s1, ($s0)
		beq $s1, $t2, executeFirstHit #if it hits
		addi $s0, $s0, 128   #if not hit check second set
		lw $s1, ($s0)
		beq $s1, $t2, executeSecondSetHit #if it hits on second set
		#no hit
		lw $s2, ($s0)
		sw $s2, -128($s0)
		sw $t2, ($s0) #replace least amt 
		addi $k0, $k0, 1 #increment miss count
		addi $t1, $t1, 4 #next memory
		beq $t0, $t1, finishTwoWay
		j twoWaySet 
	
executeFirstHit:
		addi $s0, $s0, 128   #swap start
		lw $s2, ($s0)
		sw $s2, -128($s0)
		sw $s1, ($s0) #swapping 
		addi $k1, $k1, 1 #increment hit count
		addi $t1, $t1, 4 #next memory
		beq $t0, $t1, finishTwoWay
		j twoWaySet 
	
executeSecondSetHit:
		addi $k1, $k1, 1 #increment hit count
		addi $t1, $t1, 4 #next memory
		beq $t0, $t1, finishTwoWay
		j twoWaySet 
		
#######################################
######## Initializing the two way #####
###### for chache initiialization #####		
#######################################
		
finishTwoWay:

	#########################
	
		la $t1, initCacheAddress
		addi $t0, $t1, 256
		addi $a0, $zero, -99
thirdIteration:	
		sw $a0, ($t1)
		addi $t1, $t1, 4
		blt $t1, $t0, thirdIteration
		la $t1, memoryAccess
		addi $s7, $zero, 0
		addi $s6, $zero, 0
		addi $t0, $t1, 320
	
computeFullyAssociate:
		addi $t3, $zero, 0
		lw $t2, ($t1)  #memory to t2
		la $s0, initCacheAddress
		
insiderLoopSystem:
	
	
		lw $s1, ($s0) #load cache
		beq $s1, $t2 startSwap #check it is same
		addi $t3, $t3, 4
		addi $s0, $s0, 4
		beq $t3, 260, notFoundInCache #not found in cache
		j insiderLoopSystem
	
# method gonna be used in the not found
# variables finding in cache process...	
notFoundInCache:
		addi $s6, $s6, 1 #increment miss 
		la $s0, initCacheAddress


############################################
# This method starts the swapping of things 
# that are not found in cache...############
#	
swapVarsNotFoundInCache:
		lw $s1, 4($s0)
		sw $s1, ($s0)
		addi $t3, $t3, -4
		addi $s0, $s0, 4
		beq $t3, 4, finishSwappingOfNotCacheVars
		j swapVarsNotFoundInCache
	
############################################
# This method ends the swapping of things 
# that are not found in cache...############
#	
finishSwappingOfNotCacheVars:
		sw $t2, ($s0)
		addi $t1, $t1, 4
		beq $t1, $t0, endFullyAssociate
		j computeFullyAssociate

startSwap:
        	#found hit
      	 	 addi $s7, $s7, 1
        	la $s0, initCacheAddress
swappingForInCache:
		lw $s1, 4($s0)
		sw $s1, ($s0)
		addi $t3, $t3, -4
		addi $s0, $s0, 4
		beq $t3, 4, finishSwapping
		j swappingForInCache
finishSwapping:
		sw $t2, ($s0)
		addi $t1, $t1, 4
		beq $t1, $t0, endFullyAssociate
		j computeFullyAssociate


######################################################
######################################################
######################################################
######################################################


# This method ends the process of fully associate 
# modeling and processing. 

endFullyAssociate:
		la $a0, message	 
    		li $v0, 4     	             
   	 	syscall
   	 	
   	 	
    		la $a0, hitCountMessage	
    		li $v0, 4     	               
    		syscall
		
		
		add $a0,$t9,$zero	
    		li $v0, 1                 
    		syscall
    		
    		
    		la $a0, missCountMessage	
    		li $v0, 4     
    		syscall
		
		
		add $a0,$t8,$zero	
    		li $v0, 1                 
    		syscall
    		
    		
    		la $a0, messageTwo	
    		li $v0, 4     	           
    		syscall
    		
    		
    		la $a0, hitCountMessage	
    		li $v0, 4                  
    		syscall
		
		
		add $a0,$k1,$zero	
    		li $v0, 1                
    		syscall
    		
    		
    		la $a0, missCountMessage	# Loa
    		li $v0, 4     	# Print string.
    		syscall
		
		
		add $a0,$k0,$zero	# Move $t1 to $a0.
    		li $v0, 1      	# Print integer.              
    		syscall
    		
    		
    		la $a0, messageThree	
    		li $v0, 4                 
    		syscall
    	
    		la $a0, hitCountMessage
    		li $v0, 4                
    		syscall
	
	
		add $a0,$s7,$zero	
    		li $v0, 1                   
    		syscall
    		
    		
    		la $a0, missCountMessage	# Load a space:  " ".
    		li $v0, 4     	# Print string.
    		syscall
		
		
		add $a0,$s6,$zero	# Move $t1 to $a0.
    		li $v0, 1      	# Print integer.              
    		syscall