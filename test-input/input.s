.section .text
.globl _start 

_start:
    # Read System Call
    movq $0, %rax
    movq $0, %rdi # Read from stdin
    movq $input_buffer, %rsi # Store the data in input_buffer
    movq $256, %rdx # Size of buffer
    syscall

    # Exit System Call
    movq $60, %rax
    movq $0 , %rdi
    syscall

.section .bss 
    .lcomm input_buffer, 256