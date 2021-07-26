.section .data
sample_str:
.ascii "Hello\0"

.section .text 
.globl _start 

.equ SYS_EXIT, 60

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
_start:
    pushq $sample_str
    call strlen
    movq %rax, %rdi

    movq $SYS_EXIT, %rax
    syscall 
