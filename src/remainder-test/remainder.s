.section .text 
.globl _start

.equ SYS_EXIT, 60

_start:
    movq $17, %rax
    movq $10, %rbx
    idivq %rbx
    movq %rdx, %rdi
    movq $SYS_EXIT, %rax
    syscall
