.section .text
.globl _start 

_start:
    movl $1, %eax # Exit System Call
    movl $0, %ebx # Return Code
    int $0x80 # Interrupt
