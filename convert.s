.section .data
INVALID_ARG:
    .asciz "Error Invalid Option.\nUsage: [PROGRAM] [INFILE] [OUTFILE]\n"
RW_ERROR:
    .asciz "Error while reading/writing file\n"
MY_NAME:
    .asciz "Joseph Daniel"
WORD1:
    .asciz "Enter Text: "
WORD2:
    .asciz "After converting to uppercase\n"

.section .bss
.equ BUFFER_SIZE, 256
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.globl _start
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2
.equ SYS_READ, 3 
.equ SYS_WRITE, 4

_start:
begin_write:
    pushl $WORD1
    call my_strlen
    popl %ebx
    pushl $STDOUT
    pushl %eax
    pushl %ebx
    call write_text
    addl $12, %esp
begin_read:
    pushl $STDIN
    pushl $BUFFER_SIZE
    pushl $BUFFER_DATA
    call read_text

    addl $12, %esp
    cmpl $0, %eax
    jle end_prog
perform_upper_conversion:
    pushl %eax #save buffer size
    pushl $BUFFER_DATA
    pushl %eax #push size
    call convert_upper
    addl $8, %esp

    popl %eax
    pushl $STDOUT
    pushl %eax
    pushl $BUFFER_DATA
    call write_text
    addl $12, %esp
    jmp begin_write #loop indefinitely until end of file

end_prog:
    xorl %ebx, %ebx
    mov $1, %eax
    int $0x80
    
.type my_strlen, @function
my_strlen:
    pushl %ebp
    movl %esp, %ebp

    # move string to register
    movl 8(%ebp), %ebx
    movl $0, %eax

    jmp check_end
advance:
    incl %eax

check_end:
    cmpb $0,  (%ebx, %eax, 1)
    jg advance
    
end_strlen:
    movl %ebp, %esp
    popl %ebp
    ret


#function to write text to a file descriptor. does not write newline
# data: buffer to write
#size: size of buffer
#DESC file descriptor of the file
.type write_text, @function
write_text:
    .equ DATA, 8
    .equ SIZE, 12
    .equ DESC, 16
    pushl %ebp
    movl %esp, %ebp
    
    movl DATA(%ebp), %ecx
    movl SIZE(%ebp), %edx
    movl DESC(%ebp), %ebx
    movl $SYS_WRITE, %eax
    int $0x80

    movl %ebp, %esp
    popl %ebp
    ret

#function to read text from a file descriptor.
#arg1 data: buffer to read into 
#arg2 size: upper limit of data to read
#arg2 desc descriptor of the file
.type read_text, @function
read_text:
    .equ DATA, 8
    .equ SIZE, 12
    .equ DESC, 14
    pushl %ebp
    movl %esp, %ebp
    
    movl DATA(%ebp), %ecx
    movl SIZE(%ebp), %edx
    movl DESC(%ebp), %ebx
    movl $SYS_READ, %eax
    int $0x80

    movl %ebp, %esp
    popl %ebp
    #return syscall return value in eax
    ret


#convert all character in string between a-z to uppercase ignore the rest
# calling argument convert_upper(string_length, string_address)
.type convert_upper, @function
convert_upper:
    pushl %ebp
    movl %esp, %ebp
    .equ STR_LEN, 8
    .equ STR_ADDR, 12
    movl STR_LEN(%ebp), %ecx
    movl STR_ADDR(%ebp), %ebx
    xorl %eax, %eax

convert_loop:
    cmpl $0, %ecx
    jle end_conv_loop
    jmp check_lower

increment:
    incl %eax
    cmpl %ecx, %eax
    jge end_conv_loop

check_lower:
    movb (%ebx, %eax, 1), %dl
    cmpb $0x61, %dl
    jl increment
    movb (%ebx, %eax, 1), %dl
    cmpb $0x7a, %dl
    jg increment

change_to_upper:
    movb (%ebx, %eax, 1), %dl
    subb $0x20, %dl
    movb %dl, (%ebx, %eax, 1)
    jmp increment

end_conv_loop:
    xorl %eax, %eax
    movl %ebp, %esp
    popl %ebp
    ret
