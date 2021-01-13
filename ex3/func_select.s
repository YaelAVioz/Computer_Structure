/*
 * This is run_func program, the progrem uses swich case to choose the requierd case
 * acording to the given option number
 */
 
	.section	.rodata		       # read only data section
.format_pstring:    .string	"first pstring length: %d, second pstring length: %d\n"
.scan_chars:    .string	"\n%c %c"
.format_case52:   .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
.scan_num:    .string	"%d"
.format_str_len:   .string	"length: %d, string: %s\n"
.format_case55: .string "compare result: %d\n"
.format_error:   .string	"invalid option!\n"

	.align 8
switch_case:
	.quad	case52
	.quad	case53
	.quad	case54
    .quad   case55

	.text	                        	# the beginning of the code.
	.globl	run_func
	.type	run_func, @function
run_func:
	pushq	%rbp                    	# Save the old frame pointer
	movq	%rsp, %rbp              	# Create the new frame pointer

	leal -50(%rdi), %eax		    	# Substract 50 from the first parameter
	cmpl	$0, 	%eax    	    	# Compare eax with 0 - check if the choosen number value is 50
    	je	    case50     	            	# If its equal - go to case 50
    	cmpl    $10,    %eax            	# Compare eax with 10 -check if the chooesn number value is 60 
    	je	    case50                  	# If its equal - go to case 50 (same as case 60)
    	cmpl    $1, %eax                	# Compare eax with 1 -check if the chooesn number value is 51
    	je    caseDefault              		# If its equal - go to defult case
    	cmpl    $5, %eax               		# Compare eax with 5 -check if the chooesn number value is 55
    	ja      caseDefault            		# If the number is above 55 go to defult case
    	leal -2(%eax), %eax            		# Check if the number is 52
	jmp	*switch_case(,%eax,8)	    	# In case its between 52 to 55 use the swich table

case50:
    	push	%r12		        	# Push callee save r12 to stack
    	push 	%r13			        # Push callee save r13 to stack
    	movq  	%rdx,%r12		        # Move the second pstring to r12
	movq	%r12,%rdi               	# Move r12 (second pstring) to rdi 
	call	pstrlen			        # Send to the function pstrlen
	movsbl	%al, %ebx		        # Save the return value from the function to ebx

    	movq  	%rsi,%r13		        # Move the first pstring to r12
	movq	%r13,%rdi		        # Move r13 (first pstring) to rdi 
	call	pstrlen			        # Send to the function pstrlen
	movsbl	%al, %eax		        # Save the return value from the function to eax

	movl	%ebx, %edx		        # Move the second pstring to the third parameter to print
	movl	%eax, %esi		        # Move the first pstring to the second parameter to print
	movl	$.format_pstring, %edi		# Intialize edi with the required sacn format 
	movl	$0, %eax		        # Reset eax
	call	printf			        # Print
    	pop   	%r13			        # restore r13
    	pop   	%r12                    	# Restore r12
	jmp	done		    	        # End program

case52:
    	push	%r12		    	    	# Push callee save r12 to the stack
    	push	%r13                    	# Push callee save r13 to the stack
	push 	%r14                    	# Push callee save r14 to the stack
    	push 	%r15                    	# Push callee save r15 to the stack
    	movq  	%rdx,%r12   		    	# Move the first pstring parameter to r12
    	movq  	%rsi,%r13   		    	# Move the second pstring parameter to r13
      
    	leaq	-2(%rsp), %rsp          	# Allocate memory of two bytes for the chars 
    	and     $0xf0, %spl             	# Reset the stack
    	movq  	%rsp,%rsi               	# Save the adress in rsi register
    	leaq  	1(%rsp),%rdx
    	movl	$.scan_chars, %edi      	# Intialize edi with the required sacn format 
	movl	$0, %eax		        # Reset the register- to the return value
	call	scanf                   	# Get the input from the user

    	movzbl	(%rsp), %r15d		    	# Move the first input to r15
    	movzbl	1(%rsp), %r14d		    	# Move the second input to r14
    	leaq    2(%rsp), %rsp		    	# Reduce rsp
    	movq 	%r15,%rsi               	# Move r15(first char - old cahr) to rsi 
    	movq 	%r14,%rdx               	# Move r14(second char - new char) to rdx
    	movq	%r12, %rdi		        # Move the first pstring parameter rdi
	call	replaceChar		        # Sends all the parameters to the function replaceChar (rsi, rdx, rdi)

    	movq 	%r14,%rdx               	# Move r15(first char - old cahr) to rsi 
    	movq 	%r15,%rsi               	# Move r14(second char - new char) to rdx
    	movq	%r13, %rdi		        # Move the first pstring parameter rdi
	call	replaceChar             	# Sends all the parameters to the function replaceChar (rsi, rdx, rdi)

    	add 	$1,%r12			        # To get to the first string (first byte is length)
    	add  	$1,%r13                 	# To get to the second string (second byte is length)
       
    	movq  	%r12,%r8		        # Move the value of r12 to r8
    	movq  	%r13,%rcx               	# Move the value of r13 to rcx
    	movq  	%r14,%rdx               	# Move the value of r14 to rdx
    	movq  	%r15,%rsi               	# Move the value of r15 to rsi
    	movl	$.format_case52, %edi		# Intialize edi with the required sacn format
	movl	$0, %eax	            	# Reset eax
   	push   %rsp
    	and     $0xf0, %spl             	# Reset the stack
	call	printf		            	# Print
    	pop   	%r15		            	# Restore saved registers: r15
    	pop   	%r14                    	# Restore saved registers:r r14
    	pop   	%r13                    	# Restore saved registers: r13
    	pop   	%r12                    	# Restore saved registers: r12
	jmp	done		                # End program

