include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables
.data

startTitle			DB "  *****  Start the two-operand assembly calculator  *****  ", 0
endTitle			DB "  *****  Thanks for using our two-operand assembly calculator  *****  ", 0

operand1_string			DB 16 dup (?)
operand2_string			DB 16 dup (?)
operand1_len			DD	?
operand2_len			DD	?

operand1			DD ?
operand2			DD ?
operator			DB  ?

result           	DD ?

prompt1				DB "Enter the first number, or (Q/q) to exit: ", 0
prompt2				DB "Enter the second number, or (Q/q) to exit: ", 0
prompt3				DB "Choose an operation (+, -, *, /), or (Q/q) to exit: ", 0
resultPrompt		DB "Evaluation result is: ", 0

operand_msg			DB " < Invalid number, try again ... > ",0				; invalid operand exception message
operator_msg        DB " < Invalid opertor, try again ... > ", 0               			; invalid operator exception message
overflow_msg0       DB " < Result is too large to fit, try again > ", 0   						; overflow exception message
overflow_msg1 	    DB " < First number is large to fit, please enter smaller one > ", 0
overflow_msg2   	DB " < Second number is large to fit, please enter smaller one > ", 0
zeroDiv_msg         DB " < Division by zero is not valid, try again ... > ", 0         ; division by zero exception message

addition				DB '+', 0
subtraction				DB '-', 0
multiplication			DB '*', 0
division				DB '/', 0
equal_sign				DB '=', 0
parth_1					DB '(', 0
parth_2					DB ')', 0
space					DB ' ', 0


.code		; .code is for the executable part of the program

