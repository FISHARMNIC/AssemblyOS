.ifndef VGA_ADDR
VGA_ADDR = 0xb8000
.endif

.section .bss
.comm _vgabuffer2, 4000
.section .data
_ttypos2: .int 0
.section .text

.macro GFX_ENTER
    call gl_bfstr
    push %eax
    mov %eax, _ttypos
    mov _ttypos2, %eax
    mov %eax, VGA_ADDR
    mov _ttypos, %eax
    pop %eax
    call gl_clr
.endm

.macro GFX_EXIT
    call gl_bfrst
    push %eax
    mov %eax, _ttypos2
    mov _ttypos, %eax
    pop %eax
.endm

gl_clr:
    mov %ecx, 2000
    mov %al, 0
    mov %edi, 0xb8000
    rep stosb
    ret

gl_bfstr:
    mov %ecx, 4000
    mov %esi, VGA_ADDR # movsb reads memory here (and increments)
    lea %edi, _vgabuffer2 # movsb writes memory here (and increments)
    rep movsb
    ret

gl_bfrst:
    mov %ecx, 4000
    lea %esi, _vgabuffer2
    mov %edi, VGA_ADDR
    rep movsb
    ret

gl_drawat_proc:
    mov %ebx, 80
    mul %ebx
    add %eax, %ecx
    shl %eax, 1
    or %edx, 3840
    mov [0xb8000 + %eax], %dx
    ret

.macro gl_drawat char, x, y
    mov %eax, \y
    mov %ecx, \x
    xor %edx, %edx
    mov %dl, \char
    call gl_drawat_proc
.endm