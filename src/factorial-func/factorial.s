.section .text
.globl _start 

.type factorial_func,@function
factorial_func:
    pushq %rbp
    movq %rsp, %rbp
    
    # Check if base case
    cmpq $1, 16(%rbp) 
    # If no then callback fibonacci n-1
    jne factorial_callback
    # Basecase return "1"
    movq $1, %rax
factorial_ret:
    movq %rbp, %rsp
    popq %rbp
    ret

factorial_callback:
    # Decrement param
    decq 16(%rbp)
    pushq 16(%rbp)
    # Increment for multiplication
    incq 16(%rbp)
    call factorial_func
    imulq 16(%rbp), %rax
    jmp factorial_ret  
_start:
    # Factorial of 5! = 120
    pushq $5
    call factorial_func
    addq $8, %rsp

    # Exit Call
    movq %rax, %rdi 
    movq $60, %rax
    syscall
