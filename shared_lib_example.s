# Program to demonstrate the use of shared libraries in assembly

.section .data
question1:
    .asciz "Enter name: "
question2:
    .asciz "Enter age: "
question3:
    .asciz "Enter address: "

report:
    .asciz "Your name is %sYour age is %sYour address is %s\n"

.section .bss
    .equ BUFFER_SIZE, 50
    .lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.align 4
.globl _start
    .equ NAME, -50
    .equ AGE, -60
    .equ ADDRESS, -160
_start:
    andl $-16, %esp
    mov %esp, %ebp
    sub $160, %esp

    
    subl $12, %esp #alignment requirement
    pushl $question1
    call printf
    addl $16, %esp

    subl $4, %esp
    pushl stdin
    pushl $50
    leal NAME(%ebp), %eax
    pushl %eax
    call fgets
    addl $16, %esp

    subl $12, %esp
    pushl $question2
    call printf
    addl $16, %esp

    subl $4, %esp
    pushl stdin
    pushl $10
    leal AGE(%ebp), %eax
    pushl %eax
    call fgets
    addl $16, %esp

    subl $12, %esp
    pushl $question3
    call printf
    addl $16, %esp

    subl $4, %esp
    pushl stdin
    pushl $10
    leal ADDRESS(%ebp), %eax
    pushl %eax
    call fgets
    addl $16, %esp

    leal ADDRESS(%ebp), %eax
    pushl %eax
    leal AGE(%ebp), %eax
    pushl %eax
    leal NAME(%ebp), %eax
    pushl %eax
    pushl $report
    call printf

    xorl %ebx, %ebx
    mov $1, %eax
    int $0x80
