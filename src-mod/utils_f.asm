.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "UTILS_F" FREE

.DEF PREV_NFA PREV_NFA_UTILS_F
.DEF PREFIX PREFIX_UTILS_F

; Утилиты
NFA "DUMP2"
   call _FCALL
   .word _BASE          ; BASE
   .word __40           ; @
   .word __2DROT        ; -ROT
   .word _HEX           ; HEX
   .word _LIT,0x10      ; 10
   .word _U_2F          ; U/
   .word _1_2B          ; 1+
   .word _0             ; 0
   .word __28_3FDO_29,@B2 ; (?DO) @B2
@B1:
   .word _CR            ; CR
   .word _DUP           ; DUP
   .word _DUP           ; DUP
   .word _LIT,0x4       ; 4
   .word __2E0          ; .0
   .word _SPACE         ; SPACE
   .word _SPACE         ; SPACE
   .word _LIT,0x4       ; 4
   .word _0             ; 0
   .word __28_3FDO_29,@B4 ; (?DO) @B4
@B3:
   .word _LIT,0x4       ; 4
   .word _0             ; 0
   .word __28_3FDO_29,@B6 ; (?DO) @B6
@B5:
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word _2             ; 2
   .word __2E0          ; .0
   .word _SPACE         ; SPACE
   .word _1_2B          ; 1+
   .word __28LOOP_29,@B5 ; (LOOP) @B5
@B6:
   .word _SPACE         ; SPACE
   .word __28LOOP_29,@B3 ; (LOOP) @B3
@B4:
   .word _SWAP          ; SWAP
   .word _LIT, 0x2a     ; C" *
   .word _EMIT          ; EMIT
   .word _LIT,0x10      ; 10
   .word _PTYPE         ; PTYPE
   .word _LIT, 0x2a     ; C" *
   .word _EMIT          ; EMIT
   .word __28LOOP_29,@B1 ; (LOOP) @B1
@B2:
   .word _DROP          ; DROP
   .word _BASE          ; BASE
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "NLIST2"
   call _FCALL
@B1:
   .word __40           ; @
   .word _DUP           ; DUP
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _LEAVE         ; LEAVE
@B2:
   .word _DUP           ; DUP
   .word _COUNT         ; COUNT
   .word _LIT,0x3F      ; 3F
   .word _AND           ; AND
   .word _DUP           ; DUP
   .word _LIT,0x8       ; 8
   .word __2F           ; /
   .word _1_2B          ; 1+
   .word _LIT,0x8       ; 8
   .word __2A           ; *
   .word _OVER          ; OVER
   .word __2D           ; -
   .word __2DROT        ; -ROT
   .word _TYPE          ; TYPE
   .word _SPACES        ; SPACES
   .word _N_3ELINK      ; N>LINK
; >OUT @ 63 U< IFNOT CR THEN
   .word _BRANCH,@B1    ; BRANCH @B1
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

NFA "VLIST2"
   call _FCALL
   .word _CONTEXT       ; CONTEXT
   .word __40           ; @
   .word _NLIST2        ; NLIST2
   .word _EXIT          ; EXIT

NFA2 "--2", "_2D_2D2"
   call _FCALL
   .word __23TIB        ; #TIB
   .word __40           ; @
   .word __3EIN         ; >IN
   .word __21           ; !
   .word _EXIT          ; EXIT

