include c:\irvine\Irvine32.inc
includelib c:\irvine\Irvine32.lib
includelib c:\irvine\kernel32.lib
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
prompt3				BYTE "Arithmatic operation: '+' , '-' , '*' , '/'", 0
resultPrompt		BYTE "Result evaluation: ", 0

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
		lea		edx, prompt1    ; copy the address of prompt1 to EDX register
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


        ; Check the number +ve or -ve
        ; The value is negative if the MSB is set. 
        ; Use 'cmp' to check  

        cmp operand1, 0
        jl Negative_Mul   				   	  ; Jump if less    

		cmp operand2, 0
        jl Negative_Mul   				   	  ; Jump if less 
    
        cmp operation, '*'                     ; check value of operation == '*' or not
        je Positive_Mul     			       ; if yes -> jump to multiplication_block                 
 
      
    Positive_Mul:         				       ; multiplication lable block
        mov eax,operand1                       ; copy operand1 value --> eax
        mov ebx,operand2                       ; copy operand2 value --> ebx
        mul ebx                                ; mul eax, ebx & store result in edx-eax
        mov result, eax                        ; copy eax value --> result
      
	Negative_Mul:
        mov eax,operand1                       ; copy operand1 value --> eax
        mov ebx,operand2                       ; copy operand2 value --> ebx
        imul ebx                               ; mul eax, ebx & store result in edx-eax
        mov result, eax                        ; copy eax value --> result



	; Print results

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