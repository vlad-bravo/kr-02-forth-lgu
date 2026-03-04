.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "LIFE_F" FREE

.DEF PREV_NFA PREV_NFA_LIFE_F
.DEF PREFIX PREFIX_LIFE_F

; Определение слов для последующей компиляции
NFA "FLD"
   call _FCALL
; ( -- )
; Перебор всех ячеек экрана
;    HEIGHT 0 DO
;        WIDTH 0 DO
;            C" . J WIDTH * I + VIDMEM + C!
;        LOOP
;    LOOP
; Перебор ячеек экрана по типам
; A, B, C, D - по углам экрана
; T, L, R, B - верхняя, левая, правая, нижняя границы
; . - все внутренние ячейки
   .word _VIDMEM        ; VIDMEM
   .word _LIT, 0x41     ; C" A
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word _LIT, 0x54     ; C" T
   .word _SWAP          ; SWAP
   .word _WIDTH         ; WIDTH
   .word _2             ; 2
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _2DUP          ; 2DUP
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _PRESS         ; PRESS
   .word _LIT, 0x42     ; C" B
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word _HEIGHT        ; HEIGHT
   .word _2             ; 2
   .word __28_3FDO_29,@B4 ; (?DO) @B4
@B3:
   .word _LIT, 0x4c     ; C" L
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word _LIT, 0x2e     ; C" .
   .word _SWAP          ; SWAP
   .word _WIDTH         ; WIDTH
   .word _2             ; 2
   .word __28_3FDO_29,@B6 ; (?DO) @B6
@B5:
   .word _2DUP          ; 2DUP
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B5 ; (LOOP) @B5
@B6:
   .word _PRESS         ; PRESS
   .word _LIT, 0x52     ; C" R
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B3 ; (LOOP) @B3
@B4:
   .word _LIT, 0x43     ; C" C
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word _LIT, 0x42     ; C" B
   .word _SWAP          ; SWAP
   .word _WIDTH         ; WIDTH
   .word _2             ; 2
   .word __28_3FDO_29,@B8 ; (?DO) @B8
@B7:
   .word _2DUP          ; 2DUP
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B7 ; (LOOP) @B7
@B8:
   .word _PRESS         ; PRESS
   .word _LIT, 0x44     ; C" D
   .word _SWAP          ; SWAP
   .word _C_21          ; C!
   .word _EXIT          ; EXIT

NFA "INIT"
   call _FCALL
; ( -- )
; Заполняем пробелами
   .word _VIDMEM        ; VIDMEM
   .word _SIZE          ; SIZE
   .word _DEAD          ; DEAD
   .word _FILL          ; FILL
; Рисуем планер (Glider) в центре экрана
; Координаты примерно (10, 10)
   .word _LIVE          ; LIVE
   .word _DUP           ; DUP
   .word _LIT,0xA       ; A
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
; (10, 10)
   .word _DUP           ; DUP
   .word _LIT,0xB       ; B
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
; (11, 10)
   .word _DUP           ; DUP
   .word _LIT,0xC       ; C
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
; (12, 10)
   .word _DUP           ; DUP
   .word _LIT,0xC       ; C
   .word _LIT,0x9       ; 9
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
; (12, 9)
   .word _DUP           ; DUP
   .word _LIT,0xB       ; B
   .word _LIT,0x8       ; 8
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
; (11, 8)
   .word _DUP           ; DUP
   .word _LIT,0x1A      ; 1A
   .word _LIT,0xB       ; B
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0x1B      ; 1B
   .word _LIT,0xB       ; B
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0x1C      ; 1C
   .word _LIT,0xB       ; B
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0x1A      ; 1A
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0x1B      ; 1B
   .word _LIT,0x9       ; 9
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0xA       ; A
   .word _LIT,0x1A      ; 1A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0xB       ; B
   .word _LIT,0x1A      ; 1A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0xC       ; C
   .word _LIT,0x1A      ; 1A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0xC       ; C
   .word _LIT,0x19      ; 19
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DUP           ; DUP
   .word _LIT,0xB       ; B
   .word _LIT,0x18      ; 18
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

; Анализ состояния ячейки
; Добавление адреса ячейки в массивы зарождающихся или умирающих ячеек
NFA2 "PR-CELL", "PR_2DCELL"
   call _FCALL
; ( A -- )
   .word _DUP           ; DUP
; ( A A )
   .word _COUNTNEIGHBORS; COUNTNEIGHBORS
; ( A N )
   .word _OVER          ; OVER
   .word _C_40          ; C@
   .word _LIVE          ; LIVE
   .word __3D           ; =
