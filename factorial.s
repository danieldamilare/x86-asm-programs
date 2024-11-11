# Program to find factorial of numbers
# factorial of n is calculated as n *
# n -1 * n -2 * ... * 1

.section .data

.section .text
.globl _start
_start:
    pushl $4
    call factorial
    addl $4, %esp
    movl %eax, %ebx
    movl $1, %eax
    int $0x80

.type factorial, @function
factorial:
   pushl %ebp 
   movl %esp, %ebp
   subl $4, %esp

   movl 8(%ebp), %ebx
   cmpl $1, %ebx
   jle end_factorial

   decl %ebx
   pushl %ebx
   call factorial

   movl 8(%ebp), %ebx
   imull %eax, %ebx

end_factorial:
    movl %ebx, %eax
    movl %ebp, %esp
    popl %ebp
    ret

