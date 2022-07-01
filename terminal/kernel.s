.org 0x2048
.global main

.section .data
.skip 100 # dont know why but needed

.include "libs/stdout.s"
.include "libs/stdin.s"
.include "libs/system_host.s"
.include "libs/strings.s"
.include "../terminal/internal/parse.s"
.include "../terminal/internal/terminal.s"

greeting_1: .asciz "========= Welcome! ========="
ex_0: .asciz "cmmnd: "
ex_1: .asciz "param: "
tab_ent: .asciz "-> "
.include "../terminal/internal/terminal_data.s"

.comm inbuffer, 80, 1
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
        put_string tab_ent
        call terminal
        put_line
        jmp main.kernel
    ret

