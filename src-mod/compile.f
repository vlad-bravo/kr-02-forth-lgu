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

: PR-CELL ( A -- )
  DUP
  COUNTNEIGHBORS
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
  DUP B 8 WIDTH * + VIDMEM + C! \ (11, 8)

  DUP 1A B WIDTH * + VIDMEM + C! \ (10, 10)
  DUP 1B B WIDTH * + VIDMEM + C! \ (11, 10)
  DUP 1C B WIDTH * + VIDMEM + C! \ (12, 10)
  DUP 1A A WIDTH * + VIDMEM + C! \ (12, 9)
  DUP 1B 9 WIDTH * + VIDMEM + C! \ (11, 8)

  DUP A 1A WIDTH * + VIDMEM + C! \ (10, 10)
  DUP B 1A WIDTH * + VIDMEM + C! \ (11, 10)
  DUP C 1A WIDTH * + VIDMEM + C! \ (12, 10)
  DUP C 19 WIDTH * + VIDMEM + C! \ (12, 9)
  DUP B 18 WIDTH * + VIDMEM + C! \ (11, 8)

  DROP
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
