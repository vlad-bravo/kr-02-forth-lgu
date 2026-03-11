.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "MATH_F" FREE

.DEF PREV_NFA PREV_NFA_MATH_F
.DEF PREFIX PREFIX_MATH_F

;\ Математика
NFA2 "S>D", "S_3ED"
   call _FCALL
   .word _DUP           ; DUP
   .word _0_3C          ; 0<
   .word _EXIT          ; EXIT

NFA2 "M*", "M_2A"
   call _FCALL
   .word _2DUP          ; 2DUP
   .word _XOR           ; XOR
   .word __3ER          ; >R
   .word _ABS           ; ABS
   .word _SWAP          ; SWAP
   .word _ABS           ; ABS
   .word _UM_2A         ; UM*
   .word _R_3E          ; R>
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DNEGATE       ; DNEGATE
@B1:
   .word _EXIT          ; EXIT

NFA2 "/", "_2F"
   call _FCALL
   .word __2FMOD        ; /MOD
   .word _PRESS         ; PRESS
   .word _EXIT          ; EXIT

NFA "MOD"
   call _FCALL
   .word __2FMOD        ; /MOD
   .word _DROP          ; DROP
   .word _EXIT          ; EXIT

NFA "DABS"
   call _FCALL
   .word _DUP           ; DUP
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DNEGATE       ; DNEGATE
@B1:
   .word _EXIT          ; EXIT

NFA2 "U/", "U_2F"
   call _FCALL
   .word _U_2FMOD       ; U/MOD
   .word _PRESS         ; PRESS
   .word _EXIT          ; EXIT

NFA2 "UM/MOD", "UM_2FMOD"
   call _FCALL
   .word _0             ; 0
   .word _DU_2FMOD      ; DU/MOD
   .word _DROP          ; DROP
   .word _PRESS         ; PRESS
   .word _EXIT          ; EXIT

NFA2 "M/MOD", "M_2FMOD"
   call _FCALL
   .word __3FDUP        ; ?DUP
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _DUP           ; DUP
   .word __3ER          ; >R
   .word _2DUP          ; 2DUP
   .word _XOR           ; XOR
   .word __3ER          ; >R
   .word __3ER          ; >R
   .word _DABS          ; DABS
   .word _R_40          ; R@
   .word _ABS           ; ABS
   .word _UM_2FMOD      ; UM/MOD
   .word _SWAP          ; SWAP
   .word _R_3E          ; R>
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B2 ; ?BRANCH @B2
   .word _NEGATE        ; NEGATE
@B2:
   .word _SWAP          ; SWAP
   .word _R_3E          ; R>
   .word _0_3C          ; 0<
   .word __3FBRANCH,@B3 ; ?BRANCH @B3
   .word _NEGATE        ; NEGATE
   .word _OVER          ; OVER
   .word __3FBRANCH,@B4 ; ?BRANCH @B4
   .word _1_2D          ; 1-
   .word _R_40          ; R@
   .word _ROT           ; ROT
   .word __2D           ; -
   .word _SWAP          ; SWAP
@B4:
@B3:
   .word _RDROP         ; RDROP
@B1:
   .word _EXIT          ; EXIT

NFA2 "*/MOD", "_2A_2FMOD"
   call _FCALL
   .word __3ER          ; >R
   .word _M_2A          ; M*
   .word _R_3E          ; R>
   .word _M_2FMOD       ; M/MOD
   .word _EXIT          ; EXIT

NFA2 "*/", "_2A_2F"
   call _FCALL
   .word __2A_2FMOD     ; */MOD
   .word _PRESS         ; PRESS
   .word _EXIT          ; EXIT

.ENDS
