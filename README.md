# **Simple Assembly Calculator**

  ## A. Two operands simple calculator

   ### Introduction

The two operands simple calculator is an assembly program that solves algebraic operations.

### Features and Functionalities

Calculate basic four operations using symbols ( + , - , * , / ).

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
