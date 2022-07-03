.intel_syntax
.global snake.main

.include "libs/sys/system.s"
.include "libs/sys/gfx.s"

.section .data

snakeXmov: .byte 0
snakeYmov: .byte 0

snakeX: .int 40
snakeY: .int 12

.section .rodata

str1: .asciz "Unfinished"
str2: .asciz "ARROWKEYS to move, ESC to exit"
# implement buffer-swap to return to original screen after
.section .text

DrawSnake:
    mov %eax, snakeY
    mov %ebx, 80
    mul %ebx
    add %eax, snakeX
    shl %eax, 1
    mov %ebx, '*'
    or %ebx, 3840
    mov [0xb8000 + %eax], %bx
    ret

MoveSnake:
    mov %al, snakeXmov
    add snakeX, %al
    mov %al, snakeYmov
    add snakeY, %al
    ret

snake.main:
    pusha
    GFX_ENTER
    put_string str1; put_line
    put_string str2
    snake.lp:
        read_keyboard
        cmp %al, KEY_LEFT
        je snake.left
        cmp %al, KEY_RIGHT
        je snake.right
        cmp %al, KEY_UP
        je snake.up
        cmp %al, KEY_DOWN
        je snake.down
        cmp %al, KEY_ESC
        je snake.exit
        snake.retloop:

        call DrawSnake
        call MoveSnake
        call sleep

        jmp snake.lp
    popa
    ret
    
snake.left:
    movb snakeXmov, -1
    movb snakeYmov, 0
    jmp snake.retloop

snake.right:
    movb snakeXmov, 1
    movb snakeYmov, 0
    jmp snake.retloop

snake.up:
    movb snakeYmov, -1
    movb snakeXmov, 0
    jmp snake.retloop

snake.down:
    movb snakeYmov, 1
    movb snakeXmov, 0
    jmp snake.retloop
    
snake.exit:
    GFX_EXIT
    popa
    ret
