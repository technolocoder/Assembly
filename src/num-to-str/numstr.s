.section .text
.globl _start

.equ SYS_EXIT, 60
.equ SYS_WRITE, 1

.equ STDOUT, 1

_start:
    movq $1324125109283712345, %rax
    movq $10, %rbx
    movq $str_buf, %rcx 
loop_start:

    idivq %rbx
    addq $'0', %rdx
    movb %dl, (%rcx)
    xorb %dl, %dl
    incq %rcx
    cmpq $0, %rax
    je loop_exit
    jmp loop_start

loop_exit:
    subq $str_buf, %rcx

    movq %rcx, %rax
    movq %rcx, %r12
    movq $str_buf, %rcx

    xorq %rdx, %rdx
    movq $2, %rbx
    idivq %rbx 
    movq $str_buf, %rdx
    addq %r12, %rdx
    decq %rdx

rev_start:
    cmpq $0, %rax
    je rev_exit 
    movb (%rcx), %r13b
    movb (%rdx), %r14b

    movb %r13b, (%rdx)
    movb %r14b, (%rcx)

    decq %rax
    incq %rcx
    decq %rdx

    jmp rev_start 
rev_exit:  
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $str_buf, %rsi
    movq %r12, %rdx
    syscall
main_exit:
    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall
.section .bss
    .comm str_buf, 50
