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

: STANDIO
  l6014 @ ?DUP IF EXECUTE EXIT THEN
  [COMPILE] QUERY INLINP !
  #TIB 0!
  >IN 0!
  [COMPILE] (KEY) l600c !
  [COMPILE] (EMIT) l600e !
;
