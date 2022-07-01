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

t.__init__: # DO NOT JUMP TO OR CALL
    create echo
    create debug

terminal:
    gets inbuffer # read input
    call parse_command # parse input
    
    t.__check__:
        check echo
        check debug
    
    # defualt
    put_line
    put_string _not_found_
    ret
