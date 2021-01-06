include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables

.data

calcTitle			DB "  *************  Start the assembly expression calculator  *************  ", 0
prompt1				DB "Enter expression of max 5 operands (eg. 2 + 3 * 4 / 6 - 8 ): ", 0
resultPrompt1		DB "Evaluation result of the expression ", 0
resultPrompt2		DB " is ", 0
parth_1				DB "( ", 0
parth_2				DB " )", 0
space				DB " ", 0

expression			DB 31 DUP(?)			; array for 30 characters

operand1_string			DB 16 dup (?)
operand2_string			DB 16 dup (?)
operand3_string			DB 16 dup (?)
operand4_string			DB 16 dup (?)
operand5_string			DB 16 dup (?)

operators				DB 5 dup (?)

Operand1		DD ?					; first operand
Operand2		DD ?					; second operand
Operand3		DD ?					; third operand
Operand4		DD ?					; fourth operand
Operand5		DD ?					; fifth operand

result          DD ?					; result

		; .code is for the executable part of the program
.code
main PROC
	; print calculator title
		call	CrLf
		mov		edx, OFFSET calcTitle
		call	WriteString
		call	CrLf
		call	CrLf

	; Read the expression from user 
	read_expression:
		lea		edx, prompt1
		call	WriteString
		lea  edx, expression
		mov  ecx,30
		call ReadString
		call	CrLf

	; excluding operands and operators from the expression (eg. 2 + 3 * 4)

	get_operand1:

		lea		ebx, expression
		mov 	edi, 0			; counter for operand1 string
		Loop1:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue1		
		call 	IsDigit				
		jnz	 	get_operand2
		mov		al , [ebx]
		mov		operand1_string[edi], al
		inc		edi
		continue1:
		inc		ebx
		jmp		Loop1

	get_operand2:

		mov 	edi, 0			; counter for operand2 string
		mov 	edx, 0			; initialized counter for operators string
		mov		al , [ebx]
		mov	operators[edx], al
		inc		ebx
		Loop2:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue2 		
		call 	IsDigit				
		jnz	 	get_operand3
		mov		al , [ebx]
		mov		operand2_string[edi], al
		inc		edi
		continue2:
		inc		ebx
		jmp		Loop2

	get_operand3:

		mov 	edi, 0			; counter for operand3 string
		inc 	edx				; increment  operators counter
		mov		al , [ebx]
		mov	operators[edx], al
		inc		ebx
		Loop3:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue3 		
		call 	IsDigit				
		jnz	 	get_operand4
		mov		al , [ebx]
		mov		operand3_string[edi], al
		inc		edi
		continue3:
		inc		ebx
		jmp		Loop3

	get_operand4:

		mov 	edi, 0			; counter for operand4 string
		inc 	edx				; increment  operators counter
		mov		al , [ebx]
		mov	operators[edx], al
		inc		ebx
		Loop4:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue4 		
		call 	IsDigit				
		jnz	 	get_operand5
		mov		al , [ebx]
		mov		operand4_string[edi], al
		inc		edi
		continue4:
		inc		ebx
		jmp		Loop4

	get_operand5:

		mov 	edi, 0			; counter for operand5 string
		inc 	edx				; increment  operators counter
		mov		al , [ebx]
		mov	operators[edx], al
		inc		ebx
		Loop5:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue5 		
		call 	IsDigit				
		jnz	 	parse_operands
		mov		al , [ebx]
		mov		operand5_string[edi], al
		inc		edi
		continue5:
		inc		ebx
		jmp		Loop5

	parse_operands:
	lea  	edx, operand1_string		; load operand1 string address 
    call 	StrLength					; get string length
	mov   ecx, eax						; store the length in the counter ecx
    call  ParseInteger32				; parsing the string to integer value
	mov		operand1, eax	    		; copy EAX value to the first operand1

	lea  	edx, operand2_string		; same steps for operand2 
    call 	StrLength					
	mov   	ecx, eax					
    call  	ParseInteger32				
	mov		operand2, eax	    		

	lea  	edx, operand3_string		; same steps for operand3
    call 	StrLength					
	mov   	ecx, eax					
    call  	ParseInteger32				
	mov		operand3, eax	    		

	lea  	edx, operand4_string		; same steps for operand4 
    call 	StrLength					
	mov   	ecx, eax						
    call  	ParseInteger32				
	mov		operand4, eax	    		

	lea  	edx, operand5_string		; same steps for operand5
    call 	StrLength					
	mov   	ecx, eax					
    call  	ParseInteger32				
	mov		operand5, eax	    		

	; Write the evaluation results back to user parth_1

	print_results:
		lea		edx, resultPrompt1
		call	WriteString	

		lea		edx, parth_1
		call	WriteString	

		lea		edx, expression
		call	WriteString	

		lea		edx, parth_2
		call	WriteString

		lea		edx, resultPrompt2
		call	WriteString	

		; only for testing

		lea		edx, operators
		call	WriteString	

		lea		edx, space
		call	WriteString

		mov		eax, operand5
		call	WriteInt	
		call	CrLf

	quit:
		call	CrLf
		exit	

main ENDP

END main
