include    c:\Irvine\Irvine32.inc
include    c:\Irvine\lib32\floatio.inc
includelib c:\Irvine\irvine32.lib
includelib c:\Irvine\kernel32.lib
includelib c:\masm32\lib\user32.lib


		; .data is used for declaring and defining variables
.data

calcTitle			DB "  *************  Start the simple assembly calculator  *************  ", 0

operator			DB  ?

prompt1				DB "Enter the first number: ", 0
prompt2				DB "Enter the second number: ", 0
prompt3				DB "Choose an operation (+, -, *, /): ", 0
resultPrompt			DB "Evaluation result: ", 0

operator_msg       		DB " < invalid opertor, try again ... > ", 0               			; invalid operator exception message
overflow_msg0       		DB " < Result is too large to fit, try again > ", 0   				; overflow exception message

equal_sign			DB '=', 0
space				DB ' ', 0

.code		; .code is for the executable part of the program

main PROC
    
	; Printing the calculator title
		call	CrLf				; spacing for readability
		lea	edx, calcTitle		    ; copy the address of caltitle to EDX register
		call	WriteString			; write the calculator title
		call	CrLf	
		call	CrLf							

    
	; Ask and get the first number
	    lea	edx ,   prompt1		    		; copy the address of caltitle to EDX register
	    call	WriteString			; write the calculator title
            call        ReadFloat
	    call crlf
	; Ask and get the arithmatic operator
	get_operator:
									
		lea	edx, prompt3
		call	WriteString				; write the prompt3 guidance message
		call	ReadChar				; read the operator from the user and store it in AL
		mov	operator, al	    			; copy the character from AL to operator variable

		; check if the operator is a valid 
		cmp operator , '+'                  
		je n2                     ; jump if equal to do_addition 
		cmp operator , '-'                  
		je n2                  	  ; jump if equal to do_subtraction
		cmp operator , '*'                   
		je n2                     ; jump if equal to do_multiplication 
		cmp operator , '/'                 
		je n2                     ; jump if equal to do_division
       		jmp invalid_operator

	; Ask and get the second  number
		n2:	call crlf
			call crlf
			lea	edx, prompt2		   	; copy the address of caltitle to EDX register
			call	WriteString			; write the calculator title
			call    ReadFloat
			call 	crlf
		
	; Redirection to the  the needed operator

		cmp operator , '+'                  
		je do_addition                     ; jump if equal to do_addition 
		cmp operator , '-'                  
		je do_subtraction                  ; jump if equal to do_subtraction
		cmp operator , '*'                   
		je do_multiplication               ; jump if equal to do_multiplication 
		cmp operator , '/'                 
		je do_division                     ; jump if equal to do_division
        
	; addition opertion 

	do_addition:
        	faddp st(1),st(0)
		jo overflowBlock0             ; jump if found overflow 
		jmp print_results            ; print resultes

	; subtraction opertion 

	do_subtraction:
		fsubp st(1),st(0)
        jo overflowBlock0                    ; jump to overflow section if overflow found
		jmp print_results            ; else jump to print_result section
	
	; multiplication operation	

    do_multiplication:
		fmulp st(1),st(0)
       		jo overflowBlock0                          ; jump if overflow found
		jmp print_results                          ; jump to print_results
					

	do_division: 
		fdivp st(1),st(0)
		jo overflowBlock0                           ; jump if found overflow 
		jmp print_results


	; handling exceptions 
	overflowBlock0:		              		    ; if overflow occurs in results
		call Crlf
		mov edx , offset overflow_msg0    	
		call WriteString
		call Crlf			 
		jmp quit	      			     ; exit the program 


	invalid_operator:
	       		call crlf
			mov edx , offset operator_msg    	
			call WriteString
			call Crlf			 
			jmp get_operator

    ; Print results
    
	print_results:
		; Print result prompt
		call	CrLf
		lea		edx, resultPrompt
		call	WriteString
		; Print the equals sign
		mov	al, equal_sign
		call	WriteChar

		; Print the spacing
		mov	al, space
		call	WriteChar

		;Print out the result
        
     		 call WriteFloat
        	 call	CrLf
		 jmp 	quit


	quit:
		call	CrLf
		exit	

main ENDP

END main