NFA "DISFORT2"
   call _FCALL
   .word _CR            ; CR
   .word __3ER          ; >R
   .word _R_40          ; R@
   .word _C_40          ; C@
   .word _LIT,0xCD      ; CD
   .word __3C_3E        ; <>
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _R_3E          ; R>
   .word __3FNAME2      ; ?NAME2
   .word __28_2E_22_29  ; (.")
   .byte 24
   .stringmap russian,"ACCEMБЛEPHOE OПPEДEЛEHИE"
   .word _EXIT          ; EXIT
@B1:
   .word _R_40          ; R@
   .word _1_2B          ; 1+
   .word __40           ; @
   .word _DUP           ; DUP
   .word _CALL          ; CALL
   .word __3D           ; =
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
; ?BRANCH @3F16
   .word __28_2E_22_29  ; (.")
   .byte 2
   .stringmap russian,": "
   .word _DROP          ; DROP
   .word _R_3E          ; R>
   .word _DUP           ; DUP
   .word __3FNAME2      ; ?NAME2
   .word _CFL           ; CFL
   .word __2B           ; +
; @3E65:
   .word _DUP           ; DUP
   .word __40           ; @
   .word _LIT           ; LIT
   .word _EXIT          ; EXIT
   .word __3C_3E        ; <>
   .word __3FBRANCH,@B3 ; ?BRANCH @B3
; ?BRANCH @3F0A
   .word _DUP           ; DUP
   .word _DUP           ; DUP
   .word __40           ; @
   .word _LIT           ; LIT
   .word __28_22_29     ; (")
   .word __3D           ; =
   .word __3FBRANCH,@B4 ; ?BRANCH @B4
; ?BRANCH @3E93
   .word _LIT, 0x22     ; C" "
   .word _EMIT          ; EMIT
   .word _SPACE         ; SPACE
   .word _2_2B          ; 2+
   .word _STR           ; STR
   .word _BRANCH,@B5    ; BRANCH @B5
@B4:
; BRANCH @3F06
; @3E93:
   .word _DUP           ; DUP
   .word __40           ; @
   .word _LIT           ; LIT
   .word __28_2E_22_29  ; (.")
   .word __3D           ; =
   .word __3FBRANCH,@B6 ; ?BRANCH @B6
; ?BRANCH @3EB7
   .word _LIT, 0x2e     ; C" .
   .word _EMIT          ; EMIT
   .word _LIT, 0x22     ; C" "
   .word _EMIT          ; EMIT
   .word _SPACE         ; SPACE
   .word _2_2B          ; 2+
   .word _STR           ; STR
   .word _BRANCH,@B7    ; BRANCH @B7
@B6:
; BRANCH @3F06
; @3EB7:
   .word _DUP           ; DUP
   .word __40           ; @
   .word _LIT           ; LIT
   .word __28ABORT_22_29; (ABORT")
   .word __3D           ; =
   .word __3FBRANCH,@B8 ; ?BRANCH @B8
; ?BRANCH @3EDB
   .word __28_2E_22_29  ; (.")
   .byte 5
   .stringmap russian,"ABORT"
   .word _LIT, 0x22     ; C" "
   .word _EMIT          ; EMIT
   .word _2_2B          ; 2+
   .word _STR           ; STR
   .word _BRANCH,@B9    ; BRANCH @B9
@B8:
; BRANCH @3F06
; @3EDB:
   .word _DUP           ; DUP
   .word __40           ; @
   .word _LIT           ; LIT
   .word _LIT           ; LIT
   .word __3D           ; =
   .word __3FBRANCH,@B10 ; ?BRANCH @B10
; ?BRANCH @3EFE
   .word __28_2E_22_29  ; (.")
   .byte 4
   .stringmap russian,"LIT "
   .word _2_2B          ; 2+
   .word _DUP           ; DUP
   .word __40           ; @
   .word __3FNAME2      ; ?NAME2
   .word _2_2B          ; 2+
   .word _BRANCH,@B11    ; BRANCH @B11
@B10:
; BRANCH @3F06
; @3EFE:
   .word _DUP           ; DUP
   .word __40           ; @
   .word __3FNAME2      ; ?NAME2
   .word _2_2B          ; 2+
   .word _BRANCH,@B12    ; BRANCH @B12
@B11:
; @3F06:
; BRANCH @3E65
; @3F0A:
   .word __28_2E_22_29  ; (.")
   .byte 1
   .stringmap russian,";"
   .word _CR            ; CR
   .word _DROP          ; DROP
   .word _BRANCH,@B13    ; BRANCH @B13
@B12:
; BRANCH @3F7C
; @3F16:
   .word _R_3E          ; R>
   .word __3FNAME2      ; ?NAME2
   .word _DUP           ; DUP
   .word _NEXT          ; NEXT
   .word __3D           ; =
   .word __3FBRANCH,@B14 ; ?BRANCH @B14
; ?BRANCH @3F38
   .word __28_2E_22_29  ; (.")
   .byte 13
   .stringmap russian,"- ПEPEMEHHAЯ "
   .word _BRANCH,@B15    ; BRANCH @B15
@B14:
; BRANCH @3F7C
; @3F38:
   .word _LIT           ; LIT
   .word __40           ; @
   .word __3D           ; =
   .word __3FBRANCH,@B16 ; ?BRANCH @B16
; ?BRANCH @3F56
   .word __28_2E_22_29  ; (.")
   .byte 13
   .stringmap russian,"- KOHCTAHTA  "
   .word _BRANCH,@B17    ; BRANCH @B17
@B16:
; BRANCH @3F7C
; @3F56:
   .word __28_2E_22_29  ; (.")
   .byte 35
   .stringmap russian,"- OПPEДEЛEHИE ЧEPEЗ CREATE - DOES> "
; @3F7C:
@B17:
@B15:
@B13:
   .word _EXIT          ; EXIT

NFA2 "?NAME2", "_3FNAME2"
   call _FCALL
   .word _F_2DCODE      ; F-CODE
   .word _OVER          ; OVER
   .word _U_3C          ; U<
   .word _OVER          ; OVER
   .word _F_2DDATA      ; F-DATA
   .word _LIT,0x3000    ; 3000
   .word __2B           ; +
   .word _U_3C          ; U<
   .word _AND           ; AND
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DUP           ; DUP
   .word _2_2D          ; 2-
   .word _1_2D          ; 1-
   .word _LIT,0x10      ; 10
   .word _1             ; 1
   .word __28_3FDO_29,@B3 ; (?DO) @B3
@B2:
   .word _1_2D          ; 1-
   .word _DUP           ; DUP
   .word _C_40          ; C@
   .word _LIT,0x7F      ; 7F
   .word _AND           ; AND
   .word _I             ; I
   .word __3D           ; =
   .word __3FBRANCH,@B4 ; ?BRANCH @B4
   .word _PRESS         ; PRESS
   .word _ID_2E         ; ID.
   .word _SPACE         ; SPACE
   .word _RDROP         ; RDROP
   .word _RDROP         ; RDROP
   .word _RDROP         ; RDROP
   .word _EXIT          ; EXIT
@B4:
   .word __28LOOP_29,@B2 ; (LOOP) @B2
@B3:
   .word _DROP          ; DROP
   .word __2E           ; .
   .word _BRANCH,@B5    ; BRANCH @B5
@B1:
   .word __2E           ; .
@B5:
   .word _EXIT          ; EXIT

.ENDS
