/*
To be included in the host/kernel file of the os
Allows seperate linked files to use stdin/stdout and any other system function
*/

.section .bss

system_calls:
    # IF MEMORY CORRUPTION, CHOSE A DIFFERENT FORM OF ALLOC
    .int 0 # put_char
    .int 0 # put_string
    .int 0 # put_int
    .int 0 # put_line
    .int 0 # getc
    .int 0 # gets
    .int 0 # geti
    .int 0 # k2char
    .int 0 # read_keyboard

.global system_calls

.section .text

.macro lse proc, offset # load system entry
    lea %ebx, \proc
    mov [\offset * 4 + %eax], %ebx
.endm

init_syscalls:
    push %eax
    push %ebx
    lea %eax, system_calls

    lse put_char_proc, 0
    lse put_string_proc, 1
    lse put_int_proc, 2
    lse newline_proc, 3

    lse getc_proc, 4
    lse gets_proc, 5
    lse geti_proc, 6

    lse k2char_proc, 7
    lse read_keyboard_proc, 8
    
    pop %ebx
    pop %eax
    ret
