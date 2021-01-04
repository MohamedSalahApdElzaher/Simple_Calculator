include    c:\Irvine\Irvine32.inc
includelib c:\Irvine\irvine32.lib
includelib c:\Irvine\kernel32.lib
includelib c:\masm32\lib\user32.lib

		; .data is used for declaring and defining variables
.data

calcTitle			BYTE "  *************  Simple assembly calculator  *************  ", 0
directions			BYTE "Enter two numbers to first numbers:", 0

operand1			DWORD ?
operand2			DWORD ?
operation			BYTE  ?
result           	        DWORD ?
quotinent			DWORD ?  ; for divisoin operator 
remainder 			DWORD ?  ; for divisoin operator 

prompt1				BYTE "Enter the first number: ", 0
prompt2				BYTE "Enter the second number: ", 0
prompt3				BYTE "Arithmatic operation: ", 0
resultPrompt		BYTE "Result evaluation: ", 0
subt                BYTE "subtraction",0     ;for test
msg                 BYTE "pleas enert valid opertor : ",0                      ;message for invalid operator
oferflow            BYTE "there are overflow damge pleas try again ",0         ; message for overflow
divideZero          BYTE "there is divide by zero happend",0         		   ; message for divide by zero 


addition				BYTE '+', 0
subtraction				BYTE '-', 0
multiplication				BYTE '*', 0
division				BYTE '/', 0
equal_sign				BYTE '=', 0
parth_1					BYTE '(', 0
parth_2					BYTE ')', 0
space					BYTE ' ', 0

		; .code is for the executable part of the program
.code
main PROC

	; Printing the calculator title
		call	CrLf				; spacing for readability
		lea	edx, calcTitle		        ; copy the address of caltitle to EDX register
		call	WriteString			; write the calculator title
		call	CrLf				
		call	CrLf

	; Ask and get the first number
		lea	edx, prompt1
		call	WriteString		; write the prompt1 guidance message
		call	ReadInt			; read 32-bit integer from the user and store it in EAX
		mov	operand1, eax	        ; copy EAX value to the first operand

	; Ask and get the second number
		lea	edx, prompt2
		call	WriteString		; write the prompt2 guidance message
		call	ReadInt			; read 32-bit integer from the user and store it in EAX
		mov	operand2, eax	        ; copy EAX value to the second operand

	; Ask and get the arithmatic operation
	op:
		lea	edx, prompt3
		call	WriteString		; write the prompt3 guidance message
		call	ReadChar		; read character from the user and store it in AL
		mov	operation, al	        ; copy the character from AL to operation variable
	
	
	; Redirection to the  the needed operation
    	cmp al , 2Ah                          ; 2Ah is equivalent to * opertor in ASCII
		je multiplication_block               ; jump to multiplication_block 
		cmp al , 2Bh                          ; 2Bh is equivalent to + opertor in ASCII
		je addition_block                     ; jump to addition_block 
		cmp al , 2Dh                          ; 2Fh is equivalent to - opertor in ASCII
		je subtraction_block                  ; jump to subtraction_block
		cmp al , 2Fh                          ; 2Dh is equivalent to / opertor in ASCII
		je division_block                     ; jump to division_block
		jmp mas                               ; jump to print message if user enter invalid operator

		
	addition_block:                                              ; addition opertion 
		mov eax, operand2
		add eax , operand1           ; num1  + num2
		mov result , eax
		jo ovr                       ; jump if found overflow 
		jmp Print_results            ; print resultes
	subtraction_block:
		mov eax , operand1 ;copy the first operand in eax
		sub eax , operand2 ;subtract the second operand form the fisrt onr
		mov result , eax   ;copy the subtraction result in the result
		jmp Print_results  ;jump to print_result section
	
	; Mul operation	
        ; Check the number +ve or -ve (Note: need to be handled in a seprate block for all operations)
        ; The value is negative if the MSB is set. 
        ; Use 'cmp' to check  

    multiplication_block:
		mov ebx , operand1
		cmp ebx, 0
		jl Negative_Mul   				   	  ; Jump if less    
			mov ebx , operand2
		cmp ebx, 0	
		jl Negative_Mul   				   	  ; Jump if less 

		; cmp operation, '*'                    		  ; check value of operation == '*' or not
		; je Positive_Mul     			      		  ; if yes -> jump to multiplication_block 
		
		; multiplication_32bit
	
	Positive_Mul:         				           ; mul used in unsigned numbers
		mov eax,operand1                  	       ; copy operand1 value --> eax
		mov ebx,operand2                           ; copy operand2 value --> ebx
		mul ebx                                    ; mul eax, ebx & store result in edx-eax
		mov result, eax                            ; copy eax value --> result
		jmp Print_results                          ; Print_results


	Negative_Mul:					               ; imul used in signed numbers
		mov eax,operand1                           ; copy operand1 value --> eax
		mov ebx,operand2                           ; copy operand2 value --> ebx
		imul ebx                                   ; imul eax, ebx & store result in edx-eax
		mov result, eax                      	   ; copy eax value --> result
		jmp Print_results                          ; Print_results
					

	division_block: 
		xor EDX, EDX  		 	; clear EdX => will have a most signtific 32bit from 64bit 
		mov EAX, operand1		; get operands  which is 32bit 
		mov EBX, operand2 		; make divisble by to EBX 
		cdq						; sign extend 
		cmp EBX , 0h			; check the value of EBX is it zero will make an error 
		je div_zero 
		idiv EBX 			    ; make a div operation 
		mov quotinent, EAX  	; save quotinent
		mov remainder, EDX 
		mov result, EAX  
		add EDX, EDX 			; double  remainder 
		cmp EDX, EBX 			; comp with divisible if it is bigger it will round 
		jb 1 				    ; itis not big enough sp jump the nexet instruction 
		inc result
		jmp Print_results


	;handling the errors that will happend 
   	mas:                                    ; print message if the user enterd a invalid operator 
		call Crlf
		mov edx , offset msg
		call WriteString
		jmp op
		
    ovr:
		mov edx , offset oferflow    ; print message if found overflow
		call WriteString
		jmp quit

	div_zero: 
       	mov edx , offset divideZero    ; print message if found divide by zero 
		call WriteString
		jmp quit


       ; Print results
       
	Print_results:
		; Print result prompt
		call	CrLf
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

		; Print the operation sign
		mov	al, operation
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
