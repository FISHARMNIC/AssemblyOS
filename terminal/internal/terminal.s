.section .data
_str.echo_: .asciz "echo "
.section .text
terminal:
    gets inbuffer
    call parse_command
    jmp terminal.echo
    //strcmp inbuffer, _str.echo_
    //cmp %al, 0
    //je terminal.echo
    ret

terminal.echo:
    call echo.main
    ret
