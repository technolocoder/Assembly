.section .text
.globl _start 

fibonacci_func:
    pushq %rbp
    movq %rsp, %rbp
 
    cmpq $1, 16(%rbp) 
    jne fibonacci_callback
    movq $1, %rax
fibonacci_ret:
    movq %rbp, %rsp
    popq %rbp
    ret

fibonacci_callback:
    decq 16(%rbp)
    pushq 16(%rbp)
    incq 16(%rbp)
    call fibonacci_func
    imulq 16(%rbp), %rax
    jmp fibonacci_ret  
_start:
    pushq $5
    call fibonacci_func
    addq $8, %rsp

    movq %rax, %rdi 
    movq $60, %rax
    syscall