main PROC

	start:
	; Printing the calculator title
		call	CrLf				; spacing for readability
		lea		edx, startTitle		    ; copy the address of caltitle to EDX register
		call	WriteString			; write the calculator title
		call	CrLf	
		call	CrLf							

	; Ask and get the first number
	get_operand1:
		lea		edx, prompt1
		call	WriteString					; write the prompt1 guidance message
		lea  	edx, operand1_string
		mov		ecx, 15
		call	ReadString					; read 32-bit integer from the user and store it in EAX

		jmp check_operand1_validity			; check if the first operand is a valid number
		
		parsing_operand1:

		mov   	ecx, operand1_len
    	call  	ParseInteger32
		mov		operand1, eax	    ; copy EAX value to the first operand
		jo 		operand1_overflow		; jump to operand1_overflow section if there is overflow in operand1

	; Ask and get the arithmatic operator
	get_operator:
		call	CrLf							
		lea		edx, prompt3
		call	WriteString				; write the prompt3 guidance message
		call	ReadChar				; read the operator from the user and store it in AL
		mov		operator, al	    	; copy the character from AL to operator variable
	
		jmp check_operator_validity		; check if the operator is a valid 

	; Ask and get the first number
	get_operand2:
		call Crlf
		call Crlf
		lea		edx, prompt2
		call	WriteString					; write the prompt1 guidance message
		lea  	edx, operand2_string
		mov		ecx, 15
		call	ReadString					; read 32-bit integer from the user and store it in EAX

		jmp check_operand2_validity			; check if the first operand is a valid number
		
		parsing_operand2:

		mov   ecx,operand2_len
    	call  ParseInteger32
		mov		operand2, eax	    ; copy EAX value to the first operand

		jo 	operand2_overflow		; jump to operand2_overflow section if there is overflow in operand2

		call	CrLf
	
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
		mov eax, operand2
		add eax , operand1           ; num1  + num2
		mov result , eax
		jo result_overflow            ; jump if found overflow 
		jmp print_results            ; print resultes

	; subtraction opertion 

	do_subtraction:
		mov eax , operand1 	     	 ; copy the first operand in eax
		sub eax , operand2           ; subtract the second operand form the fisrt operand
		mov result , eax             ; copy the subtraction result in the result
		jo result_overflow                  ; jump to overflow section if overflow found
		jmp print_results            ; else jump to print_result section
	
	; multiplication operation	

        ; Check the number +ve or -ve (Note: need to be handled in a seprate block for all operators)
        ; The value is negative if the MSB is set. 
        ; Use 'cmp' to check  

    do_multiplication:
		mov ebx , operand1
		cmp ebx, 0
		jl _Mul   		               ; Jump if less    
		mov ebx , operand2
		cmp ebx, 0	
		jl _Mul   		                ; Jump if less 
	

	_Mul:				          ; imul used in signed numbers
		mov eax,operand1          ; copy operand1 value --> eax
		mov ebx,operand2          ; copy operand2 value --> ebx
		imul ebx                  ; imul eax, ebx & store result in edx-eax
		mov result, eax           ; copy eax value --> result
		jo result_overflow         ; jump if overflow found
		jmp print_results         ; jump to print_results
					

	do_division: 
		xor EDX, EDX  		 	; clear EdX => will have a most signtific 32bit from 64bit 
		mov EAX, operand1		; get operands  which is 32bit 
		mov EBX, operand2 		; make divisble by to EBX 
		cdq			        	; sign extend 
		cmp EBX , 0h			; check the value of EBX is it zero will make an error 
		je division_by_zero 
		idiv EBX 				; make a div operator 
		mov result, EAX   
		jmp print_results

	; handling exceptions 

	check_operand1_validity:
		
		lea  	edx, operand1_string		; get the length of the first operand 
        call 	StrLength
        mov  	operand1_len,eax

		mov		al, operand1_string			
		cmp 	al,'q'
		je		quit	
		cmp 	al,'Q'
		je		quit

		cmp		al, '+'						; check if the operand starts with a sign
		je		sign_found1
		cmp		al, '-'
		je		sign_found1

		sign_not_found1:					; start checking operand validity from the begining
		mov		ecx, operand1_len
		lea		ebx, operand1_string
		jmp 	check_loop1

		sign_found1:						; start checking operand validity from the second character
		mov		ecx, operand1_len				
		dec		ecx
		lea		ebx, operand1_string
		inc		ebx

		check_loop1:					; checking loop
		mov		al, [ebx] 		
		call 	IsDigit				
		jnz	 	invalid_operand1
		inc		ebx
		loop	check_loop1	

		jmp parsing_operand1

		invalid_operand1:
			call	CrLf                    
			mov edx , offset operand_msg
			call WriteString
			call	CrLf
			call	CrLf
			jmp get_operand1

	check_operator_validity:

		cmp 	operator,'q'		; exit if (q/Q) is found
		je		quit	
		cmp 	operator,'Q'
		je		quit

		cmp operator , '+'                  
		je get_operand2              ; jump if equal to save the operator 
		cmp operator , '-'                  
		je get_operand2               ; jump if equal to save the operator 
		cmp operator , '*'                   
		je get_operand2              ; jump if equal to save the operator 
		cmp operator , '/'                 
		je get_operand2               ; jump if equal to save the operator 

		jmp invalid_operator                 ; else jump to invalid_operator section

		invalid_operator:                    ; print message if the user enterd a invalid operator 
			call Crlf
			call Crlf
			mov edx , offset operator_msg
			call WriteString
			call Crlf
			jmp get_operator

	check_operand2_validity:
		
		lea  	edx, operand2_string		; get the length of the first operand 
        call 	StrLength
        mov  	operand2_len,eax

		mov		al, operand2_string			; exit if (q/Q) is found
		cmp 	al,'q'
		je		quit	
		cmp 	al,'Q'
		je		quit

		cmp		al, '+'						; check if the operand starts with a sign
		je		sign_found2
		cmp		al, '-'
		je		sign_found2

		sign_not_found2:					; start checking operand validity from the begining
		mov		ecx, operand2_len
		lea		ebx, operand2_string
		jmp 	check_loop2

		sign_found2:						; start checking operand validity from the second character
		mov		ecx, operand2_len				
		dec		ecx
		lea		ebx, operand2_string
		inc		ebx

		check_loop2:					; checking loop
		mov		al, [ebx] 		
		call 	IsDigit				
		jnz	 	invalid_operand2
		inc		ebx
		loop	check_loop2	

		jmp parsing_operand2

		invalid_operand2:
			call	CrLf                    
			mov edx , offset operand_msg
			call WriteString
			call	CrLf
			call	CrLf
			jmp get_operand2

	result_overflow:		              	; if overflow occurs in results
		call Crlf
		mov edx , offset overflow_msg0    	
		call WriteString
		call Crlf			 
		jmp quit	      				; exit the program 


	operand1_overflow:		              		; if overflow occurs in operand 1
		call Crlf
		mov edx , offset overflow_msg1    	; ask the user to enter smaller number
		call WriteString
		call Crlf
		call Crlf			 
		jmp get_operand1	      			; return the user back to the get_operand1 section 

		
	operand2_overflow:			      			; if overflow occurs in operand 2
		call Crlf
		mov edx , offset overflow_msg2    	; ask the user to enter smaller number
		call WriteString
		jmp get_operand2	      			; return the user back to the get_operand2 section

	division_by_zero: 
		call Crlf
		mov edx , offset zeroDiv_msg    ; print message if found divide by zero 
		call WriteString
		call Crlf
		call Crlf
		jmp get_operand2


    ; Print results
       
	print_results:
		; Print result prompt
		call	CrLf
		lea		edx, resultPrompt
		call	WriteString

		; Print the first parth_1
		mov  al, parth_1
		call WriteChar

		; Print the first operand
		mov	eax, operand1
		call	WriteInt

		; Print the second parth_2
		mov	al, parth_2
		call	WriteChar

		; Print the spacing
		mov	al, space
		call	WriteChar

		; Print the operator sign
		mov	al, operator
		call	WriteChar

		; Print the spacing
		mov	al, space
		call	WriteChar

		; Print the first parth_1
		mov	al, parth_1
		call	WriteChar

		; Print the second operand
		mov	eax,  operand2
		call	WriteInt

		; Print the second parth_2
		mov	al, parth_2
		call	WriteChar

		; Print the spacing
		mov	al, space
		call	WriteChar

		; Print the equals sign
		mov	al, equal_sign
		call	WriteChar

		; Print the spacing
		mov	al, space
		call	WriteChar

		; Print out the result
        mov	eax, result
		call	WriteInt
		call	CrLf
		call	CrLf
		jmp		start


	quit:
		call	CrLf
		call	CrLf
		lea		edx, endTitle
		call	WriteString	
		call	CrLf
		exit	

main ENDP

END main
