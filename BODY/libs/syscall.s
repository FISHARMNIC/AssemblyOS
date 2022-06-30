.macro syscall id
    push %edi
    push %esi 

    mov %edi, \id
    shl %edi, 2 # x4 for alignment

    lea %esi, system_calls
    add %edi, %esi # absolute address

    call [%edi]

    pop %esi
    pop %edi
.endm