case53:
    	push    %r12			        # Push callee save r12 to the stack
    	push    %r13                    	# Push callee save r13 to the stack
    	push    %r14                    	# Push callee save r14 to the stack
    	push    %r15                    	# Push callee save r15 to the stack

    	movq	%rsi, %r13		        # Move the first pstring parameter to r13
    	movq	%rdx, %r12		        # Move the first pstring parameter to r12
    	leaq    -4(%rsp), %rsp		    	# Allocate memory of four bytes for the first index 
    	and     $0xf0, %spl             	# Reset the stack
    	movq    $.scan_num, %rdi        	# Intialize rdi with the required sacn format
    	movq    %rsp, %rsi		        # Save the adress in rsi register
    	movq    $0, %rax		        # Reset the register
    	call    scanf			        # Get the input from the user
    	movzbl  (%rsp), %r14d		    	# Move the user input to r14

    	leaq    4(%rsp), %rsp		    	# Reduce rsp
    	leaq    -4(%rsp), %rsp		    	# Allocate memory of four bytes for the second index 
    	movq    $.scan_num, %rdi        	# Intialize rdi with the required sacn format
    	movq    %rsp, %rsi	        	# Save the adress in rsi register
    	movq    $0, %rax		        # Reset rax register
    	call    scanf			        # Get the unput from the user
    	movzbl  (%rsp), %r15d      	    	# Move the user input to r15
    	leaq    4(%rsp), %rsp		    	# Reduce rsp
     
.conditionTrue:
	movl	%r15d, %eax	        	# Move r15 to eax
	movsbl	%al, %ecx		        # Move the second index to parameter four to the function pstrijcpy
	movl	%r14d, %eax		        # Move r14 to eax
	movsbl	%al, %edx		        # Move the first index to parameter three to the function pstrijcpy
	movq	%r12, %rsi	        	# Move the second pstring to parameter two to the function pstrijcpy
	movq	%r13, %rdi		        # Move the first pstring to parameter one to the function pstrijcpy
 	call	pstrijcpy		        # Send all the parameters to the function to pstrijcpy

	leaq	1(%rax), %rdx		     
	movq	%r13, %rax              
	movzbl	(%rax), %eax            
	movsbl	%al, %eax               
	movl	%eax, %esi	            	# Move the results - the second parameter for printf
	movl	$.format_str_len, %edi  	# Intialize edi with the required sacn format
	movl	$0, %eax		        # Reset eax
	call	printf			        # Print

	movq	%r12, %rax		        # The second pstring
	leaq	1(%rax), %rdx	    		# Move to the second byte of the pstring to get string (first byte is length)
	movq	%r12, %rax              
	movzbl	(%rax), %eax            
	movsbl	%al, %eax               
	movl	%eax, %esi		        # Move the results - the second parameter for printf
	movl	$.format_str_len, %edi		# Intialize edi with the required sacn format
	movl	$0, %eax		        # Reset eax
	call	printf			        # Print
	pop   	%r15			        # restore r15
    	pop   	%r14                    	# Restore r14
    	pop   	%r13                    	# Restore r13
    	pop   	%r12                    	# Restore r12
	jmp	done		    	        # End program

