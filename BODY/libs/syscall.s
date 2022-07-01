/*
To be included in any application that is linked to the kernel file
*/
.macro __DATA__
.section .data
.skip 100
.endm

.macro __TEXT__ 
.section .text
.endm

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

/* System calls
0 put_char - eax
1 put_string - edx
2 put_int - eax
3 put_line

4 getc
5 gets - ebx
6 geti - ebx
7 k2char - ebx
*/

/* #region OUTPUT */
.macro put_char c
    xor %eax, %eax
    mov %al, \c
    syscall 0
.endm

.macro put_string stri
    lea %edx, \stri
    syscall 1
.endm

.macro put_int num
    mov %eax, \num
    syscall 2
.endm

.macro put_line
    syscall 3
.endm
/* #endregion */

/* #region INPUT SYSCALLS */
.macro getc
    syscall 4
.endm

.macro gets buffer
    mov %ebx, \buffer
    syscall 5
.endm

.macro geti p
    mov %ebx, \p
    syscall 6
.endm

.macro k2_char p
    mov %ebx, \p
    syscall 7
.endm
/* #endregion */