.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "INTERPRET_F" FREE

.DEF PREV_NFA PREV_NFA_INTERPRET_F
.DEF PREFIX PREFIX_INTERPRET_F

;\ Интерактивные
NFA "INTERPRET"
   call _FCALL
   .word _LIT,l6004     ; l6004
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT
@B1:
@B2:
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word _FIND          ; FIND
   .word _DUP           ; DUP
   .word __3FBRANCH,@B3 ; ?BRANCH @B3
   .word _0_3C          ; 0<
   .word _STATE         ; STATE
   .word __40           ; @
   .word _AND           ; AND
   .word __3FBRANCH,@B4 ; ?BRANCH @B4
   .word __2C           ; ,
   .word _BRANCH,@B5    ; BRANCH @B5
@B4:
   .word _EXECUTE       ; EXECUTE
@B5:
   .word _BRANCH,@B6    ; BRANCH @B6
@B3:
   .word _DROP          ; DROP
   .word _NUMBER        ; NUMBER
   .word _DPL           ; DPL
   .word __40           ; @
   .word _1_2B          ; 1+
   .word __3FBRANCH,@B7 ; ?BRANCH @B7
   .word _DLITERAL      ; DLITERAL
   .word _BRANCH,@B8    ; BRANCH @B8
@B7:
   .word _DROP          ; DROP
   .word _LITERAL       ; LITERAL
@B8:
@B6:
   .word __3FSTACK      ; ?STACK
   .word _BRANCH,@B2    ; BRANCH @B2
   .word _EXIT          ; EXIT

NFA "FIND"
   call _FCALL
   .word _LIT,l6006     ; l6006
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT
@B1:
   .word _CONTEXT       ; CONTEXT
   .word __40           ; @
   .word __3FWORD       ; ?WORD
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _TRUE          ; TRUE
   .word _BRANCH,@B3    ; BRANCH @B3
@B2:
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word _DUP           ; DUP
   .word _CONTEXT       ; CONTEXT
   .word __40           ; @
   .word __3D           ; =
   .word _N_3FBRANCH,@B4 ; N?BRANCH @B4
   .word __3FWORD       ; ?WORD
   .word _BRANCH,@B5    ; BRANCH @B5
@B4:
   .word _DROP          ; DROP
   .word _FALSE         ; FALSE
@B5:
@B3:
   .word __3FBRANCH,@B6 ; ?BRANCH @B6
   .word _DUP           ; DUP
   .word _NAME_3E       ; NAME>
   .word _SWAP          ; SWAP
   .word _C_40          ; C@
   .word _LIT,0x80      ; 80
   .word _AND           ; AND
   .word __3FBRANCH,@B7 ; ?BRANCH @B7
   .word _1             ; 1
   .word _BRANCH,@B8    ; BRANCH @B8
@B7:
   .word __2D1          ; -1
@B8:
   .word _BRANCH,@B9    ; BRANCH @B9
@B6:
   .word _FALSE         ; FALSE
@B9:
   .word _EXIT          ; EXIT

NFA2 "LITERAL", "LITERAL", IMMEDIATE
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _LIT           ; COMPILE LIT
   .word __2C           ; ,
@B1:
   .word _EXIT          ; EXIT

NFA2 "DLITERAL", "DLITERAL", IMMEDIATE
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DLIT          ; COMPILE DLIT
   .word __2C           ; ,
   .word __2C           ; ,
@B1:
   .word _EXIT          ; EXIT

NFA "IMMEDIATE"
   call _FCALL
   .word _LATEST        ; LATEST
   .word _LIT,0x80      ; 80
   .word _TOGGLE        ; TOGGLE
   .word _EXIT          ; EXIT

