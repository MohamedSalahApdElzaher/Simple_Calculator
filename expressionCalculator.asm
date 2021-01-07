include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables

.data

calcTitle			DB "  *************  Start the assembly expression calculator  *************  ", 0
prompt1				DB "Enter expression to evaluate (eg. 2 + 3 * 4): ", 0
resultPrompt1		DB "Evaluation result of the expression ", 0
resultPrompt2		DB " is ", 0
parth_1				DB "( ", 0
parth_2				DB " )", 0

expression			DB 331 DUP(?)			; array for maximum 150 characters to hold the expression
expression_length	DD	?
expression_end	DD	?					; counter to know if the expression end reached

string_operand		DB 16 dup (?)
operand_len			DD	?

operators_array		DB 31 dup (?)		; maximum number of operators in the expression is 50
operators_count		DD	?

operands_array		DD	32  dup (?)		; maximum number of operands in the expression is 51
operands_count		DD	?


result          	DD ?					; result

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
		mov  ecx,330				; stop reading when user clicks enter
		call ReadString
		call	CrLf

	; excluding operands and operators from the expression (eg. 2 + 3 * 4)

		lea  	edx, expression			; get the length of the expression 
        call 	StrLength
        mov  	expression_length, eax
		mov  	expression_end, eax		; initialize the expression end counter with expression length

	get_operands:

		mov		operands_count, 0				; initialize operands count
		mov		operators_count, 0				; initialize operators count
		lea		ebx, expression					; get the base address of the expression character array
		jmp		load_new_operand

		load_new_operator:

		mov		al , [ebx]						; save the operator
		mov		edx, operators_count
		mov	operators_array[edx], al
		inc 	operators_count					; increment  operators_array counter
		dec		expression_end

		;	exit if the expression length reached
		cmp 	expression_end, 0	
		je		print_results

		inc		ebx


		load_new_operand:			; save the operator then load an operand

		mov 	edi, 0				; counter for an operand string
		Loop1:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue		
		call 	IsDigit				; ( 20 + 5 )
		jnz	 	parse_operand		; jump to parse the loaded operand
		mov		al , [ebx]
		mov		string_operand[edi], al
		inc		edi
		continue:
		dec		expression_end
		;	exit if the expression length reached
		cmp 	expression_end, 0
		je		parse_operand
		inc		ebx
		jmp		Loop1

		parse_operand:

		mov		al, ' '						; space indicating the end of the number to be parsed
		mov		string_operand[edi], al

		lea  	edx, string_operand			; get the length of the string operand
        call 	StrLength
        mov  	operand_len, eax

		mov   	ecx, operand_len
    	call  	ParseInteger32				; change the string operand to integer value

		mov		edx, operands_count				; store parsed values inside the array
		mov		operands_array[edx], eax	 
		inc		operands_count

		; just for testing i'll remove it later -----
		mov		eax, operands_array[edx]
		call	WriteInt	
		call	CrLf
		; ---------

		; exit if the expression end reached
		cmp 	expression_end, 0
		je		print_results

		jmp 	load_new_operator

	; Write the evaluation results back to user

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
		

		lea		edx, operators_array
		call	WriteString	
		call CrLf
		call CrLf
		mov		eax, expression_length
		call	WriteInt	
		call	CrLf

	quit:
		call	CrLf
		exit	

main ENDP

END main
