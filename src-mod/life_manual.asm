
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
   mvi a,0x80   ; Команда загрузки курсора
   sta 0xc001   ; Запись команды i8275
   sta 0xc000   ; Запись колонки
   sta 0xc000   ; Запись строки
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
.include "life_manual_stage.asm"
   .word 0x0000

; (A -- ) Обработка колонки по заданному адресу
; В массивы PLIVE и PDEAD вносятся необходимые изменения
; HL - адрес левой верхней ячейки тестируемого квадрата
; B - упакованные биты количества соседей и статусов по строкам квадрата
;     aabccdee
;     aa - количество соседей в нижней строке
;     b  - статус нижней строки. 1 - средняя клетка в нижней строке жива
;     cc - количество соседей в средней строке
;     d  - статус средней строки. 1 - средняя клетка в среднй строке жива
;     ee - количество соседей в верхней строке
;
; C - количество соседей в текущем квадрате
;
NFA2 "PR-COLUMN", "PR_2DCOLUMN"
   pop h
   push b
; B=00000000 C=0
   lxi b,0
   mvi e,28 ; Количество строк без верхней и нижней
@COL_LOOP:
   mov a,b
   ani 0b00000011
   mov d,a
   mov a,c
   sub d
   mov c,a
   mov a,b
   cmc
   rrc
   cmc
   rrc
   cmc
   rrc
   mov b,a
   mvi a,0x2A   ; '*'
   cmp m
   inx h
   jnz @SKIP1
   inr c
@SKIP1:

   cmp m
   inx h
   jnz @SKIP2
   inr c
   mov a,b
   adi 0b00100000
   mov b,a
   mvi a,0x2A   ; '*'
@SKIP2:

   cmp m
;   inx h
   jnz @SKIP3
   inr c
@SKIP3:

   mov a,c
   cmc
   rlc
   rlc
   rlc
   rlc
   rlc
   rlc
   mov d,a
   mov a,b
   add d
   mov b,a

   ani 0b00000100
   mov a,c
   jz @WAS_DEAD
   cpi 3
   jz @END_LOOP
   cpi 4
   jz @END_LOOP
   ; Клетка должна умереть
   push d
   push h
   lxi d,-79 ; Смещение от правого нижнего угла до центральной клетки
   dad d
   xchg
   lhld 0x5ff4
   mov m,e
   inx h
   mov m,d
   inx h
   shld 0x5ff4
   pop h
   pop d
   jmp @END_LOOP
@WAS_DEAD:
   cpi 3
   jnz @END_LOOP
   ; Клетка должна родиться
   push d
   push h
   lxi d,-79 ; Смещение от правого нижнего угла до центральной клетки
   dad d
   xchg
   lhld 0x5ff2
   mov m,e
   inx h
   mov m,d
   inx h
   shld 0x5ff2
   pop h
   pop d
@END_LOOP:
   mov a,e
   lxi d,75
   dad d
   mov e,a

   dcr e
   jnz @COL_LOOP

   pop b
   jmp _FNEXT

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
