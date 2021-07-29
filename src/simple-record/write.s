.include "linux-def.s"
.include "record-layout.s"

.equ INPUT_BUFFER_SIZE, 256
.equ AGE_BUFFER_SIZE, 4

.section .text 
.globl _start

conv_num:
    pushq %rbp
    movq %rsp, %rbp

    xorq %rax, %rax
    xorq %rcx, %rcx

    movq 16(%rbp), %rbx
    decq %rbx
conv_loop_start:
    incq %rbx
    movb (%rbx), %cl
    cmpb $'\n', %cl
    je conv_num_exit
    imulq $10, %rax
    subb $'0', %cl
    addq %rcx, %rax
    jmp conv_loop_start
conv_num_exit:
    movq %rbp, %rsp
    popq %rbp
    ret

.equ FILE_FLAGS, 1101
.equ FILE_PERM, 777
_start:
    movq %rsp, %rbp
    cmpq $2, (%rbp)
    jne invalid_arg_exit

    movq $SYS_OPEN, %rax
    movq 16(%rbp), %rdi
    movq $FILE_FLAGS, %rsi
    movq $FILE_PERM, %rdx
    syscall

    movq %rax, %r15

    movq $input_buffer, %r12
    movq $record_buffer, %r13
main_loop_begin:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $main_interface, %rsi
    movq $interface_len, %rdx
    syscall

    movq $SYS_READ, %rax
    movq $STDIN, %rdi
    movq %r12, %rsi
    movq $INPUT_BUFFER_SIZE, %rdx
    syscall

    movb (%r12), %dl
    subb $'0', %dl

    cmpb $2, %dl
    je main_exit

    cmpb $1, %dl
    jne warn_msg

    movq %r13, %r14
    movq $RECORD_SIZE, %rcx
clear_loop_begin:
    cmpq $0, %rcx
    je clear_loop_exit 
    decq %rcx    
    movq $0, (%r14)
    incq %r14
    jmp clear_loop_begin
clear_loop_exit:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $first_name_msg, %rsi
    movq $first_name_msg_len, %rdx
    syscall
    
    movq %r13, %r14
    
    movq $SYS_READ, %rax
    movq $STDIN, %rdi
    movq %r14, %rsi
    movq $NAME_SIZE, %rdx
    syscall

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $last_name_msg, %rsi
    movq $last_name_msg_len, %rdx
    syscall

    addq $NAME_SIZE, %r14

    movq $SYS_READ, %rax
    movq $STDIN, %rdi
    movq %r14, %rsi
    movq $NAME_SIZE, %rdx
    syscall

    addq $NAME_SIZE, %r14

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $age_msg, %rsi
    movq $age_msg_len, %rdx
    syscall

    movq $SYS_READ, %rax
    movq $STDIN, %rdi
    movq $age_buffer, %rsi
    movq $AGE_BUFFER_SIZE, %rdx
    syscall

    pushq $age_buffer
    call conv_num 

    movl %eax, (%r14)

    movq $SYS_WRITE, %rax
    movq %r15, %rdi
    movq %r13, %rsi
    movq $RECORD_SIZE, %rdx
    syscall

    jmp main_loop_begin
warn_msg:
    movq $SYS_WRITE, %rax 
    movq $STDOUT, %rdi
    movq $invalid_input_msg, %rsi
    movq $invalid_msg_len, %rdx
    syscall
    jmp main_loop_begin
main_exit:
    movq $SYS_CLOSE, %rax
    movq %r15, %rdi
    syscall

    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall
    
invalid_arg_exit:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $invalid_arg_msg, %rsi
    movq $invalid_arg_msg_len, %rdx
    syscall
    
    movq $SYS_EXIT, %rax
    movq $1, %rdi
    syscall

.section .data
main_interface:
    .ascii "Options:\n[1] Write Record\n[2] Exit\nInput: "
    interface_len = . - main_interface

first_name_msg:
    .ascii "Enter your first name: "
    first_name_msg_len = . - first_name_msg

last_name_msg:
    .ascii "Enter your last name: "
    last_name_msg_len = . - last_name_msg

age_msg:
    .ascii "Enter your age: "
    age_msg_len = . - age_msg

invalid_input_msg:
    .ascii "Invalid Input!\n"
    invalid_msg_len = . - invalid_input_msg

invalid_arg_msg:
    .ascii "Invalid Argument Count!\n"
    invalid_arg_msg_len = . - invalid_arg_msg

.section .bss 
    .comm input_buffer, INPUT_BUFFER_SIZE
    .comm record_buffer, RECORD_SIZE
    .comm age_buffer, AGE_BUFFER_SIZE
