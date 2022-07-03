.org 0x512 # kernel positioning
.global main

.include "libs/include.s"
.include "libs/stdout.s"
.include "libs/stdin.s"
.include "libs/system_host.s"
.include "libs/strings.s"
.include "../terminal/internal/parse.s"
.include "../terminal/internal/terminal.s"
.include "../terminal/internal/terminal_data.s"

.section .data
.section .text

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

