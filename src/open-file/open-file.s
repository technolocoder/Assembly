.section .text 
.globl _start

.equ SYS_EXIT       , 60
.equ SYS_OPEN       , 2
.equ SYS_CLOSE      , 3
.equ SYS_WRITE      , 1

.equ RW_PERM        , 777
.equ FILE_FLAGS     , 101

write_file:
    pushq  %rbp
    movq   %rsp       , %rbp

    movq   $SYS_OPEN  , %rax
    movq   16(%rbp)   , %rdi
    movq   $FILE_FLAGS, %rsi 
    movq   $RW_PERM   , %rdx
    syscall

    movq   %rax, %r15

    movq   %r15       , %rdi
    movq   $SYS_WRITE , %rax
    movq   $sample_str, %rsi
    movq   $sample_len, %rdx
    syscall

    movq   $SYS_CLOSE, %rax
    movq   %r15, %rdi 
    syscall

    movq   %rbp       , %rsp
    popq   %rbp
    ret 
_start:                 
    movq     %rsp     , %rbp
    movq    (%rbp)    , %r12
    movq %rbp, %r13
    addq $16 , %r13

main_loop_start:
    cmpq  $1, %r12
    je main_loop_exit

    movq (%r13), %r14 
    pushq %r14

    call write_file

    addq $8, %rsp 
    addq $8, %r13
    decq %r12
    jmp main_loop_start 

main_loop_exit:
    movq  $SYS_EXIT  , %rax
    movq  $0         , %rdi 
    syscall 

.section .data
sample_str:
    .ascii "Sample Text\n"
    sample_len = . - sample_str