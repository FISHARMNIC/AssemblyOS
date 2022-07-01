.intel_syntax

.global echo.main

.include "libs/syscall.s"
__TEXT__

echo.main:
    pusha
    put_line
    put_string pbuffer_1
    popa
    ret
    