; ( A N IsLive )
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
; Клетка жива
   .word _DUP           ; DUP
   .word _2             ; 2
   .word __3D           ; =
   .word _SWAP          ; SWAP
   .word _LIT,0x3       ; 3
   .word __3D           ; =
   .word _OR            ; OR
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _DROP          ; DROP
   .word _BRANCH,@B3    ; BRANCH @B3
@B2:
   .word _PDEAD         ; PDEAD
   .word __40           ; @
   .word __21           ; !
   .word _PDEAD         ; PDEAD
   .word __40           ; @
   .word _2_2B          ; 2+
   .word _PDEAD         ; PDEAD
   .word __21           ; !
@B3:
   .word _BRANCH,@B4    ; BRANCH @B4
@B1:
; Клетка мертва
   .word _LIT,0x3       ; 3
   .word __3D           ; =
   .word __3FBRANCH,@B5 ; ?BRANCH @B5
   .word _PLIVE         ; PLIVE
   .word __40           ; @
   .word __21           ; !
   .word _PLIVE         ; PLIVE
   .word __40           ; @
   .word _2_2B          ; 2+
   .word _PLIVE         ; PLIVE
   .word __21           ; !
   .word _BRANCH,@B6    ; BRANCH @B6
@B5:
   .word _DROP          ; DROP
@B6:
@B4:
   .word _EXIT          ; EXIT

NFA "LIFE"
   call _FCALL
; ( -- )
   .word _INIT          ; INIT
; Первая ячейка поля - во второй строке, второй колонке
   .word _VIDMEM        ; VIDMEM
   .word _WIDTH         ; WIDTH
   .word __2B           ; +
   .word _1_2B          ; 1+
@B1:
; Указатели на массивы зарождающихся и умирающих ячеек
   .word _SLIVE         ; SLIVE
   .word _PLIVE         ; PLIVE
   .word __21           ; !
   .word _SDEAD         ; SDEAD
   .word _PDEAD         ; PDEAD
   .word __21           ; !
; Обработка поля кроме крайних строк и колонок
   .word _DUP           ; DUP
   .word _HEIGHT        ; HEIGHT
   .word _2             ; 2
   .word __28_3FDO_29,@B3 ; (?DO) @B3
@B2:
   .word _WIDTH         ; WIDTH
   .word _2             ; 2
   .word __28_3FDO_29,@B5 ; (?DO) @B5
@B4:
   .word _DUP           ; DUP
   .word _PR_2DCELL     ; PR-CELL
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B4 ; (LOOP) @B4
@B5:
   .word _2_2B          ; 2+
; Пропуск последней ячейки текущей строки и первой ячейки следующей строки
   .word __28LOOP_29,@B2 ; (LOOP) @B2
@B3:
   .word _DROP          ; DROP
; Отображение подготовленных данных о рождённых и умерших ячейках
   .word _PLIVE         ; PLIVE
   .word __40           ; @
   .word _SLIVE         ; SLIVE
   .word __28_3FDO_29,@B7 ; (?DO) @B7
@B6:
   .word _LIVE          ; LIVE
   .word _I             ; I
   .word __40           ; @
   .word _C_21          ; C!
   .word _2             ; 2
   .word __28_2BLOOP_29,@B6 ; (+LOOP) @B6
@B7:
   .word _PDEAD         ; PDEAD
   .word __40           ; @
   .word _SDEAD         ; SDEAD
   .word __28_3FDO_29,@B9 ; (?DO) @B9
@B8:
   .word _DEAD          ; DEAD
   .word _I             ; I
   .word __40           ; @
   .word _C_21          ; C!
   .word _2             ; 2
   .word __28_2BLOOP_29,@B8 ; (+LOOP) @B8
@B9:
   .word _BRANCH,@B1    ; BRANCH @B1
   .word _EXIT          ; EXIT

NFA "HH"
   call _FCALL
   .word __28_22_29     ; (")
   .byte 12
   .stringmap russian,"HELLO, HABR!"
   .word _COUNT         ; COUNT
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA "PROMPT2"
   call _FCALL
; ( -- )
; Режим трансляции
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _LIT, 0x43     ; C" C
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _LIT, 0x49     ; C" I
@B2:
   .word _EMIT          ; EMIT
; Система счисления
   .word _BASE          ; BASE
   .word __40           ; @
   .word _DUP           ; DUP
   .word _DECIMAL       ; DECIMAL
   .word _2             ; 2
   .word __2ER          ; .R
   .word _BASE          ; BASE
   .word __21           ; !
; Галочка и пробел
   .word _LIT, 0x3e     ; C" >
   .word _EMIT          ; EMIT
   .word _SPACE         ; SPACE
   .word _EXIT          ; EXIT

; Всегда последнее слово (для правильной цепочки NFA)
NFA "BYE"
   call _FCALL
   .word _LIT,0xF800    ; F800
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT

.ENDS
