include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables

.data

calcTitle			DB "  *************  Start the assembly expression calculator  *************  ", 0
prompt1				DB "Enter expression to evaluate (eg. 2 + 3 * 4): ", 0
resultPrompt1			DB "Evaluation result of the expression ", 0
resultPrompt2			DB " is ", 0
parth_1				DB "( ", 0
parth_2				DB " )", 0

overflow_msg	  	DB " <threre an overflow happend  > ", 0
zeroDiv_msg         DB " < Division by zero is not valid > ", 0         ; division by zero exception message

expression			DB 331 DUP(?)			; array for maximum 150 characters to hold the expression
expression_length		DD	?
expression_end			DD	?					; counter to know if the expression end reached

string_operand			DB 16 dup (?)
operand_len			DD	?

operators_array			DB 31 dup (?)		; maximum number of operators in the expression is 50
operators_count			DD	?

operands_array			DD	32  dup (?)		; maximum number of operands in the expression is 51
operands_count			DD	?


result          		DD ?					; result

temp 				DD ?
number1 			DD 0	
number2 			DD 0

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
		je		start_evaluation

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
		cmp 		expression_end, 0
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

		; exit if the expression end reached
		cmp 	expression_end, 0
		je		start_evaluation

		jmp 	load_new_operator
		
start_evaluation:

	mov	edx, operators_count
	mov	operators_array[edx], '$'
	
	; continue writing your code here
	mov		esi, 0				; for operands array indexing
	mov		edi, 0				; for operators array indexing
	mov		ecx , operators_count             ; set the counter 
	
l1:							
        
        mov 	al, operators_array[edi]
        cmp 	al,'*'
        je  	do_multiplication 		
        cmp 	al,'/'
        je  	do_division	

      	mov 	eax,number1		; if (number1==0)number1=[ebx] , current_operator = [edx]
		cmp 	eax,0
		je		first_check		; 
		jmp 	second_check    ; else number2 = [ebx]     number1 = number1 +- number2
endl1: 
        mov 	al, operators_array[edi]  ;op1 = op[i]
        mov 	current_operator, al

endl12: 
        inc		edi                 ;  i++ 
        add		esi, 4              ;  i++ 
        loop l1 
   	jmp print_results 

first_check:
		mov 	eax, operands_array[esi]
		mov 	number1,eax
		jmp 	endl1

second_check:
		mov al,current_operator		;if(current_operator == '+')number1 += number2
		cmp al,'+'
		je  do_addition
		cmp al,'-'
		je  do_subtraction

do_multiplication:
		mov 	eax, operands_array[esi]  
		mov 	temp, eax                       ;  temp = arr[i]
		mov 	eax, operands_array[esi+4]      ;  eax = arr[i+1]
		imul 	temp
		mov 	operands_array[esi+4],eax       ; arr[i+1] *= eax 
		jo overflowBlock
		jmp endl12
do_division:
	   xor     edx, edx  
		mov 	eax, operands_array[esi+4]
		mov 	temp, eax
		mov 	eax, operands_array[esi]
        cdq
        cmp     temp , 0h
        je  div_zero
		idiv 	temp
        add     EDX, EDX
        cmp     EDX,  operands_array[esi]
        jb skip1
        inc     eax  
      skip1: 
		mov 	operands_array[esi+4], eax
		jo overflowBlock0
		jmp endl12

do_addition:
		mov eax,number1
        add eax, operands_array[esi]
		mov number1,eax
        jmp endl1

do_subtraction:
		mov eax,number1
		sub eax,operands_array[esi]
		mov number1,eax
        jmp endl12

div_zero: 
		call Crlf
		mov edx , offset zeroDiv_msg    ; print message if found divide by zero 
		call WriteString
		call Crlf
		call Crlf
		jmp quit 
overflowBlock:
		call Crlf
		mov edx , offset overflow_msg    	; ask the user to enter smaller number
		call WriteString
		call Crlf
		call Crlf
		jmp quit 	
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