case54:	
    	push	%r12			        # push callee save r12
    	push 	%r13                    	# push callee save r13
    	movq  	%rsi,%r12         	    	# Move the first pstring to r12
    	movq  	%rdx,%r13           		# Move the second pstring to r13
	movq	%r12, %rdi		        # Move the first pstring to rdi
	call	swapCase		        # Send first pstring to function swapCase 

	leaq	1(%rax), %rdx		    	# Move to the second byte of the pstring to get string (first byte is length)
	movq	%r12, %rax		        # Move the first psring to first parameter
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi		        # Move the lenght to the second parameter
	movl	$.format_str_len, %edi		# Move the string to the second parameter
	movl	$0, %eax		        # Reset eax
	call	printf			        # Print

	movq	%r13, %rdi	        	# Move the second pstring to rdi
	call	swapCase		        # Send the parameters to the function swapCase

	leaq	1(%rax), %rdx		    	# Move to the second byte of the pstring to get string (first byte is length)
	movq	%r13, %rax	       	    	# Move the second psring to first parameter
	movzbl	(%rax), %eax		
	movsbl	%al, %eax		
	movl	%eax, %esi		        # Move the lenght to the second parameter
	movl	$.format_str_len, %edi		# Move the string to the second parameter
	movl	$0, %eax	        	# Reset eax
	call	printf			        # Print
    	pop 	%r13    			# Restore register r13
    	pop 	%r12                    	# Restore register r12
	jmp	done			        # End program

 case55:
    	push    %r12			        # Push callee save r12 to the stack
    	push    %r13                    	# Push callee save r13 to the stack
    	push    %r14                    	# Push callee save r14 to the stack
    	push    %r15                    	# Push callee save r15 to the stack

    	movq	%rsi, %r13		        # Move the first pstring parameter to r13
    	movq	%rdx, %r12		        # Move the first pstring parameter to r12
    	leaq    -4(%rsp), %rsp		    	# Allocate memory of four bytes for the first index 
    	and     $0xf0, %spl             	# Reset the stack
    	movq    $.scan_num, %rdi        	# Intialize rdi with the required sacn format
    	movq    %rsp, %rsi		        # Save the adress in rsi register
    	movq    $0, %rax		        # Reset the register
    	call    scanf			        # Get the input from the user
    	movzbl  (%rsp), %r14d		    	# Move the user input to r14

    	leaq    4(%rsp), %rsp		    	# Reduce rsp
    	leaq    -4(%rsp), %rsp		    	# Allocate memory of four bytes for the second index 
    	movq    $.scan_num, %rdi        	# Intialize rdi with the required sacn format
    	movq    %rsp, %rsi	        	# Save the adress in rsi register
    	movq    $0, %rax		        # Reset rax register
    	call    scanf			    	# Get the unput from the user
    	movzbl  (%rsp), %r15d      	    	# Move the user input to r15
    	leaq    4(%rsp), %rsp		    	# Reduce rsp

.conditionTrue55:
	movl	%r15d, %eax	        	# Move r15 to eax
	movsbl	%al, %ecx		        # Move the second index to parameter four to the function pstrijcmp
	movl	%r14d, %eax		        # Move r14 to eax
	movsbl	%al, %edx		        # Move the first index to parameter three to the function pstrijcmp
	movq	%r12, %rsi	        	# Move the second pstring to parameter two to the function pstrijcmp
	movq	%r13, %rdi		        # Move the first pstring to parameter one to the function pstrijcmp
 	call	pstrijcmp		        # Send all the parameters to the function to pstrijcmp              
	movsbl	%al, %eax		        # Save the return value from the function to eax
	movl	%eax, %esi	            	# Move the results - the second parameter for printf
	movl	$.format_case55,  %edi  	# Intialize edi with the required sacn format
	movl	$0, %eax		        # Reset eax
	call	printf			        # Print

	pop   	%r15			        # restore r15
    	pop   	%r14                    	# Restore r14
    	pop   	%r13                    	# Restore r13
    	pop   	%r12                    	# Restore r12
	jmp	done		    	        # End program

caseDefault:			
	movl	$.format_error, %edi		# Move string to first parameter
	movq	$0, %rax                	# Reset rax
	call	printf			        # Print

done:					
	movq	$0, %rax	            	# Return value is zero
	movq	%rbp, %rsp	            	# Restore the old stack pointer - release all used memory.
	popq	%rbp	                	# Restore old frame pointer
	ret				        # Return to caller function
