	.section	.rodata		        # read only data section
.format_error:  .string	"invalid input!\n"

    .text                           		# The beginnig of the code

/************pstrlen Function************/
	
    .globl	pstrlen
	.type	pstrlen, @function

/*
 * The function gets pstring and returns the length of the string
 */
pstrlen:				
	movq	%rdi, %rax		        # Move parameter we have got to %rax
	movzbl	(%rax), %eax		    	# Get lowest byte pointed by %rax and move it to eax
	ret				        # Return the length value


/**********replaceChar Function**********/

	.globl	replaceChar
	.type	replaceChar, @function

/* 
 * The function gets two pstrings and two chars and swich
 * in each pstring the first given char in the second one
 */
replaceChar:				
	pushq	%rbp		       	    	# Save the old frame pointer
	movq	%rsp, %rbp		        # Create the new frame pointer
	movb	%sil, %r10b  		    	# Move the old char parameter to the to register
	movb	%dl, %r9b    		    	# Move the new char parameter to the to register
	movl	$0, %r8d     		    	# Initialize i to be zero 
	jmp	.forLoop

.inLoop:
	movq	%rdi, %rdx    		    	# Move the Pstring to rdx
	movl	%r8d, %eax    		    	# Save i to regisrte rax
	movzbl	1(%rdx,%rax), %eax      	# Update Pstring->str[i]
	cmpb	%r10b, %al    		    	# Compare the old char to pstring->str[i]
	jne	.incqLoop		        # In case they are not equal
	movq	%rdi, %rdx   		    	# In case they are equal
	movl	%r8d, %eax    		    	# Move i to regisrte rax
	movl	%r9d, %ecx   		    	# Take str[i] - the first byte
	movb	%cl, 1(%rdx,%rax) 	    	# Replace the byte -Put the new char at the correct place of i

.incqLoop:
	incq	%r8           		    	# i++

.forLoop:
	movq	%rdi, %rax      	    	# Move pstring to rax
	movzbl	(%rax), %eax    	    	# Take the length from pstring
	cmpl	%r8d, %eax    		    	# if i< pstring length
	jg	.inLoop       		        # True  
	movq	%rdi, %rax    		    	# Else
	popq	%rbp                    	# Restore rbp
	ret				        # Return the address of the new strings


/************pstrijcpy Function************/

 	.globl	pstrijcpy
	.type	pstrijcpy, @function

    /*
    * This function gets two pstirngs and two indexs and replace the char in index 2 with the char in index 1
    * and also replace the char in index 1 to the char in idex 2
    */
pstrijcpy:				
	pushq	%rbp			        # Save the old frame pointer
	movq	%rsp, %rbp		        # Create the new frame pointer
	movq	%rdi, %r9               	# Move the given parameter in rdi to r9
	movq  	%rdi, %r14              	# Move the given parameter in rdi to r14
	movq	%rsi, %r10   		    	# Move the given parameter in rsi to r10
	jmp	.condition		        # Valided input

.condition:
	cmpb	$0,%dl			        # Check if the given index is negetive number
      	jl    	.error			    	# If the index is negetive - go to error
      	cmpb  	$0,%cl			    	# Check if the given index is negetive number
      	jl    	.error			    	# If the index is negetive - go to error
        cmpb  	%cl, (%rsi)		    	# Check if the given index is bigger then the string length
     	jle    	.error			    	# If its bigger - go to error
        cmpb  	%dl,(%rsi)		    	# Check if the given index is bigger then the string length
     	jle    	.error			    	# If its bigger - go to error
     	cmpb	%cl,(%rdi)		    	# Check if the given index is bigger then the string length
    	jle    	.error			    	# If its bigger - go to error
      	cmpb  	%dl,(%rdi)		    	# Check if the given index is bigger then the string length
     	jle    	.error			    	# If its bigger - go to error
      	jmp   	.valid_input	    		# In case the input is valid continue

