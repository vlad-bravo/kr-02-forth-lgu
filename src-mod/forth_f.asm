.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "FORTH_F" FREE

.DEF PREV_NFA PREV_NFA_FORTH_F
.DEF PREFIX PREFIX_FORTH_F

; Слова FORTH написанные на FORTH
NFA "HERE"
   call _FCALL
   .word _H             ; H
   .word __40           ; @
   .word _EXIT          ; EXIT

NFA "CR"
   call _FCALL
   .word _LIT,0xA       ; A
   .word _EMIT          ; EMIT
   .word _LIT,0xD       ; D
   .word _EMIT          ; EMIT
   .word __3EOUT        ; >OUT
   .word _0_21          ; 0!
   .word _EXIT          ; EXIT

NFA2 "(.\")", "_28_2E_22_29"
   call _FCALL
   .word _R_40          ; R@
   .word _COUNT         ; COUNT
   .word _DUP           ; DUP
   .word _1_2B          ; 1+
   .word _R_3E          ; R>
   .word __2B           ; +
   .word __3ER          ; >R
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA "ERASE"
   call _FCALL
   .word _0             ; 0
   .word _FILL          ; FILL
   .word _EXIT          ; EXIT

NFA2 "?STACK", "_3FSTACK"
   call _FCALL
   .word _SP_40         ; SP@
   .word _S0            ; S0
   .word __40           ; @
   .word _SWAP          ; SWAP
   .word _U_3C          ; U<
   .word __28ABORT_22_29; (ABORT")
   .byte 16
   .stringmap russian,"ИCЧEPПAHИE CTEKA"
   .word _EXIT          ; EXIT

NFA "LEAVE"
   call _FCALL
   .word _RDROP         ; RDROP
   .word _RDROP         ; RDROP
   .word _RDROP         ; RDROP
   .word _EXIT          ; EXIT

NFA "DEPTH"
   call _FCALL
   .word _SP_40         ; SP@
   .word _S0            ; S0
   .word __40           ; @
   .word _SWAP          ; SWAP
   .word __2D           ; -
   .word _2_2F          ; 2/
   .word _0             ; 0
   .word _MAX           ; MAX
   .word _EXIT          ; EXIT

NFA "STR"
   call _FCALL
   .word _DUP           ; DUP
   .word _ID_2E         ; ID.
   .word _LIT, 0x22     ; C" "
   .word _EMIT          ; EMIT
   .word _SPACE         ; SPACE
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word _1_2B          ; 1+
   .word __2B           ; +
   .word _EXIT          ; EXIT

NFA "SMUDGE"
   call _FCALL
   .word _LATEST        ; LATEST
   .word _LIT,0x40      ; 40
   .word _TOGGLE        ; TOGGLE
   .word _EXIT          ; EXIT

NFA2 "(!CODE)", "_28_21CODE_29"
   call _FCALL
   .word _LATEST        ; LATEST
   .word _NAME_3E       ; NAME>
   .word __21CF         ; !CF
   .word _EXIT          ; EXIT

NFA2 "!CF", "_21CF"
   call _FCALL
   .word _LIT,0xCD      ; CD
   .word _OVER          ; OVER
   .word _C_21          ; C!
   .word _1_2B          ; 1+
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "ALLOT"
   call _FCALL
   .word _H             ; H
   .word __2B_21        ; +!
   .word _EXIT          ; EXIT

NFA2 ",", "_2C"
   call _FCALL
   .word _HERE          ; HERE
   .word _2             ; 2
   .word _ALLOT         ; ALLOT
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA2 "C,", "C_2C"
   call _FCALL
   .word _HERE          ; HERE
   .word _1             ; 1
   .word _ALLOT         ; ALLOT
   .word _C_21          ; C!
   .word _EXIT          ; EXIT

NFA2 "\",", "_22_2C"
   call _FCALL
   .word _HERE          ; HERE
   .word _OVER          ; OVER
   .word _C_40          ; C@
   .word _1_2B          ; 1+
   .word _DUP           ; DUP
   .word _ALLOT         ; ALLOT
   .word _CMOVE         ; CMOVE
   .word _EXIT          ; EXIT

NFA "PAD"
   call _FCALL
; ( ---> А )
   .word _HERE          ; HERE
   .word _LIT,0x40      ; 40
   .word __2B           ; +
   .word _EXIT          ; EXIT

NFA "COUNT"
   call _FCALL
   .word _DUP           ; DUP
   .word _1_2B          ; 1+
   .word _SWAP          ; SWAP
   .word _C_40          ; C@
   .word _EXIT          ; EXIT

NFA "COMPILE"
   call _FCALL
   .word _R_3E          ; R>
   .word _DUP           ; DUP
   .word _2_2B          ; 2+
   .word __3ER          ; >R
   .word __40           ; @
   .word __2C           ; ,
   .word _EXIT          ; EXIT

NFA "ABORT"
   call _FCALL
   .word _LIT,l6002     ; l6002
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
@B1:
   .word _S0            ; S0
   .word __40           ; @
   .word _SP_21         ; SP!
   .word _QUIT          ; QUIT
   .word _EXIT          ; EXIT

NFA2 "(ABORT\")", "_28ABORT_22_29"
   call _FCALL
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _HERE          ; HERE
   .word _ID_2E         ; ID.
   .word _SPACE         ; SPACE
   .word _R_3E          ; R>
   .word _ID_2E         ; ID.
   .word _ABORT         ; ABORT
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _R_3E          ; R>
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word _1_2B          ; 1+
   .word __2B           ; +
   .word __3ER          ; >R
@B2:
   .word _EXIT          ; EXIT

NFA2 "#>", "_23_3E"
   call _FCALL
; ( DD ---> A,N )
   .word _2DROP         ; 2DROP
   .word _HLD           ; HLD
   .word __40           ; @
   .word _PAD           ; PAD
   .word _OVER          ; OVER
   .word __2D           ; -
   .word _EXIT          ; EXIT

NFA2 "<#", "_3C_23"
   call _FCALL
; ( ---> )
   .word _PAD           ; PAD
   .word _HLD           ; HLD
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "HOLD"
   call _FCALL
; ( С ---> )
   .word _HLD           ; HLD
   .word _1_2D_21       ; 1-!
   .word _HLD           ; HLD
   .word __40           ; @
   .word _C_21          ; C!
   .word _EXIT          ; EXIT

NFA "SIGN"
   call _FCALL
; ( A ---> )
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _LIT, 0x2d     ; C" -
   .word _HOLD          ; HOLD
@B1:
   .word _EXIT          ; EXIT

NFA2 ">DIG", "_3EDIG"
   call _FCALL
   .word _LIT,0x9       ; 9
   .word _OVER          ; OVER
   .word _U_3C          ; U<
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _LIT,0x37      ; 37
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _LIT,0x30      ; 30
@B2:
   .word __2B           ; +
   .word _EXIT          ; EXIT

NFA2 "#", "_23"
   call _FCALL
   .word _BASE          ; BASE
   .word __40           ; @
   .word _0             ; 0
   .word _DU_2FMOD      ; DU/MOD
   .word _ROT           ; ROT
   .word _DROP          ; DROP
   .word _ROT           ; ROT
   .word __3EDIG        ; >DIG
   .word _HOLD          ; HOLD
   .word _EXIT          ; EXIT

NFA2 "#.", "_23_2E"
   call _FCALL
   .word _BASE          ; BASE
   .word __40           ; @
   .word _U_2FMOD       ; U/MOD
   .word _SWAP          ; SWAP
   .word __3EDIG        ; >DIG
   .word _HOLD          ; HOLD
   .word _EXIT          ; EXIT

NFA2 "#.S", "_23_2ES"
   call _FCALL
@B1:
   .word __23_2E        ; #.
   .word _DUP           ; DUP
   .word _0_3D          ; 0=
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXIT          ; EXIT

NFA2 "#S", "_23S"
   call _FCALL
; ( DD ---> 0,0 )
@B1:
   .word __23           ; #
   .word _2DUP          ; 2DUP
   .word _OR            ; OR
   .word _0_3D          ; 0=
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXIT          ; EXIT

NFA2 "<>", "_3C_3E"
   call _FCALL
   .word __3D           ; =
   .word _0_3D          ; 0=
   .word _EXIT          ; EXIT

NFA2 "D.R", "D_2ER"
   call _FCALL
   .word __3ER          ; >R
   .word _DUP           ; DUP
   .word __3ER          ; >R
   .word _DABS          ; DABS
   .word __3C_23        ; <#
   .word __23S          ; #S
   .word _R_3E          ; R>
   .word _SIGN          ; SIGN
   .word __23_3E        ; #>
   .word _R_3E          ; R>
   .word _OVER          ; OVER
   .word __2D           ; -
   .word _SPACES        ; SPACES
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA2 "D.", "D_2E"
   call _FCALL
   .word _DUP           ; DUP
   .word __3ER          ; >R
   .word _DABS          ; DABS
   .word __3C_23        ; <#
   .word __23S          ; #S
   .word _R_3E          ; R>
   .word _SIGN          ; SIGN
   .word __23_3E        ; #>
   .word _TYPE          ; TYPE
   .word _SPACE         ; SPACE
   .word _EXIT          ; EXIT

NFA2 ".R", "_2ER"
   call _FCALL
   .word __3ER          ; >R
   .word _DUP           ; DUP
   .word __3ER          ; >R
   .word _ABS           ; ABS
   .word __3C_23        ; <#
   .word __23_2ES       ; #.S
   .word _R_3E          ; R>
   .word _SIGN          ; SIGN
   .word _0             ; 0
   .word __23_3E        ; #>
   .word _R_3E          ; R>
   .word _OVER          ; OVER
   .word __2D           ; -
   .word _SPACES        ; SPACES
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA2 ".0", "_2E0"
   call _FCALL
   .word __3ER          ; >R
   .word __3C_23        ; <#
   .word __23_2ES       ; #.S
   .word _0             ; 0
   .word __23_3E        ; #>
   .word _R_3E          ; R>
   .word _OVER          ; OVER
   .word __2D           ; -
   .word _0             ; 0
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _LIT, 0x30     ; C" 0
   .word _EMIT          ; EMIT
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA2 ".", "_2E"
   call _FCALL
   .word _DUP           ; DUP
   .word __3ER          ; >R
   .word _ABS           ; ABS
   .word __3C_23        ; <#
   .word __23_2ES       ; #.S
   .word _R_3E          ; R>
   .word _SIGN          ; SIGN
   .word _0             ; 0
   .word __23_3E        ; #>
   .word _TYPE          ; TYPE
   .word _SPACE         ; SPACE
   .word _EXIT          ; EXIT

NFA2 "U.", "U_2E"
   call _FCALL
   .word _0             ; 0
   .word _D_2E          ; D.
   .word _EXIT          ; EXIT

NFA2 ">BODY", "_3EBODY"
   call _FCALL
   .word _CFL           ; CFL
   .word __2B           ; +
   .word _EXIT          ; EXIT

NFA2 "BODY>", "BODY_3E"
   call _FCALL
   .word _CFL           ; CFL
   .word __2D           ; -
   .word _EXIT          ; EXIT

NFA2 ">NAME", "_3ENAME"
   call _FCALL
   .word _2_2D          ; 2-
   .word _1_2D          ; 1-
   .word _TRAVERSE      ; TRAVERSE
   .word _EXIT          ; EXIT

NFA2 "NAME>", "NAME_3E"
   call _FCALL
   .word _1             ; 1
   .word _TRAVERSE      ; TRAVERSE
   .word _2_2B          ; 2+
   .word _EXIT          ; EXIT

NFA2 ">LINK", "_3ELINK"
   call _FCALL
   .word _2_2D          ; 2-
   .word _EXIT          ; EXIT

NFA2 "LINK>", "LINK_3E"
   call _FCALL
   .word _2_2B          ; 2+
   .word _EXIT          ; EXIT

NFA2 "N>LINK", "N_3ELINK"
   call _FCALL
   .word _1             ; 1
   .word _TRAVERSE      ; TRAVERSE
   .word _EXIT          ; EXIT

NFA2 "L>NAME", "L_3ENAME"
   call _FCALL
   .word __2D1          ; -1
   .word _TRAVERSE      ; TRAVERSE
   .word _EXIT          ; EXIT

NFA2 ">PRT", "_3EPRT"
   call _FCALL
   .word _LIT,0x7F      ; 7F
   .word _MAX           ; MAX
   .word _BL            ; BL
   .word _MAX           ; MAX
   .word _EXIT          ; EXIT

NFA "PTYPE"
   call _FCALL
   .word _0             ; 0
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word __3EPRT        ; >PRT
   .word _EMIT          ; EMIT
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

NFA "EMIT"
   call _FCALL
   .word _LIT,l600e     ; l600e
   .word __40           ; @
   .word _EXECUTE       ; EXECUTE
   .word __3EOUT        ; >OUT
   .word _1_2B_21       ; 1+!
   .word _EXIT          ; EXIT

NFA "KEY"
   call _FCALL
   .word _LIT,l600c     ; l600c
   .word __40           ; @
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT

NFA "HEX"
   call _FCALL
   .word _LIT,0x10      ; 10
   .word _BASE          ; BASE
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "DECIMAL"
   call _FCALL
   .word _LIT,0xA       ; A
   .word _BASE          ; BASE
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "BLANK"
   call _FCALL
   .word _BL            ; BL
   .word _FILL          ; FILL
   .word _EXIT          ; EXIT

NFA "SPACE"
   call _FCALL
   .word _BL            ; BL
   .word _EMIT          ; EMIT
   .word _EXIT          ; EXIT

NFA "SPACES"
   call _FCALL
   .word _0             ; 0
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _SPACE         ; SPACE
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _EXIT          ; EXIT

NFA2 "ID.", "ID_2E"
   call _FCALL
   .word _COUNT         ; COUNT
   .word _LIT,0x3F      ; 3F
   .word _AND           ; AND
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

NFA "DEFINITIONS"
   call _FCALL
   .word _CONTEXT       ; CONTEXT
   .word __40           ; @
   .word _CURRENT       ; CURRENT
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "LATEST"
   call _FCALL
   .word _CURRENT       ; CURRENT
   .word __40           ; @
   .word __40           ; @
   .word _EXIT          ; EXIT

NFA2 ";S", "_3BS"
   call _FCALL
   .word _RDROP         ; RDROP
   .word _EXIT          ; EXIT

NFA2 ">CH", "_3ECH"
   call _FCALL
   .word __3EIN         ; >IN
   .word __40           ; @
   .word _DUP           ; DUP
   .word __23TIB        ; #TIB
   .word __40           ; @
   .word _U_3C          ; U<
   .word _N_3FBRANCH,@B1 ; N?BRANCH @B1
   .word _DROP          ; DROP
   .word _FALSE         ; FALSE
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _TIB           ; TIB
   .word __2B           ; +
   .word _C_40          ; C@
   .word __3EIN         ; >IN
   .word _1_2B_21       ; 1+!
   .word _TRUE          ; TRUE
@B2:
   .word _EXIT          ; EXIT

NFA "TYPE"
   call _FCALL
   .word _LIT,l6012     ; l6012
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT
@B1:
   .word _0             ; 0
   .word __28_3FDO_29,@B3 ; (?DO) @B3
@B2:
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word _EMIT          ; EMIT
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B2 ; (LOOP) @B2
@B3:
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

NFA "TITLE"
   call _FCALL
   .word _CR            ; CR
   .word __28_2E_22_29  ; (.")
   .byte 34
   .stringmap russian,"ФOPT-7970 BEPCИЯ 6.2 OT 19.06.85  "
   .word __28_2E_22_29  ; (.")
   .byte 19
   .stringmap russian,"(CTAHДAPT FORTH-83)"
   .word _CR            ; CR
   .word __28_2E_22_29  ; (.")
   .byte 43
   .stringmap russian,"    B.A.KИPИЛЛИH A.A.KЛУБOBИЧ H.P.HOЗДPУHOB"
   .word _CR            ; CR
   .word _LIT,0x14      ; 14
   .word _SPACES        ; SPACES
   .word __28_2E_22_29  ; (.")
   .byte 7
   .stringmap russian,"BЦ  ЛГУ"
   .word _CR            ; CR
   .word __28_2E_22_29  ; (.")
   .byte 50
   .stringmap russian,"198904 ЛEHИHГPAД ПETPOДBOPEЦ БИБЛИOTEЧHAЯ ПЛ. Д. 2"
   .word _CR            ; CR
   .word _LIT,l600a     ; l600a
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
@B1:
   .word _EXIT          ; EXIT

NFA2 "FORTH-83", "FORTH_2D83"
   call _FCALL
   .word _CR            ; CR
   .word __28_2E_22_29  ; (.")
   .byte 17
   .stringmap russian,"CTAHДAPT FORTH-83"
   .word _EXIT          ; EXIT

NFA "STANDIO"
   call _FCALL
   .word _LIT,l6014     ; l6014
   .word __40           ; @
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _EXECUTE       ; EXECUTE
   .word _EXIT          ; EXIT
@B1:
   .word _LIT,_QUERY    ; [COMPILE] QUERY
   .word _INLINP        ; INLINP
   .word __21           ; !
   .word __23TIB        ; #TIB
   .word _0_21          ; 0!
   .word __3EIN         ; >IN
   .word _0_21          ; 0!
   .word _LIT,__28KEY_29; [COMPILE] (KEY)
   .word _LIT,l600c     ; l600c
   .word __21           ; !
   .word _LIT,__28EMIT_29; [COMPILE] (EMIT)
   .word _LIT,l600e     ; l600e
   .word __21           ; !
   .word _EXIT          ; EXIT

.ENDS
