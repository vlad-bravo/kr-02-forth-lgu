
.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "interpret" FREE

.DEF PREV_NFA PREV_NFA_INTERPRET
.DEF PREFIX PREFIX_INTERPRET

NFA2 "S.", "S_2E"
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

NFA2 "WHILE" ,"WHILE", IMMEDIATE
   call _FCALL            ; 3AFB
   .word __3FCOMP         ; #3afe 3862 - ?COMP
   .word _1               ; #3b00 2B34 - 1
   .word __3FPAIRS        ; #3b02 3893 - ?PAIRS
   .word _1               ; #3b04 2B34 - 1
   .word _IF              ; #3b06 39EC - IF
   .word _2_2B            ; #3b08 2325 - 2+
   .word _EXIT            ; #3b0a 21A8 - EXIT

NFA2 "REPEAT", "REPEAT", IMMEDIATE
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

NFA "FORGET"
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

NFA "VOCABULARY"
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

.ENDS