.error:
    	movq	$.format_error, %rdi    	# Initiazlized the requierd format
	movq	$0, %rax                	# Reset rax
	call	printf                  	# Print
    	movq	%r14, %rax     		    	# Return the pstring without changes
	popq	%rbp                    	# Reset rax
      	ret				        # Return the address to pstring
          
.valid_input:
    	movq 	$0,%rsi			        # Reset rsi
	movb	%dl, %sil    		    	# Move the first index to register
	movb	%cl, %r11b    		    	# Move the second index to register
	movl 	%esi, %eax   		    	# Move the first index to eax
	movl	%eax, %r8d    		    	# Initilize i with index1
	jmp	.conditionLoop

.loopPstrijcpy:
	movq	%r10, %rdx	   	 	# Move src to rdx
	movl	%r8d, %eax	    	    	# Save i to register rax
	movzbl	1(%rdx,%rax), %ecx	    	# Update
	movq	%r9, %rdx		        # Move r9 (first parameter) to rdx
	movl	%r8d, %eax		        # Save i to register
	movb	%cl, 1(%rdx,%rax)	    	# Replace between the bytes
    	incq 	%r8             		# i++

.conditionLoop:
	movsbl	%r11b, %eax     	    	# Move the first byte of the second index to eax
	cmpl	%r8d, %eax      	    	# Compare second index to i
	jge	.loopPstrijcpy      	    	# In case i <= index2
	movq	%r9, %rax     		    	# Else, move dst to rax
	popq	%rbp
	ret				        # Return the address


/************swapCase Function************/

	.globl	swapCase
	.type	swapCase, @function

/*
 * This function gets pstring and swap them to uppercase to lowercase and thr opposite
 */
swapCase:				
	pushq	%rbp			        # Save the old frame pointer
	movq	%rsp, %rbp		        # Create the new frame pointer
	movl	$0, %r9d          	    	# Reset r9
	jmp	.forCondition

.intoLoopSwapCase:
	movl	%r9d, %eax		        # Move i to rax
	movzbl	1(%rdi,%rax), %eax	    	# Add one to the address
	cmpb	$96, %al              		# Checks if its lowercase aacorrding to ascii value - if'96'<=pstr->str[i]
	jle	.upperCase
	movq	%rdi, %rdx		        # Move pstring to rdx
	movl	%r9d, %eax		        # Move i to rax
	movzbl	1(%rdi,%rax), %eax	    	# Add one to the address
	cmpb	$122, %al             		# Checks if its lowercase aacorrding to ascii value-if'122'<=pstr->str[i]
	jg	.upperCase
	movl	%r9d, %eax		        # Move i to rax
	movzbl	1(%rdi,%rax), %eax	    	# Add one to the address
	subl	$32, %eax             		# The opposite option-upperCase -32
	movl	%eax, %ecx
	movl	%r9d, %eax
	movb	%cl, 1(%rdi,%rax)	    	# Replace the char-from upperCase to lowerCase
	jmp	.incqLoopSwapCase

.upperCase:
	movl	%r9d, %eax		        # Move i to rax
	movzbl	1(%rdi,%rax), %eax	    	# Add one to the address
	cmpb	$64, %al              		# Checks if its upperCase aacorrding to ascii value-if'64'<=pstr->str[i]
	jle	.incqLoopSwapCase	        # In case its not
	movl	%r9d, %eax		        # Move i to rax
	movzbl	1(%rdi,%rax), %eax	    	# Add one to the address
	cmpb	$90, %al              		# Checks if its upperCase aacorrding to ascii value-if'90'<=pstr->str[i]
	jg	.incqLoopSwapCase	        # in case its not
	movl	%r9d, %eax		        # Move i to rax
	movzbl	1(%rdi,%rax), %eax	    	# Add one to the address
	addl	$32, %eax             		# The opposite option lowerCase +32
	movl	%eax, %ecx
	movl	%r9d, %eax
	movb	%cl, 1(%rdi,%rax)	    	# Replace the char-from lowerCase to upperCase

