.section .text 
.globl _start 

.type fibonacci,@function
fibonacci:
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp

    movq 16(%rbp), %rdx 
    
    cmpq $0, %rdx
    je fibonacci_base_case0

    cmpq $1, %rdx
    je fibonacci_base_case1
 
    decq 16(%rbp)
    pushq 16(%rbp)
    call fibonacci
    movq %rax, -8(%rbp)

    decq 16(%rbp)
    addq $8, %rsp 
    pushq 16(%rbp)

    call fibonacci
    addq -8(%rbp), %rax 
    jmp fibonacci_exit 
fibonacci_base_case0:
    movq $0, %rax
    jmp fibonacci_exit 
fibonacci_base_case1:
    movq $1, %rax
    jmp fibonacci_exit 
fibonacci_exit:
    movq %rbp, %rsp
    popq %rbp
    ret

_start:
    pushq $10
    call fibonacci
    movq %rax, %rdi 

    movq $60, %rax
    syscall 
