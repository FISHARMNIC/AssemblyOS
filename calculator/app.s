// need to be able to push more than 2 numbers

.intel_syntax
.org 0x100
.global main
.section .data

.include "../calculator/inc.s"
.include "libs/stdout.s"
.include "libs/stdin.s"
.intel_syntax

num = %edx
num_low = %dl

.macro push_num
    _shift_stack_left_
    push num # push to stack
    _shift_stack_right_
.endm

.macro pop_num
    _shift_stack_left_
    pop %eax # get from stack
    _shift_stack_right_
.endm

.section .text

prepare_hndl:
    pop_num
    clear_line
    ret

exit_hndl:
    mov num, %eax
    push_num
    put_int_safe num
    xor num, num
    ret

// use qwer instead for easier handling
kb_handler:
    # Read button on release
    getc
    # Print to screen
    k2char_al
    put_char_al


    # Check for special keys
    cmpb keyboard_out, KEY_ENTER
    je enter_ev # enter key
    cmpb %al, '='
    je plus_ev # plus key (no shift needed)
    cmpb %al, '-'
    je minus_ev # minus key
    cmpb %al, '/'
    je div_ev # divide key
    cmpb %al, 'x'
    je mul_ev # multiply key
    
    # No special keys
    # In this case, append to the input buffer
    
    sub %al, 48 # convert char to number
    cmp num, 0
    jne num_append
    # Number is equal to 0
    //put_char_safe 'L'
    mov num_low, %al
    clear_line
    add %al, 48
    put_char_al
    ret

    num_append:
    # Number is already existent
    xor %ebx, %ebx
    mov %bl, %al # copy number

    mov %eax, num
    mov %ecx, 10
    mul %ecx # multiply old number by 10
    add %eax, %ebx # add the new number
    mov num, %eax
    ret

enter_ev:
    push_num
    xor num, num
    ret
plus_ev:
    call prepare_hndl
    add %eax, num
    call exit_hndl
    ret
minus_ev:
    call prepare_hndl
    sub %eax, num
    call exit_hndl
    ret
mul_ev:
    call prepare_hndl
    mov %esi, num
    mul %esi
    call exit_hndl
    ret
div_ev:
    call prepare_hndl
    push %edx
    mov %esi, num
    div %esi
    pop %edx
    call exit_hndl
    ret

main:
    # Stack initiation
    mov %eax, %esp
    sub %eax, 100
    mov _stack_d2_, %eax
    mov num, 0
    # Program begin
    host_routine:
        call kb_handler 
        jmp host_routine
    ret
