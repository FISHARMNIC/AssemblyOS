.intel_syntax

.section .text

strlen_proc:
    /*
    Clobbers:
        EAX = addr
    Return: EAX
    */
    push %ecx
    mov %ecx, %eax # ecx will hold base
    dec %eax
    strlen.l:
        inc %eax
        cmpb [%eax], 0
        jne strlen.l
    sub %eax, %ecx
    pop %ecx
    ret

strcmp_proc:
    /*
    Clobbers:
        EAX = src1
        EBX = src2
    Return: AL
    */
    push %edx; push %ecx
    mov %ecx, %eax # eax will be overwritten by strlen

    call strlen_proc # call with str1
    mov %edx, %eax # edx holds len1
    
    xor %eax, %eax
    mov %eax, %ebx
    call strlen_proc #  call with str2

    sub %eax, %edx # cmp lengths
    jnz strcmp.exit

    # strings are now in %ebx and %ecx
    dec %ebx
    dec %ecx
    strcmp.l:
        inc %ebx
        inc %ecx

        mov %al, [%ebx] # avoid over reference
        cmp %al, 0
        jz strcmp.exit # finished string
        sub %al, [%ecx]
        jz strcmp.l
    strcmp.exit:
    pop %ecx; pop %edx  
    ret  

.macro ldbuffer buffer, size, data = 0
    mov %ecx, \size
    mov %al, \data
    lea %edi, \buffer
    rep stosb
.endm

.macro ldbuffer_safe buffer, size, data = 0
    push %ecx
    push %eax
    push %edi
    ldbuffer \buffer, \size, \data
    pop %edi
    pop %eax
    pop %ecx
.endm

.macro strcmp src, secsrc
    push %ebx
    lea %ebx, \src
    lea %eax, \secsrc
    call strcmp_proc
    pop %ebx
.endm

.macro strlen src
    lea %eax, \src
    call strlen_proc
.endm
