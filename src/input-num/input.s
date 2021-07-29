.section .text 
.globl _start

.equ SYS_EXIT, 60

.equ SYS_READ, 0
.equ STDIN   , 0

.type conv_num,@function
conv_num:
    pushq %rbp
    movq %rsp, %rbp

    xorq %rax, %rax
    movq 16(%rbp), %rbx
    decq %rbx
conv_loop_start:
    incq %rbx
    movq (%rbx), %rcx
    cmpq $'\n', %rcx
    je conv_num_exit
    imulq $10, %rax
    subq $'0', %rcx
    addq %rcx, %rax
    jmp conv_loop_start
conv_num_exit:
    movq %rbp, %rsp
    popq %rbp
    ret
_start:
    movq $SYS_READ, %rax
    movq $STDIN, %rdi
    movq $buffer, %rsi
    movq $4, %rdx
    syscall
    
    pushq $buffer
    call conv_num

    movq %rax, %rdi
    movq $SYS_EXIT, %rax
    syscall

.section .bss
    .comm buffer,4    
