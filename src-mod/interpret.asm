
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "interpret" FREE

NFA_INTERPRET:
   .byte 9,"INTERPRET"
   .word NFA__3FSTACK
_INTERPRET:
   call _FCALL
   .word _LIT             ; LIT
   .word l6004            ; 
   .word __40             ; @
   .word __3FDUP          ; ?DUP
   .word __3FBRANCH       ; ?BRANCH
   .word @3696            ; 
   .word _EXECUTE         ; EXECUTE
   .word _EXIT            ; EXIT
@3696:
   .word _BL              ; BL
   .word _WORD            ; WORD
   .word _FIND            ; FIND
   .word _DUP             ; DUP
   .word __3FBRANCH       ; ?BRANCH
   .word @36BA            ; 
   .word _0_3C            ; 0<
   .word _STATE           ; STATE
   .word __40             ; @
   .word _AND             ; AND
   .word __3FBRANCH       ; ?BRANCH
   .word @36B4            ; 
   .word __2C             ; ,
   .word _BRANCH          ; BRANCH
   .word @36B6            ; 
@36B4:
   .word _EXECUTE         ; EXECUTE
@36B6:
   .word _BRANCH          ; BRANCH
   .word @36D2            ; 
@36BA:
   .word _DROP            ; DROP
   .word _NUMBER          ; NUMBER
   .word _DPL             ; DPL
   .word __40             ; @
   .word _1_2B            ; 1+
   .word __3FBRANCH       ; ?BRANCH
   .word @36CE            ; 
   .word _DLITERAL        ; DLITERAL
   .word _BRANCH          ; BRANCH
   .word @36D2            ; 
@36CE:
   .word _DROP            ; DROP
   .word _LITERAL         ; LITERAL
@36D2:
   .word __3FSTACK        ; ?STACK
   .word _BRANCH          ; BRANCH
   .word @3696            ; 
   .word _EXIT            ; EXIT

NFA_QUIT:
   .byte 4,"QUIT"
   .word NFA__3C_3E
i_QUIT:
   call _FCALL
   .word _LIT             ; LIT
   .word l6000            ; 
   .word __40             ; @
   .word __3FDUP          ; ?DUP
   .word __3FBRANCH       ; ?BRANCH
   .word @2D1B            ; 
   .word _EXECUTE         ; EXECUTE
