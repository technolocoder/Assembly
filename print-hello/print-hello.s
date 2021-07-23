# The classic Hello World ;p

.section .data

msg_data:
    .ascii "Hello, World!\n"
    len = . - msg_data 

.section .text
.globl _start

_start:
    movq $1, %rax
    movq $1, %rdi
    movq $msg_data, %rsi
    movq $len, %rdx 
    syscall

    movq $60, %rax
    movq $0, %rdi 
    syscall
    