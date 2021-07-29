.section .text 
.globl _start 

.equ SYS_EXIT, 60
_start:
    movl $17, %eax
    movq $10, %rbx
    xorq %rdx, %rdx
    idivq %rbx

    movq %rax, %rdi
    movq $SYS_EXIT, %rax
    syscall