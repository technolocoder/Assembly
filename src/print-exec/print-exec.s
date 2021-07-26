.section .text
.globl _start

.type strlen,@function
strlen:
    pushq %rbp
    movq %rsp, %rbp

    movq 16(%rbp), %rax
loop_start:
    cmpb $0, (%rax)
    je loop_end # Loop until terminating character is found
    incq %rax  
    jmp loop_start 
loop_end:
    subq 16(%rbp), %rax
    movq %rbp, %rsp
    popq %rbp
    ret

.equ SYS_EXIT, 60
.equ SYS_WRITE, 1
.equ STDOUT, 1
_start:
    movq %rsp, %rbp

    movq 8(%rbp), %rsi
    pushq %rsi
    
    call strlen
    addq $8, %rsp

    movq %rax, %rdx
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    syscall

    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall
