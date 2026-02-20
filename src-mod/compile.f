\ Определение слов для последующей компиляции

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
