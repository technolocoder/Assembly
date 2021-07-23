.section .text
.globl _start

_start:
    pushq $3 # 2nd param (expo)
    pushq $2 # 1st param (base)
    call power
    addq $8, %rsp
    # 2^3 = 8
    movq %rax, %rcx 

    pushq $3 # 2nd param (expo)
    pushq $4 # 1st param (base)
    call power 
    # 4^3 = 64
    addq $8, %rsp
    addq %rax, %rcx
    # 64+8 = 72

    # Exit Call
    movq $60 , %rax
    movq %rcx, %rdi

    syscall

.type power,@function
power: 
    pushq %rbp
    movq %rsp, %rbp

    movq 24(%rbp), %rdi
    movq 16(%rbp), %rax
    movq %rax, %rbx 

power_loop:
    cmpq $1, %rdi
    je power_exit
    decq %rdi
    imulq %rbx, %rax
    jmp power_loop 

power_exit:
    movq %rbp, %rsp
    popq %rbp
    ret
