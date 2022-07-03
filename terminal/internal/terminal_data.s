.section .rodata
error_table:
    _not_found_: .asciz "command unknown"

command_table:
    _echo_: .asciz "echo"
    _debug_: .asciz "debug"
    _snake_: .asciz "snake"
    _disk_: .asciz "disk"
    
greeting_1: .asciz "========= Welcome! ========="
ex_0: .asciz "cmmnd: "
ex_1: .asciz "param: "
tab_ent: .asciz "-> "

.section .bss
.comm inbuffer, 40
.comm pbuffer_1, 15
.comm pbuffer_2, 15

.global inbuffer
.global pbuffer_1
.global pbuffer_2
