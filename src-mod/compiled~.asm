
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "compiled" FREE

; : PROMPT2 \ Режим трансляции STATE @ IF C" C ELSE C" I THEN EMIT \ Система счисления BASE @ DUP DECIMAL 2 .R BASE ! \ Галочка и пробел C" > EMIT SPACE ;
NFA_PROMPT2:
   .byte 7,"PROMPT2"
   .word NFA_EXIT
_PROMPT2:
   call _FCALL
   .word __5C            ; \
   .word __420_435_436_438_43C ; Режим
   .word __442_440_430_43D_441_43B_44F_446_438_438 ; трансляции
   .word _STATE          ; STATE
   .word __40            ; @
   .word __3FBRANCH,@B1  ; ?BRANCH @B1
   .word _LIT, 0x43      ; C" C
   .word _BRANCH,@B2     ; BRANCH @B2
@B1:
   .word _LIT, 0x49      ; C" I
@B2:
   .word _EMIT           ; EMIT
   .word __5C            ; \
   .word __421_438_441_442_435_43C_430 ; Система
   .word __441_447_438_441_43B_435_43D_438_44F ; счисления
   .word _BASE           ; BASE
   .word __40            ; @
   .word _DUP            ; DUP
   .word _DECIMAL        ; DECIMAL
   .word _2              ; 2
   .word __2ER           ; .R
   .word _BASE           ; BASE
   .word __21            ; !
   .word __5C            ; \
   .word __413_430_43B_43E_447_43A_430 ; Галочка
   .word __438           ; и
   .word __43F_440_43E_431_435_43B ; пробел
   .word _LIT, 0x3e      ; C" >
   .word _EMIT           ; EMIT
   .word _SPACE          ; SPACE
   .word _EXIT           ; EXIT

; : HH ." HELLO, HABR!" COUNT TYPE ;
NFA_HH:
   .byte 2,"HH"
   .word NFA_PROMPT2
_HH:
   call _FCALL
   .word __28_22_29      ; (")
   .byte 12,"HELLO, HABR!"
   .word _COUNT          ; COUNT
   .word _TYPE           ; TYPE
   .word _EXIT           ; EXIT

; : BYE F800 EXECUTE ;
NFA_BYE:
   .byte 3,"BYE"
   .word NFA_HH
_BYE:
   call _FCALL
   .word _F800           ; F800
   .word _EXECUTE        ; EXECUTE
   .word _EXIT           ; EXIT

.ENDS
