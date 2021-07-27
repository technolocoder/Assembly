.equ BUFFER_SIZE, 250
.section .bss
    .lcomm buffer, BUFFER_SIZE

.section .text 
.globl _start

.equ SYS_EXIT, 60

.equ SYS_READ, 0
.equ SYS_WRITE, 1

.equ SYS_OPEN, 2
.equ SYS_CLOSE, 3

.equ STDOUT, 1
.equ STDIN , 0
_start:
    movq %rsp, %rbp
    movq (%rbp), %r12 

    cmpq $3, %r12 
    jne arg_error_print

.equ FILE_INPUT ,16
.equ FILE_OUTPUT,24
.equ FILE_IN_FLAGS, 0
.equ FILE_OUT_FLAGS, 1102
.equ FILE_OUT_PERM, 777

.equ LOWER_CASE_MIN, 'a'
.equ LOWER_CASE_MAX, 'z'

.equ UPPER_CASE_DIFF, 'a'-'A'

    movq $SYS_OPEN, %rax
    movq FILE_INPUT(%rbp), %rdi
    movq $FILE_IN_FLAGS, %rsi
    syscall

    cmpb $254, %al 
    je file_error_print

    movq %rax, %r13

    movq $SYS_OPEN, %rax
    movq FILE_OUTPUT(%rbp), %rdi
    movq $FILE_OUT_FLAGS, %rsi
    movq $FILE_OUT_PERM, %rdx
    syscall

    movq %rax, %r14

main_loop_start:
    movq $SYS_READ, %rax
    movq %r13, %rdi
    movq $buffer, %rsi
    movq $BUFFER_SIZE, %rdx
    syscall

    movq %rax, %rcx

    cmpq $0, %rax 
    je close_files

    movq $buffer, %rbx
    decq %rbx
conv_loop_start:
    cmpq $0, %rax 
    je conv_loop_end
    decq %rax
    incq %rbx

    cmpb $LOWER_CASE_MIN, (%rbx)
    jl conv_loop_start
    
    cmpb $LOWER_CASE_MAX, (%rbx)
    jg conv_loop_start 

    subq $UPPER_CASE_DIFF,(%rbx)
    jmp conv_loop_start
conv_loop_end:
    movq $SYS_WRITE, %rax
    movq %r14, %rdi
    movq $buffer, %rsi
    movq %rcx, %rdx
    syscall
    jmp main_loop_start 

close_files:
    movq $SYS_CLOSE, %rax
    movq %r13, %rdi
    syscall

    movq $SYS_CLOSE, %rax
    movq %r14, %rdi
    syscall

    jmp exit

arg_error_print:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi 
    movq $arg_error_msg, %rsi
    movq $arg_error_msg_len, %rdx
    syscall

    jmp exit
file_error_print:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $file_error_msg, %rsi
    movq $file_error_msg_len, %rdx
    syscall

    jmp exit 
exit:
    movq $SYS_EXIT, %rax 
    movq $1, %rdi
    syscall 

.section .data
arg_error_msg:
    .ascii "Invalid number of Arguments!\n"
    arg_error_msg_len = . - arg_error_msg

file_error_msg:
    .ascii "Invalid Input File!\n"
    file_error_msg_len = . - file_error_msg 
