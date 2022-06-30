.section .data

.comm pbuffer_1, 15, 1
.comm pbuffer_2, 15, 1

.global pbuffer_1
.global pbuffer_2

.section .text

parse_command:
    pusha
    # clear param buffers
    
    ldbuffer_safe pbuffer_1, 15, 0
    ldbuffer_safe pbuffer_2, 15, 0


    lea %eax, inbuffer
    lea %ebx, pbuffer_1

    pc.loop0:
        cmpb [%eax], 0
        je pc.eret
        inc %eax
        cmpb [%eax], ' '
        jne pc.loop0
    
    movb [%eax], 0 # terminate the inbuffer (command)
    inc %eax


    pc.loop1:
        cmpb [%eax], 0
        je pc.eret 
        mov %cl, [%eax] # read inbuffer
        mov [%ebx], %cl # load byte into pbuffer
        inc %eax
        inc %ebx
        cmp %cl, ' ' # split on space
        jne pc.loop1

    dec %ebx
    movb [%ebx], 0 # terminate the buffer (param1)
    lea %ebx, pbuffer_2

    pc.loop2:
        mov %cl, [%eax] # read inbuffer
        mov [%ebx], %cl # load byte into pbuffer2
        inc %eax
        inc %ebx
        cmp %cl, 0 # split on null
        jne pc.loop2
   
    dec %ebx
    movb [%ebx], 0 # terminate the buffer (param2)
    
    pc.eret:
    popa
    ret
