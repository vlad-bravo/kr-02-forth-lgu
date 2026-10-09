
.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "life_manual" FREE

.DEF PREV_NFA PREV_NFA_LIFE_MANUAL
.DEF PREFIX PREFIX_LIFE_MANUAL

.def PTR_LIVE 0x5ff2 ; Указатель в списке зарождающихся ячеек
.def PTR_DEAD 0x5ff4 ; Указатель в списке умирающих ячеек
.def LIVE_CHAR 0x2A  ; '*'

; (A -- N)
NFA "COUNTNEIGHBORS"
   pop h
   push b
   lxi b,0xFFB2 ; -WIDTH
   lxi d,0
   dad b        ; Верхняя
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip1
   inx d
@skip1:
   dcx h        ; Верхняя правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip2
   inx d
@skip2:
   inx h
   inx h        ; Верхняя правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip3
   inx d
@skip3:
   lxi b,0x4E   ; WIDTH, 0x4e = 78 cols
   dad b        ; Правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip4
   inx d
@skip4:
   dcx h
   dcx h        ; Левая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip5
   inx d
@skip5:
   dad b        ; Левая нижняя
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip6
   inx d
@skip6:
   inx h        ; Нижняя
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip7
   inx d
@skip7:
   inx h        ; Нижняя правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip8
   inx d
@skip8:
   pop b
   push d
   jmp _FNEXT

; (A -- )
NFA2 "COUNT-NEIGHBORS", "COUNT_2DNEIGHBORS"
   pop h
   push b
   lxi b,0xFFB2 ; -WIDTH
   lxi d,0
   dad b        ; Верхняя средняя
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip1
   inr e
@skip1:
   dcx h        ; Верхняя левая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip2
   inr e
@skip2:
   inx h
   inx h        ; Верхняя правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip3
   inr e
@skip3:
   lxi b,0x4E   ; WIDTH, 0x4e = 78 cols
   dad b        ; Правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip4
   inr e
@skip4:
   dcx h        ; Центральная
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip_live
   inr d        ; D - старший байт в DE, отметка о живой клетке
@skip_live:
   dcx h        ; Левая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip5
   inr e
@skip5:
   dad b        ; Левая нижняя
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip6
   inr e
@skip6:
   inx h        ; Нижняя
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip7
   inr e
@skip7:
   inx h        ; Нижняя правая
   mov a,m
   cpi LIVE_CHAR     ; '*'
   jnz @skip8
   inr e
@skip8:

; Проверка статуса в предыдущей тройке
   mov a,d
   ani 0b00000001
   mov a,e
   jz @WAS_DEAD
@WAS_LIVE:
   cpi 2
   jz @END_LOOP
   cpi 3
   jz @END_LOOP
; Клетка должна умереть
   push h
   lxi d,-79 ; Смещение от правого нижнего угла до центральной клетки
   dad d
   xchg
   lhld PTR_DEAD ; Указатель в списке умирающих ячеек
   mov m,e
   inx h
   mov m,d
   inx h
   shld PTR_DEAD ; Указатель в списке умирающих ячеек
   pop h
   jmp @END_LOOP
@WAS_DEAD:
   cpi 3
   jnz @END_LOOP
; Клетка должна родиться
   push h
   lxi d,-79 ; Смещение от правого нижнего угла до центральной клетки
   dad d
   xchg
   lhld PTR_LIVE ; Указатель в списке зарождающихся ячеек
   mov m,e
   inx h
   mov m,d
   inx h
   shld PTR_LIVE ; Указатель в списке зарождающихся ячеек
   pop h
@END_LOOP:
   pop b
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
   mvi m,LIVE_CHAR   ; '*'
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
   mvi e,29 ; Количество строк без верхней
@COL_LOOP:
; Выделение количества в верхней тройке
   mov a,b
   ani 0b00000011
   mov d,a
; Уменьшение общего количества (удаление верхней тройки)
   mov a,c
   sub d
   mov c,a
; Удаление верхней тройки (сдвиг троек)
   mov a,b
   rrc
   rrc
   rrc
   ani 0b00011111
   mov b,a
; Подсчет живых клеток в текущей тройке
   mvi d,0
   mvi a,LIVE_CHAR   ; '*'
   cmp m
   inx h
   jnz @SKIP1
   inr d
@SKIP1:
; Вторая клетка - в проверяемом столбце, запомнить живая ли она
   cmp m
   inx h
   jnz @SKIP2
   inr d
   mov a,b
   ori 0b00100000
   mov b,a
   mvi a,LIVE_CHAR   ; '*'
@SKIP2:

   cmp m
;   inx h
   jnz @SKIP3
   inr d
@SKIP3:
; Добавление к общей сумме
   mov a,d
   add c
   mov c,a
; Добавление количества в новой тройке
   mov a,d
   rrc
   rrc
   ora b
   mov b,a
; Проверка статуса в предыдущей тройке
   ani 0b00000100
   mov a,c
   jz @WAS_DEAD
@WAS_LIVE:
   cpi 3 ; С учётом самой живой клетки
   jz @END_LOOP
   cpi 4 ; С учётом самой живой клетки
   jz @END_LOOP
; Клетка должна умереть
   push d
   push h
   lxi d,-79 ; Смещение от правого нижнего угла до центральной клетки
   dad d
   xchg
   lhld PTR_DEAD ; Указатель в списке умирающих ячеек
   mov m,e
   inx h
   mov m,d
   inx h
   shld PTR_DEAD ; Указатель в списке умирающих ячеек
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
   lhld PTR_LIVE ; Указатель в списке зарождающихся ячеек
   mov m,e
   inx h
   mov m,d
   inx h
   shld PTR_LIVE ; Указатель в списке зарождающихся ячеек
   pop h
   pop d
@END_LOOP:

   mov a,e
   lxi d,76 ; Смещение от правой клетки до левой клетки следующей строки
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
   .word LIVE_CHAR  ; 2a = '*'

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
   .word 0x4000

; Указатель в списке зарождающихся ячеек
NFA "PLIVE"
   call __40
   .word PTR_LIVE

; Указатель в списке умирающих ячеек
NFA "PDEAD"
   call __40
   .word PTR_DEAD

.ENDS
