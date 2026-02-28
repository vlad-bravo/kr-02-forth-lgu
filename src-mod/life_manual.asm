
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"
.include "life.inc"

.SECTION "life_manual" FREE

; Начало видеопамяти
NFA_VIDMEM:
   .byte 6,"VIDMEM"
   .word NFA_BYE
l_VIDMEM:
   call __40
   .word line00

; Размер экрана
NFA_SIZE:
   .byte 4,"SIZE"
   .word NFA_VIDMEM
l_SIZE:
   call __40
   .word 0x0924  ; 1e lines * 4e cols = 924

; Ширина (32 символа)
NFA_WIDTH:
   .byte 5,"WIDTH"
   .word NFA_SIZE
l_WIDTH:
   call __40
   .word 0x4e  ; 4e = 78 cols

; Высота (26 строк)
NFA_HEIGHT:
   .byte 6,"HEIGHT"
   .word NFA_WIDTH
l_HEIGHT:
   call __40
   .word 0x1e  ; 1e = 30 lines

; Символ '*' (живая клетка)
NFA_LIVE:
   .byte 4,"LIVE"
   .word NFA_HEIGHT
l_LIVE:
   call __40
   .word 0x2a  ; 2a = '*'

; Символ ' ' (мертвая клетка)
NFA_DEAD:
   .byte 4,"DEAD"
   .word NFA_LIVE
l_DEAD:
   call __40
   .word 0x20  ; 20 = ' '

; Создаем буфер в оперативной памяти для хранения текущего поколения
; CREATE WORLD SIZE ALLOT
NFA_WORLD:
   .byte 5,"WORLD"
   .word NFA_DEAD
l_WORLD:
   call __40
   .word 0x5000

; VARIABLE GX \ Координата X текущей клетки
NFA_GX:
   .byte 2,"GX"
   .word NFA_WORLD
l_GX:
   call __40
   .word 0x5ff0

; VARIABLE GY \ Координата Y текущей клетки
NFA_GY:
   .byte 2,"GY"
   .word NFA_GX
l_GY:
   call __40
   .word 0x5ff2

; VARIABLE GN \ Количество соседей
NFA_GN:
   .byte 2,"GN"
   .word NFA_GY
l_GN:
   call __40
   .word 0x5ff4

.ENDS
