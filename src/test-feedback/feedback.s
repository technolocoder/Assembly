.section .text
.globl _start 

_start:
    # Input System Call
    movq $0, %rax
    movq $0, %rdi
    movq $buffer, %rsi
    movq $256, %rdx 
    syscall

    # Print the Input (Feedback)
    movq $1, %rax
    movq $1, %rdi
    movq $buffer, %rsi
    movq $256, %rdx
    syscall

    # Exit System Call
    movq $60, %rax
    movq $0 , %rdi
    syscall

.section .bss
    .lcomm buffer, 256
