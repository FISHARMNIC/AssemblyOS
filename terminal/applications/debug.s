.intel_syntax
.global debug.main
.include "libs/sys/system.s"

.section .rodata
_reg: .asciz "REG A-D"
_flag: .asciz "FLAG"
_dsec: .asciz "data segment: "
_tsec: .asciz "text segment: "

.section .text
/* System calls
0 put_char - eax
1 put_string - edx
2 put_int - eax
3 put_line
*/
debug.main:
    pusha
    put_line
    put_string _reg; put_line
    put_int %eax; put_line
    put_int %ebx; put_line
    put_int %ecx; put_line
    put_int %edx; put_line 

    pushf
    popa
    push %esi
    push %edi

    put_line
    put_string _flag; put_line
    put_int %eax; put_line
    put_int %ebx; put_line
    put_int %ecx; put_line
    put_int %edx; put_line
    pop %eax
    put_int %eax
    put_line
    pop %eax
    put_int %eax
    put_line

    mov %eax, .data
    mov %ebx, .text
    put_string _dsec
    put_int %eax
    put_line 
    put_string _tsec
    put_int %ebx 

    popa
    ret
    