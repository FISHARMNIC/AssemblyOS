.intel_syntax

.global echo.main

// .extern inbuffer
// .extern pbuffer_1
// .extern pbuffer_2

.section .data

.include "libs/syscall.s"

.section .text

/* System calls
0 put_char - eax
1 put_string - edx
2 put_int - eax
3 put_line
*/
echo.main:
    pusha
    syscall 3
    lea %edx, pbuffer_1
    syscall 1
    popa
    ret
    