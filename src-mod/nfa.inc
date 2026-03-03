
.DEF IMMEDIATE 0x80

; Для простых слов
.MACRO NFA ARGS name
NFA_{name}:
   .byte name.length, name
   .word PREV_NFA
{PREFIX}_{name}:
.REDEF PREV_NFA NFA_{name}
.ENDM

; Для слов с отличающимся int_name
; Так же для слов IMMEDIATE
.MACRO NFA2 ARGS name, int_name
NFA_{int_name}:
.if NARGS <= 2
   .byte name.length, name
.else
   .byte name.length + 0x80, name
.endif
   .word PREV_NFA
{PREFIX}_{int_name}:
.REDEF PREV_NFA NFA_{int_name}
.ENDM
