_INT = 4
_LONG = 4
_CHAR = 1

_stack_d1_: .long 0
_stack_d2_: .long 0

.macro _shift_stack_left_
    mov _stack_d1_, %esp # duplicate the current pos
    mov %esp, _stack_d2_ # duplicate the stack frame
.endm

.macro _shift_stack_right_
    mov _stack_d2_, %esp # duplicate the current pos
    mov %esp, _stack_d1_ # go back to the original frame
.endm