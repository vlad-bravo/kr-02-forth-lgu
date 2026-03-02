
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"
.include "life.inc"

.SECTION "compiled" FREE

; Определение слов для последующей компиляции
NFA_CORNERS:
   .byte 7,"CORNERS"
   .word NFA_EXIT
_CORNERS:
   call _FCALL
   .word _LIT,0x41      ; 41
   .word _LIT,0x76D0    ; 76D0
   .word __21           ; !
   .word _LIT,0x42      ; 42
   .word _LIT,0x771D    ; 771D
   .word __21           ; !
   .word _LIT,0x43      ; 43
   .word _LIT,0x7FA6    ; 7FA6
   .word __21           ; !
   .word _LIT,0x44      ; 44
   .word _LIT,0x7FF3    ; 7FF3
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA_FLD:
   .byte 3,"FLD"
   .word NFA_CORNERS
_FLD:
   call _FCALL
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
   .word _LIT, 0x41     ; C" A
   .word _LIT,0x76D0    ; 76D0
   .word _C_21          ; C!
   .word _WIDTH         ; WIDTH
   .word _1_2D          ; 1-
   .word _1             ; 1
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _LIT, 0x54     ; C" T
   .word _I             ; I
   .word _LIT,0x76D0    ; 76D0
   .word __2B           ; +
   .word _C_21          ; C!
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _LIT, 0x42     ; C" B
   .word _LIT,0x771D    ; 771D
   .word _C_21          ; C!
   .word _HEIGHT        ; HEIGHT
   .word _1_2D          ; 1-
   .word _1             ; 1
   .word __28_3FDO_29,@B4 ; (?DO) @B4
@B3:
   .word _LIT, 0x4c     ; C" L
   .word _I             ; I
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word _LIT,0x76D0    ; 76D0
   .word __2B           ; +
   .word _C_21          ; C!
   .word _WIDTH         ; WIDTH
   .word _1_2D          ; 1-
   .word _1             ; 1
   .word __28_3FDO_29,@B6 ; (?DO) @B6
@B5:
   .word _LIT, 0x2e     ; C" .
   .word _J             ; J
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word _I             ; I
   .word __2B           ; +
   .word _LIT,0x76D0    ; 76D0
   .word __2B           ; +
   .word _C_21          ; C!
   .word __28LOOP_29,@B5 ; (LOOP) @B5
@B6:
   .word _LIT, 0x52     ; C" R
   .word _I             ; I
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word _LIT,0x771D    ; 771D
   .word __2B           ; +
   .word _C_21          ; C!
   .word __28LOOP_29,@B3 ; (LOOP) @B3
@B4:
   .word _LIT, 0x43     ; C" C
   .word _LIT,0x7FA6    ; 7FA6
   .word _C_21          ; C!
   .word _WIDTH         ; WIDTH
   .word _1_2D          ; 1-
   .word _1             ; 1
   .word __28_3FDO_29,@B8 ; (?DO) @B8
@B7:
   .word _LIT, 0x42     ; C" B
   .word _I             ; I
   .word _LIT,0x7FA6    ; 7FA6
   .word __2B           ; +
   .word _C_21          ; C!
   .word __28LOOP_29,@B7 ; (LOOP) @B7
@B8:
   .word _LIT, 0x44     ; C" D
   .word _LIT,0x7FF3    ; 7FF3
   .word _C_21          ; C!
   .word _EXIT          ; EXIT

NFA_CHECK_2DLIVE:
   .byte 10,"CHECK-LIVE"
   .word NFA_FLD
_CHECK_2DLIVE:
   call _FCALL
