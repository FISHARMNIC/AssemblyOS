.intel_syntax
.global echo.main

.include "libs/sys/system.s"

.section .text
echo.main:
    pusha
    put_line
    put_string pbuffer_1
    popa
    ret
    