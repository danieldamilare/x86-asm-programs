# A function to find the maximum of the list of a number

.section .data
list1:
    .long 3, 64, 34, 232, 34, 89, 100, 20, 29
    
list2:
    .long 3, 54, 32, 132, 80, 59, 200, 220, 129

len:
    .long 9

.section .text

.globl _start
_start:
#find the maximum in list 1 and 2
    pushl $list1 #push a pointer to the list
    pushl len # push the list variable
    call maximum
    addl $8, %esp
    pushl %eax
    pushl $list2 #push a pointer to the list
    pushl len # push the list variable
    call maximum
    addl $8, %esp
    popl %ebx #retrieve previous value
    cmpl %ebx, %eax
    jl end_prog
    movl %eax, %ebx
end_prog:
    movl $1, %eax
    int $0x80

# function maximum: find the maximum of an array
# INPUT:  first argument: length of the array
#         second argument: pointer to the start of the array      
#

maximum:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    mov 8(%ebp), %edx   #length ot the array
    movl $0, %ecx         #offset to the array 
    movl  12(%ebp), %ebx  #current maximum seen so far
    movl (%ebx), %eax

loop_start:
    incl %ecx
    cmpl %ecx, %edx
    jle end_loop

    cmpl (%ebx, %ecx, 4), %eax
    jg loop_start

    movl (%ebx, %ecx, 4),  %eax
    jmp loop_start

end_loop: #eax already hold the maximum value
    movl %ebp, %esp 
    popl %ebp
    ret

