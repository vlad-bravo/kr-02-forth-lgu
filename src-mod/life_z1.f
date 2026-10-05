( ---------------------------------------------- )
(   ИГРА "ЖИЗНЬ" - FORTH-83                      )
(   Экран: видеопамять 7CC0h..7FFFh, 1024 байта  )
(   Поле 64x16, замкнуто в тор                   )
(   Запуск: LIFE   Останов: клавиша прерывания   )
( ---------------------------------------------- )

DECIMAL

64 CONSTANT WDT       ( ширина поля )
16 CONSTANT HGT       ( высота поля )
31936 CONSTANT VIDEO  ( 7CC0h - видеопамять )

42 CONSTANT LIVE  ( '*' - живая клетка, мертвая - пробел BL )

CREATE NXT WDT HGT * ALLOT  ( буфер следующего поколения )

VARIABLE CX  VARIABLE CY   ( клетка при подсчете соседей )
VARIABLE SEED              ( для случайного заполнения )
VARIABLE SPEED  100 SPEED !  ( пауза между поколениями )

( Смещение ячейки с закольцовкой краев. )
( В FORTH-83 MOD делит с округлением к -бесконечности, )
( поэтому -1 64 MOD = 63 - края считаются сами )
: OFF ( x y -- n )
   HGT MOD WDT * SWAP WDT MOD + ;

: ALIVE? ( x y -- f )  ( клетка жива? координаты в пределах поля )
   WDT * + VIDEO + C@ LIVE = ;

: DOT ( x y -- )  ( зажечь клетку на экране )
   OFF VIDEO + LIVE SWAP C! ;

( Число живых соседей клетки )
: NEIGH ( x y -- n )
   CY ! CX !
   0
   2 -1 DO            ( dy = -1,0,1 )
      2 -1 DO         ( dx = -1,0,1 )
         J I OR IF    ( центр пропускаем )
            CX @ I + WDT MOD
            CY @ J + HGT MOD
            ALIVE? IF 1+ THEN
         THEN
      LOOP
   LOOP ;

( Одно поколение: читаем экран, новое пишем в NXT, )
( затем одним CMOVE возвращаем на экран )
: STEP ( -- )
   HGT 0 DO
      WDT 0 DO
         I J NEIGH          ( соседи )
         DUP 3 = >R         ( n=3 - родится? )
         2 =                ( n=2 - выживает... )
         I J ALIVE? AND     ( ...если сейчас жива )
         R> OR
         IF LIVE ELSE BL THEN
         I J WDT * + NXT + C!
      LOOP
   LOOP
   NXT VIDEO WDT HGT * CMOVE ;

( ---------- фигуры ---------- )

: BLINKER ( x y -- )   ( мигалка из трех клеток )
   2DUP DOT OVER 1+ OVER DOT OVER 2+ OVER DOT 2DROP ;

: GLIDER ( x y -- )    ( глайдер, летит вправо-вниз )
   OVER 1+  OVER DOT        ( .O. )
   OVER 2+  OVER 1+ DOT     ( ..O )
   2DUP 2+  DOT             ( OOO )
   OVER 1+  OVER 2+ DOT
   OVER 2+  OVER 2+ DOT
   2DROP ;

: R-PENT ( x y -- )    ( R-пентомино - долгая "каша" )
   OVER 1+  OVER DOT        ( .OO )
   OVER 2+  OVER DOT        ( OO. )
   2DUP 1+  DOT             ( .O. )
   OVER 1+  OVER 1+ DOT
   OVER 1+  OVER 2+ DOT
   2DROP ;

( Случайное заполнение - по желанию )
: RND ( -- u )
   SEED @ 25173 * 13849 + DUP SEED ! ;

: RNDINIT ( -- )
   VIDEO WDT HGT * BL FILL
   HGT 0 DO WDT 0 DO
      RND 3 MOD 0= IF I J DOT THEN
   LOOP LOOP ;

( Стартовая конфигурация: очистка экрана + фигуры )
: INIT ( -- )
   VIDEO WDT HGT * BL FILL
   2  2  GLIDER
   22 3  GLIDER
   42 2  GLIDER
   12 12 BLINKER
   30 12 BLINKER
   48 12 BLINKER
   28 6  R-PENT ;

: PAUSE ( -- )
   SPEED @ 0 DO LOOP ;

( Главный цикл )
: LIFE ( -- )
   INIT PAUSE          ( показать стартовую конфигурацию )
   BEGIN
      STEP
      PAUSE
      ?TERMINAL        ( нажата клавиша прерывания? )
   UNTIL ;
