.intel_syntax

.global debug.main


.include "libs/syscall.s"

__DATA__
_reg: .asciz "REG A-D ESI EDI"
_flag: .asciz "FLAG"
__TEXT__

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

    push %edi
    push %esi 

    put_line
    put_string _flag; put_line
    put_int %eax; put_line
    put_int %ebx; put_line
    put_int %ecx; put_line
    put_int %edx; put_line

    pop %eax
    put_int %eax
    pop %eax
    put_int %eax

    popa
    ret
    