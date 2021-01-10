# **Simple Assembly Calculator**

We introduce to you two versions of simple assembly calculator:

### A. Two-operand simple calculator
### B. Expression-solver simple calculator

Let's go in some details <br/>


  ## A. Two-operand simple calculator

### Introduction

The two-operand simple calculator is an assembly program that solves algebraic operations.

### Features and Functionalities

Calculate basic four operations using symbols ( + , - , * , / ).
<br/>

<br/>

- **Addition operation**

- **Subtraction operation**

- **Multiplication operation**

- **Division operation**


### Exception Handling

- **Invalid operands**

> **Example 1:** `Enter the first number: a5f`
> 
> **Output:** `< invalid number, try again ... >`
>
>`Enter the first number: `

> **Example 2:** `Enter the first number: 5`
> 
>`Choose an operation (+, -, *, /): + `
>
>`Enter the second number: ffffff5`
>
> **Output:** `< invalid number, try again ... >`
>
>`Enter the second number: `

- **Invalid operator**

> **Example:** `Enter the first number: 5`
> 
> `Choose an operation (+, -, *, /): h `
> 
> **Output:** `< invalid opertor, try again ... >`
>
>`Choose an operation (+, -, *, /): `

- **Division by zero**

> **Example:** `Enter the first number: 5`
>
> `Choose an operation (+, -, *, /): / `
> 
> `Enter the second number: 0`
>
> **Output:** `< Division by zero is not valid, try again ... >`
>
>`Enter the second number: `

- **Overflow cases**

1. **In operands during runtime** 


> **Example 1:** `Enter the first number: 3333333333`
>
> `< First number is large to fit, please enter smaller one >`
>
> **Output:** `Enter the first number:`


> **Example 2:** `Enter the first number: 5`
>
> `Choose an operation (+, -, *, /): / `
>
> `Enter the second number: 3333333333`
>
> **Output:** `< Second number is large to fit, please enter smaller one >`
>
>> `Enter the second number: `
 
  2. **Addition overflow** 

> **Example:** `Enter the first number: 1500000000`
>
> `Choose an operation (+, -, *, /): + `
> 
> `Enter the second number: 1500000000`
>
> **Output:** `< Incorrect result due to overflow, try again >`
>
> `Enter the first number: `


  3. **Subtraction overflow** 
   
> **Example:** `Enter the first number: -1500000000`
>
> `Choose an operation (+, -, *, /): - `
> 
> `Enter the second number: 1500000000`
>
> **Output:** `< Incorrect result due to overflow, try again >`
>
> `Enter the first number: `

  4. **Multiplication overflow** 
   
> **Example:** `Enter the first number: 1000000000`
>
> `Choose an operation (+, -, *, /): * `
> 
> `Enter the second number: 2000000000`
>
> **Output:** `< Incorrect result due to overflow, try again >`
>
> `Enter the first number: `

  5. **Division overflow**
  
  There is no overflow will occur in division because the user is restricted to enter a 32-bit numerator and we fill the EDX register with zeros to avoid calculation problems



### Limitations

To be filled later

### Notes

To be filled later

##  B. Expression-solver simple calculator

### Introduction

The expression-solver calculator is an assembly program that solves algebraic expressions.

### Features and Functionalities

Evaluate basic expressions using symbols ('+' '-' '*' '/' ).
<br/>
> **Example:** `Enter expression to evaluate (eg. 2 + 3 * 4): 5+2*10-6+9/3*100+99-21-2+4*5 `
>
> **Output:** `Evaluation result of the expression (5+2*10-6+9/3*100+99-21-2+4*5) is +415 `
<br/>

- **Algorithm description:**
  
    
If we have an arithmetic operation like 2*30/5-3+24/2
We generate two arrays
The first one to hold the numbers in that operation
2     30     5 	   3   	 24     2
And it will be like that 
And second one will hold the operators and it will like that
*     /     -    	+    	/	     $
Filling the last position with this symbol $

Then we iterate over the operator array
If we find that the operator is multiplication or division then we will do the operation on the current number and the next one then we store the result in the next number in the array of numbers
In the above example we multiply 2*30 and store 60 in the second place and the array will be 
2    60     5     3     24	   2

Then we continue doing the division so we do the division 60/5 and store the result in the third number in the array of numbers and the array will be 
2     60    12     3 	  24     2

Then we will find that the next operation to be done is minus but we need to end all division and multiplication first but after we end them it is obvious that the first number in addition and subtraction operations will be this number i.e. 12 so we store it in a variable called number1 and store that the operation to be done i.e. subtraction in another variable called current_operator then continue 
After that we will find that the next operation is addition so is obvious that the second number in addition and subtraction operations will be this number i.e. 3 then we do not have to wait for all multiplication and division operations to be done so we check what is the operation to be done by checking the current_operator variable then we will do that operation i.e. subtraction 12-3 and store its result i.e. 9 in number1 to be the first number of the next addition or subtraction operation then we store the addition in current_operator to be the next operation to be done in addition and subtraction operations then continue  
We will find that the next operation is division so we divide the corresponding number by the next one i.e. 24/2 then we store the result in the next number so the numbers array will be 
2 	  60     12     3	   24	   12
 
Then at the last operation we will find that the operator is $ then now we get the next number in our addition and subtraction operations so we check the current_operator then we will find that the operation to be done is addition then we add number1 with that number i.e. 9+12 and store the result i.e. 21 in number1 
Now we just finished our loop then the result will be the number stored in number1 i.e. 21  
2*30/5-3+24/2 = 21

<br/>

### Error Handling

To be filled later

### Limitations

To be filled later

### Notes

## Resources

**Tools**

- ASSEMBLY PROGRAMMING LANGUAGE
- MASM32 (COMPILER)
- IRVINE LIBRARY
- VISUAL STUDIO CODE (EDITOR)
- CMD (RUN CODE)

**Resources**

- [MASM32 assembler](https://www.masm32.com/)
- [Visual studio code](https://code.visualstudio.com/Download)
- [Irvine Library](http://csc.csudh.edu/mmccullough/asm/help/index.html?page=source%2Fmacros32%2Fmdumpmem.htm)

// Briefy illustration of solving 2 inputs program algorithm 

// Briefy illustration of solving equation program algorithm 

// put Image show program at first before any I/O operations

// put some gifs show different I/O operations
