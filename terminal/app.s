.org 0x100
.global main

.section .data
.include "libs/stdout.s"
.include "libs/stdin.s"

.include "libs/system_host.s"
.include "libs/syscall.s"
.include "libs/strings.s"
.include "../terminal/internal/parse.s"
.include "../terminal/internal/terminal.s"


greeting_1: .asciz "========= Welcome! ========="
ex_0: .asciz "cmmnd: "
ex_1: .asciz "param: "

inbuffer: .fill 80
.global inbuffer

.section .text

.extern echo.main

init:
    dis_cursor
    call init_syscalls
    put_string greeting_1; put_line
    ret

main:
    call init
    main.kernel:
    call terminal

    ret

