
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "compiled" FREE

; : HH ." HELLO, HABR!" COUNT TYPE ;
NFA_HH:
   .byte 2,"HH"
   .word NFA_EXIT
_HH:
   call _FCALL
   .word __28_22_29      ; (")
   .byte 12,"HELLO, HABR!"
   .word _COUNT          ; COUNT
   .word _TYPE           ; TYPE
   .word _EXIT           ; EXIT

; : PROMPT2 STATE @ IF C" C ELSE C" I THEN EMIT BASE @ DUP DECIMAL 2 .R BASE ! C" > EMIT SPACE ;
NFA_PROMPT2:
   .byte 7,"PROMPT2"
   .word NFA_HH
_PROMPT2:
   call _FCALL
   .word _STATE          ; STATE
   .word __40            ; @
   .word __3FBRANCH,@B1  ; ?BRANCH @B1
   .word _LIT, 0x43      ; C" C
   .word _BRANCH,@B2     ; BRANCH @B2
@B1:
   .word _LIT, 0x49      ; C" I
@B2:
   .word _EMIT           ; EMIT
   .word _BASE           ; BASE
   .word __40            ; @
   .word _DUP            ; DUP
   .word _DECIMAL        ; DECIMAL
   .word _LIT, 0x2       ; 2
   .word __2ER           ; .R
   .word _BASE           ; BASE
   .word __21            ; !
   .word _LIT, 0x3e      ; C" >
   .word _EMIT           ; EMIT
   .word _SPACE          ; SPACE
   .word _EXIT           ; EXIT

; : BYE F800 EXECUTE ;
NFA_BYE:
   .byte 3,"BYE"
   .word NFA_PROMPT2
_BYE:
   call _FCALL
   .word _LIT, 0xF800    ; F800
   .word _EXECUTE        ; EXECUTE
   .word _EXIT           ; EXIT

.ENDS
