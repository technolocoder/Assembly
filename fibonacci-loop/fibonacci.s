.section .text
 .globl _start

 _start:
    movq $5, %rdi
    movq $1, %rcx
    fibonacci_start:
    imulq %rdi, %rcx
    decq %rdi
    cmpq $1, %rdi 
    je fibonacci_end
    jmp fibonacci_start
    fibonacci_end:
    movq $60, %rax
    movq %rcx,  %rdi
    syscall
    