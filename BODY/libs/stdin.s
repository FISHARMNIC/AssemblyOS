.intel_syntax

.section .rodata
char_map: .asciz "`^1234567890-=  qwertyuiop[]\  asdfghjkl;' ) zxcvbnm,./      "
.section .data
keyboard_out: .byte 0
keyboard_redge: .byte 0
.section .text

/* #region Raw Input */
// Read directly from the keyboard
read_keyboard_proc:
    /* 
    Clobbers:
        AL = out char
    
    Return: AL
    */
    xor %eax, %eax
    inb %al, KEYBOARD_PORT # store keycode in al
    mov keyboard_out, %al # save the resulting keycode
    ret

// Convert a keycode the its corresponding character
k2char_proc:
    /*
    Clobbers:
        EAX = keycode
    */
    push %ebx
    lea %ebx, char_map
    add %ebx, %eax
    mov %al, [%ebx]
    pop %ebx
    ret

// Macros
.macro k2char_al 
    call k2char_proc
.endm
.macro k2char key
    xor %eax, %eax
    mov %al, \key
    call k2char_proc
.endm
.macro read_keyboard
    call read_keyboard_proc
.endm
/* #endregion */

/* #region Keyform Detection */
// Check key input types
key_redge_proc:
    movb keyboard_redge, 0
    cmpb keyboard_out, 0 # below -128 - 0 is falling edge
    jg _ke_fedge
    ret
    _ke_fedge:
    movb keyboard_redge, 1
    ret

.macro key_redge
    call key_redge_proc
.endm
/* #endregion */

/* #region Stdin Functions */
    // Await a single keypress
    getc_proc:
        /* 
        Return: AL
        */
        // CONVERT TO CHAR AND MODIFY OTHER GET FUCNTIONS ACCODRINGLY
        read_keyboard
        cmpb keyboard_out, 0 # Read and compare keyboard
        jle getc_proc # falling edge or no key pressed (-128 -> 0)
        _ic_fe:
        # Awaiting keyboard release
        read_keyboard
        cmpb keyboard_out, 0 
        jge _ic_fe # (0-128) means the key is still being held
        sub %al, 128
        subb keyboard_out, 128
        ret

    gets_proc:
        /*
        Clobbers:
            EBX = string address
        */
        push %eax
        _gets_entry:
            call getc_proc
            k2char_al
            put_char_al
            mov [%ebx], %al # move into pointer
            inc %ebx
            cmpb keyboard_out, KEY_BACKSPACE
            je _gets_DEL
            _gets_RET:
            cmpb keyboard_out, KEY_ENTER
            jne _gets_entry
        dec %ebx
        movb [%ebx], 0
        pop %eax
        ret

        _gets_DEL:
            dec %ebx # back to type char
            movb [%ebx], 0 # clear
            dec %ebx # back to char before
            subw _ttypos, 4
            put_char_safe ' '
            tty_dec 
            jmp _gets_RET


    geti_proc:
        /* 
        Clobbers:
            EBX = Stores number
        */
        push %ecx
        xor %ebx, %ebx # stores number
        xor %ecx, %ecx # incase overflow
        call getc_proc
        dec %al # convert to number
        mov %bl, %al
        _gi_loop:
            call getc_proc
            cmp %al, KEY_ENTER
            je _gi_exit # exit on key enter
            dec %al
            mov %cl, %al # store entered
            mov %eax, 10
            mul %ebx # saved number
            add %eax, %ecx # shift and add
            mov %ebx, %eax
            jmp _gi_loop
        _gi_exit:
        pop %ecx
        ret
// Macros
.macro getc
    call getc_proc
.endm

.macro gets lbl
    lea %ebx, \lbl
    call gets_proc
.endm

.macro gets_safe lbl
    push %ebx
    gets \lbl
    pop %ebx
.endm

.macro geti num
    push %ebx
    call geti_proc
    mov \num, %ebx
    pop %ebx
.endm
/* #endregion */