NFA "QUIT"
   call _FCALL
   .word _LIT,l6000     ; l6000
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
@B1:
   .word _R0            ; R0
   .word __40           ; @
   .word _RP_21         ; RP!
   .word _STANDIO       ; STANDIO
   .word _CR            ; CR
   .word __5B           ; [
   .word _FORTH         ; FORTH
   .word _DEFINITIONS   ; DEFINITIONS
@B2:
   .word _INTERPRET     ; INTERPRET
   .word _BRANCH,@B2    ; BRANCH @B2
   .word _EXIT          ; EXIT

NFA "PROMPT"
   call _FCALL
; ( -- )
;\ Режим трансляции
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _LIT, 0x43     ; C" C
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _LIT, 0x49     ; C" I
@B2:
   .word _EMIT          ; EMIT
;\ Система счисления
   .word _BASE          ; BASE
   .word __40           ; @
   .word _DUP           ; DUP
   .word _DECIMAL       ; DECIMAL
   .word _2             ; 2
   .word __2ER          ; .R
   .word _BASE          ; BASE
   .word __21           ; !
;\ Галочка и пробел
   .word _LIT, 0x3e     ; C" >
   .word _EMIT          ; EMIT
   .word _SPACE         ; SPACE
   .word _EXIT          ; EXIT

NFA "QUERY"
   call _FCALL
   .word _CR            ; CR
   .word _PROMPT        ; PROMPT
;\ C" > EMIT
   .word _TIB           ; TIB
   .word _LIT,0x4F      ; 4F
   .word _EXPECT        ; EXPECT
   .word _CR            ; CR
   .word _TIB           ; TIB
   .word _SPAN          ; SPAN
   .word __40           ; @
   .word _0             ; 0
   .word _TRUE          ; TRUE
   .word _EXIT          ; EXIT

NFA "VARIABLE"
   call _FCALL
   .word _CREATE        ; CREATE
   .word _0             ; 0
   .word __2C           ; ,
   .word _NEXT          ; NEXT
   .word __28_21CODE_29 ; (!CODE)
   .word _EXIT          ; EXIT

NFA "CONSTANT"
   call _FCALL
   .word _CREATE        ; CREATE
   .word __2C           ; ,
   .word _LIT,__40      ; [COMPILE] @
   .word __28_21CODE_29 ; (!CODE)
   .word _EXIT          ; EXIT

NFA2 "DOES>", "DOES_3E", IMMEDIATE
   call _FCALL
   .word __28DOES_3E_29 ; COMPILE (DOES>)
   .word _CALL          ; CALL
   .word _HERE          ; HERE
   .word __21CF         ; !CF
   .word _CFL           ; CFL
   .word _ALLOT         ; ALLOT
   .word _EXIT          ; EXIT

NFA2 "(DOES>)", "_28DOES_3E_29"
   call _FCALL
   .word _R_3E          ; R>
   .word __28_21CODE_29 ; (!CODE)
   .word _EXIT          ; EXIT

NFA2 "<BUILDS", "_3CBUILDS"
   call _FCALL
   .word _CREATE        ; CREATE
   .word _EXIT          ; EXIT

NFA "CREATE"
   call _FCALL
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word _DUP           ; DUP
   .word _FIND          ; FIND
   .word _PRESS         ; PRESS
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DUP           ; DUP
   .word _ID_2E         ; ID.
   .word __28_2E_22_29  ; (.")
   .byte 15
   .stringmap russian," УЖE OПPEДEЛEH "
   .word _CR            ; CR
@B1:
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word __2BWORD       ; +WORD
   .word _CFL           ; CFL
   .word _ALLOT         ; ALLOT
   .word _EXIT          ; EXIT

NFA2 "'", "_27"
   call _FCALL
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word _FIND          ; FIND
   .word _0_3D          ; 0=
   .word __28ABORT_22_29; (ABORT")
   .byte 3
   .stringmap russian,"-? "
   .word _EXIT          ; EXIT

NFA2 "-WORD", "_2DWORD"
   call _FCALL
   .word __3FWORD       ; ?WORD
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _N_3ELINK      ; N>LINK
   .word __40           ; @
   .word _W_2DLINK      ; W-LINK
   .word __40           ; @
   .word __21           ; !
   .word _TRUE          ; TRUE
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _DROP          ; DROP
   .word _FALSE         ; FALSE
@B2:
   .word _EXIT          ; EXIT

NFA2 "+WORD", "_2BWORD"
   call _FCALL
   .word _HERE          ; HERE
   .word _ROT           ; ROT
   .word __22_2C        ; ",
   .word _SWAP          ; SWAP
   .word _DUP           ; DUP
   .word __40           ; @
   .word __2C           ; ,
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "?CURRENT", "_3FCURRENT"
   call _FCALL
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word __3FWORD       ; ?WORD
   .word _0_3D          ; 0=
   .word __28ABORT_22_29; (ABORT")
   .byte 4
   .stringmap russian," -? "
   .word _EXIT          ; EXIT

NFA2 "?PAIRS", "_3FPAIRS"
   call _FCALL
   .word _XOR           ; XOR
   .word __28ABORT_22_29; (ABORT")
   .byte 16
   .stringmap russian," HEПAPHAЯ CKOБKA"
   .word _EXIT          ; EXIT

NFA2 "?COMP", "_3FCOMP"
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word _0_3D          ; 0=
   .word __28ABORT_22_29; (ABORT")
   .byte 26
   .stringmap russian," TPEБУET PEЖИMA KOMПИЛЯЦИИ"
   .word _EXIT          ; EXIT

NFA2 "?EXEC", "_3FEXEC"
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word __28ABORT_22_29; (ABORT")
   .byte 26
   .stringmap russian," TPEБУET PEЖИMA BЫПOЛHEHИЯ"
   .word _EXIT          ; EXIT

NFA2 "!CSP", "_21CSP"
   call _FCALL
   .word _SP_40         ; SP@
   .word _CSP           ; CSP
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "?CSP", "_3FCSP"
   call _FCALL
   .word _SP_40         ; SP@
   .word _CSP           ; CSP
   .word __40           ; @
   .word _XOR           ; XOR
   .word __28ABORT_22_29; (ABORT")
   .byte 17
   .stringmap russian,"CБOЙ CTEKA ПO CSP"
   .word _EXIT          ; EXIT

NFA2 ":", "_3A", IMMEDIATE
   call _FCALL
   .word __3FEXEC       ; ?EXEC
   .word __21CSP        ; !CSP
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word _CONTEXT       ; CONTEXT
   .word __21           ; !
   .word _CREATE        ; CREATE
   .word _SMUDGE        ; SMUDGE
   .word __5D           ; ]
   .word _CALL          ; CALL
   .word __28_21CODE_29 ; (!CODE)
   .word _EXIT          ; EXIT

NFA2 ";", "_3B", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __3FCSP        ; ?CSP
   .word _EXIT          ; COMPILE EXIT
   .word _SMUDGE        ; SMUDGE
   .word __5B           ; [
   .word _EXIT          ; EXIT

NFA2 "[", "_5B", IMMEDIATE
   call _FCALL
   .word _STATE         ; STATE
   .word _0_21          ; 0!
   .word _EXIT          ; EXIT

NFA2 "]", "_5D"
   call _FCALL
   .word __2D1          ; -1
   .word _STATE         ; STATE
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "NEW", "NEW", IMMEDIATE
   call _FCALL
   .word __3FEXEC       ; ?EXEC
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word _DUP           ; DUP
   .word __3FCURRENT    ; ?CURRENT
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word __3ER          ; >R
   .word _DUP           ; DUP
   .word _N_3ELINK      ; N>LINK
   .word _CURRENT       ; CURRENT
   .word __21           ; !
   .word _NAME_3E       ; NAME>
   .word _SWAP          ; SWAP
   .word __3FCURRENT    ; ?CURRENT
   .word _NAME_3E       ; NAME>
   .word _LIT,0xCD      ; CD
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word __21           ; !
   .word _R_3E          ; R>
   .word _CURRENT       ; CURRENT
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "JOIN", "JOIN", IMMEDIATE
   call _FCALL
   .word __3FEXEC       ; ?EXEC
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word __3FCURRENT    ; ?CURRENT
   .word _N_3ELINK      ; N>LINK
   .word __40           ; @
   .word _LATEST        ; LATEST
   .word _N_3ELINK      ; N>LINK
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "SCRATCH", "SCRATCH", IMMEDIATE
   call _FCALL
   .word __3FEXEC       ; ?EXEC
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word __2DWORD       ; -WORD
   .word _0_3D          ; 0=
   .word __28ABORT_22_29; (ABORT")
   .byte 4
   .stringmap russian," - ?"
   .word _EXIT          ; EXIT

NFA2 "(", "_28", IMMEDIATE
   call _FCALL
   .word _LIT, 0x29     ; C" )
   .word _WORD          ; WORD
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

NFA2 "[COMPILE]", "_5BCOMPILE_5D", IMMEDIATE
   call _FCALL
   .word __27           ; '
   .word __2C           ; ,
   .word _EXIT          ; EXIT

NFA2 "[']", "_5B_27_5D", IMMEDIATE
   call _FCALL
   .word __27           ; '
   .word _LITERAL       ; LITERAL
   .word _EXIT          ; EXIT

NFA2 "ABORT\"", "ABORT_22", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __28ABORT_22_29; COMPILE (ABORT")
   .word _LIT, 0x22     ; C" "
   .word _WORD          ; WORD
   .word __22_2C        ; ",
   .word _EXIT          ; EXIT

NFA2 "C\"", "C_22", IMMEDIATE
   call _FCALL
   .word _BL            ; BL
   .word _WORD          ; WORD
   .word _1_2B          ; 1+
   .word _C_40          ; C@
   .word _LITERAL       ; LITERAL
   .word _EXIT          ; EXIT

NFA2 ".\"", "_2E_22", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __28_2E_22_29  ; COMPILE (.")
   .word _LIT, 0x22     ; C" "
   .word _WORD          ; WORD
   .word __22_2C        ; ",
   .word _EXIT          ; EXIT

NFA2 "\"", "_22", IMMEDIATE
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word __28_22_29     ; COMPILE (")
   .word _LIT, 0x22     ; C" "
   .word _WORD          ; WORD
   .word __22_2C        ; ",
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _LIT, 0x22     ; C" "
   .word _WORD          ; WORD
   .word _PAD           ; PAD
   .word _OVER          ; OVER
   .word _C_40          ; C@
   .word _1_2B          ; 1+
   .word _CMOVE         ; CMOVE
   .word _PAD           ; PAD
@B2:
   .word _EXIT          ; EXIT

NFA2 ".(", "_2E_28", IMMEDIATE
   call _FCALL
   .word _LIT, 0x29     ; C" )
   .word _WORD          ; WORD
   .word _COUNT         ; COUNT
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA2 ">MARK", "_3EMARK"
   call _FCALL
   .word _HERE          ; HERE
   .word _0             ; 0
   .word __2C           ; ,
   .word _EXIT          ; EXIT

NFA2 ">RESOLVE", "_3ERESOLVE"
   call _FCALL
   .word _HERE          ; HERE
   .word _SWAP          ; SWAP
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "<MARK", "_3CMARK"
   call _FCALL
   .word _HERE          ; HERE
   .word _EXIT          ; EXIT

NFA2 "<RESOLVE", "_3CRESOLVE"
   call _FCALL
   .word __2C           ; ,
   .word _EXIT          ; EXIT

NFA2 "IF", "IF", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __3FBRANCH     ; COMPILE ?BRANCH
   .word __3EMARK       ; >MARK
   .word _2             ; 2
   .word _EXIT          ; EXIT

NFA2 "IFNOT", "IFNOT", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _N_3FBRANCH    ; COMPILE N?BRANCH
   .word __3EMARK       ; >MARK
   .word _2             ; 2
   .word _EXIT          ; EXIT

NFA2 "ELSE", "ELSE", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _2             ; 2
   .word __3FPAIRS      ; ?PAIRS
   .word _BRANCH        ; COMPILE BRANCH
   .word __3EMARK       ; >MARK
   .word _SWAP          ; SWAP
   .word __3ERESOLVE    ; >RESOLVE
   .word _2             ; 2
   .word _EXIT          ; EXIT

NFA2 "THEN", "THEN", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _2             ; 2
   .word __3FPAIRS      ; ?PAIRS
   .word __3ERESOLVE    ; >RESOLVE
   .word _EXIT          ; EXIT

NFA2 "BEGIN", "BEGIN", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __3CMARK       ; <MARK
   .word _1             ; 1
   .word _EXIT          ; EXIT

NFA2 "AGAIN", "AGAIN", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _1             ; 1
   .word __3FPAIRS      ; ?PAIRS
   .word _BRANCH        ; COMPILE BRANCH
   .word __3CRESOLVE    ; <RESOLVE
   .word _EXIT          ; EXIT

NFA2 "DO", "DO", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __28DO_29      ; COMPILE (DO)
   .word __3EMARK       ; >MARK
   .word __3CMARK       ; <MARK
   .word _LIT,0x3       ; 3
   .word _EXIT          ; EXIT

NFA2 "?DO", "_3FDO", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word __28_3FDO_29   ; COMPILE (?DO)
   .word __3EMARK       ; >MARK
   .word __3CMARK       ; <MARK
   .word _LIT,0x3       ; 3
   .word _EXIT          ; EXIT

NFA2 "LOOP", "LOOP", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _LIT,0x3       ; 3
   .word __3FPAIRS      ; ?PAIRS
   .word __28LOOP_29    ; COMPILE (LOOP)
   .word __3CRESOLVE    ; <RESOLVE
   .word __3ERESOLVE    ; >RESOLVE
   .word _EXIT          ; EXIT

NFA2 "+LOOP", "_2BLOOP", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _LIT,0x3       ; 3
   .word __3FPAIRS      ; ?PAIRS
   .word __28_2BLOOP_29 ; COMPILE (+LOOP)
   .word __3CRESOLVE    ; <RESOLVE
   .word __3ERESOLVE    ; >RESOLVE
   .word _EXIT          ; EXIT

NFA2 "UNTIL", "UNTIL", IMMEDIATE
   call _FCALL
   .word __3FCOMP       ; ?COMP
   .word _1             ; 1
   .word __3FPAIRS      ; ?PAIRS
   .word __3FBRANCH     ; COMPILE ?BRANCH
   .word __3CRESOLVE    ; <RESOLVE
   .word _EXIT          ; EXIT

NFA "STRING"
   call _FCALL
   .word _CREATE        ; CREATE
   .word __22_2C        ; ",
   .word _NEXT          ; NEXT
   .word __28_21CODE_29 ; (!CODE)
   .word _EXIT          ; EXIT

.ENDS
