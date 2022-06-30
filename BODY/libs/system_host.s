.section .data

system_calls:
    .int # put_char
    .int # put_string
    .int # put_int
    .int # put_line

.global system_calls

.section .text

init_syscalls:
    push %eax
    push %ebx
    lea %eax, system_calls

    lea %ebx, put_char_proc
    mov [%eax], %ebx

    lea %ebx, put_string_proc
    mov [%eax + 4], %ebx

    lea %ebx, put_int_proc
    mov [%eax + 8], %ebx

    lea %ebx, newline_proc
    mov [%eax + 12], %ebx

    pop %ebx
    pop %eax
    ret
