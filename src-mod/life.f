\ Определение слов для последующей компиляции

: FLD ( -- )
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
  VIDMEM
  C" A OVER C! 1+
  C" T SWAP
  WIDTH 2 DO
    2DUP C! 1+
  LOOP
  PRESS
  C" B OVER C! 1+

  HEIGHT 2 DO
    C" L OVER C! 1+
    C" . SWAP
    WIDTH 2 DO
      2DUP C! 1+
    LOOP
    PRESS
    C" R OVER C! 1+
  LOOP

  C" C OVER C! 1+
  C" B SWAP
  WIDTH 2 DO
    2DUP C! 1+
  LOOP
  PRESS
  C" D SWAP C!
;

: INIT ( -- )
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

  DUP 1A B WIDTH * + VIDMEM + C!
  DUP 1B B WIDTH * + VIDMEM + C!
  DUP 1C B WIDTH * + VIDMEM + C!
  DUP 1A A WIDTH * + VIDMEM + C!
  DUP 1B 9 WIDTH * + VIDMEM + C!

  DUP A 1A WIDTH * + VIDMEM + C!
  DUP B 1A WIDTH * + VIDMEM + C!
  DUP C 1A WIDTH * + VIDMEM + C!
  DUP C 19 WIDTH * + VIDMEM + C!
  DUP B 18 WIDTH * + VIDMEM + C!

  DROP
;

\ Анализ состояния ячейки
\ Добавление адреса ячейки в массивы зарождающихся или умирающих ячеек
: PR-CELL ( A -- )
  DUP            ( A A )
  COUNTNEIGHBORS ( A N )
  OVER C@ LIVE = ( A N IsLive )
    
  IF       \ Клетка жива
    DUP 2 = SWAP 3 = OR
    IF DROP ELSE PDEAD @ ! PDEAD @ 2+ PDEAD ! THEN
  ELSE     \ Клетка мертва
    3 = IF PLIVE @ ! PLIVE @ 2+ PLIVE ! ELSE DROP THEN
  THEN
;

: LIFE ( -- )
  INIT
  \ Первая ячейка поля - во второй строке, второй колонке
  VIDMEM WIDTH + 1+
  BEGIN
    \ Указатели на массивы зарождающихся и умирающих ячеек
    SLIVE PLIVE !
    SDEAD PDEAD !

    \ Обработка поля кроме крайних строк и колонок
    DUP
    HEIGHT 2 DO
      WIDTH 2 DO
        DUP PR-CELL 1+
      LOOP
      2+ \ Пропуск последней ячейки текущей строки и первой ячейки следующей строки
    LOOP
    DROP

    \ Отображение подготовленных данных о рождённых и умерших ячейках
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
