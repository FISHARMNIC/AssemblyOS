.intel_syntax

.macro create lbl
    terminal.\()\lbl\():
        call \lbl\().main
    ret
.endm

.macro check lbl
    strcmp _\lbl\()_, inbuffer
    cmp %al, 0
    je terminal.\lbl
.endm

.local create
.local check

.section .text

t.__init__: # DO NOT JUMP TO OR CALL
    create echo
    create debug
    create snake

terminal:
    gets inbuffer # read input
    call parse_command # parse input
    
    t.__check__:
        check echo
        check debug
        check snake
        //check disk
    # defualt
    put_line
    put_string _not_found_
    ret
    