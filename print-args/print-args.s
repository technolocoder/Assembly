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
    movq (%rbp), %r12
    movq %rbp, %r13
    addq $8, %r13
main_loop_start:
    cmpq $0, %r12
    je main_loop_exit
    decq %r12 

    movq (%r13), %r14
    pushq %r14
    call strlen 
    addq $8, %rsp
    addq $8, %r13

    movq %rax, %rdx
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq %r14, %rsi
    syscall

    movq $1, %rdx
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $newline, %rsi
    syscall

    jmp main_loop_start 
main_loop_exit:
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall
.section .data
newline:
    .ascii "\n"
