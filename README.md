# **Simple Assembly Calculator**

We introduce to you two versions of simple assembly calculator:

### A. Two-operand simple calculator
### B. Expression-solver simple calculator

Let's go in some details <br/>


  ## A. Two-operand simple calculator

### Introduction

The two-operand simple calculator is an assembly program that solves arithmatic operations.

### Features and Functionalities

It supports the basic four arithmatic operations using symbols ( + , - , * , / ).

- **Addition operation**
> **Example:** `Enter the first number, or (Q/q) to exit:  15`
> 
>`Choose an operation (+, -, *, /), or (Q/q) to exit: + `
>
>`Enter the second number, or (Q/q) to exit: 20`
>
> **Output:** `Evaluation result is (+15) + (+20) = +35`

- **Subtraction operation**
> **Example:** `Enter the first number, or (Q/q) to exit:  3`
> 
>`Choose an operation (+, -, *, /), or (Q/q) to exit: - `
>
>`Enter the second number, or (Q/q) to exit: 13`
>
> **Output:** `Evaluation result is (+3) - (+13) = -10`

- **Multiplication operation**
> **Example:** `Enter the first number, or (Q/q) to exit:  500`
> 
>`Choose an operation (+, -, *, /), or (Q/q) to exit: * `
>
>`Enter the second number, or (Q/q) to exit: -5`
>
> **Output:** `Evaluation result is (+500) * (-5) = -2500`

- **Division operation**
> **Example:** `Enter the first number, or (Q/q) to exit:  500000`
> 
>`Choose an operation (+, -, *, /), or (Q/q) to exit: / `
>
>`Enter the second number, or (Q/q) to exit: 1000`
>
> **Output:** `Evaluation result is (+500000) / (+1000) = +500`


### Exception Handling

- **Invalid operands**

> **Example 1:** `Enter the first number, or (Q/q) to exit: a5f`
> 
> **Output:** `< Invalid number, try again ... >`
>
>`Enter the first number, or (Q/q) to exit: `

> **Example 2:** `Enter the first number, or (Q/q) to exit: 5`
> 
>`Choose an operation (+, -, *, /), or (Q/q) to exit: + `
>
>`Enter the second number, or (Q/q) to exit: ffffff5`
>
> **Output:** `< Invalid number, try again ... >`
>
>`Enter the second number, or (Q/q) to exit: `

- **Invalid operator**

> **Example:** `Enter the first number, or (Q/q) to exit: 5`
> 
> `Choose an operation (+, -, *, /), or (Q/q) to exit: h `
> 
> **Output:** `< Invalid opertor, try again ... >`
>
>`Choose an operation (+, -, *, /), or (Q/q) to exit: `

- **Division by zero**

> **Example:** `Enter the first number, or (Q/q) to exit: 5`
>
> `Choose an operation (+, -, *, /), or (Q/q) to exit: / `
> 
> `Enter the second number, or (Q/q) to exit: 0`
>
> **Output:** `< Division by zero is not valid, try again ... >`
>
>`Enter the second number, or (Q/q) to exit: `

- **Overflow cases**

1. **In operands during runtime** 


> **Example 1:** `Enter the first number, or (Q/q) to exit: 3333333333`
>
> `< First number is large to fit, please enter smaller one >`
>
> **Output:** `Enter the first number, or (Q/q) to exit:`


> **Example 2:** `Enter the first number, or (Q/q) to exit: 5`
>
> `Choose an operation (+, -, *, /), or (Q/q) to exit: / `
>
> `Enter the second number, or (Q/q) to exit: 3333333333`
>
> **Output:** `< Second number is large to fit, please enter smaller one >`
>
>> `Enter the second number, or (Q/q) to exit: `
 
  2. **Addition overflow** 

> **Example:** `Enter the first number, or (Q/q) to exit: 1500000000`
>
> `Choose an operation (+, -, *, /), or (Q/q) to exit: + `
> 
> `Enter the second number, or (Q/q) to exit: 1500000000`
>
> **Output:** `< Incorrect result due to overflow, try again >`
>
> `Enter the first number, or (Q/q) to exit: `


  3. **Subtraction overflow** 
   
> **Example:** `Enter the first number, or (Q/q) to exit: -1500000000`
>
> `Choose an operation (+, -, *, /), or (Q/q) to exit: - `
> 
> `Enter the second number, or (Q/q) to exit: 1500000000`
>
> **Output:** `< Incorrect result due to overflow, try again >`
>
> `Enter the first number, or (Q/q) to exit: `

  4. **Multiplication overflow** 
   
> **Example:** `Enter the first number, or (Q/q) to exit: 1000000000`
>
> `Choose an operation (+, -, *, /), or (Q/q) to exit: * `
> 
> `Enter the second number, or (Q/q) to exit: 2000000000`
>
> **Output:** `< Incorrect result due to overflow, try again >`
>
> `Enter the first number, or (Q/q) to exit: `

  5. **Division overflow**
  
  There is no overflow will occur in division because the user is restricted to enter a 32-bit numerator and we fill the EDX register with zeros to avoid calculation problems



### Limitations

  1. Dosen't support floating point numbers
  2. Can't print out the result of multiplication of a 32-bit numbers (Errors arises when trying to use a library procedure and we couldn't solve them)
  
<br/>

##  B. Expression-solver simple calculator

### Introduction

The expression-solver calculator is an assembly program that solves arithmatic expressions.

### Features and Functionalities

 It supports evaluation of expressions that includes the basic four arithmatic operations using symbols ('+' '-' '*' '/' ).

- **Algorithm description:**
  
If we have an algebraic expression like (2*30/5-3+24/2) to be solved , we start by creating two arrays, The first one is a double worded array to hold numbers [2, 30, 5, 3, 24, 2], the second one will be byte array to hold the operators like that ['*', '/', '-', '+', '/'], then we iterate over the operators array, if we find a multiplication or division operator then, we will do the operation on the current number and the next one then we store the result in the next number in the array of numbers, in the above example we multiply 2 by 30 and store 60 in the second number and the array will be [2, 60, 5,  3, 24, 2], then we continue doing the division so we do the division 60/5 and store the result in the third number in the array of numbers and the array will be [2, 60, 12, 3, 24, 2], then we will find that the next operation to be done is subtraction but we need to finish all the accumulated division and multiplication operations first, then after we finish them it is obvious that the first number in addition and subtraction operations will be this number i.e. 12 so we store it in a variable called number1 and store that the operation to be done i.e. subtraction in another variable called current_operator then continue, after that we will find that the next operation is addition so it is obvious that the second number in addition and subtraction operations will be this number i.e. 3 then we do not have to wait for all multiplication and division operations to be done so we check what is the operation to be done by checking the current_operator variable then we will do that operation i.e. subtraction 12-3 and store its result i.e. 9 in number1 to be the first number of the next addition or subtraction operation then we store the addition in current_operator to be the next operation to be done in addition and subtraction operations then continue, we will find that the next operation is division so we divide the corresponding number by the next one i.e. 24/2 then we store the result in the second number so the numbers array will be [2, 60, 12, 3, 24, 12], then at the last operation we get the next number in our addition and subtraction operations so we check the current_operator then we will find that the operation to be done is addition then we add number1 with last number i.e. 9+12 and store the result i.e. 21 in number1, now we have just finished our loop then the result will be the accumulated results stored in number1 i.e. 21 , 2*30/5-3+24/2 = 21.
<br/>
> **Example:** `Enter expression (eg. 2+3*4) and (Q/q) to exit:  5+2*10-6+9/3*100+99-21-2+4*5 `
>
> **Output:** `Evaluation result of the expression (5+2*10-6+9/3*100+99-21-2+4*5) is +415 `

### Exception Handling

- **Invalid expression**

> **Example 1:** `Enter expression (eg. 2+3*4) and (Q/q) to exit: ghjvjs + 35ffv`
> 
> **Output:** `< Invalid expression, try again ... >`
>
>`Enter expression (eg. 2+3*4) and (Q/q) to exit: `

> **Example 2:** `Enter expression (eg. 2+3*4) and (Q/q) to exit: 2**2`
> 
> **Output:** `< Invalid expression, try again ... >`
>
>`Enter expression (eg. 2+3*4) and (Q/q) to exit: `

- **Division by zero**

> **Example:** `Enter expression (eg. 2+3*4) and (Q/q) to exit: 5*2+9/0-20`
>  
> **Output:** `< Division by zero is not valid >`

- **Overflow cases**

1. **Input overflow** 


> **Example:** `Enter expression (eg. 2+3*4) and (Q/q) to exit: 3000000000 + 8`
>  
> **Output:** `< Invalid number in the expression, try again ... >`
>
>`Enter expression (eg. 2+3*4) and (Q/q) to exit: `

 
  2. **Result overflow** 

> **Example:** `Enter expression (eg. 2+3*4) and (Q/q) to exit: 2000000000 + 2000000000`
>  
> **Output:** `< Incorrect result due to overflow, try again >`


### Limitations
  1. Dosen't support brackets ['(' ')']
  2. Dosen't support floating point numbers
  
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


## **Team Members**

- [Muhammad Salah](https://github.com/MohamedSalahApdElzaher)
- [Muhammad Mohie](https://github.com/muhammadmohie)
- [Muhammad Adel Sharkawy](https://github.com/mohamed-el-sharkawy)
- [Youseef Magdy](https://github.com/youssefmagdy1)
- [Mohamed Abd-El-Nasser](https://github.com/Mohamed-Abd-El-Nasser)

