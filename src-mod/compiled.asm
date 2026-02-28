
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

NFA_5S:
   .byte 2,"5S"
   .word NFA_CORNERS
_5S:
   call _FCALL
   .word _LIT,0x5       ; 5
   .word _0             ; 0
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _LIVE          ; LIVE
   .word _EMIT          ; EMIT
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _EXIT          ; EXIT

; Нормализация координат (зацикливание экрана)
NFA_WRAPX:
   .byte 5,"WRAPX"
   .word NFA_5S
_WRAPX:
   call _FCALL
; ( x -- x' )
   .word _DUP           ; DUP
   .word _WIDTH         ; WIDTH
   .word __3D           ; =
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DROP          ; DROP
   .word _0             ; 0
@B1:
   .word _DUP           ; DUP
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _WIDTH         ; WIDTH
   .word __2B           ; +
@B2:
   .word _EXIT          ; EXIT

NFA_WRAPY:
   .byte 5,"WRAPY"
   .word NFA_WRAPX
_WRAPY:
   call _FCALL
; ( y -- y' )
   .word _DUP           ; DUP
   .word _HEIGHT        ; HEIGHT
   .word __3D           ; =
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DROP          ; DROP
   .word _0             ; 0
@B1:
   .word _DUP           ; DUP
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _HEIGHT        ; HEIGHT
   .word __2B           ; +
@B2:
   .word _EXIT          ; EXIT

; Получить значение клетки из буфера WORLD по координатам x, y
NFA_GETW:
   .byte 4,"GETW"
   .word NFA_WRAPY
_GETW:
   call _FCALL
; ( x y -- char )
   .word _WRAPY         ; WRAPY
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word _SWAP          ; SWAP
   .word _WRAPX         ; WRAPX
   .word __2B           ; +
   .word _WORLD         ; WORLD
   .word __2B           ; +
   .word _C_40          ; C@
   .word _EXIT          ; EXIT

; Проверить соседа и увеличить счетчик, если он жив
NFA_CHECK_2DN:
   .byte 7,"CHECK-N"
   .word NFA_GETW
_CHECK_2DN:
   call _FCALL
; ( x y -- )
   .word _GETW          ; GETW
   .word _LIVE          ; LIVE
   .word __3D           ; =
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _1             ; 1
   .word _GN            ; GN
   .word __2B_21        ; +!
@B1:
   .word _EXIT          ; EXIT

; Посчитать количество живых соседей для клетки с координатами GX, GY
NFA_COUNT_2DNEIGHBORS:
   .byte 15,"COUNT-NEIGHBORS"
   .word NFA_CHECK_2DN
_COUNT_2DNEIGHBORS:
   call _FCALL
; ( -- n )
   .word _0             ; 0
   .word _GN            ; GN
   .word __21           ; !
   .word _GX            ; GX
   .word __40           ; @
   .word _1_2D          ; 1-
   .word _GY            ; GY
   .word __40           ; @
   .word _1_2D          ; 1-
   .word _CHECK_2DN     ; CHECK-N
; Верхний левый
   .word _GX            ; GX
   .word __40           ; @
   .word _GY            ; GY
   .word __40           ; @
   .word _1_2D          ; 1-
   .word _CHECK_2DN     ; CHECK-N
; Верхний
   .word _GX            ; GX
   .word __40           ; @
   .word _1_2B          ; 1+
   .word _GY            ; GY
   .word __40           ; @
   .word _1_2D          ; 1-
   .word _CHECK_2DN     ; CHECK-N
; Верхний правый
   .word _GX            ; GX
   .word __40           ; @
   .word _1_2D          ; 1-
   .word _GY            ; GY
   .word __40           ; @
   .word _CHECK_2DN     ; CHECK-N
; Левый
   .word _GX            ; GX
   .word __40           ; @
   .word _1_2B          ; 1+
   .word _GY            ; GY
   .word __40           ; @
   .word _CHECK_2DN     ; CHECK-N
; Правый
   .word _GX            ; GX
   .word __40           ; @
   .word _1_2D          ; 1-
   .word _GY            ; GY
   .word __40           ; @
   .word _1_2B          ; 1+
   .word _CHECK_2DN     ; CHECK-N
; Нижний левый
   .word _GX            ; GX
   .word __40           ; @
   .word _GY            ; GY
   .word __40           ; @
   .word _1_2B          ; 1+
   .word _CHECK_2DN     ; CHECK-N
; Нижний
   .word _GX            ; GX
   .word __40           ; @
   .word _1_2B          ; 1+
   .word _GY            ; GY
   .word __40           ; @
   .word _1_2B          ; 1+
   .word _CHECK_2DN     ; CHECK-N
; Нижний правый
   .word _GN            ; GN
   .word __40           ; @
   .word _EXIT          ; EXIT

; ===========================================
; Основная логика
; ===========================================
; Обработка одной клетки
NFA_PROCESS_2DCELL:
   .byte 12,"PROCESS-CELL"
   .word NFA_COUNT_2DNEIGHBORS
_PROCESS_2DCELL:
   call _FCALL
; ( x y -- )
   .word _GY            ; GY
   .word __21           ; !
   .word _GX            ; GX
   .word __21           ; !
; Сохраняем координаты
   .word _COUNT_2DNEIGHBORS; COUNT-NEIGHBORS
; Считаем соседей (стек: n )
   .word _GX            ; GX
   .word __40           ; @
   .word _GY            ; GY
   .word __40           ; @
   .word _GETW          ; GETW
   .word _LIVE          ; LIVE
   .word __3D           ; =
; Проверяем, жива ли сама клетка (стек: n is_alive )
   .word _OVER          ; OVER
; ( n is_alive n )
; Дублируем n для проверок
; Правила Жизни:
; Если клетка жива (is_alive = TRUE):
;   Выживает, если n=2 или n=3
; Если клетка мертва:
;   Рождается, если n=3
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
; ( n n -- )
; Клетка жива
   .word _DUP           ; DUP
   .word _2             ; 2
   .word __3D           ; =
   .word _SWAP          ; SWAP
   .word _LIT,0x3       ; 3
   .word __3D           ; =
   .word _OR            ; OR
; ( n (2|3) )
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _LIVE          ; LIVE
   .word _BRANCH,@B3    ; BRANCH @B3
@B2:
   .word _DEAD          ; DEAD
@B3:
   .word _BRANCH,@B4    ; BRANCH @B4
@B1:
; ( n -- )
; Клетка мертва
   .word _LIT,0x3       ; 3
   .word __3D           ; =
   .word __3FBRANCH,@B5 ; ?BRANCH @B5
   .word _LIVE          ; LIVE
   .word _BRANCH,@B6    ; BRANCH @B6
@B5:
   .word _DEAD          ; DEAD
@B6:
@B4:
; Записываем результат в видеопамять
   .word _GX            ; GX
   .word __40           ; @
   .word _GY            ; GY
   .word __40           ; @
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _VIDMEM        ; VIDMEM
   .word __2B           ; +
   .word _C_21          ; C!
   .word _EXIT          ; EXIT

; Один шаг эволюции
NFA_GENERATION:
   .byte 10,"GENERATION"
   .word NFA_PROCESS_2DCELL
_GENERATION:
   call _FCALL
; ( -- )
   .word _HEIGHT        ; HEIGHT
   .word _0             ; 0
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _WIDTH         ; WIDTH
   .word _0             ; 0
   .word __28_3FDO_29,@B4 ; (?DO) @B4
@B3:
   .word _J             ; J
   .word _I             ; I
   .word _PROCESS_2DCELL; PROCESS-CELL
; J = Y, I = X
   .word __28LOOP_29,@B3 ; (LOOP) @B3
@B4:
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
; После отрисовки копируем видеопамять обратно в буфер WORLD
   .word _VIDMEM        ; VIDMEM
   .word _WORLD         ; WORLD
   .word _SIZE          ; SIZE
   .word _CMOVE         ; CMOVE
   .word _EXIT          ; EXIT

; ===========================================
; Инициализация и запуск
; ===========================================
; Очистка буфера и экрана, установка начальной конфигурации
NFA_INIT:
   .byte 4,"INIT"
   .word NFA_GENERATION
_INIT:
   call _FCALL
; ( -- )
; Заполняем пробелами
   .word _WORLD         ; WORLD
   .word _SIZE          ; SIZE
   .word _DEAD          ; DEAD
   .word _FILL          ; FILL
   .word _VIDMEM        ; VIDMEM
   .word _SIZE          ; SIZE
   .word _DEAD          ; DEAD
   .word _FILL          ; FILL
; Рисуем планер (Glider) в центре экрана
; Координаты примерно (10, 10)
   .word _LIT,0xA       ; A
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _WORLD         ; WORLD
   .word __2B           ; +
   .word _LIVE          ; LIVE
   .word _SWAP          ; SWAP
   .word _C_21          ; C!
; (10, 10)
   .word _LIT,0xB       ; B
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _WORLD         ; WORLD
   .word __2B           ; +
   .word _LIVE          ; LIVE
   .word _SWAP          ; SWAP
   .word _C_21          ; C!
; (11, 10)
   .word _LIT,0xC       ; C
   .word _LIT,0xA       ; A
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _WORLD         ; WORLD
   .word __2B           ; +
   .word _LIVE          ; LIVE
   .word _SWAP          ; SWAP
   .word _C_21          ; C!
; (12, 10)
   .word _LIT,0xC       ; C
   .word _LIT,0x9       ; 9
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _WORLD         ; WORLD
   .word __2B           ; +
   .word _LIVE          ; LIVE
   .word _SWAP          ; SWAP
   .word _C_21          ; C!
; (12, 9)
   .word _LIT,0xB       ; B
   .word _LIT,0x8       ; 8
   .word _WIDTH         ; WIDTH
   .word __2A           ; *
   .word __2B           ; +
   .word _WORLD         ; WORLD
   .word __2B           ; +
   .word _LIVE          ; LIVE
   .word _SWAP          ; SWAP
   .word _C_21          ; C!
; (11, 8)
; Выводим стартовую конфигурацию на экран
   .word _WORLD         ; WORLD
   .word _VIDMEM        ; VIDMEM
   .word _SIZE          ; SIZE
   .word _CMOVE         ; CMOVE
   .word _EXIT          ; EXIT

; Главный цикл
NFA_LIFE:
   .byte 4,"LIFE"
   .word NFA_INIT
_LIFE:
   call _FCALL
; ( -- )
   .word _INIT          ; INIT
@B1:
   .word _GENERATION    ; GENERATION
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