; ( N A -- N' A )
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word _LIVE          ; LIVE
   .word __3D           ; =
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _SWAP          ; SWAP
   .word _1_2B          ; 1+
   .word _SWAP          ; SWAP
@B1:
   .word _EXIT          ; EXIT

; Посчитать количество живых соседей для клетки с адресом A
NFA_COUNT_2DNEIGHBORS:
   .byte 15,"COUNT-NEIGHBORS"
   .word NFA_CHECK_2DLIVE
_COUNT_2DNEIGHBORS:
   call _FCALL
; ( A -- N )
   .word _0             ; 0
   .word _SWAP          ; SWAP
; N A
   .word _WIDTH         ; WIDTH
   .word __2D           ; -
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Верхняя
   .word _1_2D          ; 1-
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Верхняя левая
   .word _2_2B          ; 2+
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Верхняя правая
   .word _WIDTH         ; WIDTH
   .word __2B           ; +
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Правая
   .word _2_2D          ; 2-
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Левая
   .word _WIDTH         ; WIDTH
   .word __2B           ; +
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Нижняя левая
   .word _1_2B          ; 1+
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Нижняя
   .word _1_2B          ; 1+
   .word _CHECK_2DLIVE  ; CHECK-LIVE
; Нижняя правая
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

NFA_PR_2DCELL:
   .byte 7,"PR-CELL"
   .word NFA_COUNT_2DNEIGHBORS
_PR_2DCELL:
   call _FCALL
; ( A -- )
   .word _DUP           ; DUP
   .word _COUNT_2DNEIGHBORS; COUNT-NEIGHBORS
   .word _OVER          ; OVER
   .word _C_40          ; C@
   .word _LIVE          ; LIVE
   .word __3D           ; =
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

NFA_INIT:
   .byte 4,"INIT"
   .word NFA_PR_2DCELL
_INIT:
   call _FCALL
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
   .word _LIT,0xB       ; B
   .word _LIT,0x8       ; 8
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
; (11, 8)
   .word _EXIT          ; EXIT

NFA_LIFE:
   .byte 4,"LIFE"
   .word NFA_INIT
_LIFE:
   call _FCALL
   .word _INIT          ; INIT
@B1:
; Указатели на стеки зарождающихся и умирающих ячеек
   .word _SLIVE         ; SLIVE
   .word _PLIVE         ; PLIVE
   .word __21           ; !
   .word _SDEAD         ; SDEAD
   .word _PDEAD         ; PDEAD
   .word __21           ; !
;  C" A 76D0 C!
;  WIDTH 1- 1 DO
;    C" T I 76D0 + C!
;  LOOP
;  C" B 771D C!
   .word _HEIGHT        ; HEIGHT
   .word _1_2D          ; 1-
   .word _1             ; 1
   .word __28_3FDO_29,@B3 ; (?DO) @B3
@B2:
;    C" L I WIDTH * 76D0 + C!
   .word _WIDTH         ; WIDTH
   .word _1_2D          ; 1-
   .word _1             ; 1
   .word __28_3FDO_29,@B5 ; (?DO) @B5
@B4:
   .word _J             ; J
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word _I             ; I
   .word __2B           ; +
   .word _LIT,0x76D0    ; 76D0
   .word __2B           ; +
   .word _PR_2DCELL     ; PR-CELL
   .word __28LOOP_29,@B4 ; (LOOP) @B4
@B5:
;    C" R I WIDTH * 771D + C!
   .word __28LOOP_29,@B2 ; (LOOP) @B2
@B3:
;  C" C 7FA6 C!
;  WIDTH 1- 1 DO
;    C" B I 7FA6 + C!
;  LOOP
;  C" D 7FF3 C!
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

NFA_HH:
   .byte 2,"HH"
   .word NFA_LIFE
_HH:
   call _FCALL
   .word __28_22_29     ; (")
   .byte 12,"HELLO, HABR!"
   .word _COUNT         ; COUNT
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA_PROMPT2:
   .byte 7,"PROMPT2"
   .word NFA_HH
_PROMPT2:
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
NFA_BYE:
   .byte 3,"BYE"
   .word NFA_PROMPT2
_BYE:
   call _FCALL
   .word _LIT,0xF800    ; F800
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT

.ENDS
