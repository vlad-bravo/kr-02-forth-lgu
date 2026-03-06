\ Утилиты

: DUMP2
  BASE @ -ROT HEX 10 U/ 1+ 0
  DO
    CR DUP DUP 4 .0 SPACE SPACE 4 0
    DO
      4 0
      DO
        DUP C@ 2 .0 SPACE 1+
      LOOP
      SPACE
    LOOP
    SWAP C" * EMIT 10 PTYPE C" * EMIT
  LOOP
  DROP BASE !
;

: NLIST2
  BEGIN
    @ DUP IF LEAVE THEN
    DUP COUNT 3F AND DUP 8 / 1+ 8 * OVER - -ROT TYPE SPACES N>LINK
    \ >OUT @ 63 U< IFNOT CR THEN
  AGAIN
  DROP
;

: VLIST2
  CONTEXT @ NLIST2
;

: --
  #TIB @ >IN !
; IMMEDIATE

: DISFORT2
  CR >R R@ C@ CD <>
  IF
    R> ?NAME2 ." ACCEMБЛEPHOE OПPEДEЛEHИE"
    EXIT
  THEN
  R@ 1+ @ DUP CALL =
  IF \ ?BRANCH @3F16
    ." : "
    DROP R> DUP ?NAME2 CFL +
    BEGIN \ @3E65:
      DUP @ [COMPILE] EXIT <>
      IF \ ?BRANCH @3F0A
        DUP DUP @ [COMPILE] (") =
        IF
          C" " EMIT SPACE 2+ STR
        ELSE
          DUP @ [COMPILE] (.") =
          IF
            C" . EMIT C" " EMIT SPACE 2+ STR
          ELSE
            DUP @ [COMPILE] (ABORT") =
            IF
              ." ABORT" C" " EMIT 2+ STR
            ELSE
              DUP @ [COMPILE] LIT =
              IF
                ." LIT " 2+ DUP @ ?NAME2 2+
              ELSE
                DUP @ ?NAME2 2+
              THEN
            THEN
          THEN
        THEN
      THEN
    AGAIN \ BRANCH @3E65
\ @3F0A:
    ." ;" CR DROP
  ELSE \ BRANCH @3F7C \ @3F16:
    R> ?NAME2 DUP NEXT =
    IF \ ?BRANCH @3F38
    ." - ПEPEMEHHAЯ "
    ELSE \ BRANCH @3F7C \ @3F38:
      [COMPILE] @ =
      IF \ ?BRANCH @3F56
        ." - KOHCTAHTA  "
      ELSE \ BRANCH @3F7C \ @3F56:
        ." - OПPEДEЛEHИE ЧEPEЗ CREATE - DOES> "
\ @3F7C:
      THEN
    THEN
  THEN
;

: ?NAME2
  F-CODE OVER U< OVER F-DATA 3000 + U< AND
  IF
    DUP 2- 1- 10 1
    DO
      1- DUP C@ 7F AND I =
      IF
        PRESS ID. SPACE RDROP RDROP RDROP EXIT
      THEN
    LOOP
    DROP .
  ELSE
    .
  THEN
;
