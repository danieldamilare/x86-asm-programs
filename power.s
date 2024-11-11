#Program to calculate the power of two numbers 
# Value to compute is 2^3 + 5 ^ 2

.section .data

.section .text
.globl _start

_start:
# Call power (2, 3)
pushl $3
pushl $2
call power
addl $8, %esp
pushl %eax

# Call power (5, 3)
pushl $3
push $5
call power
addl $8, %esp

popl %ebx

addl %eax, %ebx

movl $1, %eax
int $0x80


#function power: compute the value of a 
#         number raised to power
#
#input: Takes two parameters
#        first argument: the base number
#        second argument: the power to raise
#           the first number to 


power:
    pushl %ebp
    movl  %esp, %ebp
    movl 12(%ebp), %ecx #mov the power
    movl 8(%ebp), %ebx

    cmpl $0, %ecx
    jne power_loop
    movl $1, %ebx

    jmp end_power
power_loop:
    jmp loop_check

start_loop:
    subl $1, %ecx
    imull 8(%ebp), %ebx

loop_check:
    cmpl $1, %ecx
    jne start_loop

end_power:
    movl %ebx, %eax

    movl %ebp, %esp
    popl %ebp
    ret
