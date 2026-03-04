.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "INTERPRET_F" FREE

.DEF PREV_NFA PREV_NFA_INTERPRET_F
.DEF PREFIX PREFIX_INTERPRET_F

; Интерактивные
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
   .word _LIT,0x-1      ; -1
@B8:
   .word _BRANCH,@B9    ; BRANCH @B9
@B6:
   .word _FALSE         ; FALSE
@B9:
   .word _EXIT          ; EXIT

NFA "LITERAL"
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _COMPILE       ; COMPILE
   .word _LIT           ; LIT
   .word __2C           ; ,
@B1:
   .word _EXIT          ; EXIT

   .word _IMMEDIATE     ; IMMEDIATE
NFA "DLITERAL"
   call _FCALL
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _COMPILE       ; COMPILE
   .word _DLIT          ; DLIT
   .word __2C           ; ,
   .word __2C           ; ,
@B1:
   .word _EXIT          ; EXIT

   .word _IMMEDIATE     ; IMMEDIATE
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
; Режим трансляции
   .word _STATE         ; STATE
   .word __40           ; @
   .word __3FBRANCH,@B1 ; ?BRANCH @B1
   .word _LIT, 0x43     ; C" C
   .word _BRANCH,@B2    ; BRANCH @B2
@B1:
   .word _LIT, 0x49     ; C" I
@B2:
   .word _EMIT          ; EMIT
; Система счисления
   .word _BASE          ; BASE
   .word __40           ; @
   .word _DUP           ; DUP
   .word _DECIMAL       ; DECIMAL
   .word _2             ; 2
   .word __2ER          ; .R
   .word _BASE          ; BASE
   .word __21           ; !
; Галочка и пробел
   .word _LIT, 0x3e     ; C" >
   .word _EMIT          ; EMIT
   .word _SPACE         ; SPACE
   .word _EXIT          ; EXIT

NFA "QUERY"
   call _FCALL
   .word _CR            ; CR
   .word _PROMPT        ; PROMPT
; C" > EMIT
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

.ENDS
