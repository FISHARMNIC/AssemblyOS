.intel_syntax
.global disk.main
.include "libs/sys/system.s"
.section .text
disk.read:
    // expects sector in eax
    mov %ebx, %eax
    shr %ebx, 24
    or %ebx, 0xE0
    out 0x1F6, %bl
    outb 0x1F2, 1 # read one sector
    out 0x1F3, %al; shr %eax, 8
    out 0x1F4, %al; shr %eax, 8
    out 0x1F5, %al
    outb 0x1F7, 0x20
    
    ret


disk.main:
    pusha
    mov %eax, 1
    call disk.read

    xor %ebx, %ebx
    inb %bl, 0x01F0
    put_int %ebx 
    popa
    ret
    