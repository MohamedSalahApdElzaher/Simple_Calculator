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
result           	DWORD ?
quotinent			DWORD ?  ; for divisoin operator 
remainder 			DWORD ?  ; for divisoin operator 

prompt1				BYTE "Enter the first number: ", 0
prompt2				BYTE "Enter the second number: ", 0
prompt3				BYTE "Arithmatic operation: ", 0
resultPrompt		BYTE "Result evaluation: ", 0
addt                BYTE "addtion",0         ;for test
subt                BYTE "subtraction",0     ;for test
msg                 BYTE "pleas enert valid opertor : ",0

addition				BYTE '+', 0
subtraction				BYTE '-', 0
multiplication			BYTE '*', 0
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
		lea		edx, calcTitle		; copy the address of caltitle to EDX register
		call	WriteString			; write the calculator title
		call	CrLf				
		call	CrLf

	; Ask and get the first number
		lea		edx, prompt1
		call	WriteString		; write the prompt1 guidance message
		call	ReadInt			; read 32-bit integer from the user and store it in EAX
		mov		operand1, eax	; copy EAX value to the first operand

	; Ask and get the second number
		lea		edx, prompt2
		call	WriteString		; write the prompt2 guidance message
		call	ReadInt			; read 32-bit integer from the user and store it in EAX
		mov		operand2, eax	; copy EAX value to the second operand

	; Ask and get the arithmatic operation
	op:
		lea		edx, prompt3
		call	WriteString		; write the prompt3 guidance message
		call	ReadChar		; read character from the user and store it in AL
		mov		operation, al	; copy the character from AL to operation variable
	
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

		comment ! 
		
		Here you must check out the operation then redirect the program flow
		to the suitable arithmatic block, and then from that block jump to print
		results.

		The following lines may help (I didn't test it)

		cmp operation, '+'
		jnz addition_block
		cmp operation, '-'
		jnz subtraction_block
		cmp operation, '*'
		jnz multiplication_block
		cmp operation, '/'
		jnz division_block
		jmp quit

		!
	; A comment block to guide you all
		
		
	addition_block:
					mov eax, operand2
					add eax , operand1
					mov result , eax
					jmp Print_results
	subtraction_block:
	                mov edx , offset subt  ; for test
					call WriteString
					jmp quit
	
	
	
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

				; cmp operation, '*'                    		   	  ; check value of operation == '*' or not
				; je Positive_Mul     			      		  ; if yes -> jump to multiplication_block 
				
				; multiplication_32bit
			
				Positive_Mul:         				                  ; mul used in unsigned numbers
						mov eax,operand1                  		          ; copy operand1 value --> eax
						mov ebx,operand2                     			  ; copy operand2 value --> ebx
						mul ebx                            			  ; mul eax, ebx & store result in edx-eax
						mov result, eax                      			  ; copy eax value --> result
				        jmp Print_results                                 ; Print_results


				Negative_Mul:							  ; imul used in signed numbers
						mov eax,operand1                     			  ; copy operand1 value --> eax
						mov ebx,operand2                     			  ; copy operand2 value --> ebx
						imul ebx                             			  ; imul eax, ebx & store result in edx-eax
						mov result, eax                      			  ; copy eax value --> result
					    jmp Print_results                                 ; Print_results
					
				
				


	; divisoin opertion 
		; 1. division operation 32bit => 64bit by 32bit 
			;1.a) the 64bit number is saved in EDX and EAX , 32 bit any operand by the instruction 
			;1.b) will result quotinent 32bit in EAX and remainder in 32bit in EDX 
				;* the CDQ convert doubleword to quadword 
			;1.c) the reminder may takes two ways : A- round up B- convert to fractional number 
		; 2. fix divide by zero 
		; 3. divide overflow 
		; 4. signed divide 
		

	division_block: 
		xor EDX, EDX  		; clear EdX 
		mov EAX, operand1	; get operands 
		mov EBX, operand2 
		div EBX 
		mov quotinent, EAX  ; save quotinent
		mov result, EAX 
		jmp Print_results
		; xor EAX, EAX
		; div EBX 			; genrate remainder 
		; mov remainder, EAX   




	; Print results
    mas:
	        call Crlf
			mov edx , offset msg
			call WriteString
			jmp op
	
	Print_results:
		; Print result prompt
		call	CrLf
		call	CrLf
		lea		edx, resultPrompt
		call	WriteString

		; Print the first parth_1
		mov		al, parth_1
		call	WriteChar

		; Print the first operand
		mov		eax, operand1
		call	WriteInt

		; Print the second parth_2
		mov		al, parth_2
		call	WriteChar

		; Print the spacing
		mov		al, space
		call	WriteChar

		; Print the operation sign
		mov		al, operation
		call	WriteChar

		; Print the spacing
		mov		al, space
		call	WriteChar

		; Print the first parth_1
		mov		al, parth_1
		call	WriteChar

		; Print the second operand
		mov		eax,  operand2
		call	WriteInt

		; Print the second parth_2
		mov		al, parth_2
		call	WriteChar

		; Print the spacing
		mov		al, space
		call	WriteChar

		; Print the equals sign
		mov		al, equal_sign
		call	WriteChar

		; Print the spacing
		mov		al, space
		call	WriteChar

		; Print out the result
                mov		eax, result
		call	WriteInt
		call	CrLf
		jmp 	quit

	

	quit:
		call	CrLf
		exit	

main ENDP

END main
