.section .data

# The Array that will be used
array:
    .int 6,34,5,8,12,23,13,5,9,3,3,35,7,0

.section .text 
.globl _start

_start:
    movl $0, %edi # Set the index to 0
    movl array(,%edi,4), %eax # Load the first variable 
    movl %eax, %ebx # The first variable is the highest
    incl %edi # Increment index to 1

    # Loop
    loop_check:
        movl array(,%edi,4), %eax # Get the current number 
        cmpl $0, %eax # Check if current number is equal to terminating number
        je loop_exit # If it is then terminate
        incl %edi # Increment index
        cmpl %ebx, %eax # Check if current number is greater than seen greatest number
        jle loop_check # If not reiterate the loop
        movl %eax, %ebx # if yes then set the new greatest number to the current number
        jmp loop_check 

    # Exit Call
    loop_exit:
    movl $1, %eax
    int $0x80
