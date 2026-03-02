\ Определение слов для последующей компиляции

: CORNERS
  41 76D0 !
  42 771D !
  43 7FA6 !
  44 7FF3 !
;

: FLD
\ Перебор всех ячеек экрана
\    HEIGHT 0 DO
\        WIDTH 0 DO
\            C" . J WIDTH * I + VIDMEM + C!
\        LOOP
\    LOOP

\ Перебор ячеек экрана по типам
\ A, B, C, D - по углам экрана
\ T, L, R, B - верхняя, левая, правая, нижняя границы
\ . - все внутренние ячейки
  C" A 76D0 C!
  WIDTH 1- 1 DO
    C" T I 76D0 + C!
  LOOP
  C" B 771D C!

  HEIGHT 1- 1 DO
    C" L I WIDTH * 76D0 + C!
    WIDTH 1- 1 DO
      C" . J WIDTH * I + 76D0 + C!
    LOOP
    C" R I WIDTH * 771D + C!
  LOOP

  C" C 7FA6 C!
  WIDTH 1- 1 DO
    C" B I 7FA6 + C!
  LOOP
  C" D 7FF3 C!
;

: CHECK-LIVE ( N A -- N' A )
  DUP C@ LIVE = IF SWAP 1+ SWAP THEN
;

\ Посчитать количество живых соседей для клетки с адресом A
: COUNT-NEIGHBORS ( A -- N )
  0 SWAP           \ N A
  WIDTH - CHECK-LIVE  \ Верхняя
       1- CHECK-LIVE  \ Верхняя левая
       2+ CHECK-LIVE  \ Верхняя правая
  WIDTH + CHECK-LIVE  \ Правая
       2- CHECK-LIVE  \ Левая
  WIDTH + CHECK-LIVE  \ Нижняя левая
       1+ CHECK-LIVE  \ Нижняя
       1+ CHECK-LIVE  \ Нижняя правая
  DROP
;

: PR-CELL ( A -- )
  DUP
  COUNT-NEIGHBORS
  OVER C@ LIVE =
    
  IF       \ Клетка жива
    DUP 2 = SWAP 3 = OR
    IF DROP ELSE PDEAD @ ! PDEAD @ 2+ PDEAD ! THEN
  ELSE     \ Клетка мертва
    3 = IF PLIVE @ ! PLIVE @ 2+ PLIVE ! ELSE DROP THEN
  THEN
;

: INIT
  \ Заполняем пробелами
  VIDMEM SIZE DEAD FILL
    
  \ Рисуем планер (Glider) в центре экрана
  \ Координаты примерно (10, 10)
  LIVE
  DUP A A WIDTH * + VIDMEM + C! \ (10, 10)
  DUP B A WIDTH * + VIDMEM + C! \ (11, 10)
  DUP C A WIDTH * + VIDMEM + C! \ (12, 10)
  DUP C 9 WIDTH * + VIDMEM + C! \ (12, 9)
      B 8 WIDTH * + VIDMEM + C! \ (11, 8)
;

: LIFE
  INIT
  BEGIN
    \ Указатели на стеки зарождающихся и умирающих ячеек
    SLIVE PLIVE !
    SDEAD PDEAD !
  \  C" A 76D0 C!
  \  WIDTH 1- 1 DO
  \    C" T I 76D0 + C!
  \  LOOP
  \  C" B 771D C!

    HEIGHT 1- 1 DO
  \    C" L I WIDTH * 76D0 + C!
      WIDTH 1- 1 DO
        J WIDTH * I + 76D0 + PR-CELL
      LOOP
  \    C" R I WIDTH * 771D + C!
    LOOP

  \  C" C 7FA6 C!
  \  WIDTH 1- 1 DO
  \    C" B I 7FA6 + C!
  \  LOOP
  \  C" D 7FF3 C!
    PLIVE @ SLIVE DO LIVE I @ C! 2 +LOOP
    PDEAD @ SDEAD DO DEAD I @ C! 2 +LOOP
  AGAIN
;

: HH ." HELLO, HABR!" COUNT TYPE ;

: PROMPT2 ( -- )
  \ Режим трансляции
  STATE @ IF C" C ELSE C" I THEN EMIT
  \ Система счисления
  BASE @ DUP DECIMAL 2 .R BASE !
  \ Галочка и пробел
  C" > EMIT SPACE
;

\ Всегда последнее слово (для правильной цепочки NFA)
: BYE F800 EXECUTE ;
