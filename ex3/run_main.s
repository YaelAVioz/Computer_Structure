# 207237421 Yael Avioz

        .section	.rodata		# Read-only data section
.format_scan_num:   .string	"%d"
.format_scan_str:   .string	"%s"

    .text                  		# The beginnig of the code
    .globl 	run_main
    .type	run_main, @function

/*
 * This is the main function, the function scans number of string length from the user and also the string itself
 * The function stores the string in the memory as a Pstring
 * Also the function scans an option number for the choosen case and calls the switch-case function
 */
run_main:					            # The main function
    pushq	%rbp                        # Save the old frame pointer
    movq	%rsp, %rbp		            # Create the new frame pointer

    /***********Get First String***********/
    leaq    -4(%rsp), %rsp              # Allocate memory to the user input
    and     $0xf0, %spl                 # Reset the stack
    movq	%rsp, %rsi            	    # Save the adress in rsi register
    movq	$.format_scan_num, %rdi   	# Intialize edi with the required sacn format 
    xor	    %rax, %rax              	# Reset the register
    call	scanf                       # Get the user input of first string length
    movq  	$0,%r8                	    # Reset the regiter 
    movzbq	(%rsp),%r8                 	# Save the input of the user in r8

    decq	%rsp                       	# Decrese one byte
    movb	$0, (%rsp)         	        # Put zero in the last byte of the string
    subq	%r8, %rsp         	        # Save the adress for the first string
    decq	%rsp               	        # Save one byte that will contain the string length
    and     $0xf0, %spl                 # Reset the stack
    movb	%r8b, (%rsp)            	# Put the first string length in the first byte
    movq	%rsp, %rsi              	# Save the adress in rsi register
    incq	%rsi                  	    # Increse rsi register
    movl	$.format_scan_str, %edi     # Intialize edi with the required sacn format 
    movl	$0, %eax                 	# Reset eax
    call	scanf                    	# Get the user input of string
    movq	$0, %r13                   	# Reset the register
    leaq	(%rsp), %r13            	# Save the input of the user

    /***********Get second String***********/
    leaq    -4(%rsp), %rsp              # Allocate memory to the user input
    and     $0xf0, %spl                 # Reset the stack
    movq	%rsp, %rsi              	# Save the adress in rsi register
    movl	$.format_scan_num, %edi   	# Intialize edi with the required sacn format 
    movl	$0, %eax                	# Reset the register- to the return value
    call	scanf                    	# Get the user input of second string length
    movq	$0,%r10                  	# Reset the register
    movzbq	(%rsp),%r10                 # Save the input of the user

    decq	%rsp                      	# Decrese one byte
    movb	$0, (%rsp)         	        # Put zero in the last byte of the string
    subq	%r10, %rsp                	# Save the adress for the second string
    decq	%rsp                  	    # Save one byte that will contain the string length
    and     $0xf0, %spl                 # Reset the stack
    movb	%r10b, (%rsp)         	    # Put the first string length in the first byte
    movq	%rsp, %rsi            	    # Save the adress in rsi register
    incq	%rsi                  	    # Inscese rsi register
    movl	$.format_scan_str, %edi     # Intialize edi with the required sacn format 
    movl	$0, %eax              	    # Reset the register
    call	scanf                 	    # Get the user input of second string
    movq	$0, %r14               	    # Reset the register
    leaq	(%rsp), %r14            	# Save the input of the user

    /***********Get Option Number***********/
    subq	$4, %rsp                    # Allocate 4 bytes for the string length (int size)
    and     $0xf0, %spl                 # Reset the stack
    movq	%rsp, %rsi           	    # Save the adress in rsi register
    movl	$.format_scan_num, %edi  	# Intialize edi with the required sacn format 
    movl	$0, %eax             	    # Reset the register
    call	scanf                	    # Scan the user input 
    movq	$0, %r12                	# Reset the register
    movzbq	(%rsp), %r12            	# Save the input of the user

    /****Send Parameters to the function****/
    movq	%r14, %rdx                  # The first pstring
    movq	%r13, %rsi                  # The second pstring 2
    movq	%r12, %rdi                  # The option choosen number
    call	run_func                    # Send all the parameters to the function

    /******************End******************/
    movq	$0, %rax	                # Return value is zero
	movq	%rbp, %rsp	                # Restore the old stack pointer - release all used memory.
	popq	%rbp		                # Restore old frame pointer
    ret				                    # Return to caller function