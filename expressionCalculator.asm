include    \Irvine\Irvine32.inc
includelib \Irvine\irvine32.lib
includelib \Irvine\kernel32.lib
includelib \masm32\lib\user32.lib

		; .data is used for declaring and defining variables

.data

calcTitle			DB "  *  Start the assembly expression calculator  *  ", 0
prompt1				DB "Enter expression to evaluate (eg. 2 + 3 * 4): ", 0
resultPrompt1		DB "Evaluation result of the expression ", 0
resultPrompt2		DB " is ", 0
parth_1				DB "( ", 0
parth_2				DB " )", 0

overflow_msg	  	DB " <threre an overflow happend  > ", 0
zeroDiv_msg         DB " < Division by zero is not valid > ", 0         ; division by zero exception message

expression				DB 331 DUP(?)			; array for maximum 150 characters to hold the expression
expression_length		DD	?
expression_end			DD	?					; counter to know if the expression end reached

string_operand			DB 16 dup (?)
operand_len				DD	?

operators_array			DB 31 dup (?)		; maximum number of operators in the expression is 50
operators_count			DD	?

operands_array			DD	32  dup (?)		; maximum number of operands in the expression is 51
operands_count			DD	?
operands_index			DD	?

current_operator 		DB ?				; to hold operators of + and - 
temp 					DD ?				; to use in mylti and division 
number1 				DD 0				; the result will be on there 
first_access 			DD 0				; to check if first access happend or not 
number2 				DD 0				; hold the secound number 

		; .code is for the executable part of the program
.code
main PROC
	; print calculator title
		call	CrLf                               ;Writes a carriage return/linefeed sequence (0Dh,0Ah) to standard output.
		mov	edx, OFFSET calcTitle
		call	WriteString			  ;Writes a null-terminated string to standard output.
		call	CrLf
		call	CrLf

	; Read the expression from user 
	read_expression:
		lea		edx, prompt1
		call	WriteString
		lea  	edx, expression
		mov  	ecx,330				; stop reading when user clicks enter
		call 	ReadString			; Reads a string of up to ECX non-null characters from standard input,stop when user click enter
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
		mov		operators_array[edx], al
		inc 	operators_count					; increment  operators_array counter
		dec		expression_end				; decrement  expression_end counter

		;	exit if the expression length reached
		cmp 	expression_end, 0	
		je		start_evaluation

		inc		ebx


		load_new_operand:			; save the operator then load an operand

		mov 	edi, 0				; counter for an operand string
		Loop1:
		mov		al, [ebx]
		cmp		al, ' ' 
		je		continue		;jump if equal
		call 	IsDigit				; ( 20 + 5 ) Determines whether the character in AL is a valid decimal digit.
		jnz	 	parse_operand		; jump to parse the loaded operand
		mov		al , [ebx]
		mov		string_operand[edi], al
		inc		edi
		continue:
		dec		expression_end
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

		mov		edx, operands_index				; store parsed values inside the array
		mov		operands_array[edx], eax	 
		add		operands_index,4
		inc		operands_count

		; exit if the expression end reached
		cmp 	expression_end, 0
		je		start_evaluation
		jmp 	load_new_operator
		
start_evaluation:
	
	; continue writing your code here
	mov		esi, 0							; for operands array indexing
	mov		edi, 0							; for operators array indexing
	mov		ecx , operands_count            ; set the counter 
	
l1:		
		; get the new operator and compare it with first piroity operation * and /  					
        mov 	al, operators_array[edi]		
        cmp 	al,'*'							 
        je  	do_multiplication 		
        cmp 	al,'/'
        je  	do_division	

		; if not send it to numeber1 and number2 to do second piroity operation + and - 
      	mov 	eax, first_access		; if (number1==0)number1=[ebx] , current_operator = [edx]
		cmp 	eax, 0
		je		first_check		; 
		jmp 	second_check    ; else number2 = [ebx]     number1 = number1 +- number2
		
endl1: ; change the current operator afte make the prev on in second check 
        mov 	al, operators_array[edi]  ;op1 = op[i] 
        mov 	current_operator, al

endl12: ; ending of loop just inc the indexing 
        inc		edi                 ;  i++ 
        add		esi, 4              ;  i++ 
        loop 	l1
   		jmp 	print_results 

first_check:  ; first to put the number in first number 
		mov 	eax, operands_array[esi]
		mov 	number1,eax
		inc		first_access
		jmp 	endl1

second_check:	; do the sescound operation 
		mov 	al,current_operator		;if(current_operator == '+')number1 += number2
		cmp 	al,'+'
		je  	do_addition
		cmp 	al,'-'
		je  	do_subtraction

do_multiplication:
		mov 	eax, operands_array[esi]  
		mov 	temp, eax                       ;  temp = arr[i]
		mov 	eax, operands_array[esi+4]      ;  eax = arr[i+1]
		imul 	temp
		mov 	operands_array[esi+4],eax       ; arr[i+1] *= eax  ; put the result in next indexing 
		jo 		overflowBlock
		jmp 	endl12
do_division:
	   xor     edx, edx  
		mov 	eax, operands_array[esi+4]
		mov 	temp, eax
		mov 	eax, operands_array[esi]
        cdq
        cmp     temp , 0h
        je  	div_zero
		idiv 	temp
        add     EDX, EDX
        cmp     EDX,  operands_array[esi]
        jb 		skip1
        inc     eax  
      skip1: 
		mov 	operands_array[esi+4], eax     ; put the result in next indexing 
		; jo overflowBlock
		jmp endl12							; jum] to the end of loop 

do_addition:
		mov eax,number1
        add eax, operands_array[esi]
		mov number1,eax
        jmp endl1								; jump to change to next operator 

do_subtraction:
		mov eax,number1
		sub eax,operands_array[esi]
		mov number1,eax
        jmp endl1

div_zero:   ; block for divisoin by zero 
		call 	Crlf
		mov 	edx , offset zeroDiv_msg    ; print message if found divide by zero 
		call 	WriteString
		call 	Crlf
		call 	Crlf
		jmp 	quit 

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
		
		mov		eax, number1			; here to print the answer 
		call	WriteInt	
		call	CrLf

	quit:
		call	CrLf
		exit	

main ENDP

END main
