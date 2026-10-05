( ========================================================== )
(  ИГРА "ЖИЗНЬ" -- клеточный автомат Дж. Х. Конвея           )
(  Стандарт: Forth-83                                        )
(  Поле -- видеопамять 7CC0..7FFF (832 байта):               )
(  знаковый экран 32 x 26, 1 байт = 1 клетка.                )
(  Запуск: LIFE        Останов: любая клавиша                )
( ========================================================== )

HEX
7CC0 CONSTANT SCREEN          ( начало видеопамяти )

DECIMAL
32 CONSTANT COLS              ( столбцов )
26 CONSTANT ROWS              ( строк )
COLS ROWS * CONSTANT VLEN     ( размер поля: 832 байт, 7CC0+340=8000 )
42 CONSTANT LIVE              ( символ живой клетки: "*" )
32 CONSTANT DEAD              ( символ пустой клетки: " " )

CREATE NEXTGEN VLEN ALLOT     ( буфер следующего поколения )

VARIABLE RR                   ( текущая строка  )
VARIABLE CC                   ( текущий столбец )
VARIABLE DELAY     0 DELAY !  ( пауза между поколениями )
VARIABLE RND     1234 RND !   ( генератор случайных чисел )

: -ROT   ROT ROT ;            ( a b c -- c a b )

( ---------------- экран и фигуры ---------------- )

: CLS  ( -- )                 ( очистить всё поле )
   SCREEN VLEN DEAD FILL ;

: CELL  ( r c -- addr )       ( адрес клетки )
   SWAP COLS * + SCREEN + ;

: SET   ( r c -- )            ( зажечь клетку )
   CELL LIVE SWAP C! ;

: AT    ( r c -- )            ( начало координат фигуры )
   CC ! RR ! ;

: DOT   ( dr dc -- )          ( точка фигуры со смещением )
   SWAP RR @ + SWAP CC @ + SET ;

: GLIDER ( r c -- )           ( планер, летит вправо-вниз )
   AT 0 1 DOT 1 2 DOT 2 0 DOT 2 1 DOT 2 2 DOT ;

: RPENT ( r c -- )            ( R-пентомино )
   AT 0 1 DOT 0 2 DOT 1 0 DOT 1 1 DOT 2 1 DOT ;

: SEED ( -- )                 ( очистка экрана + стартовая позиция )
   CLS
   11 14 RPENT
   2 3 GLIDER
   5 25 GLIDER ;

: RND1 ( -- u )               ( псевдослучайное число )
   RND @ 25173 * 13849 + DUP RND ! ;

: SOUP ( -- )                 ( случайная начальная каша, p=1/6 )
   CLS
   ROWS 0 DO
      COLS 0 DO
         RND1 10923 U< IF J I SET THEN
      LOOP
   LOOP ;

( ---------------- правила игры ---------------- )

: ALIVE? ( r c -- 0|1 )       ( 1, если клетка жива )
   CELL C@ LIVE = IF 1 ELSE 0 THEN ;

: WRAP ( n limit -- n' )      ( замкнуть индекс: -1 -> limit-1, limit -> 0 )
   OVER 0< IF SWAP DROP 1- EXIT THEN
   2DUP = IF 2DROP 0 ELSE DROP THEN ;

: COUNT9 ( r c -- n )         ( живых в квадрате 3x3, включая центр )
   CC ! RR ! 0
   2 -1 DO                    ( dr = J: -1, 0, +1 )
      2 -1 DO                 ( dc = I: -1, 0, +1 )
         RR @ J + ROWS WRAP
         CC @ I + COLS WRAP
         ALIVE? +
      1 +LOOP
   1 +LOOP ;

: NEIGHBORS ( r c -- n )      ( число живых соседей )
   2DUP COUNT9 -ROT ALIVE? - ;

: NEXTSTATE ( n self -- 0|1 ) ( правило Конвея )
   SWAP DUP 3 =               ( 3 соседа -- рождение )
   IF 2DROP 1
   ELSE DUP 2 =               ( 2 соседа -- выживание )
      IF DROP
      ELSE 2DROP 0
      THEN
   THEN ;

: CELLNEXT ( r c -- 0|1 )     ( состояние клетки в новом поколении )
   2DUP ALIVE? -ROT NEIGHBORS SWAP NEXTSTATE ;

( ---------------- смена поколений ---------------- )

: STEP ( -- )                 ( вычислить и вывести поколение )
   ROWS 0 DO
      COLS 0 DO
         J I CELLNEXT
         IF LIVE ELSE DEAD THEN
         NEXTGEN J COLS * I + + C!
      LOOP
   LOOP
   NEXTGEN SCREEN VLEN CMOVE ;

( ---------------- запуск ---------------- )

: CLEARKEY ( -- )             ( выбросить накопленные коды клавиш )
   BEGIN ?TERMINAL WHILE KEY DROP REPEAT ;

: WAIT ( -- )                 ( пауза между поколениями )
   DELAY @ DUP 0= IF DROP ELSE 0 DO LOOP THEN ;

: RUN ( u -- )                ( u поколений, выход по клавише )
   CLEARKEY
   0 DO
      STEP WAIT
      ?TERMINAL IF KEY DROP LEAVE THEN
   LOOP ;

: LIFE ( -- )                 ( очистить экран и играть до клавиши )
   CLEARKEY
   SEED
   BEGIN
      STEP WAIT ?TERMINAL
   UNTIL
   KEY DROP ;
