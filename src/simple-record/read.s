.include "linux-def.s"
.include "record-layout.s"

.section .text
.globl _start

.equ FILE_FLAGS, 0
_start:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $begin_record_msg, %rsi
    movq $begin_record_msg_len, %rdx
    syscall

    movq %rsp, %rbp
    cmpq $2, (%rbp)
    jne arg_error

    movq $SYS_OPEN, %rax
    movq 16(%rbp), %rdi
    movq $FILE_FLAGS, %rsi
    syscall

    cmpb $254, %al
    je file_error
    movq %rax, %r12

read_loop:
    movq $SYS_READ, %rax
    movq %r12, %rdi
    movq $record_buffer, %rsi
    movq $RECORD_SIZE, %rdx
    syscall

    cmpq $0, %rax 
    je main_exit

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $first_name_msg, %rsi
    movq $first_name_msg_len, %rdx
    syscall

    movq $record_buffer, %r13

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq %r13, %rsi
    movq $NAME_SIZE, %rdx
    syscall

    addq $NAME_SIZE, %r13

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $last_name_msg, %rsi
    movq $last_name_msg_len, %rdx
    syscall

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq %r13, %rsi
    movq $NAME_SIZE, %rdx
    syscall

    addq $NAME_SIZE, %r13
    movq $age_buffer, %r14
    
    xorq %rax, %rax
    movl (%r13), %eax
    movq $10, %rbx
conv_str_start:
    xorq %rdx, %rdx
    idivq %rbx
    addb $'0', %dl
    movb %dl, (%r14)
    incq %r14

    cmpq $0, %rax
    je conv_str_exit

    jmp conv_str_start

conv_str_exit:
    subq $age_buffer, %r14
    movq %r14, %rax

    movq $age_buffer, %rsi
    movq $age_buffer, %rdi
    addq %r14, %rdi
    decq %rdi

    movq $2, %rbx
    xorq %rdx, %rdx
    idivq %rbx
rev_begin:
    cmpq $0, %rax
    je rev_end 
    decq %rax

    movb (%rdi), %bl
    movb (%rsi), %cl 

    movb %bl, (%rsi)
    movb %cl, (%rdi)

    jmp rev_begin 
rev_end:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi 
    movq $age_msg, %rsi
    movq $age_msg_len, %rdx
    syscall

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $age_buffer, %rsi
    movq %r14, %rdx
    syscall

    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $record_seperator, %rsi 
    movq $record_seperator_len, %rdx
    syscall

    jmp read_loop
file_error:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $file_error_msg, %rsi
    movq $file_error_msg_len, %rdx
    syscall
    jmp main_exit

arg_error:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $arg_error_msg, %rsi
    movq $arg_error_msg_len, %rdx
    syscall
main_exit:
    movq $SYS_WRITE, %rax
    movq $STDOUT, %rdi
    movq $end_record_msg, %rsi
    movq $end_record_msg_len, %rdx
    syscall

    movq $SYS_EXIT, %rax
    movq $0, %rdi
    syscall

.section .data
arg_error_msg:
    .ascii "Invalid number of Arguments!\n"
    arg_error_msg_len = . - arg_error_msg 

file_error_msg:
    .ascii "Invalid File!\n"
    file_error_msg_len = . - file_error_msg

first_name_msg:
    .ascii "First Name: "
    first_name_msg_len = . - first_name_msg 

last_name_msg:
    .ascii "Last Name: "
    last_name_msg_len = . - last_name_msg

age_msg:
    .ascii "Age: "
    age_msg_len = . - age_msg

begin_record_msg:
    .ascii "\tBEGIN OF RECORD\n-------------------------------\n"
    begin_record_msg_len = . - begin_record_msg

end_record_msg:
    .ascii "\n-------------------------------\n\tEND OF RECORD\n"
    end_record_msg_len = . - end_record_msg

record_seperator:
    .ascii "\n-------------------------------\n"
    record_seperator_len = . - record_seperator

.section .bss
    .comm record_buffer, RECORD_SIZE
    .comm age_buffer, 4