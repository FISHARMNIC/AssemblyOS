.intel_syntax


.section .data

_ttypos: .long VGA_ADDR # current tty position
.global _ttypos
.section .text
/* #region VGA handlers */

// Disabling the cursor
disable_cursor_proc:
    push %ax; push %dx
    mov %dx, 0x3D4
    mov %al, 0xA	 # disable cursor
    out %dx, %al
    inc %dx
    mov %al, 0x20 # disable cursor
    out %dx, %al
    pop %dx; pop %ax
    ret

// The correct format for displaying characters
format_VGA_proc:
    /* 
    Clobbers: 
        EAX = character 
        EBX
    
    Return: AX

    VGA format:
       4    4     8
    | BG | FG | CHAR |
    */
    mov %bh, BG_COLOR
    mov %bl, FG_COLOR
    shl %ebx, 8
    or %eax, %ebx # Append the format with the character
    ret 

// Clearing
clear_vga_proc:
    mov %ecx, 4000
    mov %al, 0
    mov %edi, 0xb8000
    rep stosb
    mov %ebx, VGA_ADDR
    mov _ttypos, %ebx
    ret

// Adding a new line
newline_proc:
    // newline = position  + (80 - (position % 80))
    # NEWLINE = position  + (80 - (position % 80))
    pusha

    xor %edx, %edx 

    mov %ecx, _ttypos
    sub %ecx, VGA_ADDR 
    shr %ecx, 1 # ecx holds relative tty

    cmp %ecx, 1920
    jg _newline.refresh

    mov %eax, %ecx
    mov %ebx, 80 # divisor
    div %ebx # remainder (mod) in %edx

    sub %ebx, %edx # 80 - remainder
    add %ebx, %ecx # edx = linePos
    shl %ebx, 1 # reajust for 2-width
    mov _ttypos, %ebx # new line position
    
    mov %ebx, VGA_ADDR
    add _ttypos, %ebx
    popa
    ret
    _newline.refresh:
    call clear_vga_proc
    popa
    ret

clear_line_proc:
    push %eax
    mov %eax, VGA_ADDR
    _clp_ls:
        movw [%eax], 0
        inc %eax
        cmp %eax, 0xB8019
        jl _clp_ls
    
    mov %eax, VGA_ADDR
    mov _ttypos, %eax
    pop %eax
    ret

.macro clear_line
    call clear_line_proc
.endm

.macro put_line
    call newline_proc
.endm

.macro tty_inc
    addw _ttypos, 2
.endm

.macro tty_dec
    subw _ttypos, 2
.endm

.macro dis_cursor
    call disable_cursor_proc
.endm

/* #endregion */

/* #region Character Out */
// Displaying a character on screen

put_char_proc:
    /* 
    Clobbers: 
        EAX = character 
        EBX
    */
    push %ebx
    
    or %eax, 3840 # Equivalent of BG = 0, FG = 15
    mov %ebx, _ttypos
    mov [%ebx], %ax # Move the character into the tty pointer

    addw _ttypos, 2 # Increment to the next character spot
    pop %ebx
    ret

// QOL macros

.macro put_char_al char
    call put_char_proc
.endm

.macro put_char char
    xor %eax, %eax
    mov %al, \char
    put_char_al \char
.endm

.macro put_char_safe char
    push %eax
    put_char \char
    pop %eax
.endm
/* #endregion */

/* #region String Out */
// Displaying a string on screen
put_string_proc:
    # remake using scasb
    /* Clobbers
        EDX = String Address
    */
    cmpb [%edx], 0
    je _ps_proc_fin
    put_char [%edx] # Print at the address of the pointer
    inc %edx
    jmp put_string_proc
    _ps_proc_fin:
    ret

.macro put_string label
    lea %edx, \label
    call put_string_proc
.endm

.macro put_string_safe label
    push %ecx
    push %edx
    put_string \label
    pop %edx
    pop %ecx
.endm
/* #endregion */

/* #region UInteger Out */
// Displaying uints on screen
put_int_proc:
    /*
    Clobbers:
        EAX = number
        ECX
        EDX
    */
    push %ecx; push %edx

    push 10 # know when to stop, ten is the first 2 digit number (will never show up)
    _pip_slice:
    mov %ecx, 10
    xor %edx, %edx
    div %ecx # eax = number / 10, edx = number % 10
    push %edx # push remainder
    cmp %eax, 0 # check if zero
    jne _pip_slice
    
    _pip_print:
    pop %edx
    cmp %edx, 10
    je _pip_ret 
    add %dl, 48 # convert to char
    put_char %dl
    jmp _pip_print
    _pip_ret: 

    pop %edx; pop %ecx
    ret

.macro put_int num
    mov %eax, \num
    call put_int_proc
.endm

.macro put_int_safe num
    push %eax
    put_int \num
    pop %eax
.endm

.macro put_rep amt, char, id
    mov %ecx, \amt
    _pr_\()\id\():
    put_char \char
    dec %ecx
    cmp %ecx, 0
    jne _pr_\()\id\()
.endm
/* #endregion */