@2D1B:
   .word _R0              ; R0
   .word __40             ; @
   .word _RP_21           ; RP!
   .word _STANDIO         ; STANDIO
   .word _CR              ; CR
   .word __5B             ; [
   .word _FORTH           ; FORTH
   .word _DEFINITIONS     ; DEFINITIONS
@2D2B:
   .word _INTERPRET       ; INTERPRET
   .word _BRANCH          ; BRANCH
   .word @2D2B            ; 
   .word _EXIT            ; EXIT

NFA_PROMPT:
   .byte 6,"PROMPT"
   .word NFA_CR
_PROMPT:
   call _FCALL
; Буква режима работы
; STATE @ IF C" C ELSE C" I THEN EMIT
   .word _STATE, __40, __3FBRANCH, @B1
   .word _LIT, 0x43, _BRANCH, @B2  ; C - режим компиляции
@B1:
   .word _LIT, 0x49                ; I - режим интерпретации
@B2:
   .word _EMIT
; Система счисления
   .word _BASE            ; BASE
   .word __40             ; @
   .word _DUP             ; DUP
   .word _DECIMAL         ; DECIMAL
   .word _2               ; 2
   .word __2ER            ; .R
   .word _BASE            ; BASE
   .word __21             ; !
; Галочка с пробелом
   .word _LIT, 0x3e       ; LIT ">"
   .word _EMIT, _SPACE, _EXIT

NFA_QUERY:       ; 4561
   .byte 5,"QUERY"
   .word NFA_PROMPT
i_QUERY:
   call _FCALL            ; 4569
   .word _CR              ; #456c 454C - CR
   .word _PROMPT
;   .word _LIT             ; #456e 28C7 - LIT
;   .word 0x003E           ; #4570 003E
;   .word _EMIT            ; #4572 3189 - EMIT
   .word _TIB             ; #4574 2176 - TIB
   .word _LIT             ; #4576 28C7 - LIT
   .word 0x004F           ; #4578 004F
   .word _EXPECT          ; #457a 30C2 - EXPECT
   .word _CR              ; #457c 454C - CR
   .word _TIB             ; #457e 2176 - TIB
   .word _SPAN            ; #4580 215F - SPAN
   .word __40             ; #4582 2820 - @
   .word _0               ; #4584 2B2B - 0
   .word _TRUE            ; #4586 2B49 - TRUE
   .word _EXIT            ; #4588 21A8 - EXIT

NFA_S_2E:        ; 3C1A
   .byte 2,"S."
   .word NFA__2D_2D           ; 3C08
_S_2E:           ; 3C1F - 3C58
   call _FCALL            ; 3C1F
   .word _DEPTH           ; #3c22 3915 - DEPTH
   .word __3FDUP          ; #3c24 2284 - ?DUP
   .word __3FBRANCH       ; #3c26 2916 - ?BRANCH
   .word @3C48            ; #3c28 3C48
   .word _1_2B            ; #3c2a 231A - 1+
   .word _1               ; #3c2c 2B34 - 1
   .word __28DO_29        ; #3c2e 2991 - (DO)
   .word @3C44            ; #3c30 3C44
@3C32:
   .word _S0              ; #3c32 2088 - S0
   .word __40             ; #3c34 2820 - @
   .word _I               ; #3c36 294B - I
   .word _2_2A            ; #3c38 2348 - 2*
   .word __2D             ; #3c3a 22F8 - -
   .word __40             ; #3c3c 2820 - @
   .word __2E             ; #3c3e 2F15 - .
   .word __28LOOP_29      ; #3c40 29DA - (LOOP)
   .word @3C32            ; #3c42 3C32
@3C44:
   .word _BRANCH          ; #3c44 2904 - BRANCH
   .word @3C56            ; #3c46 3C56
@3C48:
   .word __28_2E_22_29    ; #3c48 3421 - (.")
   .byte 9
   .stringmap russian,"CTEK ПУCT"
   .word _CR              ; #3c54 454C - CR
@3C56:
   .word _EXIT            ; #3c56 21A8 - EXIT

NFA_C_22:
   .byte 0x82,"C\"" ; IMMEDIATE
   .word NFA_DEPTH
_C_22:
   call _FCALL
   .word _BL              ; BL
   .word _WORD            ; WORD
   .word _1_2B            ; 1+
   .word _C_40            ; C@
   .word _LITERAL         ; LITERAL
   .word _EXIT            ; EXIT

NFA__2E_22:
   .byte 0x82,".\"" ; IMMEDIATE
   .word NFA_C_22
__2E_22:
   call _FCALL
   .word __3FCOMP         ; ?COMP
   .word _COMPILE         ; COMPILE
   .word __28_2E_22_29    ; (.")
   .word _LIT             ; LIT
   .word 0x0022           ; 
   .word _WORD            ; WORD
   .word __22_2C          ; ",
   .word _EXIT            ; EXIT

NFA__22:         ; 3956
   .byte 0x81,"\"" ; IMMEDIATE
   .word NFA__2E_22           ; 393E
__22:            ; 395A - 3989
   call _FCALL            ; 395A
   .word _STATE           ; #395d 20D5 - STATE
   .word __40             ; #395f 2820 - @
   .word __3FBRANCH       ; #3961 2916 - ?BRANCH
   .word @3975            ; #3963 3975
   .word _COMPILE         ; #3965 2BE9 - COMPILE
   .word __28_22_29       ; #3967 28EF - (")
   .word _LIT             ; #3969 28C7 - LIT
   .word 0x0022           ; #396b 0022
   .word _WORD            ; #396d 302A - WORD
   .word __22_2C          ; #396f 2BA4 - ",
   .word _BRANCH          ; #3971 2904 - BRANCH
   .word @3987            ; #3973 3987
@3975:
   .word _LIT             ; #3975 28C7 - LIT
   .word 0x0022           ; #3977 0022
   .word _WORD            ; #3979 302A - WORD
   .word _PAD             ; #397b 2BBD - PAD
   .word _OVER            ; #397d 220D - OVER
   .word _C_40            ; #397f 282D - C@
   .word _1_2B            ; #3981 231A - 1+
   .word _CMOVE           ; #3983 2A28 - CMOVE
   .word _PAD             ; #3985 2BBD - PAD
@3987:
   .word _EXIT            ; #3987 21A8 - EXIT

NFA__2E_28:      ; 3989
   .byte 0x82,".(" ; IMMEDIATE
   .word NFA__22            ; 3956
__2E_28:         ; 398E - 399D
   call _FCALL            ; 398E
   .word _LIT             ; #3991 28C7 - LIT
   .word 0x0029           ; #3993 0029
   .word _WORD            ; #3995 302A - WORD
   .word _COUNT           ; #3997 2BD2 - COUNT
   .word _TYPE            ; #3999 31B4 - TYPE
   .word _EXIT            ; #399b 21A8 - EXIT

NFA__3EMARK:     ; 399D
   .byte 5,">MARK"
   .word NFA__2E_28           ; 3989
__3EMARK:        ; 39A5 - 39B0
   call _FCALL            ; 39A5
   .word _HERE            ; #39a8 2B62 - HERE
   .word _0               ; #39aa 2B2B - 0
   .word __2C             ; #39ac 2B80 - ,
   .word _EXIT            ; #39ae 21A8 - EXIT

NFA__3ERESOLVE:  ; 39B0
   .byte 8,">RESOLVE"
   .word NFA__3EMARK        ; 399D
__3ERESOLVE:     ; 39BB - 39C6
   call _FCALL            ; 39BB
   .word _HERE            ; #39be 2B62 - HERE
   .word _SWAP            ; #39c0 2238 - SWAP
   .word __21             ; #39c2 2839 - !
   .word _EXIT            ; #39c4 21A8 - EXIT

NFA__3CMARK:     ; 39C6
   .byte 5,"<MARK"
   .word NFA__3ERESOLVE     ; 39B0
__3CMARK:        ; 39CE - 39D5
   call _FCALL            ; 39CE
   .word _HERE            ; #39d1 2B62 - HERE
   .word _EXIT            ; #39d3 21A8 - EXIT

NFA__3CRESOLVE:  ; 39D5
   .byte 8,"<RESOLVE"
   .word NFA__3CMARK        ; 39C6
__3CRESOLVE:     ; 39E0 - 39E7
   call _FCALL            ; 39E0
   .word __2C             ; #39e3 2B80 - ,
   .word _EXIT            ; #39e5 21A8 - EXIT

NFA_IF:          ; 39E7
   .byte 0x82,"IF" ; IMMEDIATE
   .word NFA__3CRESOLVE     ; 39D5
_IF:             ; 39EC - 39FB
   call _FCALL            ; 39EC
   .word __3FCOMP         ; #39ef 3862 - ?COMP
   .word _COMPILE         ; #39f1 2BE9 - COMPILE
   .word __3FBRANCH       ; #39f3 2916 - ?BRANCH
   .word __3EMARK         ; #39f5 39A5 - >MARK
   .word _2               ; #39f7 2B3D - 2
   .word _EXIT            ; #39f9 21A8 - EXIT

NFA_IFNOT:       ; 39FB
   .byte 0x85,"IFNOT" ; IMMEDIATE
   .word NFA_IF           ; 39E7
_IFNOT:          ; 3A03 - 3A12
   call _FCALL            ; 3A03
   .word __3FCOMP         ; #3a06 3862 - ?COMP
   .word _COMPILE         ; #3a08 2BE9 - COMPILE
   .word _N_3FBRANCH      ; #3a0a 2934 - N?BRANCH
   .word __3EMARK         ; #3a0c 39A5 - >MARK
   .word _2               ; #3a0e 2B3D - 2
   .word _EXIT            ; #3a10 21A8 - EXIT

NFA_ELSE:        ; 3A12
   .byte 0x84,"ELSE" ; IMMEDIATE
   .word NFA_IFNOT        ; 39FB
_ELSE:           ; 3A19 - 3A30
   call _FCALL            ; 3A19
   .word __3FCOMP         ; #3a1c 3862 - ?COMP
   .word _2               ; #3a1e 2B3D - 2
   .word __3FPAIRS        ; #3a20 3893 - ?PAIRS
   .word _COMPILE         ; #3a22 2BE9 - COMPILE
   .word _BRANCH          ; #3a24 2904 - BRANCH
   .word __3EMARK         ; #3a26 39A5 - >MARK
   .word _SWAP            ; #3a28 2238 - SWAP
   .word __3ERESOLVE      ; #3a2a 39BB - >RESOLVE
   .word _2               ; #3a2c 2B3D - 2
   .word _EXIT            ; #3a2e 21A8 - EXIT

NFA_THEN:        ; 3A30
   .byte 0x84,"THEN" ; IMMEDIATE
   .word NFA_ELSE         ; 3A12
_THEN:           ; 3A37 - 3A44
   call _FCALL            ; 3A37
   .word __3FCOMP         ; #3a3a 3862 - ?COMP
   .word _2               ; #3a3c 2B3D - 2
   .word __3FPAIRS        ; #3a3e 3893 - ?PAIRS
   .word __3ERESOLVE      ; #3a40 39BB - >RESOLVE
   .word _EXIT            ; #3a42 21A8 - EXIT

NFA_BEGIN:       ; 3A44
   .byte 0x85,"BEGIN" ; IMMEDIATE
   .word NFA_THEN         ; 3A30
_BEGIN:          ; 3A4C - 3A57
   call _FCALL            ; 3A4C
   .word __3FCOMP         ; #3a4f 3862 - ?COMP
   .word __3CMARK         ; #3a51 39CE - <MARK
   .word _1               ; #3a53 2B34 - 1
   .word _EXIT            ; #3a55 21A8 - EXIT

NFA_AGAIN:       ; 3A57
   .byte 0x85,"AGAIN" ; IMMEDIATE
   .word NFA_BEGIN        ; 3A44
_AGAIN:          ; 3A5F - 3A70
   call _FCALL            ; 3A5F
   .word __3FCOMP         ; #3a62 3862 - ?COMP
   .word _1               ; #3a64 2B34 - 1
   .word __3FPAIRS        ; #3a66 3893 - ?PAIRS
   .word _COMPILE         ; #3a68 2BE9 - COMPILE
   .word _BRANCH          ; #3a6a 2904 - BRANCH
   .word __3CRESOLVE      ; #3a6c 39E0 - <RESOLVE
   .word _EXIT            ; #3a6e 21A8 - EXIT

NFA_DO:          ; 3A70
   .byte 0x82,"DO" ; IMMEDIATE
   .word NFA_AGAIN        ; 3A57
_DO:             ; 3A75 - 3A88
   call _FCALL            ; 3A75
   .word __3FCOMP         ; #3a78 3862 - ?COMP
   .word _COMPILE         ; #3a7a 2BE9 - COMPILE
   .word __28DO_29        ; #3a7c 2991 - (DO)
   .word __3EMARK         ; #3a7e 39A5 - >MARK
   .word __3CMARK         ; #3a80 39CE - <MARK
   .word _LIT             ; #3a82 28C7 - LIT
   .word 0003             ; #3a84 0003
   .word _EXIT            ; #3a86 21A8 - EXIT

NFA__3FDO:       ; 3A88
   .byte 0x83,"?DO" ; IMMEDIATE
   .word NFA_DO           ; 3A70
__3FDO:          ; 3A8E - 3AA1
   call _FCALL            ; 3A8E
   .word __3FCOMP         ; #3a91 3862 - ?COMP
   .word _COMPILE         ; #3a93 2BE9 - COMPILE
   .word __28_3FDO_29     ; #3a95 29B8 - (?DO)
   .word __3EMARK         ; #3a97 39A5 - >MARK
   .word __3CMARK         ; #3a99 39CE - <MARK
   .word _LIT             ; #3a9b 28C7 - LIT
   .word 0003             ; #3a9d 0003
   .word _EXIT            ; #3a9f 21A8 - EXIT

NFA_LOOP:        ; 3AA1
   .byte 0x84,"LOOP" ; IMMEDIATE
   .word NFA__3FDO          ; 3A88
_LOOP:           ; 3AA8 - 3ABD
   call _FCALL            ; 3AA8
   .word __3FCOMP         ; #3aab 3862 - ?COMP
   .word _LIT             ; #3aad 28C7 - LIT
   .word 0003             ; #3aaf 0003
   .word __3FPAIRS        ; #3ab1 3893 - ?PAIRS
   .word _COMPILE         ; #3ab3 2BE9 - COMPILE
   .word __28LOOP_29      ; #3ab5 29DA - (LOOP)
   .word __3CRESOLVE      ; #3ab7 39E0 - <RESOLVE
   .word __3ERESOLVE      ; #3ab9 39BB - >RESOLVE
   .word _EXIT            ; #3abb 21A8 - EXIT

NFA__2BLOOP:     ; 3ABD
   .byte 0x85,"+LOOP" ; IMMEDIATE
   .word NFA_LOOP         ; 3AA1
__2BLOOP:        ; 3AC5 - 3ADA
   call _FCALL            ; 3AC5
   .word __3FCOMP         ; #3ac8 3862 - ?COMP
   .word _LIT             ; #3aca 28C7 - LIT
   .word 0003             ; #3acc 0003
   .word __3FPAIRS        ; #3ace 3893 - ?PAIRS
   .word _COMPILE         ; #3ad0 2BE9 - COMPILE
   .word __28_2BLOOP_29   ; #3ad2 2A0F - (+LOOP)
   .word __3CRESOLVE      ; #3ad4 39E0 - <RESOLVE
   .word __3ERESOLVE      ; #3ad6 39BB - >RESOLVE
   .word _EXIT            ; #3ad8 21A8 - EXIT

NFA_UNTIL:       ; 3ADA
   .byte 0x85,"UNTIL" ; IMMEDIATE
   .word NFA__2BLOOP        ; 3ABD
_UNTIL:          ; 3AE2 - 3AF3
   call _FCALL            ; 3AE2
   .word __3FCOMP         ; #3ae5 3862 - ?COMP
   .word _1               ; #3ae7 2B34 - 1
   .word __3FPAIRS        ; #3ae9 3893 - ?PAIRS
   .word _COMPILE         ; #3aeb 2BE9 - COMPILE
   .word __3FBRANCH       ; #3aed 2916 - ?BRANCH
   .word __3CRESOLVE      ; #3aef 39E0 - <RESOLVE
   .word _EXIT            ; #3af1 21A8 - EXIT

NFA_WHILE:       ; 3AF3
   .byte 0x85,"WHILE" ; IMMEDIATE
   .word NFA_UNTIL        ; 3ADA
_WHILE:          ; 3AFB - 3B0C
   call _FCALL            ; 3AFB
   .word __3FCOMP         ; #3afe 3862 - ?COMP
   .word _1               ; #3b00 2B34 - 1
   .word __3FPAIRS        ; #3b02 3893 - ?PAIRS
   .word _1               ; #3b04 2B34 - 1
   .word _IF              ; #3b06 39EC - IF
   .word _2_2B            ; #3b08 2325 - 2+
   .word _EXIT            ; #3b0a 21A8 - EXIT

NFA_REPEAT:      ; 3B0C
   .byte 0x86,"REPEAT" ; IMMEDIATE
   .word NFA_WHILE        ; 3AF3
_REPEAT:         ; 3B15 - 3B2A
   call _FCALL            ; 3B15
   .word __3FCOMP         ; #3b18 3862 - ?COMP
   .word __3ER            ; #3b1a 27A9 - >R
   .word __3ER            ; #3b1c 27A9 - >R
   .word _AGAIN           ; #3b1e 3A5F - AGAIN
   .word _R_3E            ; #3b20 27BC - R>
   .word _R_3E            ; #3b22 27BC - R>
   .word _2_2D            ; #3b24 233C - 2-
   .word _THEN            ; #3b26 3A37 - THEN
   .word _EXIT            ; #3b28 21A8 - EXIT

NFA_ABORT_22:    ; 2D86
   .byte 0x86,"ABORT\"" ; IMMEDIATE
   .word NFA__28ABORT_22_29     ; 2D56
_ABORT_22:       ; 2D8F - 2DA2
   call _FCALL            ; 2D8F
   .word __3FCOMP         ; #2d92 3862 - ?COMP
   .word _COMPILE         ; #2d94 2BE9 - COMPILE
   .word __28ABORT_22_29  ; #2d96 2D61 - (ABORT")
   .word _LIT             ; #2d98 28C7 - LIT
   .word 0x0022           ; #2d9a 0022
   .word _WORD            ; #2d9c 302A - WORD
   .word __22_2C          ; #2d9e 2BA4 - ",
   .word _EXIT            ; #2da0 21A8 - EXIT

NFA_:            ; 3172
   .byte 0x80,"" ; IMMEDIATE
   .word NFA_PTYPE        ; 314F
_:               ; 3175 - 3182
   call _FCALL            ; 3175
   .word _INLINE          ; #3178 3096 - INLINE
   .word _N_3FBRANCH      ; #317a 2934 - N?BRANCH
   .word @3180            ; #317c 3180
   .word _RDROP           ; #317e 2811 - RDROP
@3180:
   .word _EXIT            ; #3180 21A8 - EXIT

NFA__5B_27_5D:   ; 345E
   .byte 0x83,"[']" ; IMMEDIATE
   .word NFA__27            ; 3447
__5B_27_5D:      ; 3464 - 346D
   call _FCALL            ; 3464
   .word __27             ; #3467 344B - '
   .word _LITERAL         ; #3469 3477 - LITERAL
   .word _EXIT            ; #346b 21A8 - EXIT

NFA_LITERAL:     ; 346D
   .byte 0x87,"LITERAL" ; IMMEDIATE
   .word NFA__5B_27_5D          ; 345E
_LITERAL:        ; 3477 - 348A
   call _FCALL            ; 3477
   .word _STATE           ; #347a 20D5 - STATE
   .word __40             ; #347c 2820 - @
   .word __3FBRANCH       ; #347e 2916 - ?BRANCH
   .word @3488            ; #3480 3488
   .word _COMPILE         ; #3482 2BE9 - COMPILE
   .word _LIT             ; #3484 28C7 - LIT
   .word __2C             ; #3486 2B80 - ,
@3488:
   .word _EXIT            ; #3488 21A8 - EXIT

NFA_DLITERAL:    ; 348A
   .byte 0x88,"DLITERAL" ; IMMEDIATE
   .word NFA_LITERAL      ; 346D
_DLITERAL:       ; 3495 - 34AA
   call _FCALL            ; 3495
   .word _STATE           ; #3498 20D5 - STATE
   .word __40             ; #349a 2820 - @
   .word __3FBRANCH       ; #349c 2916 - ?BRANCH
   .word @34A8            ; #349e 34A8
   .word _COMPILE         ; #34a0 2BE9 - COMPILE
   .word _DLIT            ; #34a2 28D8 - DLIT
   .word __2C             ; #34a4 2B80 - ,
   .word __2C             ; #34a6 2B80 - ,
@34A8:
   .word _EXIT            ; #34a8 21A8 - EXIT

NFA__5BCOMPILE_5D:; 34AA
   .byte 0x89,"[COMPILE]" ; IMMEDIATE
   .word NFA_DLITERAL     ; 348A
__5BCOMPILE_5D:  ; 34B6 - 34BF
   call _FCALL            ; 34B6
   .word __27             ; #34b9 344B - '
   .word __2C             ; #34bb 2B80 - ,
   .word _EXIT            ; #34bd 21A8 - EXIT

NFA__28:         ; 3C58
   .byte 0x81,"(" ; IMMEDIATE
   .word NFA_S_2E           ; 3C1A
__28:            ; 3C5C - 3C69
   call _FCALL            ; 3C5C
   .word _LIT             ; #3c5f 28C7 - LIT
   .word 0x0029           ; #3c61 0029
   .word _WORD            ; #3c63 302A - WORD
   .word _DROP            ; #3c65 222D - DROP
   .word _EXIT            ; #3c67 21A8 - EXIT

NFA_SCRATCH:     ; 3C88
   .byte 0x87,"SCRATCH" ; IMMEDIATE
   .word NFA__3FCURRENT     ; 3C69
_SCRATCH:        ; 3C92 - 3CAC
   call _FCALL            ; 3C92
   .word __3FEXEC         ; #3c95 3834 - ?EXEC
   .word _BL              ; #3c97 3289 - BL
   .word _WORD            ; #3c99 302A - WORD
   .word _CURRENT         ; #3c9b 20F3 - CURRENT
   .word __40             ; #3c9d 2820 - @
   .word __2DWORD         ; #3c9f 33FB - -WORD
   .word _0_3D            ; #3ca1 2421 - 0=
   .word __28ABORT_22_29  ; #3ca3 2D61 - (ABORT")
   .byte 4," - ?"
   .word _EXIT            ; #3caa 21A8 - EXIT

NFA_JOIN:        ; 3CAC
   .byte 0x84,"JOIN" ; IMMEDIATE
   .word NFA_SCRATCH      ; 3C88
_JOIN:           ; 3CB3 - 3CCA
   call _FCALL            ; 3CB3
   .word __3FEXEC         ; #3cb6 3834 - ?EXEC
   .word _BL              ; #3cb8 3289 - BL
   .word _WORD            ; #3cba 302A - WORD
   .word __3FCURRENT      ; #3cbc 3C74 - ?CURRENT
   .word _N_3ELINK        ; #3cbe 3008 - N>LINK
   .word __40             ; #3cc0 2820 - @
   .word _LATEST          ; #3cc2 3303 - LATEST
   .word _N_3ELINK        ; #3cc4 3008 - N>LINK
   .word __21             ; #3cc6 2839 - !
   .word _EXIT            ; #3cc8 21A8 - EXIT

NFA_NEW:         ; 3CCA
   .byte 0x83,"NEW" ; IMMEDIATE
   .word NFA_JOIN         ; 3CAC
_NEW:            ; 3CD0 - 3D07
   call _FCALL            ; 3CD0
   .word __3FEXEC         ; #3cd3 3834 - ?EXEC
   .word _BL              ; #3cd5 3289 - BL
   .word _WORD            ; #3cd7 302A - WORD
   .word _DUP             ; #3cd9 2277 - DUP
   .word __3FCURRENT      ; #3cdb 3C74 - ?CURRENT
   .word _CURRENT         ; #3cdd 20F3 - CURRENT
   .word __40             ; #3cdf 2820 - @
   .word __3ER            ; #3ce1 27A9 - >R
   .word _DUP             ; #3ce3 2277 - DUP
   .word _N_3ELINK        ; #3ce5 3008 - N>LINK
   .word _CURRENT         ; #3ce7 20F3 - CURRENT
   .word __21             ; #3ce9 2839 - !
   .word _NAME_3E         ; #3ceb 2FD6 - NAME>
   .word _SWAP            ; #3ced 2238 - SWAP
   .word __3FCURRENT      ; #3cef 3C74 - ?CURRENT
   .word _NAME_3E         ; #3cf1 2FD6 - NAME>
   .word _LIT             ; #3cf3 28C7 - LIT
   .word 0x00C3           ; #3cf5 00C3
   .word _OVER            ; #3cf7 220D - OVER
   .word _C_21            ; #3cf9 2846 - C!
   .word _1_2B            ; #3cfb 231A - 1+
   .word __21             ; #3cfd 2839 - !
   .word _R_3E            ; #3cff 27BC - R>
   .word _CURRENT         ; #3d01 20F3 - CURRENT
   .word __21             ; #3d03 2839 - !
   .word _EXIT            ; #3d05 21A8 - EXIT

NFA_FORGET:      ; 3D07
   .byte 6,"FORGET"
   .word NFA_NEW          ; 3CCA
_FORGET:         ; 3D10 - 3D80
   call _FCALL            ; 3D10
   .word _BL              ; #3d13 3289 - BL
   .word _WORD            ; #3d15 302A - WORD
   .word __3FCURRENT      ; #3d17 3C74 - ?CURRENT
   .word _DUP             ; #3d19 2277 - DUP
   .word _FENCE           ; #3d1b 20AE - FENCE
   .word __40             ; #3d1d 2820 - @
   .word _U_3C            ; #3d1f 239D - U<
   .word __28ABORT_22_29  ; #3d21 2D61 - (ABORT")
   .byte 14
   .stringmap russian,"BЫXOД ЗA FENCE"
   .word __3ER            ; #3d32 27A9 - >R
   .word _VOC_2DLINK      ; #3d34 20A1 - VOC-LINK
   .word __40             ; #3d36 2820 - @
@3D38:
   .word _R_40            ; #3d38 27CF - R@
   .word _OVER            ; #3d3a 220D - OVER
   .word _U_3C            ; #3d3c 239D - U<
   .word __3FBRANCH       ; #3d3e 2916 - ?BRANCH
   .word @3D52            ; #3d40 3D52
   .word _FORTH           ; #3d42 604C - FORTH
   .word _DEFINITIONS     ; #3d44 32ED - DEFINITIONS
   .word __40             ; #3d46 2820 - @
   .word _DUP             ; #3d48 2277 - DUP
   .word _VOC_2DLINK      ; #3d4a 20A1 - VOC-LINK
   .word __21             ; #3d4c 2839 - !
   .word _BRANCH          ; #3d4e 2904 - BRANCH
   .word @3D38            ; #3d50 3D38
@3D52:
   .word _DUP             ; #3d52 2277 - DUP
   .word _LIT             ; #3d54 28C7 - LIT
   .word 0004            ; #3d56 0004
   .word __2D             ; #3d58 22F8 - -
@3D5A:
   .word _N_3ELINK        ; #3d5a 3008 - N>LINK
   .word __40             ; #3d5c 2820 - @
   .word _DUP             ; #3d5e 2277 - DUP
   .word _R_40            ; #3d60 27CF - R@
   .word _U_3C            ; #3d62 239D - U<
   .word __3FBRANCH       ; #3d64 2916 - ?BRANCH
   .word @3D5A            ; #3d66 3D5A
   .word _OVER            ; #3d68 220D - OVER
   .word _2_2D            ; #3d6a 233C - 2-
   .word __21             ; #3d6c 2839 - !
   .word __40             ; #3d6e 2820 - @
   .word __3FDUP          ; #3d70 2284 - ?DUP
   .word _0_3D            ; #3d72 2421 - 0=
   .word __3FBRANCH       ; #3d74 2916 - ?BRANCH
   .word @3D52            ; #3d76 3D52
   .word _R_3E            ; #3d78 27BC - R>
   .word _H               ; #3d7a 2091 - H
   .word __21             ; #3d7c 2839 - !
   .word _EXIT            ; #3d7e 21A8 - EXIT

NFA__5B:         ; 3350
   .byte 0x81,"[" ; IMMEDIATE
   .word NFA_SMUDGE       ; 333A
i__5B:
   call _FCALL            ; 3354
   .word _STATE           ; #3357 20D5 - STATE
   .word _0_21            ; #3359 2898 - 0!
   .word _EXIT            ; #335b 21A8 - EXIT

NFA__5D:         ; 335D
   .byte 1,"]"
   .word NFA__5B            ; 3350
__5D:            ; 3361 - 336C
   call _FCALL            ; 3361
   .word __2D1            ; #3364 2B22 - -1
   .word _STATE           ; #3366 20D5 - STATE
   .word __21             ; #3368 2839 - !
   .word _EXIT            ; #336a 21A8 - EXIT

NFA__3A:         ; 38C0
   .byte 0x81,":" ; IMMEDIATE
   .word NFA_LEAVE        ; 38AD
__3A:            ; 38C4 - 38DF
   call _FCALL            ; 38C4
   .word __3FEXEC         ; #38c7 3834 - ?EXEC
   .word __21CSP          ; #38c9 37F9 - !CSP
   .word _CURRENT         ; #38cb 20F3 - CURRENT
   .word __40             ; #38cd 2820 - @
   .word _CONTEXT         ; #38cf 20E4 - CONTEXT
   .word __21             ; #38d1 2839 - !
   .word _CREATE          ; #38d3 36E3 - CREATE
   .word _SMUDGE          ; #38d5 3343 - SMUDGE
   .word __5D             ; #38d7 3361 - ]
   .word _CALL            ; #38d9 2201 - CALL
   .word __28_21CODE_29   ; #38db 332F - (!CODE)
   .word _EXIT            ; #38dd 21A8 - EXIT

NFA__3B:         ; 38DF
   .byte 0x81,";" ; IMMEDIATE
   .word NFA__3A            ; 38C0
__3B:            ; 38E3 - 38F4
   call _FCALL            ; 38E3
   .word __3FCOMP         ; #38e6 3862 - ?COMP
   .word __3FCSP          ; #38e8 380B - ?CSP
   .word _COMPILE         ; #38ea 2BE9 - COMPILE
   .word _EXIT            ; #38ec 21A8 - EXIT
   .word _SMUDGE          ; #38ee 3343 - SMUDGE
   .word __5B             ; #38f0 3354 - [
   .word _EXIT            ; #38f2 21A8 - EXIT

NFA_IMMEDIATE:   ; 38F4
   .byte 9,"IMMEDIATE"
   .word NFA__3B            ; 38DF
_IMMEDIATE:      ; 3900 - 390D
   call _FCALL            ; 3900
   .word _LATEST          ; #3903 3303 - LATEST
   .word _LIT             ; #3905 28C7 - LIT
   .word 0x0080           ; #3907 0080
   .word _TOGGLE          ; #3909 2982 - TOGGLE
   .word _EXIT            ; #390b 21A8 - EXIT

NFA__21CSP:      ; 37F2
   .byte 4,"!CSP"
   .word NFA_STRING       ; 37DC
i__21CSP:
   call _FCALL            ; 37F9
   .word _SP_40           ; #37fc 22D6 - SP@
   .word _CSP             ; #37fe 2114 - CSP
   .word __21             ; #3800 2839 - !
   .word _EXIT            ; #3802 21A8 - EXIT

NFA__3FCSP:      ; 3804
   .byte 4,"?CSP"
   .word NFA__21CSP         ; 37F2
i__3FCSP:
   call _FCALL            ; 380B
   .word _SP_40           ; #380e 22D6 - SP@
   .word _CSP             ; #3810 2114 - CSP
   .word __40             ; #3812 2820 - @
   .word _XOR             ; #3814 2787 - XOR
   .word __28ABORT_22_29  ; #3816 2D61 - (ABORT")
   .byte 17
   .stringmap russian,"CБOЙ CTEKA ПO CSP"
   .word _EXIT            ; #382a 21A8 - EXIT

NFA__3FEXEC:     ; 382C
   .byte 5,"?EXEC"
   .word NFA__3FCSP         ; 3804
i__3FEXEC:
   call _FCALL            ; 3834
   .word _STATE           ; #3837 20D5 - STATE
   .word __40             ; #3839 2820 - @
   .word __28ABORT_22_29  ; #383b 2D61 - (ABORT")
   .byte 26
   .stringmap russian," TPEБУET PEЖИMA BЫПOЛHEHИЯ"
   .word _EXIT            ; #3858 21A8 - EXIT

NFA__3FCOMP:     ; 385A
   .byte 5,"?COMP"
   .word NFA__3FEXEC        ; 382C
i__3FCOMP:
   call _FCALL            ; 3862
   .word _STATE           ; #3865 20D5 - STATE
   .word __40             ; #3867 2820 - @
   .word _0_3D            ; #3869 2421 - 0=
   .word __28ABORT_22_29  ; #386b 2D61 - (ABORT")
   .byte 26
   .stringmap russian," TPEБУET PEЖИMA KOMПИЛЯЦИИ"
   .word _EXIT            ; #3888 21A8 - EXIT

NFA__3FPAIRS:    ; 388A
   .byte 6,"?PAIRS"
   .word NFA__3FCOMP        ; 385A
i__3FPAIRS:
   call _FCALL            ; 3893
   .word _XOR             ; #3896 2787 - XOR
   .word __28ABORT_22_29  ; #3898 2D61 - (ABORT")
   .byte 16
   .stringmap russian," HEПAPHAЯ CKOБKA"
   .word _EXIT            ; #38ab 21A8 - EXIT

NFA__3FCURRENT:  ; 3C69
   .byte 8,"?CURRENT"
   .word NFA__28            ; 3C58
__3FCURRENT:     ; 3C74 - 3C88
   call _FCALL            ; 3C74
   .word _CURRENT         ; #3c77 20F3 - CURRENT
   .word __40             ; #3c79 2820 - @
   .word __3FWORD         ; #3c7b 26DB - ?WORD
   .word _0_3D            ; #3c7d 2421 - 0=
   .word __28ABORT_22_29  ; #3c7f 2D61 - (ABORT")
   .byte 4," - ?"
   .word _EXIT            ; #3c86 21A8 - EXIT

NFA_FIND:        ; 336C
   .byte 4,"FIND"
   .word NFA__5D            ; 335D
_FIND:           ; 3373 - 33D6
   call _FCALL            ; 3373
   .word _LIT             ; #3376 28C7 - LIT
   .word l6006            ; #3378 6006
   .word __40             ; #337a 2820 - @
   .word __3FDUP          ; #337c 2284 - ?DUP
   .word __3FBRANCH       ; #337e 2916 - ?BRANCH
   .word @3386            ; #3380 3386
   .word _EXECUTE         ; #3382 21BF - EXECUTE
   .word _EXIT            ; #3384 21A8 - EXIT
@3386:
   .word _CONTEXT         ; #3386 20E4 - CONTEXT
   .word __40             ; #3388 2820 - @
   .word __3FWORD         ; #338a 26DB - ?WORD
   .word __3FBRANCH       ; #338c 2916 - ?BRANCH
   .word @3396            ; #338e 3396
   .word _TRUE            ; #3390 2B49 - TRUE
   .word _BRANCH          ; #3392 2904 - BRANCH
   .word @33B0            ; #3394 33B0
@3396:
   .word _CURRENT         ; #3396 20F3 - CURRENT
   .word __40             ; #3398 2820 - @
   .word _DUP             ; #339a 2277 - DUP
   .word _CONTEXT         ; #339c 20E4 - CONTEXT
   .word __40             ; #339e 2820 - @
   .word __3D             ; #33a0 2409 - =
   .word _N_3FBRANCH      ; #33a2 2934 - N?BRANCH
   .word @33AC            ; #33a4 33AC
   .word __3FWORD         ; #33a6 26DB - ?WORD
   .word _BRANCH          ; #33a8 2904 - BRANCH
   .word @33B0            ; #33aa 33B0
@33AC:
   .word _DROP            ; #33ac 222D - DROP
   .word _FALSE           ; #33ae 2B56 - FALSE
@33B0:
   .word __3FBRANCH       ; #33b0 2916 - ?BRANCH
   .word @33D2            ; #33b2 33D2
   .word _DUP             ; #33b4 2277 - DUP
   .word _NAME_3E         ; #33b6 2FD6 - NAME>
   .word _SWAP            ; #33b8 2238 - SWAP
   .word _C_40            ; #33ba 282D - C@
   .word _LIT             ; #33bc 28C7 - LIT
   .word 0x0080           ; #33be 0080
   .word _AND             ; #33c0 2764 - AND
   .word __3FBRANCH       ; #33c2 2916 - ?BRANCH
   .word @33CC            ; #33c4 33CC
   .word _1               ; #33c6 2B34 - 1
   .word _BRANCH          ; #33c8 2904 - BRANCH
   .word @33CE            ; #33ca 33CE
@33CC:
   .word __2D1            ; #33cc 2B22 - -1
@33CE:
   .word _BRANCH          ; #33ce 2904 - BRANCH
   .word @33D4            ; #33d0 33D4
@33D2:
   .word _FALSE           ; #33d2 2B56 - FALSE
@33D4:
   .word _EXIT            ; #33d4 21A8 - EXIT

NFA__2BWORD:     ; 33D6
   .byte 5,"+WORD"
   .word NFA_FIND         ; 336C
__2BWORD:        ; 33DE - 33F3
   call _FCALL            ; 33DE
   .word _HERE            ; #33e1 2B62 - HERE
   .word _ROT             ; #33e3 225A - ROT
   .word __22_2C          ; #33e5 2BA4 - ",
   .word _SWAP            ; #33e7 2238 - SWAP
   .word _DUP             ; #33e9 2277 - DUP
   .word __40             ; #33eb 2820 - @
   .word __2C             ; #33ed 2B80 - ,
   .word __21             ; #33ef 2839 - !
   .word _EXIT            ; #33f1 21A8 - EXIT

NFA__2DWORD:     ; 33F3
   .byte 5,"-WORD"
   .word NFA__2BWORD        ; 33D6
__2DWORD:        ; 33FB - 341A
   call _FCALL            ; 33FB
   .word __3FWORD         ; #33fe 26DB - ?WORD
   .word __3FBRANCH       ; #3400 2916 - ?BRANCH
   .word @3414            ; #3402 3414
   .word _N_3ELINK        ; #3404 3008 - N>LINK
   .word __40             ; #3406 2820 - @
   .word _W_2DLINK        ; #3408 20BC - W-LINK
   .word __40             ; #340a 2820 - @
   .word __21             ; #340c 2839 - !
   .word _TRUE            ; #340e 2B49 - TRUE
   .word _BRANCH          ; #3410 2904 - BRANCH
   .word @3418            ; #3412 3418
@3414:
   .word _DROP            ; #3414 222D - DROP
   .word _FALSE           ; #3416 2B56 - FALSE
@3418:
   .word _EXIT            ; #3418 21A8 - EXIT

NFA__27:         ; 3447
   .byte 1,"'"
   .word NFA_ERASE        ; 3436
__27:            ; 344B - 345E
   call _FCALL            ; 344B
   .word _BL              ; #344e 3289 - BL
   .word _WORD            ; #3450 302A - WORD
   .word _FIND            ; #3452 3373 - FIND
   .word _0_3D            ; #3454 2421 - 0=
   .word __28ABORT_22_29  ; #3456 2D61 - (ABORT")
   .byte 3,"-? "
   .word _EXIT            ; #345c 21A8 - EXIT

NFA_CREATE:      ; 36DA
   .byte 6,"CREATE"
   .word NFA_INTERPRET    ; 3677
i_CREATE:
   call _FCALL            ; 36E3
   .word _BL              ; #36e6 3289 - BL
   .word _WORD            ; #36e8 302A - WORD
   .word _DUP             ; #36ea 2277 - DUP
   .word _FIND            ; #36ec 3373 - FIND
   .word _PRESS           ; #36ee 22B4 - PRESS
   .word __3FBRANCH       ; #36f0 2916 - ?BRANCH
   .word @370C            ; #36f2 370C
   .word _DUP             ; #36f4 2277 - DUP
   .word _ID_2E           ; #36f6 32D0 - ID.
   .word __28_2E_22_29    ; #36f8 3421 - (.")
   .byte 15
   .stringmap russian," УЖE OПPEДEЛEH "
   .word _CR              ; #370a 454C - CR
@370C:
   .word _CURRENT         ; #370c 20F3 - CURRENT
   .word __40             ; #370e 2820 - @
   .word __2BWORD         ; #3710 33DE - +WORD
   .word _CFL             ; #3712 2F44 - CFL
   .word _ALLOT           ; #3714 2B73 - ALLOT
   .word _EXIT            ; #3716 21A8 - EXIT

NFA__3CBUILDS:   ; 3718
   .byte 7,"<BUILDS"
   .word NFA_CREATE       ; 36DA
__3CBUILDS:      ; 3722 - 3729
   call _FCALL            ; 3722
   .word _CREATE          ; #3725 36E3 - CREATE
   .word _EXIT            ; #3727 21A8 - EXIT

NFA__28DOES_3E_29:; 3729
   .byte 7,"(DOES>)"
   .word NFA__3CBUILDS      ; 3718
i__28DOES_3E_29:  ; 3733 - 373C
   call _FCALL            ; 3733
   .word _R_3E            ; #3736 27BC - R>
   .word __28_21CODE_29   ; #3738 332F - (!CODE)
   .word _EXIT            ; #373a 21A8 - EXIT

NFA_DOES_3E:     ; 373C
   .byte 0x85,"DOES>" ; IMMEDIATE
   .word NFA__28DOES_3E_29      ; 3729
_DOES_3E:        ; 3744 - 3757
   call _FCALL            ; 3744
   .word _COMPILE         ; #3747 2BE9 - COMPILE
   .word __28DOES_3E_29   ; #3749 3733 - (DOES>)
   .word _CALL            ; #374b 2201 - CALL
   .word _HERE            ; #374d 2B62 - HERE
   .word __21CF           ; #374f 3314 - !CF
   .word _CFL             ; #3751 2F44 - CFL
   .word _ALLOT           ; #3753 2B73 - ALLOT
   .word _EXIT            ; #3755 21A8 - EXIT

NFA_CONSTANT:    ; 3757
   .byte 8,"CONSTANT"
   .word NFA_DOES_3E        ; 373C
_CONSTANT:       ; 3762 - 3771
   call _FCALL            ; 3762
   .word _CREATE          ; #3765 36E3 - CREATE
   .word __2C             ; #3767 2B80 - ,
   .word _LIT             ; #3769 28C7 - LIT
   .word __40             ; #376b 2820 - @
   .word __28_21CODE_29   ; #376d 332F - (!CODE)
   .word _EXIT            ; #376f 21A8 - EXIT

NFA_VARIABLE:    ; 3771
   .byte 8,"VARIABLE"
   .word NFA_CONSTANT     ; 3757
_VARIABLE:       ; 377C - 378B
   call _FCALL            ; 377C
   .word _CREATE          ; #377f 36E3 - CREATE
   .word _0               ; #3781 2B2B - 0
   .word __2C             ; #3783 2B80 - ,
   .word _NEXT            ; #3785 21F5 - NEXT
   .word __28_21CODE_29   ; #3787 332F - (!CODE)
   .word _EXIT            ; #3789 21A8 - EXIT

NFA_VOCABULARY:  ; 378B
   .byte 10,"VOCABULARY"
   .word NFA_VARIABLE     ; 3771
_VOCABULARY:     ; 3798 - 37DC
   call _FCALL            ; 3798
   .word _LIT             ; #379b 28C7 - LIT
   .word l6008            ; #379d 6008
   .word __40             ; #379f 2820 - @
   .word __3FDUP          ; #37a1 2284 - ?DUP
   .word __3FBRANCH       ; #37a3 2916 - ?BRANCH
   .word @37AB            ; #37a5 37AB
   .word _EXECUTE         ; #37a7 21BF - EXECUTE
   .word _EXIT            ; #37a9 21A8 - EXIT
@37AB:
   .word _CREATE          ; #37ab 36E3 - CREATE
   .word _LIT             ; #37ad 28C7 - LIT
   .word 0001             ; #37af 0001
   .word _C_2C            ; #37b1 2B92 - C,
   .word _LIT             ; #37b3 28C7 - LIT
   .word 0x0080           ; #37b5 0080
   .word _C_2C            ; #37b7 2B92 - C,
   .word _CURRENT         ; #37b9 20F3 - CURRENT
   .word __40             ; #37bb 2820 - @
   .word _2               ; #37bd 2B3D - 2
   .word __2D             ; #37bf 22F8 - -
   .word __2C             ; #37c1 2B80 - ,
   .word _HERE            ; #37c3 2B62 - HERE
   .word _VOC_2DLINK      ; #37c5 20A1 - VOC-LINK
   .word __40             ; #37c7 2820 - @
   .word __2C             ; #37c9 2B80 - ,
   .word _VOC_2DLINK      ; #37cb 20A1 - VOC-LINK
   .word __21             ; #37cd 2839 - !
   .word __28DOES_3E_29   ; #37cf 3733 - (DOES>)
VOCABULARY_DOES:
   call _FCALL      ; #37d1 cd 8f 21
   .word _2_2B            ; #37d4 2325 - 2+
   .word _CONTEXT         ; #37d6 20E4 - CONTEXT
   .word __21             ; #37d8 2839 - !
   .word _EXIT            ; #37da 21A8 - EXIT

NFA_STRING:      ; 37DC
   .byte 6,"STRING"
   .word NFA_VOCABULARY   ; 378B
_STRING:         ; 37E5 - 37F2
   call _FCALL            ; 37E5
   .word _CREATE          ; #37e8 36E3 - CREATE
   .word __22_2C          ; #37ea 2BA4 - ",
   .word _NEXT            ; #37ec 21F5 - NEXT
   .word __28_21CODE_29   ; #37ee 332F - (!CODE)
   .word _EXIT            ; #37f0 21A8 - EXIT

.ENDS
