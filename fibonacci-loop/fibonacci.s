.section .text
.globl _start

_start:
    # Exit Call 
    movq $60, %rax 
    movq $0 , %rdi
    syscall 
