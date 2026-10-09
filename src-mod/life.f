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

\ Анализ состояния ячейки
\ Добавление адреса ячейки в массивы зарождающихся или умирающих ячеек
: PR-CELL ( A -- )
  DUP            ( A A )
  COUNTNEIGHBORS ( A N )
  OVER C@ LIVE = ( A N IsLive )
    
  IF       \ Клетка жива
    DUP 2 = SWAP 3 = OR
    IF DROP ELSE PDEAD @ DUP 2+ PDEAD ! ! THEN
  ELSE     \ Клетка мертва
    3 = IF PLIVE @ DUP 2+ PLIVE ! ! ELSE DROP THEN
  THEN
;

: LIFE ( -- )
  \ Заполняем пробелами
  VIDMEM SIZE DEAD FILL
  \ Начальная сцена
  INIT-STAGE
  \ 0 1 DO 355 113 / DROP LOOP
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
    \ PLIVE @ SLIVE DO 2B I @ C! 2 +LOOP
    \ PDEAD @ SDEAD DO 2D I @ C! 2 +LOOP
    \ 500 0 DO 355 113 / DROP LOOP
    PLIVE @ SLIVE DO LIVE I @ C! 2 +LOOP
    PDEAD @ SDEAD DO DEAD I @ C! 2 +LOOP
    \ 1B EMIT C" Y EMIT 0 EMIT 0 EMIT PLIVE @ . PDEAD @ .
  AGAIN
;

: LIFE2 ( -- )
  \ Заполняем пробелами
  VIDMEM SIZE DEAD FILL
  \ Начальная сцена
  INIT-STAGE
  \ 0 1 DO 355 113 / DROP LOOP
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
        DUP COUNT-NEIGHBORS 1+
      LOOP
      2+ \ Пропуск последней ячейки текущей строки и первой ячейки следующей строки
    LOOP
    DROP

    \ Отображение подготовленных данных о рождённых и умерших ячейках
    \ PLIVE @ SLIVE DO 2B I @ C! 2 +LOOP
    \ PDEAD @ SDEAD DO 2D I @ C! 2 +LOOP
    \ 500 0 DO 355 113 / DROP LOOP
    PLIVE @ SLIVE DO LIVE I @ C! 2 +LOOP
    PDEAD @ SDEAD DO DEAD I @ C! 2 +LOOP
    \ 1B EMIT C" Y EMIT 0 EMIT 0 EMIT PLIVE @ . PDEAD @ .
  AGAIN
;

: LIFE3 ( -- )
  \ Заполняем пробелами
  VIDMEM SIZE DEAD FILL
  \ Начальная сцена
  INIT-STAGE
  \ 0 1 DO 355 113 / DROP LOOP
  \ Первая ячейка поля - во второй строке, первой колонке
  VIDMEM WIDTH +
  BEGIN
    \ Указатели на массивы зарождающихся и умирающих ячеек
    SLIVE PLIVE !
    SDEAD PDEAD !

    \ Обработка поля кроме крайних строк и колонок
    DUP
    WIDTH 2 DO
      DUP PR-COLUMN 1+
    LOOP
    DROP

    \ Отображение подготовленных данных о рождённых и умерших ячейках
    \ PLIVE @ SLIVE DO C" + I @ C! 2 +LOOP
    \ PDEAD @ SDEAD DO C" - I @ C! 2 +LOOP
    \ 500 0 DO 355 113 / DROP LOOP

    PLIVE @ SLIVE DO LIVE I @ C! 2 +LOOP
    PDEAD @ SDEAD DO DEAD I @ C! 2 +LOOP

    \ \ Отладочная печать указателей
    \ \ 1B EMIT C" Y EMIT 0 EMIT 0 EMIT PLIVE @ . PDEAD @ .

    \ Очищаем мусор в верхней строке
    VIDMEM WIDTH DEAD FILL
  AGAIN
;

\ Всегда последнее слово (для правильной цепочки NFA)
: BYE F800 EXECUTE ;
