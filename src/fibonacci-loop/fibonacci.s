.section .text
.globl _start

_start:
    movq $10, %rdi
    
    cmp $0, %rdi
    je base_case0 
    
    cmp $1, %rdi 
    je base_case1

    movq $0, %rax 
    movq $1, %rbx 
    subq $2, %rdi
loop_start:
    movq $0, %rcx 
    addq %rax, %rcx
    addq %rbx, %rcx

    cmp $0, %rdi
    je exit 
    
    movq %rbx, %rax
    movq %rcx, %rbx 
    decq %rdi
    jmp loop_start

base_case0:
    movq $0, %rcx
    jmp exit
base_case1: 
    movq $1, %rcx
    jmp exit
exit:
    # Exit Call 
    movq $60, %rax 
    movq %rcx , %rdi
    syscall 
