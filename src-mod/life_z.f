\ Определение слов для последующей компиляции

HEX

\ ===========================================
\ Константы и переменные
\ ===========================================
7CC0 CONSTANT VIDMEM  \ Начало видеопамяти
0340 CONSTANT SIZE    \ Размер экрана (832 байта)
20   CONSTANT WIDTH   \ Ширина (32 символа)
1A   CONSTANT HEIGHT  \ Высота (26 строк)
2A   CONSTANT LIVE    \ Символ '*' (живая клетка)
20   CONSTANT DEAD    \ Символ ' ' (мертвая клетка)

\ Создаем буфер в оперативной памяти для хранения текущего поколения
CREATE WORLD SIZE ALLOT

VARIABLE GX \ Координата X текущей клетки
VARIABLE GY \ Координата Y текущей клетки
VARIABLE GN \ Количество соседей

\ ===========================================
\ Вспомогательные слова
\ ===========================================

\ Нормализация координат (зацикливание экрана)
: WRAPX ( x -- x' )
    DUP WIDTH = IF DROP 0 THEN
    DUP 0< IF WIDTH + THEN ;

: WRAPY ( y -- y' )
    DUP HEIGHT = IF DROP 0 THEN
    DUP 0< IF HEIGHT + THEN ;

\ Получить значение клетки из буфера WORLD по координатам x, y
: GETW ( x y -- char )
    WRAPY WIDTH * SWAP WRAPX + WORLD + C@ ;

\ Проверить соседа и увеличить счетчик, если он жив
: CHECK-N ( x y -- )
    GETW LIVE = IF 1 GN +! THEN ;

\ Посчитать количество живых соседей для клетки с координатами GX, GY
: COUNT-NEIGHBORS ( -- n )
    0 GN !
    GX @ 1- GY @ 1- CHECK-N   \ Верхний левый
    GX @    GY @ 1- CHECK-N   \ Верхний
    GX @ 1+ GY @ 1- CHECK-N   \ Верхний правый
    GX @ 1- GY @    CHECK-N   \ Левый
    GX @ 1+ GY @    CHECK-N   \ Правый
    GX @ 1- GY @ 1+ CHECK-N   \ Нижний левый
    GX @    GY @ 1+ CHECK-N   \ Нижний
    GX @ 1+ GY @ 1+ CHECK-N   \ Нижний правый
    GN @ ;

\ ===========================================
\ Основная логика
\ ===========================================

\ Обработка одной клетки
: PROCESS-CELL ( x y -- )
    GY ! GX !                   \ Сохраняем координаты
    COUNT-NEIGHBORS             \ Считаем соседей (стек: n )
    GX @ GY @ GETW LIVE =       \ Проверяем, жива ли сама клетка (стек: n is_alive )
    
    OVER ( n is_alive n )       \ Дублируем n для проверок
    
    \ Правила Жизни:
    \ Если клетка жива (is_alive = TRUE):
    \   Выживает, если n=2 или n=3
    \ Если клетка мертва:
    \   Рождается, если n=3
    
    IF   ( n n -- )             \ Клетка жива
        DUP 2 = SWAP 3 = OR     \ ( n (2|3) )
        IF LIVE ELSE DEAD THEN
    ELSE ( n -- )               \ Клетка мертва
        3 = IF LIVE ELSE DEAD THEN
    THEN
    
    \ Записываем результат в видеопамять
    GX @ GY @ WIDTH * + VIDMEM + C! ;

\ Один шаг эволюции
: GENERATION ( -- )
    HEIGHT 0 DO
        WIDTH 0 DO
            J I PROCESS-CELL    \ J = Y, I = X
        LOOP
    LOOP
    \ После отрисовки копируем видеопамять обратно в буфер WORLD
    VIDMEM WORLD SIZE CMOVE ;

\ ===========================================
\ Инициализация и запуск
\ ===========================================

\ Очистка буфера и экрана, установка начальной конфигурации
: INIT ( -- )
    \ Заполняем пробелами
    WORLD SIZE DEAD FILL
    VIDMEM SIZE DEAD FILL
    
    \ Рисуем планер (Glider) в центре экрана
    \ Координаты примерно (10, 10)
    A A WIDTH * + WORLD + LIVE SWAP C! \ (10, 10)
    B A WIDTH * + WORLD + LIVE SWAP C! \ (11, 10)
    C A WIDTH * + WORLD + LIVE SWAP C! \ (12, 10)
    C 9 WIDTH * + WORLD + LIVE SWAP C! \ (12, 9)
    B 8 WIDTH * + WORLD + LIVE SWAP C! \ (11, 8)
    
    \ Выводим стартовую конфигурацию на экран
    WORLD VIDMEM SIZE CMOVE ;

\ Главный цикл
: LIFE ( -- )
    INIT
    BEGIN
        GENERATION
    AGAIN ;

\ Запуск игры
\ LIFE

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
