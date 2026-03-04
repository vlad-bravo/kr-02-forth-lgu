\ Слова FORTH написанные на FORTH

: HERE
  H @
;

: CR
  A EMIT D EMIT >OUT 0!
;

: (.")
  R@ COUNT DUP 1+ R> + >R TYPE
;

: ERASE
  0 FILL
;

: ?STACK
  SP@ S0 @ SWAP U<
  ABORT" ИCЧEPПAHИE CTEKA"
;

: LEAVE
  RDROP RDROP RDROP
;

: DEPTH
  SP@ S0 @ SWAP - 2/ 0 MAX
;

: STR
  DUP ID. C" " EMIT SPACE
  DUP C@ 1+ +
;

: SMUDGE
  LATEST 40 TOGGLE
;

: (!CODE)
  LATEST NAME> !CF
;

: !CF
  CD OVER C! 1+ !
;

: ALLOT
  H +!
;

: ,
  HERE 2 ALLOT !
;

: C,
  HERE 1 ALLOT C!
;

: ",
  HERE OVER C@ 1+ DUP ALLOT CMOVE
;

: PAD ( ---> А )
  HERE 40 +
;

: COUNT
  DUP 1+ SWAP C@
;

: COMPILE
  R> DUP 2+ >R @ ,
;

: ABORT
  l6002 @ ?DUP IF EXECUTE THEN
  S0 @ SP! QUIT
;

: (ABORT")
  IF
    HERE ID. SPACE R> ID. ABORT
  ELSE
    R> DUP C@ 1+ + >R
  THEN
;

: #> ( DD ---> A,N )
  2DROP HLD @ PAD OVER -
;

: <# ( ---> )
  PAD HLD !
;

: HOLD ( С ---> )
  HLD 1-! HLD @ C!
;

: SIGN ( A ---> )
  0< IF C" - HOLD THEN
;

: >DIG
  9 OVER U< IF 37 ELSE 30 THEN +
;

: #
  BASE @ 0 DU/MOD ROT DROP ROT >DIG HOLD
;

: #.
  BASE @ U/MOD SWAP >DIG HOLD
;

: #.S
  REPEAT #. DUP 0= UNTIL
;

: #S ( DD ---> 0,0 )
  REPEAT # 2DUP OR 0= UNTIL
;

: <>
  = 0=
;

: D.R
  >R DUP >R DABS <# #S R> SIGN #> R> OVER - SPACES TYPE
;

: D.
  DUP >R DABS <# #S R> SIGN #> TYPE SPACE
;

: .R
  >R DUP >R ABS <# #.S R> SIGN 0 #> R> OVER - SPACES TYPE
;

: .0
  >R <# #.S 0 #> R> OVER - 0 DO C" 0 EMIT LOOP TYPE
;

: .
  DUP >R ABS <# #.S R> SIGN 0 #> TYPE SPACE
;

: U.
  0 D.
;

: >BODY
  CFL +
;

: BODY>
  CFL -
;

: >NAME
  2- 1- TRAVERSE
;

: NAME>
  1 TRAVERSE 2+
;

: >LINK
  2-
;

: LINK>
  2+
;

: N>LINK
  1 TRAVERSE
;

: L>NAME
  -1 TRAVERSE
;

: >PRT
  7F MAX BL MAX
;

: PTYPE
  0 DO
    DUP C@ >PRT EMIT 1+
  LOOP
  DROP
;

: EMIT
  l600e @ EXECUTE >OUT 1+!
;

: KEY
  l600c @ EXECUTE
;

: HEX
  10 BASE !
;

: DECIMAL
  A BASE !
;

: BLANK
  BL FILL
;

: SPACE
  BL EMIT
;

: SPACES
  0 DO SPACE LOOP
;

: ID.
  COUNT 3F AND TYPE
;

: DEFINITIONS
  CONTEXT @ CURRENT !
;

: LATEST
  CURRENT @ @
;

: ;S
  RDROP
;

: >CH
  >IN @ DUP #TIB @ U<
  IFNOT
    DROP FALSE
  ELSE
    TIB + C@ >IN 1+! TRUE
  THEN
;

: TYPE
  l6012 @ ?DUP IF EXECUTE EXIT THEN
  0 DO DUP C@ EMIT 1+ LOOP
  DROP
;

: TITLE
  CR ." ФOPT-7970 BEPCИЯ 6.2 OT 19.06.85  " ." (CTAHДAPT FORTH-83)"
  CR ."     B.A.KИPИЛЛИH A.A.KЛУБOBИЧ H.P.HOЗДPУHOB"
  CR 14 SPACES ." BЦ  ЛГУ"
  CR ." 198904 ЛEHИHГPAД ПETPOДBOPEЦ БИБЛИOTEЧHAЯ ПЛ. Д. 2"
  CR l600a @ ?DUP IF EXECUTE THEN
;

: FORTH-83
  CR ." CTAHДAPT FORTH-83"
;

: STANDIO
  l6014 @ ?DUP IF EXECUTE EXIT THEN
  [COMPILE] QUERY INLINP !
  #TIB 0!
  >IN 0!
  [COMPILE] (KEY) l600c !
  [COMPILE] (EMIT) l600e !
;
