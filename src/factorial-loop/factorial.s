.section .text
 .globl _start

 _start:
    movq $4, %rdi
    movq $1, %rcx
    factorial_start:
    imulq %rdi, %rcx
    decq %rdi
    cmpq $1, %rdi 
    je factorial_end
    jmp factorial_start
    factorial_end:
    movq $60, %rax
    movq %rcx,  %rdi
    syscall
    