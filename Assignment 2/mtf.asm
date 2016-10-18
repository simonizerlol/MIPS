# -----------   STARTER CODE -------------------------------

.data	  
	
sizeBuffer:	.word   0	# dummy value:  real value will be entered by user
stringRefArray:	.space 20       # allocate bytes for the array of 5 starting addresses of strings 
strings:	.space 100	# allocate 100 bytes for all the strings		
maxLenStrPrompt:
		.asciiz		"ENTER MAX LENGTH STRING: "	
stringPrompt:
		.asciiz		"ENTER STRING : "	
newline:	.asciiz		"\n"	
numStringsMessage:
		.asciiz		"NUMBER OF STRINGS IS: "	
enumerate:	.asciiz		".) "	
MTF:		.asciiz		"MOVE TO FRONT ITEM (ENTER NUMBER) : "
exitMessage:	.asciiz		"BYE FOR NOW !"

.text  
       
main:  	 				


#  print prompt  to enter maximum length of a string
 
	la	$a0, maxLenStrPrompt	 #load address maxLenStrPrompt from memory and store it into arguement register 0
	li	$v0, 4  #load immediate to maxLenStrPrompt, (loads the value 4 into register $v0 which is the op code for print string)
	syscall 	#reads register $v0 for op code, sees 4 and prints the string located in $a0

#  read maximum length of string buffer,  read value goes into $v0
	li	$v0, 5  #read integer
	syscall 	

#  If user specifies that string is at most N characters, then we need a buffer for 
#  reading the string that is at least size = N+1 bytes.  The reason is that the
#  syscall will append a \0 character.  If the entered string is less than N
#  bytes, then the syscall will append \n\0, that is, a line feed followed by a null terminator.

#   Store the value size = N+1 in Memory.  This is the size of the buffer that syscall needs.

  	addi	$v0, $v0, 1  
	la	$t0,  sizeBuffer
	sw	$v0, 0($t0) #this is the max length of string

# ---------------  ADD YOUR CODE BELOW HERE  -------------------------------
#name: simon hsu
#id: 260610820
#comp273a2
	# t0 stores address of new element
	# t2 stores the index of the last element
	addi	$t5, $zero, 0 #index of array $t5 set to 0, stores the length of the input
	la	$t6, strings #load address of strings to $t6
	li 	$s0, 0        #Clear the $s0 register that will contains the counter
   	la 	$s1, stringRefArray  #get the address of the first element
   	move 	$s2, $v0 #set the max string size to $s2
	
inputstring:	
	beq	$t2, 6, endInputstring #when t2 equals equals 5 the loop stops
	
	li 	$v0, 4 # print stringPrompt "enter string: "
	la	$a0, stringPrompt
	syscall
	
	add 	$t6, $t6, $t5    #move to the next address
    	move 	$a0, $t6
	
	li	$v0, 8 # get the input string
	move	$a1, $s2	#make a1 equal the space of user input max length
	addi	$a1, $a1, 1
	syscall
	
	subi 	$t3, $s2, 1
       
       	move 	$t2, $a0	# t2 points to the string
        	li 	$t1, 0	# t1 holds the count

length:	# find the length of the strings
	lb 	$t0, ($t2)	# load byte from string
        	#condition to stop the loop of putting numbers
	beqz 	$t0, endLength # Branch on greater than or equal to zero, if it is zero means the end of string
	beq 	$t1,$t3, numloopEnd
                    
            add 	$t1,$t1,1	# increment count
            add 	$t2,$t2,1	# move pointer one character
            j 	length	# go round the loop again
                    
numloopEnd:	
	lb 	$t7,($t2)
	li 	$t4,10	#exit
            sb 	$t4,($t2) 	#store byte of the last element to be '\n'
            addi 	$t1,$t1, 1	#increment by 1         
            beq 	$t7,10, endLength #check if the last character is a \n and if it is then go to endLength
              	
    	la 	$a0, newline #Goto the line
    	li 	$v0, 4
    	syscall  
    	
endLength:	
	beq 	$t1,1 ,endInputstring 	#if the string is empty go to endInputstring
   	addi 	$t5, $t1, 1 	#add the count to t5, increment by 1
               		  
        
        	move	$a0, $t6	#print the user input string
        	li 	$v0, 4	
        	syscall		
        
        	sll 	$t0, $s0, 2     #shift s0 by 2 to t0
        	add 	$t0, $s1, $t0    #get the address of first free space      
        
        	sw 	$t6, ($t0)     #save the reference to the begining the input      
        	add 	$s0, $s0,1     #increment the counter
        	j 	inputstring

endInputstring:	
	li	$v0, 4 #print numStringsMessage
	la	$a0, numStringsMessage
	syscall
	
	li	$v0, 1 #print number of inputs
	move	$a0, $s0
	syscall
	
	li	$v0, 4	#print a new line
	la	$a0, newline 
	syscall
	
displayAndSwap:
    	li 	$t0, 0	    #t0 holds the count
    	la 	$t1, stringRefArray    #t1 point to the address in the array
    	
displayInputstring:
    	beq 	$t0, $s0, endDisplayInputstring
    
   	 #Display number of the input
    	move 	$a0, $t0	
    	li 	$v0, 1
    	syscall	
    
   	#Display the '.)' sign
    	la 	$a0, enumerate
    	li 	$v0, 4
    	syscall
    
   	 #Display the string
    	lw 	$a0, ($t1)	
    	li 	$v0, 4
    	syscall
    	
    
    	addi 	$t0, $t0, 1	# increment count
    	addi	$t1, $t1, 4	# move pointer one character
    
    	j	displayInputstring
    
endDisplayInputstring:       
   	 
    	la 	$a0, MTF #Display "MOVE TO FRONT ITEM (ENTER NUMBER) : "
    	li 	$v0, 4
   	syscall
    
   	li	$v0, 5  #ask for input 
    	syscall 
    
   	slt 	$t0, $v0, $s0 	#set on less than if v0 < s0 set 1
   	beq 	$t0, $zero, stop 	#the loop stop
    	
#swap the registers
   	move 	$t0, $v0		#t0 is the index of the element you want to change place
   	li 	$t1, 0	    	#t1 is the the count
   	move 	$t2, $s1   		#t2 point to the first element of the array now
         
    	sll 	$t5, $t0, 2     	#t3 is the address of the element you want to change place
    	add 	$t5, $s1, $t5   	#get the address of the element
    	lw 	$t3, 0($t5)     	#get the reference to the previous address
    	
    	add 	$t0, $t0, 1
    	
swap:
    	beq 	$t1, $t0, endSwap #if we reach the end
    	lw 	$t4, ($t2) #load the address store at t0
    	sw 	$t3, ($t2)
    	move 	$t3, $t4
    	addi 	$t2, $t2, 4
    	addi 	$t1, $t1, 1
    	j 	swap
  
    
endSwap:   	
	j 	displayAndSwap #keep asking to swap, until the program stops
# ---------------  ADD YOUR CODE ABOVE HERE  ------------------------------
stop:	la	$a0, exitMessage	
	li	$v0, 4
	syscall 

	li	$v0, 10 # end of the program
	syscall
#	nop 