.incqLoopSwapCase:
	incl	%r9d			        # i++

.forCondition:
	movzbl	(%rdi), %eax            	# Get the string length from pstring 
	cmpl	%r9d, %eax      	    	# Compare between the bytes i to pstring length
	jg	.intoLoopSwapCase   	    	# If i < pstring length

	movq	%rdi, %rax
	popq	%rbp
	ret				        # Return the address to pstring


/************pstrijcmp Function************/
	.globl	pstrijcmp
	.type	pstrijcmp, @function

    /*
    * This function gets two index and compeare between the first string to the second string
    * The comperae is according to the given indexs 
    */

pstrijcmp:
	pushq	%rbp			        # Save the old frame pointer
	movq	%rsp, %rbp	            	# Create the new frame pointer
	movq	%rdi, %r9   	        	# Move first pstring to r9
	movq	%rsi, %r10   		    	# Move second pstring to r10
	jmp	.condition_cmp		        # Validede the given indexs

.condition_cmp:
	cmpb	$0,%dl			        # Check if the given index is negetive number
      	jl    	.error_cmp			# If the index is negetive - go to error
      	cmpb  	$0,%cl			    	# Check if the given index is negetive number
      	jl    	.error_cmp			# If the index is negetive - go to error
        cmpb  	%cl, (%rsi)		    	# Check if the given index is bigger then the string length
     	jle    	.error_cmp			# If its bigger - go to error
        cmpb  	%dl,(%rsi)		    	# Check if the given index is bigger then the string length
     	jle    	.error_cmp			# If its bigger - go to error
     	cmpb	%cl,(%rdi)		    	# Check if the given index is bigger then the string length
    	jle    	.error_cmp			# If its bigger - go to error
      	cmpb  	%dl,(%rdi)		    	# Check if the given index is bigger then the string length
     	jle    	.error_cmp			# If its bigger - go to error
      	jmp   	.valid_input_cmp	    	# In case the input is valid continue
.error_cmp:
    	movq	$.format_error, %rdi		# Initiallized the requierd format
	movq	$0, %rax                	# Reset rax
	call	printf                  	# Print
    	movq	$-2, %rax     	        	# Return the pstring without change
	popq	%rbp                    	# Restore rbp
    	ret				        # Return the address to pstring

.valid_input_cmp:
    movq 	$0,%rsi			        # Reset rsi
	movb	%dl, %sil    	    		# Move first index to register
	movb	%cl, %r11b    		   	# Move second index to register
	movl 	%esi, %eax   		    	# move index1 to eax
	movl	%eax, %r8d    		    	# Initilize i with index1
	jmp	.conditionLoopCmp
    
.loopPstrijcmp:
	movq	%r10, %rdx		        # Move the second pstring to rdx
	movl	%r8d, %eax		        # Save i to register rax
	movzbl	1(%rdx,%rax), %ecx  		# Update i
	movq	%r9, %rdx		        # Move first pstring to rdx
	movl	%r8d, %eax		        # Save i to register rax
    movzbl	1(%rdx,%rax), %edx	    	# Update
	cmpb    %cl, %dl
    	ja	.greater	
	jl	.less
    	incq 	%r8             		# i++
	jmp     .conditionLoopCmp

.conditionLoopCmp:
	movsbl	%r11b, %eax     	    	# Move the first byte of the second index to eax
	cmpl	%r8d, %eax      	    	# Compare second index to i
	jge	.loopPstrijcmp    	        # In case i <= index2
	movq	$0, %rax     		    	# Else, move dst to rax
	popq	%rbp
	ret			                # Return the address

.greater:
	movq $1, %rax
	popq	%rbp
	ret

.less:
	movq $-1, %rax
	popq	%rbp
	ret
