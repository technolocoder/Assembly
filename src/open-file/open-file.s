.section .text 
.globl _start

.equ SYS_EXIT       , 60
.equ SYS_OPEN       , 2
.equ SYS_CLOSE      , 3

.equ RW_PERM        , 666
.equ FILE_FLAGS     , 100

write_file:
    pushq  %rbp
    movq   %rsp       , %rbp

    movq   $SYS_OPEN  , %rax
    movq   16(%rbp)   , %rdi
    movq   $FILE_FLAGS, %rsi 
    movq   $RW_PERM   , %rdx
    syscall

    movq   %rbp       , %rsp
    popq   %rbp
    ret 
_start:                 
    movq    %rsp     , %rbp
    pushq 16(%rbp)

    call write_file

    movq  $SYS_EXIT  , %rax
    movq  $0         , %rdi 
    syscall 

.section .data
sample_text:
    .ascii "Sample Text\n"
    sample_len = . - sample_text