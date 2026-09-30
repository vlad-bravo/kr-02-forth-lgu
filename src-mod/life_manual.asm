
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

NFA2 "INIT-STAGE", "INIT_2DSTAGE"
   lxi h,@STAGE_DATA
@STAGE_LOOP:
   mov e,m
   inx h
   mov a,m
   cpi 0x00
   jz _FNEXT
   mov d,a
   inx h
   xchg
   mvi m,0x2A   ; '*'
   xchg
   jmp @STAGE_LOOP

@STAGE_DATA:
   .word 0x7825,0x7871,0x7873,0x78B5,0x78B6,0x78BD,0x78BE,0x78CB,0x78CC,0x7902,0x7906,0x790B,0x790C,0x7919
   .word 0x791A,0x7945,0x7946,0x794F,0x7955,0x7959,0x795A,0x7993,0x7994,0x799D,0x79A1,0x79A3,0x79A4,0x79A9
   .word 0x79AB,0x79EB,0x79F1,0x79F9,0x7A3A,0x7A3E,0x7A89,0x7A8A,0x7C3A,0x7C3B,0x7C87,0x7C88,0x7CD6
   .word 0x0000

; Начало видеопамяти
NFA "VIDMEM"
   call __40
   .word 0x76D0

; Размер экрана
NFA "SIZE"
   call __40
   .word 0x0924  ; 1e lines * 4e cols = 924

; Ширина
NFA "WIDTH"
   call __40
   .word 0x4e  ; 4e = 78 cols

; Высота
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

; Список зарождающихся ячеек
NFA "SLIVE"
   call __40
   .word 0x5000

; Список умирающих ячеек
NFA "SDEAD"
   call __40
   .word 0x5800

; Указатель в списке зарождающихся ячеек
NFA "PLIVE"
   call __40
   .word 0x5ff2

; Указатель в списке умирающих ячеек
NFA "PDEAD"
   call __40
   .word 0x5ff4

.ENDS
