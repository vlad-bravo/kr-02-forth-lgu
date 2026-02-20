
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "compiled" FREE

; : HH ... ;
NFA__HH:
   .byte 2,"HH"
   .word NFA_EXIT
__HH:
   call _FCALL
   .word __2E_22 ; ."
   .word _HELLO_2C ; HELLO,
   .word _HABR_21_22 ; HABR!"
   .word _COUNT ; COUNT
   .word _TYPE ; TYPE
   .word _EXIT ; EXIT

; : PROMPT2 ... ;
NFA__PROMPT2:
   .byte 7,"PROMPT2"
   .word NFA__HH
__PROMPT2:
   call _FCALL
   .word _STATE ; STATE
   .word __40 ; @
   .word _IF ; IF
   .word _C_22 ; C"
   .word _LIT ; LIT
   .word C ; C
   .word _ELSE ; ELSE
   .word _C_22 ; C"
   .word _I ; I
   .word _THEN ; THEN
   .word _EMIT ; EMIT
   .word _BASE ; BASE
   .word __40 ; @
   .word _DUP ; DUP
   .word _DECIMAL ; DECIMAL
   .word _LIT ; LIT
   .word 2 ; 2
   .word __2ER ; .R
   .word _BASE ; BASE
   .word __21 ; !
   .word _C_22 ; C"
   .word __3E ; >
   .word _EMIT ; EMIT
   .word _SPACE ; SPACE
   .word _EXIT ; EXIT

; : BYE ... ;
NFA__BYE:
   .byte 3,"BYE"
   .word NFA__PROMPT2
__BYE:
   call _FCALL
   .word _LIT ; LIT
   .word COLD_INIT ; COLD_INIT
   .word _EXECUTE ; EXECUTE
   .word _EXIT ; EXIT


.ENDS
