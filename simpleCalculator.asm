include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables
.data

calcTitle			BYTE "  *************  Simple assembly calculator  *************  ", 0
directions			BYTE "Enter two numbers to first numbers:", 0

operand1			DWORD ?
operand2			DWORD ?
operation			BYTE  ?
result           	DWORD ?

prompt1				BYTE "Enter the first number: ", 0
prompt2				BYTE "Enter the second number: ", 0
prompt3				BYTE "Arithmatic operation: ", 0
resultPrompt		BYTE "Result evaluation: ", 0

addition				BYTE '+', 0
subtraction				BYTE '-', 0
multiplication			BYTE '*', 0
division				BYTE '/', 0
equal_sign				BYTE '=', 0

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
		lea		edx, prompt3
		call	WriteString		; write the prompt3 guidance message
		call	ReadChar		; read character from the user and store it in AL
		mov		operation, al	; copy the character from AL to operation variable
	
	; Redirection to the  the needed operation

	; A comment block to guide you all

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
		


	; divisoin opertion 
		; 1. division operation 32bit => 64bit by 32bit 
			;1.a) the 64bit number is saved in EDX and EAX , 32 bit any operand by the instruction 
			;1.b) will result quotinent 32bit in EAX and remainder in 32bit in EDX 
				;* the CDQ convert doubleword to quadword 
			;1.c) the reminder may takes two ways : A- round up B- convert to fractional number 
		; 2. fix divide by zero 
		; 3. divide overflow 
		; 4. signed divide 
		 





	; Print results

	Print_results:
		; Print result prompt
		call	CrLf
		call	CrLf
		lea		edx, resultPrompt
		call	WriteString

		; Print the first operand
		mov		eax, operand1
		call	WriteDec

		; Print the operation sign
		mov		al, operation
		call	WriteChar

		; Print the second operand
		mov		eax,  operand2
		call	WriteDec

		; Print the equals sign
		mov		al, equal_sign
		call	WriteChar

		; Print out the result
		mov		eax, result
		call	WriteDec
		call	CrLf
		jmp 	quit

	quit:
		call	CrLf
		exit	

main ENDP

END main