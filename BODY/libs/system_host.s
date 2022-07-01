/*
To be included in the host/kernel file of the os
Allows seperate linked files to use stdin/stdout and any other system function
*/

.section .data

system_calls:
    .int # put_char
    .int # put_string
    .int # put_int
    .int # put_line
    .int # getc
    .int # gets
    .int # geti
    .int # k2char

.global system_calls

.section .text

.macro lse proc, offset # load system entry
    lea %ebx, \proc
    mov [%eax + \offset], %ebx
.endm

init_syscalls:
    push %eax
    push %ebx
    lea %eax, system_calls

    lse put_char_proc, 0
    lse put_string_proc, 4
    lse put_int_proc, 8
    lse newline_proc, 12

    lse getc_proc, 16
    lse gets_proc, 20
    lse geti_proc, 24

    lse k2char_proc, 28

    pop %ebx
    pop %eax
    ret
