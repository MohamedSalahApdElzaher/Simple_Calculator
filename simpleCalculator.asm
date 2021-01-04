include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables
.data

calcTitle			BYTE "  *************  Simple assembly calculator  *************  ", 0
directions			BYTE "Enter two numbers to evaluate:", 0

operand1			DWORD ?
operand2			DWORD ?
operator			BYTE  ?
result           	DWORD ?
quotinent			DWORD ?  ; for divisoin operator 
remainder 			DWORD ?  ; for divisoin operator 

prompt1				BYTE "Enter the first number: ", 0
prompt2				BYTE "Enter the second number: ", 0
prompt3				BYTE "Choose an arithmatic operation (+, -, *, /): ", 0
resultPrompt		BYTE "Result evaluation: ", 0

operator_msg        BYTE "Enter a valid opertor : ",0               ;message for invalid operator
overflow_msg        BYTE "Overflow occures try again ",0   			; message for overflow
zeroDiv_msg         BYTE "Division by zero is not valid, try again ... ",0         	; message for divide by zero 


addition				BYTE '+', 0
subtraction				BYTE '-', 0
multiplication			BYTE '*', 0
division				BYTE '/', 0
equal_sign				BYTE '=', 0
parth_1					BYTE '(', 0
parth_2					BYTE ')', 0
space					BYTE ' ', 0


.code		; .code is for the executable part of the program

main PROC

	; Printing the calculator title
		call	CrLf				; spacing for readability
		lea	edx, calcTitle		        ; copy the address of caltitle to EDX register
		call	WriteString			; write the calculator title
		call	CrLf				
		call	CrLf

	; Ask and get the first number
	get_operand1:
		lea	edx, prompt1
		call	WriteString		; write the prompt1 guidance message
		call	ReadInt			; read 32-bit integer from the user and store it in EAX
		mov	operand1, eax	        ; copy EAX value to the first operand

	; Ask and get the arithmatic operator
	get_operator:
		lea	edx, prompt3
		call	WriteString		; write the prompt3 guidance message
		call	ReadChar		; read the operator from the user and store it in AL
		mov	operator, al	    ; copy the character from AL to operator variable
		call	CrLf

	; Ask and get the second number
	get_operand2:
		lea	edx, prompt2
		call	WriteString		; write the prompt2 guidance message
		call	ReadInt			; read 32-bit signed decimal integer from the user and store it in EAX
		mov	operand2, eax	    ; copy EAX value to the second operand


	
	
	; Redirection to the  the needed operator

		cmp operator , '+'                  
		je do_addition                     ; jump if equal to do_addition 
		cmp operator , '-'                  
		je do_subtraction                  ; jump if equal to do_subtraction
		cmp operator , '*'                   
		je do_multiplication               ; jump if equal to do_multiplication 
		cmp operator , '/'                 
		je do_division                     ; jump if equal to do_division

		jmp invalid_operator               ; else jump to invalid_operator section

	; addition opertion 

	do_addition:
		mov eax, operand2
		add eax , operand1           ; num1  + num2
		mov result , eax
		jo overflow                  ; jump if found overflow 
		jmp print_results            ; print resultes

	; subtraction opertion 

	do_subtraction:
		mov eax , operand1 	     ; copy the first operand in eax
		sub eax , operand2           ; subtract the second operand form the fisrt operand
		mov result , eax             ; copy the subtraction result in the result
		jo overflow                  ; jump to overflow section if overflow found
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
	

	_Mul:				                   ; imul used in signed numbers
		mov eax,operand1                           ; copy operand1 value --> eax
		mov ebx,operand2                           ; copy operand2 value --> ebx
		imul ebx                                   ; imul eax, ebx & store result in edx-eax
		mov result, eax                      	   ; copy eax value --> result
		jo overflow                                ; jump if overflow found
		jmp print_results                          ; jump to print_results
					

	do_division: 
		xor EDX, EDX  		 	; clear EdX => will have a most signtific 32bit from 64bit 
		mov EAX, operand1		; get operands  which is 32bit 
		mov EBX, operand2 		; make divisble by to EBX 
		cdq			        ; sign extend 
		cmp EBX , 0h			; check the value of EBX is it zero will make an error 
		je div_zero 
		idiv EBX 			; make a div operator 
		mov quotinent, EAX  	        ; save quotinent
		mov remainder, EDX 
		mov result, EAX  
		add EDX, EDX 			; double  remainder 
		cmp EDX, EBX 			; comp with divisible if it is bigger it will round 
		jb skip1 			; itis not big enough sp jump the nexet instruction 
		inc result 
	skip1:
		jo overflow             ; jump if found overflow 
		jmp print_results


	; handling exceptions 

   	invalid_operator:                    ; print message if the user enterd a invalid operator 
		call Crlf
		mov edx , offset operator_msg
		call WriteString
		jmp get_operator
		
    overflow:
		mov edx , offset overflow_msg    ; print message if overflow found
		call WriteString
		jmp quit

	div_zero: 
       	call Crlf
		call Crlf
		mov edx , offset zeroDiv_msg    ; print message if found divide by zero 
		call WriteString
		call Crlf
		call Crlf
		jmp get_operand1


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
		jmp 	quit


	quit:
		call	CrLf
		exit	

main ENDP

END main
