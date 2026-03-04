\ Математика

: S>D
  DUP 0<
;

: M*
  2DUP XOR >R ABS SWAP ABS UM* R> 0< IF DNEGATE THEN
;

: /
  /MOD PRESS
;

: MOD
  /MOD DROP
;

: DABS
  DUP 0< IF DNEGATE THEN
;

: U/
  U/MOD PRESS
;

: UM/MOD
  0 DU/MOD DROP PRESS
;

: M/MOD
  ?DUP
  IF
    DUP >R 2DUP XOR >R >R DABS R@ ABS UM/MOD SWAP R> 0< IF NEGATE THEN
    SWAP R> 0<
    IF
      NEGATE OVER
      IF
        1- R@ ROT - SWAP
      THEN
    THEN
    RDROP
  THEN
;

: */MOD
  >R M* R> M/MOD
;

: */
  */MOD PRESS
;
