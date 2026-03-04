
.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "life_manual" FREE

.DEF PREV_NFA PREV_NFA_LIFE_MANUAL
.DEF PREFIX PREFIX_LIFE_MANUAL

; : CHECK-LIVE ( N A -- N' A )
;   DUP C@ LIVE = IF SWAP 1+ SWAP THEN
; ;

NFA "CHECKLIVE"
   pop h    ; A
   pop d    ; N
   mov a,m
   cpi 0x2A ; '*'
   jnz @skip
   inx d
@skip:
   push d   ; N'
   push h   ; A
   jmp _FNEXT

; : COUNT-NEIGHBORS ( A -- N )
;   0 SWAP           \ N A
;   WIDTH - CHECKLIVE  \ Верхняя
;        1- CHECKLIVE  \ Верхняя левая
;        2+ CHECKLIVE  \ Верхняя правая
;   WIDTH + CHECKLIVE  \ Правая
;        2- CHECKLIVE  \ Левая
;   WIDTH + CHECKLIVE  \ Нижняя левая
;        1+ CHECKLIVE  \ Нижняя
;        1+ CHECKLIVE  \ Нижняя правая
;   DROP
; ;

NFA "COUNTNEIGHBORS"
   pop h
   push b
   lxi b,0xFFB2 ; -WIDTH
   lxi d,0
   dad b        ; Верхняя
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip1
   inx d
@skip1:
   dcx h        ; Верхняя правая
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip2
   inx d
@skip2:
   inx h
   inx h        ; Верхняя правая
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip3
   inx d
@skip3:
   lxi b,0x4E   ; WIDTH, 0x4e = 78 cols
   dad b        ; Правая
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip4
   inx d
@skip4:
   dcx h
   dcx h        ; Левая
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip5
   inx d
@skip5:
   dad b        ; Левая нижняя
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip6
   inx d
@skip6:
   inx h        ; Нижняя
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip7
   inx d
@skip7:
   inx h        ; Нижняя правая
   mov a,m
   cpi 0x2A     ; '*'
   jnz @skip8
   inx d
@skip8:
   pop b
   push d
   jmp _FNEXT

; Начало видеопамяти
NFA "VIDMEM"
   call __40
   .word 0x76D0

; Размер экрана
NFA "SIZE"
   call __40
   .word 0x0924  ; 1e lines * 4e cols = 924

; Ширина (32 символа)
NFA "WIDTH"
   call __40
   .word 0x4e  ; 4e = 78 cols

; Высота (26 строк)
NFA "HEIGHT"
   call __40
   .word 0x1e  ; 1e = 30 lines

; Символ '*' (живая клетка)
NFA "LIVE"
   call __40
   .word 0x2a  ; 2a = '*'

; Символ ' ' (мертвая клетка)
NFA "DEAD"
   call __40
   .word 0x20  ; 20 = ' '

NFA "SLIVE"
   call __40
   .word 0x5000

NFA "SDEAD"
   call __40
   .word 0x5800

NFA "PLIVE"
   call __40
   .word 0x5ff2

NFA "PDEAD"
   call __40
   .word 0x5ff4

.ENDS
