; ФОРТ-7970 ВЕРСИЯ 6.2 ОТ 19.06.85 (СТАНДАРТ FORTH-83)
; В.А.КИРИЛЛИН А.А.КЛУБОВИЧ Н.Р.НОЗДРУНОВ
; ВЦ ЛГУ
; 198904 ЛЕНИНГРАД ПЕТРОДВОРЕЦ БИБЛИОТЕЧНАЯ ПЛ. Д. 2

.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.BANK 0 SLOT 0
.ORGA 0x0000

l2000:
   jmp _COLD

NFA_COLD:
   .byte 4,"COLD"
   .word NFA_FORTH
_COLD:
   lxi d,N_FORTH
   lxi h,NFA_FORTH
   mvi b,0x11
@200e:
   ldax d
   mov m,a
   inx h
   inx d
   dcr b
   jnz @200e
   mvi b,0x1a
   lxi h,l6000
   sub a
@201c:
   mov m,a
   inx h
   dcr b
   jnz @201c
   lhld l217b
   shld l601c
   lhld l217d
   shld l601e
   lhld l217f
   shld l6020
   lhld l2181
   shld l6024
   lhld l2183
   shld l6022
l2040:
   lhld l601e
   sphl
   lhld l601c
   shld l601a
   lxi b,l2050     ; 
   jmp _FNEXT

l2050:
   .word _LIT             ; LIT
   .word l6018            ; 
   .word __40             ; @
   .word __3FDUP          ; ?DUP
   .word __3FBRANCH       ; ?BRANCH
   .word @2060            ; 
   .word _EXECUTE, _EXIT
@2060:
   .word _STANDIO, _TITLE, _DECIMAL, _QUIT

_FCALL:
   lhld l601a
   dcx h
   mov m,b
   dcx h
   mov m,c
   shld l601a
   pop b
_FNEXT:
   ldax b
   mov l,a
   inx b
   ldax b
   mov h,a
   inx b
   pchl

NFA_EXIT:
   .byte 4,"EXIT"
   .word NFA_COLD
_EXIT:
   lhld l601a
   mov c,m
   inx h
   mov b,m
   inx h
   shld l601a
   jmp _FNEXT

N_FORTH:       ; 2068
   .byte 5,"FORTH"
   .word 0000
;_FORTH:             ; 2070 - None
   call VOCABULARY_DOES ; #2070 cd d1 37
   .byte 0x01        ; #2073
   .byte 0x80        ; #2074 nfa (fake)
   .word NFA_STANDIO ; #2075 lfa
   .word 0000        ; #2077 voc-link

;!!!
l217b:
   .word l6095
l217d:
   .word l6139
l217f:
   .word l614d
l2181:
   .word l614d
l2183:
   .word l3f91

NFA_EXECUTE:     ; 21B5
   .byte 7,"EXECUTE"
   .word NFA_TIB
_EXECUTE:        ; 21BF - 21C0
   ret

NFA_ASMCALL:     ; 21C0
   .byte 7,"ASMCALL"
   .word NFA_EXECUTE      ; 21B5
_ASMCALL:        ; 21CA - 21EE
   lhld l601a      ; #21ca 2a 1a 60
   dcx h           ; #21cd 2b
   mov m,b         ; #21ce 70
   dcx h           ; #21cf 2b
   mov m,c         ; #21d0 71
   shld l601a      ; #21d1 22 1a 60
   pop h           ; #21d4 e1
   pop b           ; #21d5 c1
   pop d           ; #21d6 d1
   xthl            ; #21d7 e3
   shld l613d      ; #21d8 22 3d 61
   pop h           ; #21db e1
   pop psw         ; #21dc f1
   push h          ; #21dd e5
   lxi h,l21e7     ; #21de 21 e7 21
   xthl            ; #21e1 e3
   push h          ; #21e2 e5
   lhld l613d      ; #21e3 2a 3d 61
   ret             ; #21e6 c9
l21e7:
   push psw        ; #21e7 f5
   push h          ; #21e8 e5
   push d          ; #21e9 d5
   push b          ; #21ea c5
   jmp _EXIT       ; #21eb c3 a8 21

NFA_OVER:        ; 2206
   .byte 4,"OVER"
   .word NFA_CALL         ; 21FA
_OVER:           ; 220D - 2215
   pop h           ; #220d e1
   pop d           ; #220e d1
   push d          ; #220f d5
   push h          ; #2210 e5
   push d          ; #2211 d5
   jmp _FNEXT      ; #2212 c3 9a 21

NFA_PICK:        ; 2215
   .byte 4,"PICK"
   .word NFA_OVER         ; 2206
_PICK:           ; 221C - 2226
   pop h           ; #221c e1
   dad h           ; #221d 29
   dad sp          ; #221e 39
   mov e,m         ; #221f 5e
   inx h           ; #2220 23
   mov d,m         ; #2221 56
   push d          ; #2222 d5
   jmp _FNEXT      ; #2223 c3 9a 21

NFA_DROP:        ; 2226
   .byte 4,"DROP"
   .word NFA_PICK         ; 2215
_DROP:           ; 222D - 2231
   pop h           ; #222d e1
   jmp _FNEXT      ; #222e c3 9a 21

NFA_SWAP:        ; 2231
   .byte 4,"SWAP"
   .word NFA_DROP         ; 2226
_SWAP:           ; 2238 - 223E
   pop h           ; #2238 e1
   xthl            ; #2239 e3
   push h          ; #223a e5
   jmp _FNEXT      ; #223b c3 9a 21

NFA_2SWAP:       ; 223E
   .byte 5,"2SWAP"
   .word NFA_SWAP         ; 2231
_2SWAP:          ; 2246 - 2254
   pop d           ; #2246 d1
   pop h           ; #2247 e1
   inx sp          ; #2248 33
   inx sp          ; #2249 33
   xthl            ; #224a e3
   xchg            ; #224b eb
   dcx sp          ; #224c 3b
   dcx sp          ; #224d 3b
   xthl            ; #224e e3
   push d          ; #224f d5
   push h          ; #2250 e5
   jmp _FNEXT      ; #2251 c3 9a 21

NFA_ROT:         ; 2254
   .byte 3,"ROT"
   .word NFA_2SWAP        ; 223E
_ROT:            ; 225A - 2262
   pop d           ; #225a d1
   pop h           ; #225b e1
   xthl            ; #225c e3
   push d          ; #225d d5
   push h          ; #225e e5
   jmp _FNEXT      ; #225f c3 9a 21

NFA__2DROT:      ; 2262
   .byte 4,"-ROT"
   .word NFA_ROT          ; 2254
__2DROT:         ; 2269 - 2271
   pop h           ; #2269 e1
   pop d           ; #226a d1
   xthl            ; #226b e3
   push h          ; #226c e5
   push d          ; #226d d5
   jmp _FNEXT      ; #226e c3 9a 21

NFA_DUP:         ; 2271
   .byte 3,"DUP"
   .word NFA__2DROT         ; 2262
_DUP:            ; 2277 - 227D
   pop h           ; #2277 e1
   push h          ; #2278 e5
   push h          ; #2279 e5
   jmp _FNEXT      ; #227a c3 9a 21

NFA__3FDUP:      ; 227D
   .byte 4,"?DUP"
   .word NFA_DUP          ; 2271
__3FDUP:         ; 2284 - 228F
   pop h           ; #2284 e1
   push h          ; #2285 e5
   mov a,h         ; #2286 7c
   ora l           ; #2287 b5
   jz _FNEXT       ; #2288 ca 9a 21
   push h          ; #228b e5
   jmp _FNEXT      ; #228c c3 9a 21

NFA_2DUP:        ; 228F
   .byte 4,"2DUP"
   .word NFA__3FDUP         ; 227D
_2DUP:           ; 2296 - 229F
   pop h           ; #2296 e1
   pop d           ; #2297 d1
   push d          ; #2298 d5
   push h          ; #2299 e5
   push d          ; #229a d5
   push h          ; #229b e5
   jmp _FNEXT      ; #229c c3 9a 21

NFA_2DROP:       ; 229F
   .byte 5,"2DROP"
   .word NFA_2DUP         ; 228F
_2DROP:          ; 22A7 - 22AC
   pop d           ; #22a7 d1
   pop d           ; #22a8 d1
   jmp _FNEXT      ; #22a9 c3 9a 21

NFA_PRESS:       ; 22AC
   .byte 5,"PRESS"
   .word NFA_2DROP        ; 229F
_PRESS:          ; 22B4 - 22B9
   pop h           ; #22b4 e1
   xthl            ; #22b5 e3
   jmp _FNEXT      ; #22b6 c3 9a 21

NFA_2OVER:       ; 22B9
   .byte 5,"2OVER"
   .word NFA_PRESS        ; 22AC
_2OVER:          ; 22C1 - 22D0
   pop d           ; #22c1 d1
   pop d           ; #22c2 d1
   pop d           ; #22c3 d1
   pop h           ; #22c4 e1
   push h          ; #22c5 e5
   push d          ; #22c6 d5
   dcx sp          ; #22c7 3b
   dcx sp          ; #22c8 3b
   dcx sp          ; #22c9 3b
   dcx sp          ; #22ca 3b
   push h          ; #22cb e5
   push d          ; #22cc d5
   jmp _FNEXT      ; #22cd c3 9a 21

NFA_SP_40:       ; 22D0
   .byte 3,"SP@"
   .word NFA_2OVER        ; 22B9
_SP_40:          ; 22D6 - 22DE
   lxi h,0000      ; #22d6 21 00 00
   dad sp          ; #22d9 39
   push h          ; #22da e5
   jmp _FNEXT      ; #22db c3 9a 21

NFA_SP_21:       ; 22DE
   .byte 3,"SP!"
   .word NFA_SP_40          ; 22D0
_SP_21:          ; 22E4 - 22E9
   pop h           ; #22e4 e1
   sphl            ; #22e5 f9
   jmp _FNEXT      ; #22e6 c3 9a 21

NFA__2DTRAILING: ; 2437
   .byte 9,"-TRAILING"
   .word NFA_0_3D           ; 241C
__2DTRAILING:    ; 2443 - 245B
   pop d           ; #2443 d1
   mov a,e         ; #2444 7b
   ora a           ; #2445 b7
   jz @2457        ; #2446 ca 57 24
   pop h           ; #2449 e1
   push h          ; #244a e5
   dad d           ; #244b 19
@244c:
   dcx h           ; #244c 2b
   mov a,m         ; #244d 7e
   cpi 0x20        ; #244e fe 20
   jnz @2457       ; #2450 c2 57 24
   dcr e           ; #2453 1d
   jnz @244c       ; #2454 c2 4c 24
@2457:
   push d          ; #2457 d5
   jmp _FNEXT      ; #2458 c3 9a 21

NFA__2DTEXT:     ; 24D8
   .byte 5,"-TEXT"
   .word NFA_DNEGATE      ; 24B9
__2DTEXT:        ; 24E0 - 250D
   mov h,b         ; #24e0 60
   mov l,c         ; #24e1 69
   pop d           ; #24e2 d1
   pop b           ; #24e3 c1
   xthl            ; #24e4 e3
   xchg            ; #24e5 eb
   mov a,b         ; #24e6 78
   ora c           ; #24e7 b1
   jz @2500        ; #24e8 ca 00 25
   mov a,c         ; #24eb 79
   ora a           ; #24ec b7
   jz @24f1        ; #24ed ca f1 24
   inr b           ; #24f0 04
@24f1:
   ldax d          ; #24f1 1a
   sub m           ; #24f2 96
   jnz @2500       ; #24f3 c2 00 25
   inx d           ; #24f6 13
   inx h           ; #24f7 23
   dcr c           ; #24f8 0d
   jnz @24f1       ; #24f9 c2 f1 24
   dcr b           ; #24fc 05
   jnz @24f1       ; #24fd c2 f1 24
@2500:
   mov l,a         ; #2500 6f
   mvi h,00        ; #2501 26 00
   ora a           ; #2503 b7
   jp @2508        ; #2504 f2 08 25
   dcr h           ; #2507 25
@2508:
   pop b           ; #2508 c1
   push h          ; #2509 e5
   jmp _FNEXT      ; #250a c3 9a 21

NFA_ROLL:        ; 250D
   .byte 4,"ROLL"
   .word NFA__2DTEXT        ; 24D8
_ROLL:           ; 2514 - 2538
   pop h           ; #2514 e1
   mov a,h         ; #2515 7c
   ora l           ; #2516 b5
   jz _FNEXT       ; #2517 ca 9a 21
   inx h           ; #251a 23
   dad h           ; #251b 29
   push h          ; #251c e5
   dad sp          ; #251d 39
   mov e,m         ; #251e 5e
   inx h           ; #251f 23
   mov d,m         ; #2520 56
   xchg            ; #2521 eb
   xthl            ; #2522 e3
   xchg            ; #2523 eb
   push b          ; #2524 c5
   mov b,h         ; #2525 44
   mov c,l         ; #2526 4d
   dcx b           ; #2527 0b
   dcx b           ; #2528 0b
@2529:
   ldax b          ; #2529 0a
   mov m,a         ; #252a 77
   dcx h           ; #252b 2b
   dcx b           ; #252c 0b
   dcx d           ; #252d 1b
   mov a,d         ; #252e 7a
   ora e           ; #252f b3
   jnz @2529       ; #2530 c2 29 25
   pop b           ; #2533 c1
   pop h           ; #2534 e1
   jmp _FNEXT      ; #2535 c3 9a 21

NFA__3FWORD:     ; 26D3
   .byte 5,"?WORD"
   .word NFA_U_2FMOD        ; 26BF
__3FWORD:        ; 26DB - 2727
   pop h           ; #26db e1
   pop d           ; #26dc d1
   push b          ; #26dd c5
   push d          ; #26de d5
   mvi b,00        ; #26df 06 00
@26e1:
   shld l6026      ; #26e1 22 26 60
   mov e,m         ; #26e4 5e
   inx h           ; #26e5 23
   mov d,m         ; #26e6 56
   xchg            ; #26e7 eb
   mov a,h         ; #26e8 7c
   ora l           ; #26e9 b5
   jz @271d        ; #26ea ca 1d 27
   pop d           ; #26ed d1
   push d          ; #26ee d5
   push h          ; #26ef e5
   mov a,m         ; #26f0 7e
   ani 0x7f        ; #26f1 e6 7f
   mov c,a         ; #26f3 4f
   ldax d          ; #26f4 1a
   cmp c           ; #26f5 b9
   jnz @2713       ; #26f6 c2 13 27
   ora c           ; #26f9 b1
   jz @2708        ; #26fa ca 08 27
@26fd:
   inx h           ; #26fd 23
   inx d           ; #26fe 13
   ldax d          ; #26ff 1a
   cmp m           ; #2700 be
   jnz @2718       ; #2701 c2 18 27
   dcr c           ; #2704 0d
   jnz @26fd       ; #2705 c2 fd 26
@2708:
   pop h           ; #2708 e1
   pop d           ; #2709 d1
   pop b           ; #270a c1
   push h          ; #270b e5
   lxi h,0xffff    ; #270c 21 ff ff
   push h          ; #270f e5
   jmp _FNEXT      ; #2710 c3 9a 21
@2713:
   mov a,c         ; #2713 79
   ani 0x3f        ; #2714 e6 3f
   mov c,a         ; #2716 4f
   inx b           ; #2717 03
@2718:
   dad b           ; #2718 09
   pop d           ; #2719 d1
   jmp @26e1       ; #271a c3 e1 26
@271d:
   pop d           ; #271d d1
   pop b           ; #271e c1
   push d          ; #271f d5
   lxi h,0000      ; #2720 21 00 00
   push h          ; #2723 e5
   jmp _FNEXT      ; #2724 c3 9a 21

NFA_DIGIT:       ; 2727
   .byte 5,"DIGIT"
   .word NFA__3FWORD        ; 26D3
_DIGIT:          ; 272F - 275E
   pop d           ; #272f d1
   pop h           ; #2730 e1
   mov a,l         ; #2731 7d
   cpi 0x30        ; #2732 fe 30
   jm @2757        ; #2734 fa 57 27
   cpi 0x3a        ; #2737 fe 3a
   jp @274b        ; #2739 f2 4b 27
   sui 0x30        ; #273c d6 30
@273e:
   cmp e           ; #273e bb
   jp @2757        ; #273f f2 57 27
   mov l,a         ; #2742 6f
   push h          ; #2743 e5
   lxi h,0xffff    ; #2744 21 ff ff
   push h          ; #2747 e5
   jmp _FNEXT      ; #2748 c3 9a 21
@274b:
   cpi 0x41        ; #274b fe 41
   jm @2757        ; #274d fa 57 27
   sui 0x41        ; #2750 d6 41
   adi 0x0a        ; #2752 c6 0a
   jmp @273e       ; #2754 c3 3e 27
@2757:
   lxi h,0000      ; #2757 21 00 00
   push h          ; #275a e5
   jmp _FNEXT      ; #275b c3 9a 21

NFA__3ER:        ; 27A4
   .byte 2,">R"
   .word NFA_NOT          ; 2793
__3ER:           ; 27A9 - 27B7
   pop d           ; #27a9 d1
   lhld l601a      ; #27aa 2a 1a 60
   dcx h           ; #27ad 2b
   mov m,d         ; #27ae 72
   dcx h           ; #27af 2b
   mov m,e         ; #27b0 73
   shld l601a      ; #27b1 22 1a 60
   jmp _FNEXT      ; #27b4 c3 9a 21

NFA_R_3E:        ; 27B7
   .byte 2,"R>"
   .word NFA__3ER           ; 27A4
_R_3E:           ; 27BC - 27CA
   lhld l601a      ; #27bc 2a 1a 60
   mov e,m         ; #27bf 5e
   inx h           ; #27c0 23
   mov d,m         ; #27c1 56
   inx h           ; #27c2 23
   push d          ; #27c3 d5
   shld l601a      ; #27c4 22 1a 60
   jmp _FNEXT      ; #27c7 c3 9a 21

NFA_R_40:        ; 27CA
   .byte 2,"R@"
   .word NFA_R_3E           ; 27B7
_R_40:           ; 27CF - 27D9
   lhld l601a      ; #27cf 2a 1a 60
   mov e,m         ; #27d2 5e
   inx h           ; #27d3 23
   mov d,m         ; #27d4 56
   push d          ; #27d5 d5
   jmp _FNEXT      ; #27d6 c3 9a 21

NFA_RP_40:       ; 27D9
   .byte 3,"RP@"
   .word NFA_R_40           ; 27CA
_RP_40:          ; 27DF - 27E6
   lhld l601a      ; #27df 2a 1a 60
   push h          ; #27e2 e5
   jmp _FNEXT      ; #27e3 c3 9a 21

NFA_RP_21:       ; 27E6
   .byte 3,"RP!"
   .word NFA_RP_40          ; 27D9
_RP_21:          ; 27EC - 27F3
   pop h           ; #27ec e1
   shld l601a      ; #27ed 22 1a 60
   jmp _FNEXT      ; #27f0 c3 9a 21

NFA_RPICK:       ; 27F3
   .byte 5,"RPICK"
   .word NFA_RP_21          ; 27E6
_RPICK:          ; 27FB - 2809
   pop h           ; #27fb e1
   dad h           ; #27fc 29
   xchg            ; #27fd eb
   lhld l601a      ; #27fe 2a 1a 60
   dad d           ; #2801 19
   mov e,m         ; #2802 5e
   inx h           ; #2803 23
   mov d,m         ; #2804 56
   push d          ; #2805 d5
   jmp _FNEXT      ; #2806 c3 9a 21

NFA_RDROP:       ; 2809
   .byte 5,"RDROP"
   .word NFA_RPICK        ; 27F3
_RDROP:          ; 2811 - 281C
   lhld l601a      ; #2811 2a 1a 60
   inx h           ; #2814 23
   inx h           ; #2815 23
   shld l601a      ; #2816 22 1a 60
   jmp _FNEXT      ; #2819 c3 9a 21

NFA__40:         ; 281C
   .byte 1,"@"
   .word NFA_RDROP        ; 2809
__40:            ; 2820 - 2828
   pop h           ; #2820 e1
   mov e,m         ; #2821 5e
   inx h           ; #2822 23
   mov d,m         ; #2823 56
   push d          ; #2824 d5
   jmp _FNEXT      ; #2825 c3 9a 21

NFA_C_40:        ; 2828
   .byte 2,"C@"
   .word NFA__40            ; 281C
_C_40:           ; 282D - 2835
   pop h           ; #282d e1
   mov e,m         ; #282e 5e
   mvi d,00        ; #282f 16 00
   push d          ; #2831 d5
   jmp _FNEXT      ; #2832 c3 9a 21

NFA__21:         ; 2835
   .byte 1,"!"
   .word NFA_C_40           ; 2828
__21:            ; 2839 - 2841
   pop h           ; #2839 e1
   pop d           ; #283a d1
   mov m,e         ; #283b 73
   inx h           ; #283c 23
   mov m,d         ; #283d 72
   jmp _FNEXT      ; #283e c3 9a 21

NFA_C_21:        ; 2841
   .byte 2,"C!"
   .word NFA__21            ; 2835
_C_21:           ; 2846 - 284C
   pop h           ; #2846 e1
   pop d           ; #2847 d1
   mov m,e         ; #2848 73
   jmp _FNEXT      ; #2849 c3 9a 21

NFA_2_21:        ; 284C
   .byte 2,"2!"
   .word NFA_C_21           ; 2841
_2_21:           ; 2851 - 285E
   pop h           ; #2851 e1
   pop d           ; #2852 d1
   mov m,e         ; #2853 73
   inx h           ; #2854 23
   mov m,d         ; #2855 72
   inx h           ; #2856 23
   pop d           ; #2857 d1
   mov m,e         ; #2858 73
   inx h           ; #2859 23
   mov m,d         ; #285a 72
   jmp _FNEXT      ; #285b c3 9a 21

NFA_2_40:        ; 285E
   .byte 2,"2@"
   .word NFA_2_21           ; 284C
_2_40:           ; 2863 - 2871
   pop h           ; #2863 e1
   mov e,m         ; #2864 5e
   inx h           ; #2865 23
   mov d,m         ; #2866 56
   inx h           ; #2867 23
   mov a,m         ; #2868 7e
   inx h           ; #2869 23
   mov h,m         ; #286a 66
   mov l,a         ; #286b 6f
   push h          ; #286c e5
   push d          ; #286d d5
   jmp _FNEXT      ; #286e c3 9a 21

NFA__2B_21:      ; 2871
   .byte 2,"+!"
   .word NFA_2_40           ; 285E
__2B_21:         ; 2876 - 2882
   pop h           ; #2876 e1
   pop d           ; #2877 d1
   mov a,m         ; #2878 7e
   add e           ; #2879 83
   mov m,a         ; #287a 77
   inx h           ; #287b 23
   mov a,m         ; #287c 7e
   adc d           ; #287d 8a
   mov m,a         ; #287e 77
   jmp _FNEXT      ; #287f c3 9a 21

NFA__2D_21:      ; 2882
   .byte 2,"-!"
   .word NFA__2B_21           ; 2871
__2D_21:         ; 2887 - 2893
   pop h           ; #2887 e1
   pop d           ; #2888 d1
   mov a,m         ; #2889 7e
   sub e           ; #288a 93
   mov m,a         ; #288b 77
   inx h           ; #288c 23
   mov a,m         ; #288d 7e
   sbb d           ; #288e 9a
   mov m,a         ; #288f 77
   jmp _FNEXT      ; #2890 c3 9a 21

NFA_0_21:        ; 2893
   .byte 2,"0!"
   .word NFA__2D_21           ; 2882
_0_21:           ; 2898 - 28A0
   sub a           ; #2898 97
   pop h           ; #2899 e1
   mov m,a         ; #289a 77
   inx h           ; #289b 23
   mov m,a         ; #289c 77
   jmp _FNEXT      ; #289d c3 9a 21

NFA_1_2B_21:     ; 28A0
   .byte 3,"1+!"
   .word NFA_0_21           ; 2893
_1_2B_21:        ; 28A6 - 28B0
   pop h           ; #28a6 e1
   inr m           ; #28a7 34
   jnz _FNEXT      ; #28a8 c2 9a 21
   inx h           ; #28ab 23
   inr m           ; #28ac 34
   jmp _FNEXT      ; #28ad c3 9a 21

NFA_1_2D_21:     ; 28B0
   .byte 3,"1-!"
   .word NFA_1_2B_21          ; 28A0
_1_2D_21:        ; 28B6 - 28C1
   pop h           ; #28b6 e1
   mov e,m         ; #28b7 5e
   inx h           ; #28b8 23
   mov d,m         ; #28b9 56
   dcx d           ; #28ba 1b
   mov m,d         ; #28bb 72
   dcx h           ; #28bc 2b
   mov m,e         ; #28bd 73
   jmp _FNEXT      ; #28be c3 9a 21

NFA_LIT:         ; 28C1
   .byte 3,"LIT"
   .word NFA_1_2D_21          ; 28B0
_LIT:            ; 28C7 - 28D1
   ldax b          ; #28c7 0a
   mov l,a         ; #28c8 6f
   inx b           ; #28c9 03
   ldax b          ; #28ca 0a
   mov h,a         ; #28cb 67
   inx b           ; #28cc 03
   push h          ; #28cd e5
   jmp _FNEXT      ; #28ce c3 9a 21

NFA_DLIT:        ; 28D1
   .byte 4,"DLIT"
   .word NFA_LIT          ; 28C1
_DLIT:           ; 28D8 - 28E9
   ldax b          ; #28d8 0a
   mov e,a         ; #28d9 5f
   inx b           ; #28da 03
   ldax b          ; #28db 0a
   mov d,a         ; #28dc 57
   inx b           ; #28dd 03
   ldax b          ; #28de 0a
   mov l,a         ; #28df 6f
   inx b           ; #28e0 03
   ldax b          ; #28e1 0a
   mov h,a         ; #28e2 67
   inx b           ; #28e3 03
   push h          ; #28e4 e5
   push d          ; #28e5 d5
   jmp _FNEXT      ; #28e6 c3 9a 21

NFA__28_22_29:   ; 28E9
   .byte 3,"(\")"
   .word NFA_DLIT         ; 28D1
__28_22_29:      ; 28EF - 28FB
   push b          ; #28ef c5
   ldax b          ; #28f0 0a
   mov l,a         ; #28f1 6f
   mvi h,00        ; #28f2 26 00
   inx h           ; #28f4 23
   dad b           ; #28f5 09
   mov b,h         ; #28f6 44
   mov c,l         ; #28f7 4d
   jmp _FNEXT      ; #28f8 c3 9a 21

NFA_BRANCH:      ; 28FB
   .byte 6,"BRANCH"
   .word NFA__28_22_29          ; 28E9
_BRANCH:         ; 2904 - 290C
   mov h,b         ; #2904 60
   mov l,c         ; #2905 69
   mov c,m         ; #2906 4e
   inx h           ; #2907 23
   mov b,m         ; #2908 46
   jmp _FNEXT      ; #2909 c3 9a 21

NFA__3FBRANCH:   ; 290C
   .byte 7,"?BRANCH"
   .word NFA_BRANCH       ; 28FB
__3FBRANCH:      ; 2916 - 2929
   pop d           ; #2916 d1
   mov a,d         ; #2917 7a
   ora e           ; #2918 b3
   jnz @2924       ; #2919 c2 24 29
   mov h,b         ; #291c 60
   mov l,c         ; #291d 69
   mov c,m         ; #291e 4e
   inx h           ; #291f 23
   mov b,m         ; #2920 46
   jmp _FNEXT      ; #2921 c3 9a 21
@2924:
   inx b           ; #2924 03
   inx b           ; #2925 03
   jmp _FNEXT      ; #2926 c3 9a 21

NFA_N_3FBRANCH:  ; 2929
   .byte 8,"N?BRANCH"
   .word NFA__3FBRANCH      ; 290C
_N_3FBRANCH:     ; 2934 - 2947
   pop d           ; #2934 d1
   mov a,d         ; #2935 7a
   ora e           ; #2936 b3
   jnz @293f       ; #2937 c2 3f 29
   inx b           ; #293a 03
   inx b           ; #293b 03
   jmp _FNEXT      ; #293c c3 9a 21
@293f:
   mov h,b         ; #293f 60
   mov l,c         ; #2940 69
   mov c,m         ; #2941 4e 
   inx h           ; #2942 23
   mov b,m         ; #2943 46
   jmp _FNEXT      ; #2944 c3 9a 21

NFA_I:           ; 2947
   .byte 1,"I"
   .word NFA_N_3FBRANCH     ; 2929
_I:              ; 294B - 2955
   lhld l601a      ; #294b 2a 1a 60
   mov e,m         ; #294e 5e
   inx h           ; #294f 23
   mov d,m         ; #2950 56
   push d          ; #2951 d5
   jmp _FNEXT      ; #2952 c3 9a 21

NFA_J:           ; 2955
   .byte 1,"J"
   .word NFA_I            ; 2947
_J:              ; 2959 - 2967
   lhld l601a      ; #2959 2a 1a 60
   lxi d,0006      ; #295c 11 06 00
   dad d           ; #295f 19
   mov e,m         ; #2960 5e
   inx h           ; #2961 23
   mov d,m         ; #2962 56
   push d          ; #2963 d5
   jmp _FNEXT      ; #2964 c3 9a 21

NFA_K:           ; 2967
   .byte 1,"K"
   .word NFA_J            ; 2955
_K:              ; 296B - 2979
   lhld l601a      ; #296b 2a 1a 60
   lxi d,0x000c    ; #296e 11 0c 00
   dad d           ; #2971 19
   mov e,m         ; #2972 5e
   inx h           ; #2973 23
   mov d,m         ; #2974 56
   push d          ; #2975 d5
   jmp _FNEXT      ; #2976 c3 9a 21

NFA_TOGGLE:      ; 2979
   .byte 6,"TOGGLE"
   .word NFA_K            ; 2967
_TOGGLE:         ; 2982 - 298A
   pop d           ; #2982 d1
   mov a,e         ; #2983 7b
   pop h           ; #2984 e1
   xra m           ; #2985 ae
   mov m,a         ; #2986 77
   jmp _FNEXT      ; #2987 c3 9a 21

NFA__28DO_29:    ; 298A
   .byte 4,"(DO)"
   .word NFA_TOGGLE       ; 2979
__28DO_29:       ; 2991 - 29B0
   pop h           ; #2991 e1
   xthl            ; #2992 e3
   push h          ; #2993 e5
   lhld l601a      ; #2994 2a 1a 60
   ldax b          ; #2997 0a
   mov d,a         ; #2998 57
   inx b           ; #2999 03
   ldax b          ; #299a 0a
   inx b           ; #299b 03
   dcx h           ; #299c 2b
   mov m,a         ; #299d 77
   dcx h           ; #299e 2b
   mov m,d         ; #299f 72
   pop d           ; #29a0 d1
   dcx h           ; #29a1 2b
   mov m,d         ; #29a2 72
   dcx h           ; #29a3 2b
   mov m,e         ; #29a4 73
   pop d           ; #29a5 d1
   dcx h           ; #29a6 2b
   mov m,d         ; #29a7 72
   dcx h           ; #29a8 2b
   mov m,e         ; #29a9 73
   shld l601a      ; #29aa 22 1a 60
   jmp _FNEXT      ; #29ad c3 9a 21

NFA__28_3FDO_29: ; 29B0
   .byte 5,"(?DO)"
   .word NFA__28DO_29         ; 298A
__28_3FDO_29:    ; 29B8 - 29D1
   pop h           ; #29b8 e1
   pop d           ; #29b9 d1
   push d          ; #29ba d5
   push h          ; #29bb e5
   mov a,l         ; #29bc 7d
   cmp e           ; #29bd bb
   jnz __28DO_29   ; #29be c2 91 29
   mov a,h         ; #29c1 7c
   cmp d           ; #29c2 ba
   jnz __28DO_29   ; #29c3 c2 91 29
   ldax b          ; #29c6 0a
   mov d,a         ; #29c7 57
   inx b           ; #29c8 03
   ldax b          ; #29c9 0a
   mov b,a         ; #29ca 47
   mov c,d         ; #29cb 4a
   pop h           ; #29cc e1
   pop h           ; #29cd e1
   jmp _FNEXT      ; #29ce c3 9a 21

NFA__28LOOP_29:  ; 29D1
   .byte 6,"(LOOP)"
   .word NFA__28_3FDO_29        ; 29B0
__28LOOP_29:     ; 29DA - 2A05
   lhld l601a      ; #29da 2a 1a 60
   mov e,m         ; #29dd 5e
   inx h           ; #29de 23
   mov d,m         ; #29df 56
   inx h           ; #29e0 23
   inx d           ; #29e1 13
l29e2:
   mov a,m         ; #29e2 7e
   inx h           ; #29e3 23
   cmp e           ; #29e4 bb
   jnz @29f8       ; #29e5 c2 f8 29
   mov a,m         ; #29e8 7e
   cmp d           ; #29e9 ba
   jnz @29f8       ; #29ea c2 f8 29
   inx h           ; #29ed 23
   inx h           ; #29ee 23
   inx h           ; #29ef 23
   shld l601a      ; #29f0 22 1a 60
   inx b           ; #29f3 03
   inx b           ; #29f4 03
   jmp _FNEXT      ; #29f5 c3 9a 21
@29f8:
   dcx h           ; #29f8 2b
   dcx h           ; #29f9 2b
   mov m,d         ; #29fa 72
   dcx h           ; #29fb 2b
   mov m,e         ; #29fc 73
   mov h,b         ; #29fd 60
   mov l,c         ; #29fe 69
   mov c,m         ; #29ff 4e
   inx h           ; #2a00 23
   mov b,m         ; #2a01 46
   jmp _FNEXT      ; #2a02 c3 9a 21

NFA__28_2BLOOP_29:; 2A05
   .byte 7,"(+LOOP)"
   .word NFA__28LOOP_29       ; 29D1
__28_2BLOOP_29:  ; 2A0F - 2A20
   pop h           ; #2a0f e1
   push b          ; #2a10 c5
   xchg            ; #2a11 eb
   lhld l601a      ; #2a12 2a 1a 60
   mov c,m         ; #2a15 4e
   inx h           ; #2a16 23
   mov b,m         ; #2a17 46
   inx h           ; #2a18 23
   xchg            ; #2a19 eb
   dad b           ; #2a1a 09
   xchg            ; #2a1b eb
   pop b           ; #2a1c c1
   jmp l29e2       ; #2a1d c3 e2 29

NFA_CMOVE:       ; 2A20
   .byte 5,"CMOVE"
   .word NFA__28_2BLOOP_29      ; 2A05
_CMOVE:          ; 2A28 - 2A48
   mov h,b         ; #2a28 60
   mov l,c         ; #2a29 69
   pop b           ; #2a2a c1
   pop d           ; #2a2b d1
   xthl            ; #2a2c e3
   mov a,c         ; #2a2d 79
   ora b           ; #2a2e b0
   jz l2a44        ; #2a2f ca 44 2a
l2a32:
   mov a,c         ; #2a32 79
   ora a           ; #2a33 b7
   jz @2a38        ; #2a34 ca 38 2a
   inr b           ; #2a37 04
@2a38:
   mov a,m         ; #2a38 7e
   stax d          ; #2a39 12
   inx h           ; #2a3a 23
   inx d           ; #2a3b 13
   dcr c           ; #2a3c 0d
   jnz @2a38       ; #2a3d c2 38 2a
   dcr b           ; #2a40 05
   jnz @2a38       ; #2a41 c2 38 2a
l2a44:
   pop b           ; #2a44 c1
   jmp _FNEXT      ; #2a45 c3 9a 21

NFA_CMOVE_3E:    ; 2A48
   .byte 6,"CMOVE>"
   .word NFA_CMOVE        ; 2A20
_CMOVE_3E:       ; 2A51 - 2A78
   mov h,b         ; #2a51 60
   mov l,c         ; #2a52 69
   pop b           ; #2a53 c1
   pop d           ; #2a54 d1
   xthl            ; #2a55 e3
   mov a,c         ; #2a56 79
   ora b           ; #2a57 b0
   jz l2a74        ; #2a58 ca 74 2a
l2a5b:
   dad b           ; #2a5b 09
   xchg            ; #2a5c eb
   dad b           ; #2a5d 09
   mov a,c         ; #2a5e 79
   ora a           ; #2a5f b7
   jz @2a64        ; #2a60 ca 64 2a
   inr b           ; #2a63 04
@2a64:
   dcx h           ; #2a64 2b
   dcx d           ; #2a65 1b
   ldax d          ; #2a66 1a
   mov m,a         ; #2a67 77
   dcr c           ; #2a68 0d
   jnz @2a64       ; #2a69 c2 64 2a
   dcr b           ; #2a6c 05
   jnz @2a64       ; #2a6d c2 64 2a
   pop b           ; #2a70 c1
   jmp _FNEXT      ; #2a71 c3 9a 21
l2a74:
   pop b           ; #2a74 c1
   jmp _FNEXT      ; #2a75 c3 9a 21

NFA__3CCMOVE_3E: ; 2A78
   .byte 7,"<CMOVE>"
   .word NFA_CMOVE_3E       ; 2A48
__3CCMOVE_3E:    ; 2A82 - 2A9A
   mov h,b         ; #2a82 60
   mov l,c         ; #2a83 69
   pop b           ; #2a84 c1
   pop d           ; #2a85 d1
   xthl            ; #2a86 e3
   mov a,c         ; #2a87 79
   ora b           ; #2a88 b0
   jz @2a96        ; #2a89 ca 96 2a
   mov a,l         ; #2a8c 7d
   sub e           ; #2a8d 93
   mov a,h         ; #2a8e 7c
   sbb d           ; #2a8f 9a
   jnc l2a32       ; #2a90 d2 32 2a
   jmp l2a5b       ; #2a93 c3 5b 2a
@2a96:
   pop b           ; #2a96 c1
   jmp _FNEXT      ; #2a97 c3 9a 21

NFA_FILL:        ; 2A9A
   .byte 4,"FILL"
   .word NFA__3CCMOVE_3E      ; 2A78
_FILL:           ; 2AA1 - 2ABD
   pop d
   pop h
   mov a,h         ; #2aa3 7c
   ora l           ; #2aa4 b5
   jnz @2aac       ; #2aa5 c2 ac 2a
   pop h           ; #2aa8 e1
   jmp _FNEXT      ; #2aa9 c3 9a 21
@2aac:
   mov a,e         ; #2aac 7b
   pop d           ; #2aad d1
   dcx h           ; #2aae 2b
   push b          ; #2aaf c5
   lxi b,0xffff    ; #2ab0 01 ff ff
@2ab3:
   stax d          ; #2ab3 12
   inx d           ; #2ab4 13
   dad b           ; #2ab5 09
   jc @2ab3        ; #2ab6 da b3 2a
   pop b           ; #2ab9 c1
   jmp _FNEXT      ; #2aba c3 9a 21

NFA_0_3EBL:      ; 2ABD
   .byte 4,"0>BL"
   .word NFA_FILL         ; 2A9A
_0_3EBL:         ; 2AC4 - 2AD5
   pop d
   pop h
@2ac6:
   mov a,m         ; #2ac6 7e
   ora a           ; #2ac7 b7
   jnz @2acd       ; #2ac8 c2 cd 2a
   mvi m,0x20      ; #2acb 36 20
@2acd:
   inx h           ; #2acd 23
   dcr e           ; #2ace 1d
   jnz @2ac6       ; #2acf c2 c6 2a
   jmp _FNEXT      ; #2ad2 c3 9a 21

NFA_ENCLOSE:     ; 2AD5
   .byte 7,"ENCLOSE"
   .word NFA_0_3EBL         ; 2ABD
_ENCLOSE:        ; 2ADF - 2B1D
   mov h,b         ; #2adf 60
   mov l,c         ; #2ae0 69
   pop b           ; #2ae1 c1
   pop d           ; #2ae2 d1
   xthl            ; #2ae3 e3
   xchg            ; #2ae4 eb
   dcx b           ; #2ae5 0b
@2ae6:
   mov a,b         ; #2ae6 78
   ora a           ; #2ae7 b7
   jm @2b15        ; #2ae8 fa 15 2b
   mov a,m         ; #2aeb 7e 
   cmp e           ; #2aec bb
   dcx b           ; #2aed 0b
   inx h           ; #2aee 23
   jz @2ae6        ; #2aef ca e6 2a
   push h          ; #2af2 e5
@2af3:
   mov a,b         ; #2af3 78
   ora a           ; #2af4 b7
   jm @2b00        ; #2af5 fa 00 2b
   mov a,m         ; #2af8 7e
   cmp e           ; #2af9 bb
   dcx b           ; #2afa 0b
   inx h           ; #2afb 23
   jnz @2af3       ; #2afc c2 f3 2a
   dcx h           ; #2aff 2b
@2b00:
   pop d           ; #2b00 d1
   dcx d           ; #2b01 1b
   pop b           ; #2b02 c1
   push d          ; #2b03 d5
   push h          ; #2b04 e5
   mov a,l         ; #2b05 7d
   sub e           ; #2b06 93
   mov l,a         ; #2b07 6f
   mov a,h         ; #2b08 7c
   sbb d           ; #2b09 9a
   mov h,a         ; #2b0a 67
   xthl            ; #2b0b e3
   inx h           ; #2b0c 23
   push h          ; #2b0d e5
   lxi h,0xffff    ; #2b0e 21 ff ff
   push h          ; #2b11 e5
   jmp _FNEXT      ; #2b12 c3 9a 21
@2b15:
   pop b           ; #2b15 c1
   lxi h,0000      ; #2b16 21 00 00
   push h          ; #2b19 e5
   jmp _FNEXT      ; #2b1a c3 9a 21

NFA_HERE:        ; 2B5B
   .byte 4,"HERE"
   .word NFA_FALSE        ; 2B4E
_HERE:           ; 2B62 - 2B6B
   call _FCALL            ; 2B62
   .word _H               ; #2b65 2091 - H
   .word __40             ; #2b67 2820 - @
   .word _EXIT            ; #2b69 21A8 - EXIT

NFA_ALLOT:       ; 2B6B
   .byte 5,"ALLOT"
   .word NFA_HERE         ; 2B5B
_ALLOT:          ; 2B73 - 2B7C
   call _FCALL            ; 2B73
   .word _H               ; #2b76 2091 - H
   .word __2B_21          ; #2b78 2876 - +!
   .word _EXIT            ; #2b7a 21A8 - EXIT

NFA__2C:         ; 2B7C
   .byte 1,","
   .word NFA_ALLOT        ; 2B6B
__2C:            ; 2B80 - 2B8D
   call _FCALL            ; 2B80
   .word _HERE            ; #2b83 2B62 - HERE
   .word _2               ; #2b85 2B3D - 2
   .word _ALLOT           ; #2b87 2B73 - ALLOT
   .word __21             ; #2b89 2839 - !
   .word _EXIT            ; #2b8b 21A8 - EXIT

NFA_C_2C:        ; 2B8D
   .byte 2,"C,"
   .word NFA__2C            ; 2B7C
_C_2C:           ; 2B92 - 2B9F
   call _FCALL            ; 2B92
   .word _HERE            ; #2b95 2B62 - HERE
   .word _1               ; #2b97 2B34 - 1
   .word _ALLOT           ; #2b99 2B73 - ALLOT
   .word _C_21            ; #2b9b 2846 - C!
   .word _EXIT            ; #2b9d 21A8 - EXIT

NFA__22_2C:      ; 2B9F
   .byte 2,"\","
   .word NFA_C_2C           ; 2B8D
__22_2C:         ; 2BA4 - 2BB7
   call _FCALL            ; 2BA4
   .word _HERE            ; #2ba7 2B62 - HERE
   .word _OVER            ; #2ba9 220D - OVER
   .word _C_40            ; #2bab 282D - C@
   .word _1_2B            ; #2bad 231A - 1+
   .word _DUP             ; #2baf 2277 - DUP
   .word _ALLOT           ; #2bb1 2B73 - ALLOT
   .word _CMOVE           ; #2bb3 2A28 - CMOVE
   .word _EXIT            ; #2bb5 21A8 - EXIT

NFA_PAD:         ; 2BB7
   .byte 3,"PAD"
   .word NFA__22_2C           ; 2B9F
_PAD:            ; 2BBD - 2BCA
   call _FCALL            ; 2BBD
   .word _HERE            ; #2bc0 2B62 - HERE
   .word _LIT             ; #2bc2 28C7 - LIT
   .word 0x0040           ; #2bc4 0040
   .word __2B             ; #2bc6 22ED - +
   .word _EXIT            ; #2bc8 21A8 - EXIT
'
NFA_COUNT:       ; 2BCA
   .byte 5,"COUNT"
   .word NFA_PAD          ; 2BB7
_COUNT:          ; 2BD2 - 2BDF
   call _FCALL            ; 2BD2
   .word _DUP             ; #2bd5 2277 - DUP
   .word _1_2B            ; #2bd7 231A - 1+
   .word _SWAP            ; #2bd9 2238 - SWAP
   .word _C_40            ; #2bdb 282D - C@
   .word _EXIT            ; #2bdd 21A8 - EXIT

NFA_COMPILE:     ; 2BDF
   .byte 7,"COMPILE"
   .word NFA_COUNT        ; 2BCA
_COMPILE:        ; 2BE9 - 2BFA
   call _FCALL            ; 2BE9
   .word _R_3E            ; #2bec 27BC - R>
   .word _DUP             ; #2bee 2277 - DUP
   .word _2_2B            ; #2bf0 2325 - 2+
   .word __3ER            ; #2bf2 27A9 - >R
   .word __40             ; #2bf4 2820 - @
   .word __2C             ; #2bf6 2B80 - ,
   .word _EXIT            ; #2bf8 21A8 - EXIT

NFA_S_3ED:       ; 2BFA
   .byte 3,"S>D"
   .word NFA_COMPILE      ; 2BDF
_S_3ED:          ; 2C00 - 2C09
   call _FCALL            ; 2C00
   .word _DUP             ; #2c03 2277 - DUP
   .word _0_3C            ; #2c05 23E0 - 0<
   .word _EXIT            ; #2c07 21A8 - EXIT

NFA_M_2A:        ; 2C09
   .byte 2,"M*"
   .word NFA_S_3ED          ; 2BFA
_M_2A:           ; 2C0E - 2C2B
   call _FCALL            ; 2C0E
   .word _2DUP            ; #2c11 2296 - 2DUP
   .word _XOR             ; #2c13 2787 - XOR
   .word __3ER            ; #2c15 27A9 - >R
   .word _ABS             ; #2c17 2354 - ABS
   .word _SWAP            ; #2c19 2238 - SWAP
   .word _ABS             ; #2c1b 2354 - ABS
   .word _UM_2A           ; #2c1d 2568 - UM*
   .word _R_3E            ; #2c1f 27BC - R>
   .word _0_3C            ; #2c21 23E0 - 0<
   .word __3FBRANCH       ; #2c23 2916 - ?BRANCH
   .word @2c29            ; #2c25 2C29
   .word _DNEGATE         ; #2c27 24C3 - DNEGATE
@2c29:
   .word _EXIT            ; #2c29 21A8 - EXIT

NFA__2F:         ; 2C2B
   .byte 1,"/"
   .word NFA_M_2A           ; 2C09
__2F:            ; 2C2F - 2C38
   call _FCALL            ; 2C2F
   .word __2FMOD          ; #2c32 267E - /MOD
   .word _PRESS           ; #2c34 22B4 - PRESS
   .word _EXIT            ; #2c36 21A8 - EXIT

NFA_MOD:         ; 2C38
   .byte 3,"MOD"
   .word NFA__2F            ; 2C2B
_MOD:            ; 2C3E - 2C47
   call _FCALL            ; 2C3E
   .word __2FMOD          ; #2c41 267E - /MOD
   .word _DROP            ; #2c43 222D - DROP
   .word _EXIT            ; #2c45 21A8 - EXIT

NFA_DABS:        ; 2C47
   .byte 4,"DABS"
   .word NFA_MOD          ; 2C38
_DABS:           ; 2C4E - 2C5D
   call _FCALL            ; 2C4E
   .word _DUP             ; #2c51 2277 - DUP
   .word _0_3C            ; #2c53 23E0 - 0<
   .word __3FBRANCH       ; #2c55 2916 - ?BRANCH
   .word @2C5B            ; #2c57 2C5B
   .word _DNEGATE         ; #2c59 24C3 - DNEGATE
@2C5B:
   .word _EXIT            ; #2c5b 21A8 - EXIT

NFA_U_2F:        ; 2C5D
   .byte 2,"U/"
   .word NFA_DABS         ; 2C47
_U_2F:           ; 2C62 - 2C6B
   call _FCALL            ; 2C62
   .word _U_2FMOD         ; #2c65 26C7 - U/MOD
   .word _PRESS           ; #2c67 22B4 - PRESS
   .word _EXIT            ; #2c69 21A8 - EXIT

NFA_UM_2FMOD:    ; 2C6B
   .byte 6,"UM/MOD"
   .word NFA_U_2F           ; 2C5D
_UM_2FMOD:       ; 2C74 - 2C81
   call _FCALL            ; 2C74
   .word _0               ; #2c77 2B2B - 0
   .word _DU_2FMOD        ; #2c79 259A - DU/MOD
   .word _DROP            ; #2c7b 222D - DROP
   .word _PRESS           ; #2c7d 22B4 - PRESS
   .word _EXIT            ; #2c7f 21A8 - EXIT

NFA_M_2FMOD:     ; 2C81
   .byte 5,"M/MOD"
   .word NFA_UM_2FMOD       ; 2C6B
_M_2FMOD:        ; 2C89 - 2CD2
   call _FCALL            ; 2C89
   .word __3FDUP          ; #2c8c 2284 - ?DUP
   .word __3FBRANCH       ; #2c8e 2916 - ?BRANCH
   .word @2CD0            ; #2c90 2CD0
   .word _DUP             ; #2c92 2277 - DUP
   .word __3ER            ; #2c94 27A9 - >R
   .word _2DUP            ; #2c96 2296 - 2DUP
   .word _XOR             ; #2c98 2787 - XOR
   .word __3ER            ; #2c9a 27A9 - >R
   .word __3ER            ; #2c9c 27A9 - >R
   .word _DABS            ; #2c9e 2C4E - DABS
   .word _R_40            ; #2ca0 27CF - R@
   .word _ABS             ; #2ca2 2354 - ABS
   .word _UM_2FMOD        ; #2ca4 2C74 - UM/MOD
   .word _SWAP            ; #2ca6 2238 - SWAP
   .word _R_3E            ; #2ca8 27BC - R>
   .word _0_3C            ; #2caa 23E0 - 0<
   .word __3FBRANCH       ; #2cac 2916 - ?BRANCH
   .word @2CB2            ; #2cae 2CB2
   .word _NEGATE          ; #2cb0 230D - NEGATE
@2CB2:
   .word _SWAP            ; #2cb2 2238 - SWAP
   .word _R_3E            ; #2cb4 27BC - R>
   .word _0_3C            ; #2cb6 23E0 - 0<
   .word __3FBRANCH       ; #2cb8 2916 - ?BRANCH
   .word @2CCE            ; #2cba 2CCE
   .word _NEGATE          ; #2cbc 230D - NEGATE
   .word _OVER            ; #2cbe 220D - OVER
   .word __3FBRANCH       ; #2cc0 2916 - ?BRANCH
   .word @2CCE            ; #2cc2 2CCE
   .word _1_2D            ; #2cc4 2331 - 1-
   .word _R_40            ; #2cc6 27CF - R@
   .word _ROT             ; #2cc8 225A - ROT
   .word __2D             ; #2cca 22F8 - -
   .word _SWAP            ; #2ccc 2238 - SWAP
@2CCE:
   .word _RDROP           ; #2cce 2811 - RDROP
@2CD0:
   .word _EXIT            ; #2cd0 21A8 - EXIT

NFA__2A_2FMOD:   ; 2CD2
   .byte 5,"*/MOD"
   .word NFA_M_2FMOD        ; 2C81
__2A_2FMOD:      ; 2CDA - 2CE7
   call _FCALL            ; 2CDA
   .word __3ER            ; #2cdd 27A9 - >R
   .word _M_2A            ; #2cdf 2C0E - M*
   .word _R_3E            ; #2ce1 27BC - R>
   .word _M_2FMOD         ; #2ce3 2C89 - M/MOD
   .word _EXIT            ; #2ce5 21A8 - EXIT

NFA__2A_2F:      ; 2CE7
   .byte 2,"*/"
   .word NFA__2A_2FMOD        ; 2CD2
__2A_2F:         ; 2CEC - 2CF5
   call _FCALL            ; 2CEC
   .word __2A_2FMOD       ; #2cef 2CDA - */MOD
   .word _PRESS           ; #2cf1 22B4 - PRESS
   .word _EXIT            ; #2cf3 21A8 - EXIT

NFA__3C_3E:      ; 2CF5
   .byte 2,"<>"
   .word NFA__2A_2F           ; 2CE7
__3C_3E:         ; 2CFA - 2D03
   call _FCALL            ; 2CFA
   .word __3D             ; #2cfd 2409 - =
   .word _0_3D            ; #2cff 2421 - 0=
   .word _EXIT            ; #2d01 21A8 - EXIT

NFA_ABORT:       ; 2D33
   .byte 5,"ABORT"
   .word NFA_QUIT         ; 2D03
_ABORT:          ; 2D3B - 2D56
   call _FCALL            ; 2D3B
   .word _LIT             ; #2d3e 28C7 - LIT
   .word l6002            ; #2d40 6002
   .word __40             ; #2d42 2820 - @
   .word __3FDUP          ; #2d44 2284 - ?DUP
   .word __3FBRANCH       ; #2d46 2916 - ?BRANCH
   .word @2D4C            ; #2d48 2D4C
   .word _EXECUTE         ; #2d4a 21BF - EXECUTE
@2D4C:
   .word _S0              ; #2d4c 2088 - S0
   .word __40             ; #2d4e 2820 - @
   .word _SP_21           ; #2d50 22E4 - SP!
   .word _QUIT            ; #2d52 2D0A - QUIT
   .word _EXIT            ; #2d54 21A8 - EXIT

NFA__28ABORT_22_29:; 2D56
   .byte 8,"(ABORT\")"
   .word NFA_ABORT        ; 2D33
__28ABORT_22_29: ; 2D61 - 2D86
   call _FCALL            ; 2D61
   .word __3FBRANCH       ; #2d64 2916 - ?BRANCH
   .word @2D78            ; #2d66 2D78
   .word _HERE            ; #2d68 2B62 - HERE
   .word _ID_2E           ; #2d6a 32D0 - ID.
   .word _SPACE           ; #2d6c 32A7 - SPACE
   .word _R_3E            ; #2d6e 27BC - R>
   .word _ID_2E           ; #2d70 32D0 - ID.
   .word _ABORT           ; #2d72 2D3B - ABORT
   .word _BRANCH          ; #2d74 2904 - BRANCH
   .word @2D84            ; #2d76 2D84
@2D78:
   .word _R_3E            ; #2d78 27BC - R>
   .word _DUP             ; #2d7a 2277 - DUP
   .word _C_40            ; #2d7c 282D - C@
   .word _1_2B            ; #2d7e 231A - 1+
   .word __2B             ; #2d80 22ED - +
   .word __3ER            ; #2d82 27A9 - >R
@2D84:
   .word _EXIT            ; #2d84 21A8 - EXIT

NFA__23_3E:      ; 2DA2
   .byte 2,"#>"
   .word NFA_ABORT_22       ; 2D86
__23_3E:         ; 2DA7 - 2DB8
   call _FCALL            ; 2DA7
   .word _2DROP           ; #2daa 22A7 - 2DROP
   .word _HLD             ; #2dac 2109 - HLD
   .word __40             ; #2dae 2820 - @
   .word _PAD             ; #2db0 2BBD - PAD
   .word _OVER            ; #2db2 220D - OVER
   .word __2D             ; #2db4 22F8 - -
   .word _EXIT            ; #2db6 21A8 - EXIT

NFA__3C_23:      ; 2DB8
   .byte 2,"<#"
   .word NFA__23_3E           ; 2DA2
__3C_23:         ; 2DBD - 2DC8
   call _FCALL            ; 2DBD
   .word _PAD             ; #2dc0 2BBD - PAD
   .word _HLD             ; #2dc2 2109 - HLD
   .word __21             ; #2dc4 2839 - !
   .word _EXIT            ; #2dc6 21A8 - EXIT

NFA_HOLD:        ; 2DC8
   .byte 4,"HOLD"
   .word NFA__3C_23           ; 2DB8
_HOLD:           ; 2DCF - 2DDE
   call _FCALL            ; 2DCF
   .word _HLD             ; #2dd2 2109 - HLD
   .word _1_2D_21         ; #2dd4 28B6 - 1-!
   .word _HLD             ; #2dd6 2109 - HLD
   .word __40             ; #2dd8 2820 - @
   .word _C_21            ; #2dda 2846 - C!
   .word _EXIT            ; #2ddc 21A8 - EXIT

NFA_SIGN:        ; 2DDE
   .byte 4,"SIGN"
   .word NFA_HOLD         ; 2DC8
_SIGN:           ; 2DE5 - 2DF6
   call _FCALL            ; 2DE5
   .word _0_3C            ; #2de8 23E0 - 0<
   .word __3FBRANCH       ; #2dea 2916 - ?BRANCH
   .word @2DF4            ; #2dec 2DF4
   .word _LIT             ; #2dee 28C7 - LIT
   .word 0x002D           ; #2df0 002D
   .word _HOLD            ; #2df2 2DCF - HOLD
@2DF4:
   .word _EXIT            ; #2df4 21A8 - EXIT

NFA__3EDIG:      ; 2DF6
   .byte 4,">DIG"
   .word NFA_SIGN         ; 2DDE
__3EDIG:         ; 2DFD - 2E1C
   call _FCALL            ; 2DFD
   .word _LIT             ; #2e00 28C7 - LIT
   .word 0009             ; #2e02 0009
   .word _OVER            ; #2e04 220D - OVER
   .word _U_3C            ; #2e06 239D - U<
   .word __3FBRANCH       ; #2e08 2916 - ?BRANCH
   .word @2E14            ; #2e0a 2E14
   .word _LIT             ; #2e0c 28C7 - LIT
   .word 0x0037           ; #2e0e 0037
   .word _BRANCH          ; #2e10 2904 - BRANCH
   .word @2E18            ; #2e12 2E18
@2E14:
   .word _LIT             ; #2e14 28C7 - LIT
   .word 0x0030           ; #2e16 0030
@2E18:
   .word __2B             ; #2e18 22ED - +
   .word _EXIT            ; #2e1a 21A8 - EXIT

NFA__23:         ; 2E1C
   .byte 1,"#"
   .word NFA__3EDIG         ; 2DF6
__23:            ; 2E20 - 2E37
   call _FCALL            ; 2E20
   .word _BASE            ; #2e23 20C8 - BASE
   .word __40             ; #2e25 2820 - @
   .word _0               ; #2e27 2B2B - 0
   .word _DU_2FMOD        ; #2e29 259A - DU/MOD
   .word _ROT             ; #2e2b 225A - ROT
   .word _DROP            ; #2e2d 222D - DROP
   .word _ROT             ; #2e2f 225A - ROT
   .word __3EDIG          ; #2e31 2DFD - >DIG
   .word _HOLD            ; #2e33 2DCF - HOLD
   .word _EXIT            ; #2e35 21A8 - EXIT

NFA__23_2E:      ; 2E37
   .byte 2,"#."
   .word NFA__23            ; 2E1C
__23_2E:         ; 2E3C - 2E4D
   call _FCALL            ; 2E3C
   .word _BASE            ; #2e3f 20C8 - BASE
   .word __40             ; #2e41 2820 - @
   .word _U_2FMOD         ; #2e43 26C7 - U/MOD
   .word _SWAP            ; #2e45 2238 - SWAP
   .word __3EDIG          ; #2e47 2DFD - >DIG
   .word _HOLD            ; #2e49 2DCF - HOLD
   .word _EXIT            ; #2e4b 21A8 - EXIT

NFA__23_2ES:     ; 2E4D
   .byte 3,"#.S"
   .word NFA__23_2E           ; 2E37
__23_2ES:        ; 2E53 - 2E62
   call _FCALL            ; 2E53
@2E56:
   .word __23_2E          ; #2e56 2E3C - #.
   .word _DUP             ; #2e58 2277 - DUP
   .word _0_3D            ; #2e5a 2421 - 0=
   .word __3FBRANCH       ; #2e5c 2916 - ?BRANCH
   .word @2E56            ; #2e5e 2E56
   .word _EXIT            ; #2e60 21A8 - EXIT

NFA__23S:        ; 2E62
   .byte 2,"#S"
   .word NFA__23_2ES          ; 2E4D
__23S:           ; 2E67 - 2E78
   call _FCALL            ; 2E67
@2E6A:
   .word __23             ; #2e6a 2E20 - #
   .word _2DUP            ; #2e6c 2296 - 2DUP
   .word _OR              ; #2e6e 2775 - OR
   .word _0_3D            ; #2e70 2421 - 0=
   .word __3FBRANCH       ; #2e72 2916 - ?BRANCH
   .word @2E6A            ; #2e74 2E6A
   .word _EXIT            ; #2e76 21A8 - EXIT

NFA_D_2ER:       ; 2E78
   .byte 3,"D.R"
   .word NFA__23S           ; 2E62
_D_2ER:          ; 2E7E - 2E9F
   call _FCALL            ; 2E7E
   .word __3ER            ; #2e81 27A9 - >R
   .word _DUP             ; #2e83 2277 - DUP
   .word __3ER            ; #2e85 27A9 - >R
   .word _DABS            ; #2e87 2C4E - DABS
   .word __3C_23          ; #2e89 2DBD - <#
   .word __23S            ; #2e8b 2E67 - #S
   .word _R_3E            ; #2e8d 27BC - R>
   .word _SIGN            ; #2e8f 2DE5 - SIGN
   .word __23_3E          ; #2e91 2DA7 - #>
   .word _R_3E            ; #2e93 27BC - R>
   .word _OVER            ; #2e95 220D - OVER
   .word __2D             ; #2e97 22F8 - -
   .word _SPACES          ; #2e99 32B9 - SPACES
   .word _TYPE            ; #2e9b 31B4 - TYPE
   .word _EXIT            ; #2e9d 21A8 - EXIT

NFA_D_2E:        ; 2E9F
   .byte 2,"D."
   .word NFA_D_2ER          ; 2E78
_D_2E:           ; 2EA4 - 2EBD
   call _FCALL            ; 2EA4
   .word _DUP             ; #2ea7 2277 - DUP
   .word __3ER            ; #2ea9 27A9 - >R
   .word _DABS            ; #2eab 2C4E - DABS
   .word __3C_23          ; #2ead 2DBD - <#
   .word __23S            ; #2eaf 2E67 - #S
   .word _R_3E            ; #2eb1 27BC - R>
   .word _SIGN            ; #2eb3 2DE5 - SIGN
   .word __23_3E          ; #2eb5 2DA7 - #>
   .word _TYPE            ; #2eb7 31B4 - TYPE
   .word _SPACE           ; #2eb9 32A7 - SPACE
   .word _EXIT            ; #2ebb 21A8 - EXIT

NFA__2ER:        ; 2EBD
   .byte 2,".R"
   .word NFA_D_2E           ; 2E9F
__2ER:           ; 2EC2 - 2EE5
   call _FCALL            ; 2EC2
   .word __3ER            ; #2ec5 27A9 - >R
   .word _DUP             ; #2ec7 2277 - DUP
   .word __3ER            ; #2ec9 27A9 - >R
   .word _ABS             ; #2ecb 2354 - ABS
   .word __3C_23          ; #2ecd 2DBD - <#
   .word __23_2ES         ; #2ecf 2E53 - #.S
   .word _R_3E            ; #2ed1 27BC - R>
   .word _SIGN            ; #2ed3 2DE5 - SIGN
   .word _0               ; #2ed5 2B2B - 0
   .word __23_3E          ; #2ed7 2DA7 - #>
   .word _R_3E            ; #2ed9 27BC - R>
   .word _OVER            ; #2edb 220D - OVER
   .word __2D             ; #2edd 22F8 - -
   .word _SPACES          ; #2edf 32B9 - SPACES
   .word _TYPE            ; #2ee1 31B4 - TYPE
   .word _EXIT            ; #2ee3 21A8 - EXIT

NFA__2E0:        ; 2EE5
   .byte 2,".0"
   .word NFA__2ER           ; 2EBD
__2E0:           ; 2EEA - 2F11
   call _FCALL            ; 2EEA
   .word __3ER            ; #2eed 27A9 - >R
   .word __3C_23          ; #2eef 2DBD - <#
   .word __23_2ES         ; #2ef1 2E53 - #.S
   .word _0               ; #2ef3 2B2B - 0
   .word __23_3E          ; #2ef5 2DA7 - #>
   .word _R_3E            ; #2ef7 27BC - R>
   .word _OVER            ; #2ef9 220D - OVER
   .word __2D             ; #2efb 22F8 - -
   .word _0               ; #2efd 2B2B - 0
   .word __28_3FDO_29     ; #2eff 29B8 - (?DO)
   .word @2F0D            ; #2f01 2F0D
@2F03:
   .word _LIT             ; #2f03 28C7 - LIT
   .word 0x0030           ; #2f05 0030
   .word _EMIT            ; #2f07 3189 - EMIT
   .word __28LOOP_29      ; #2f09 29DA - (LOOP)
   .word @2F03            ; #2f0b 2F03
@2F0D:
   .word _TYPE            ; #2f0d 31B4 - TYPE
   .word _EXIT            ; #2f0f 21A8 - EXIT

NFA__2E:         ; 2F11
   .byte 1,"."
   .word NFA__2E0           ; 2EE5
__2E:            ; 2F15 - 2F30
   call _FCALL            ; 2F15
   .word _DUP             ; #2f18 2277 - DUP
   .word __3ER            ; #2f1a 27A9 - >R
   .word _ABS             ; #2f1c 2354 - ABS
   .word __3C_23          ; #2f1e 2DBD - <#
   .word __23_2ES         ; #2f20 2E53 - #.S
   .word _R_3E            ; #2f22 27BC - R>
   .word _SIGN            ; #2f24 2DE5 - SIGN
   .word _0               ; #2f26 2B2B - 0
   .word __23_3E          ; #2f28 2DA7 - #>
   .word _TYPE            ; #2f2a 31B4 - TYPE
   .word _SPACE           ; #2f2c 32A7 - SPACE
   .word _EXIT            ; #2f2e 21A8 - EXIT

NFA_U_2E:        ; 2F30
   .byte 2,"U."
   .word NFA__2E            ; 2F11
_U_2E:           ; 2F35 - 2F3E
   call _FCALL            ; 2F35
   .word _0               ; #2f38 2B2B - 0
   .word _D_2E            ; #2f3a 2EA4 - D.
   .word _EXIT            ; #2f3c 21A8 - EXIT

NFA_TRAVERSE:    ; 2F49
   .byte 8,"TRAVERSE"
   .word NFA_CFL          ; 2F3E
_TRAVERSE:       ; 2F54 - 2F99
   call _FCALL            ; 2F54
   .word _1_2D            ; #2f57 2331 - 1-
   .word _N_3FBRANCH      ; #2f59 2934 - N?BRANCH
   .word @2F6B            ; #2f5b 2F6B
   .word _COUNT           ; #2f5d 2BD2 - COUNT
   .word _LIT             ; #2f5f 28C7 - LIT
   .word 0x003F           ; #2f61 003F
   .word _AND             ; #2f63 2764 - AND
   .word __2B             ; #2f65 22ED - +
   .word _BRANCH          ; #2f67 2904 - BRANCH
   .word @2F97            ; #2f69 2F97
@2F6B:
   .word _LIT             ; #2f6b 28C7 - LIT
   .word 0x0020           ; #2f6d 0020
   .word _2               ; #2f6f 2B3D - 2
   .word __28DO_29        ; #2f71 2991 - (DO)
   .word @2F97            ; #2f73 2F97
@2F75:
   .word _DUP             ; #2f75 2277 - DUP
   .word _I               ; #2f77 294B - I
   .word __2D             ; #2f79 22F8 - -
   .word _C_40            ; #2f7b 282D - C@
   .word _LIT             ; #2f7d 28C7 - LIT
   .word 0x007F           ; #2f7f 007F
   .word _AND             ; #2f81 2764 - AND
   .word _1_2B            ; #2f83 231A - 1+
   .word _I               ; #2f85 294B - I
   .word __3D             ; #2f87 2409 - =
   .word __3FBRANCH       ; #2f89 2916 - ?BRANCH
   .word @2F93            ; #2f8b 2F93
   .word _I               ; #2f8d 294B - I
   .word __2D             ; #2f8f 22F8 - -
   .word _LEAVE           ; #2f91 38B5 - LEAVE
@2F93:
   .word __28LOOP_29      ; #2f93 29DA - (LOOP)
   .word @2F75            ; #2f95 2F75
@2F97:
   .word _EXIT            ; #2f97 21A8 - EXIT

NFA__3EBODY:     ; 2F99
   .byte 5,">BODY"
   .word NFA_TRAVERSE     ; 2F49
__3EBODY:        ; 2FA1 - 2FAA
   call _FCALL            ; 2FA1
   .word _CFL             ; #2fa4 2F44 - CFL
   .word __2B             ; #2fa6 22ED - +
   .word _EXIT            ; #2fa8 21A8 - EXIT

NFA_BODY_3E:     ; 2FAA
   .byte 5,"BODY>"
   .word NFA__3EBODY        ; 2F99
_BODY_3E:        ; 2FB2 - 2FBB
   call _FCALL            ; 2FB2
   .word _CFL             ; #2fb5 2F44 - CFL
   .word __2D             ; #2fb7 22F8 - -
   .word _EXIT            ; #2fb9 21A8 - EXIT

NFA__3ENAME:     ; 2FBB
   .byte 5,">NAME"
   .word NFA_BODY_3E        ; 2FAA
__3ENAME:        ; 2FC3 - 2FCE
   call _FCALL            ; 2FC3
   .word _2_2D            ; #2fc6 233C - 2-
   .word __2D1            ; #2fc8 2B22 - -1
   .word _TRAVERSE        ; #2fca 2F54 - TRAVERSE
   .word _EXIT            ; #2fcc 21A8 - EXIT

NFA_NAME_3E:     ; 2FCE
   .byte 5,"NAME>"
   .word NFA__3ENAME        ; 2FBB
_NAME_3E:        ; 2FD6 - 2FE1
   call _FCALL            ; 2FD6
   .word _1               ; #2fd9 2B34 - 1
   .word _TRAVERSE        ; #2fdb 2F54 - TRAVERSE
   .word _2_2B            ; #2fdd 2325 - 2+
   .word _EXIT            ; #2fdf 21A8 - EXIT

NFA__3ELINK:     ; 2FE1
   .byte 5,">LINK"
   .word NFA_NAME_3E        ; 2FCE
__3ELINK:        ; 2FE9 - 2FF0
   call _FCALL            ; 2FE9
   .word _2_2D            ; #2fec 233C - 2-
   .word _EXIT            ; #2fee 21A8 - EXIT

NFA_LINK_3E:     ; 2FF0
   .byte 5,"LINK>"
   .word NFA__3ELINK        ; 2FE1
_LINK_3E:        ; 2FF8 - 2FFF
   call _FCALL            ; 2FF8
   .word _2_2B            ; #2ffb 2325 - 2+
   .word _EXIT            ; #2ffd 21A8 - EXIT

NFA_N_3ELINK:    ; 2FFF
   .byte 6,"N>LINK"
   .word NFA_LINK_3E        ; 2FF0
_N_3ELINK:       ; 3008 - 3011
   call _FCALL            ; 3008
   .word _1               ; #300b 2B34 - 1
   .word _TRAVERSE        ; #300d 2F54 - TRAVERSE
   .word _EXIT            ; #300f 21A8 - EXIT

NFA_L_3ENAME:    ; 3011
   .byte 6,"L>NAME"
   .word NFA_N_3ELINK       ; 2FFF
_L_3ENAME:       ; 301A - 3023
   call _FCALL            ; 301A
   .word __2D1            ; #301d 2B22 - -1
   .word _TRAVERSE        ; #301f 2F54 - TRAVERSE
   .word _EXIT            ; #3021 21A8 - EXIT

NFA_WORD:        ; 3023
   .byte 4,"WORD"
   .word NFA_L_3ENAME       ; 3011
_WORD:           ; 302A - 308D
   call _FCALL            ; 302A
   .word _LIT             ; #302d 28C7 - LIT
   .word l6016            ; #302f 6016
   .word __40             ; #3031 2820 - @
   .word __3FDUP          ; #3033 2284 - ?DUP
   .word __3FBRANCH       ; #3035 2916 - ?BRANCH
   .word @303D            ; #3037 303D
   .word _EXECUTE         ; #3039 21BF - EXECUTE
   .word _EXIT            ; #303b 21A8 - EXIT
@303D:
   .word _TIB             ; #303d 2176 - TIB
   .word __3EIN           ; #303f 2153 - >IN
   .word __40             ; #3041 2820 - @
   .word __2B             ; #3043 22ED - +
   .word __23TIB          ; #3045 2148 - #TIB
   .word __40             ; #3047 2820 - @
   .word __3EIN           ; #3049 2153 - >IN
   .word __40             ; #304b 2820 - @
   .word __2D             ; #304d 22F8 - -
   .word _ENCLOSE         ; #304f 2ADF - ENCLOSE
   .word __3FBRANCH       ; #3051 2916 - ?BRANCH
   .word @3061            ; #3053 3061
   .word _TIB             ; #3055 2176 - TIB
   .word __2D             ; #3057 22F8 - -
   .word __3EIN           ; #3059 2153 - >IN
   .word __21             ; #305b 2839 - !
   .word _BRANCH          ; #305d 2904 - BRANCH
   .word @306D            ; #305f 306D
@3061:
   .word __23TIB          ; #3061 2148 - #TIB
   .word __40             ; #3063 2820 - @
   .word __3EIN           ; #3065 2153 - >IN
   .word __21             ; #3067 2839 - !
   .word _0               ; #3069 2B2B - 0
   .word _0               ; #306b 2B2B - 0
@306D:
   .word _DUP             ; #306d 2277 - DUP
   .word _HERE            ; #306f 2B62 - HERE
   .word _C_21            ; #3071 2846 - C!
   .word _HERE            ; #3073 2B62 - HERE
   .word _1_2B            ; #3075 231A - 1+
   .word _SWAP            ; #3077 2238 - SWAP
   .word _CMOVE           ; #3079 2A28 - CMOVE
   .word _HERE            ; #307b 2B62 - HERE
   .word _BL              ; #307d 3289 - BL
   .word _OVER            ; #307f 220D - OVER
   .word _DUP             ; #3081 2277 - DUP
   .word _C_40            ; #3083 282D - C@
   .word _1_2B            ; #3085 231A - 1+
   .word __2B             ; #3087 22ED - +
   .word _C_21            ; #3089 2846 - C!
   .word _EXIT            ; #308b 21A8 - EXIT

NFA_INLINE:      ; 308D
   .byte 6,"INLINE"
   .word NFA_WORD         ; 3023
_INLINE:         ; 3096 - 30B9
   call _FCALL            ; 3096
   .word _INLINP          ; #3099 2122 - INLINP
   .word __40             ; #309b 2820 - @
   .word _EXECUTE         ; #309d 21BF - EXECUTE
   .word __3FBRANCH       ; #309f 2916 - ?BRANCH
   .word @30B5            ; #30a1 30B5
   .word __3EIN           ; #30a3 2153 - >IN
   .word __21             ; #30a5 2839 - !
   .word __23TIB          ; #30a7 2148 - #TIB
   .word __21             ; #30a9 2839 - !
   .word _INB             ; #30ab 213C - INB
   .word __21             ; #30ad 2839 - !
   .word _TRUE            ; #30af 2B49 - TRUE
   .word _BRANCH          ; #30b1 2904 - BRANCH
   .word @30B7            ; #30b3 30B7
@30B5:
   .word _FALSE           ; #30b5 2B56 - FALSE
@30B7:
   .word _EXIT            ; #30b7 21A8 - EXIT

NFA_EXPECT:      ; 30B9
   .byte 6,"EXPECT"
   .word NFA_INLINE       ; 308D
_EXPECT:         ; 30C2 - 3139
   call _FCALL            ; 30C2
   .word __3ER            ; #30c5 27A9 - >R
   .word _DUP             ; #30c7 2277 - DUP
   .word _R_3E            ; #30c9 27BC - R>
   .word _0               ; #30cb 2B2B - 0
   .word __28_3FDO_29     ; #30cd 29B8 - (?DO)
   .word @312F            ; #30cf 312F
@30D1:
   .word _KEY             ; #30d1 31A0 - KEY
   .word _DUP             ; #30d3 2277 - DUP
   .word _B_2DSP          ; #30d5 44F5 - B-SP
   .word __3D             ; #30d7 2409 - =
   .word __3FBRANCH       ; #30d9 2916 - ?BRANCH
   .word @310B            ; #30db 310B
   .word __3ER            ; #30dd 27A9 - >R
   .word _2DUP            ; #30df 2296 - 2DUP
   .word __3D             ; #30e1 2409 - =
   .word _N_3FBRANCH      ; #30e3 2934 - N?BRANCH
   .word @30FF            ; #30e5 30FF
   .word _R_3E            ; #30e7 27BC - R>
   .word _DUP             ; #30e9 2277 - DUP
   .word _EMIT            ; #30eb 3189 - EMIT
   .word _BL              ; #30ed 3289 - BL
   .word _EMIT            ; #30ef 3189 - EMIT
   .word _EMIT            ; #30f1 3189 - EMIT
   .word _1_2D            ; #30f3 2331 - 1-
   .word _R_3E            ; #30f5 27BC - R>
   .word _1_2D            ; #30f7 2331 - 1-
   .word __3ER            ; #30f9 27A9 - >R
   .word _BRANCH          ; #30fb 2904 - BRANCH
   .word @3101            ; #30fd 3101
@30FF:
   .word _RDROP           ; #30ff 2811 - RDROP
@3101:
   .word _R_3E            ; #3101 27BC - R>
   .word _1_2D            ; #3103 2331 - 1-
   .word __3ER            ; #3105 27A9 - >R
   .word _BRANCH          ; #3107 2904 - BRANCH
   .word @312B            ; #3109 312B
@310B:
   .word _DUP             ; #310b 2277 - DUP
   .word _ST_2DC          ; #310d 44E9 - ST-C
   .word __3D             ; #310f 2409 - =
   .word __3FBRANCH       ; #3111 2916 - ?BRANCH
   .word @3121            ; #3113 3121
   .word _DROP            ; #3115 222D - DROP
   .word _BL              ; #3117 3289 - BL
   .word _EMIT            ; #3119 3189 - EMIT
   .word _LEAVE           ; #311b 38B5 - LEAVE
   .word _BRANCH          ; #311d 2904 - BRANCH
   .word @312B            ; #311f 312B
@3121:
   .word _DUP             ; #3121 2277 - DUP
   .word _EMIT            ; #3123 3189 - EMIT
   .word _OVER            ; #3125 220D - OVER
   .word _C_21            ; #3127 2846 - C!
   .word _1_2B            ; #3129 231A - 1+
@312B:
   .word __28LOOP_29      ; #312b 29DA - (LOOP)
   .word @30D1            ; #312d 30D1
@312F:
   .word _SWAP            ; #312f 2238 - SWAP
   .word __2D             ; #3131 22F8 - -
   .word _SPAN            ; #3133 215F - SPAN
   .word __21             ; #3135 2839 - !
   .word _EXIT            ; #3137 21A8 - EXIT

NFA__3EPRT:      ; 3139
   .byte 4,">PRT"
   .word NFA_EXPECT       ; 30B9
__3EPRT:         ; 3140 - 314F
   call _FCALL            ; 3140
   .word _LIT             ; #3143 28C7 - LIT
   .word 0x007F           ; #3145 007F
   .word _MAX             ; #3147 2381 - MAX
   .word _BL              ; #3149 3289 - BL
   .word _MAX             ; #314b 2381 - MAX
   .word _EXIT            ; #314d 21A8 - EXIT

NFA_PTYPE:       ; 314F
   .byte 5,"PTYPE"
   .word NFA__3EPRT         ; 3139
_PTYPE:          ; 3157 - 3172
   call _FCALL            ; 3157
   .word _0               ; #315a 2B2B - 0
   .word __28_3FDO_29     ; #315c 29B8 - (?DO)
   .word @316E            ; #315e 316E
@3160:
   .word _DUP             ; #3160 2277 - DUP
   .word _C_40            ; #3162 282D - C@
   .word __3EPRT          ; #3164 3140 - >PRT
   .word _EMIT            ; #3166 3189 - EMIT
   .word _1_2B            ; #3168 231A - 1+
   .word __28LOOP_29      ; #316a 29DA - (LOOP)
   .word @3160            ; #316c 3160
@316E:
   .word _DROP            ; #316e 222D - DROP
   .word _EXIT            ; #3170 21A8 - EXIT

NFA_EMIT:        ; 3182
   .byte 4,"EMIT"
   .word NFA_             ; 3172
_EMIT:           ; 3189 - 319A
   call _FCALL            ; 3189
   .word _LIT             ; #318c 28C7 - LIT
   .word l600e            ; #318e 600E
   .word __40             ; #3190 2820 - @
   .word _EXECUTE         ; #3192 21BF - EXECUTE
   .word __3EOUT          ; #3194 216B - >OUT
   .word _1_2B_21         ; #3196 28A6 - 1+!
   .word _EXIT            ; #3198 21A8 - EXIT

NFA_KEY:         ; 319A
   .byte 3,"KEY"
   .word NFA_EMIT         ; 3182
_KEY:            ; 31A0 - 31AD
   call _FCALL            ; 31A0
   .word _LIT             ; #31a3 28C7 - LIT
   .word l600c            ; #31a5 600C
   .word __40             ; #31a7 2820 - @
   .word _EXECUTE         ; #31a9 21BF - EXECUTE
   .word _EXIT            ; #31ab 21A8 - EXIT

NFA_TYPE:        ; 31AD
   .byte 4,"TYPE"
   .word NFA_KEY          ; 319A
_TYPE:           ; 31B4 - 31DD
   call _FCALL            ; 31B4
   .word _LIT             ; #31b7 28C7 - LIT
   .word l6012            ; #31b9 6012
   .word __40             ; #31bb 2820 - @
   .word __3FDUP          ; #31bd 2284 - ?DUP
   .word __3FBRANCH       ; #31bf 2916 - ?BRANCH
   .word @31C7            ; #31c1 31C7
   .word _EXECUTE         ; #31c3 21BF - EXECUTE
   .word _EXIT            ; #31c5 21A8 - EXIT
@31C7:
   .word _0               ; #31c7 2B2B - 0
   .word __28_3FDO_29     ; #31c9 29B8 - (?DO)
   .word @31D9            ; #31cb 31D9
@31CD:
   .word _DUP             ; #31cd 2277 - DUP
   .word _C_40            ; #31cf 282D - C@
   .word _EMIT            ; #31d1 3189 - EMIT
   .word _1_2B            ; #31d3 231A - 1+
   .word __28LOOP_29      ; #31d5 29DA - (LOOP)
   .word @31CD            ; #31d7 31CD
@31D9:
   .word _DROP            ; #31d9 222D - DROP
   .word _EXIT            ; #31db 21A8 - EXIT

NFA__3ECH:       ; 31DD
   .byte 3,">CH"
   .word NFA_TYPE         ; 31AD
__3ECH:          ; 31E3 - 320C
   call _FCALL            ; 31E3
   .word __3EIN           ; #31e6 2153 - >IN
   .word __40             ; #31e8 2820 - @
   .word _DUP             ; #31ea 2277 - DUP
   .word __23TIB          ; #31ec 2148 - #TIB
   .word __40             ; #31ee 2820 - @
   .word _U_3C            ; #31f0 239D - U<
   .word _N_3FBRANCH      ; #31f2 2934 - N?BRANCH
   .word @31FE            ; #31f4 31FE
   .word _DROP            ; #31f6 222D - DROP
   .word _FALSE           ; #31f8 2B56 - FALSE
   .word _BRANCH          ; #31fa 2904 - BRANCH
   .word @320A            ; #31fc 320A
@31FE:
   .word _TIB             ; #31fe 2176 - TIB
   .word __2B             ; #3200 22ED - +
   .word _C_40            ; #3202 282D - C@
   .word __3EIN           ; #3204 2153 - >IN
   .word _1_2B_21         ; #3206 28A6 - 1+!
   .word _TRUE            ; #3208 2B49 - TRUE
@320A:
   .word _EXIT            ; #320a 21A8 - EXIT

NFA_FORTH_2D83:  ; 320C
   .byte 8,"FORTH-83"
   .word NFA__3ECH          ; 31DD
_FORTH_2D83:     ; 3217 - 3232
   call _FCALL            ; 3217
   .word _CR              ; #321a 454C - CR
   .word __28_2E_22_29    ; #321c 3421 - (.")
   .byte 17
   .stringmap russian,"CTAHДAPT FORTH-83"
   .word _EXIT            ; #3230 21A8 - EXIT

NFA__3BS:        ; 324E
   .byte 2,";S"
   .word NFA_F_2DDATA       ; 3240
__3BS:           ; 3253 - 325A
   call _FCALL            ; 3253
   .word _RDROP           ; #3256 2811 - RDROP
   .word _EXIT            ; #3258 21A8 - EXIT

NFA_HEX:         ; 325A
   .byte 3,"HEX"
   .word NFA__3BS           ; 324E
_HEX:            ; 3260 - 326D
   call _FCALL            ; 3260
   .word _LIT             ; #3263 28C7 - LIT
   .word 0x0010           ; #3265 0010
   .word _BASE            ; #3267 20C8 - BASE
   .word __21             ; #3269 2839 - !
   .word _EXIT            ; #326b 21A8 - EXIT

NFA_DECIMAL:     ; 326D
   .byte 7,"DECIMAL"
   .word NFA_HEX          ; 325A
_DECIMAL:        ; 3277 - 3284
   call _FCALL            ; 3277
   .word _LIT             ; #327a 28C7 - LIT
   .word 0x000A           ; #327c 000A
   .word _BASE            ; #327e 20C8 - BASE
   .word __21             ; #3280 2839 - !
   .word _EXIT            ; #3282 21A8 - EXIT

NFA_BLANK:       ; 328E
   .byte 5,"BLANK"
   .word NFA_BL           ; 3284
_BLANK:          ; 3296 - 329F
   call _FCALL            ; 3296
   .word _BL              ; #3299 3289 - BL
   .word _FILL            ; #329b 2AA1 - FILL
   .word _EXIT            ; #329d 21A8 - EXIT

NFA_SPACE:       ; 329F
   .byte 5,"SPACE"
   .word NFA_BLANK        ; 328E
_SPACE:          ; 32A7 - 32B0
   call _FCALL            ; 32A7
   .word _BL              ; #32aa 3289 - BL
   .word _EMIT            ; #32ac 3189 - EMIT
   .word _EXIT            ; #32ae 21A8 - EXIT

NFA_SPACES:      ; 32B0
   .byte 6,"SPACES"
   .word NFA_SPACE        ; 329F
_SPACES:         ; 32B9 - 32CA
   call _FCALL            ; 32B9
   .word _0               ; #32bc 2B2B - 0
   .word __28_3FDO_29     ; #32be 29B8 - (?DO)
   .word @32C8            ; #32c0 32C8
@32C2:
   .word _SPACE           ; #32c2 32A7 - SPACE
   .word __28LOOP_29      ; #32c4 29DA - (LOOP)
   .word @32C2            ; #32c6 32C2
@32C8:
   .word _EXIT            ; #32c8 21A8 - EXIT

NFA_ID_2E:       ; 32CA
   .byte 3,"ID."
   .word NFA_SPACES       ; 32B0
_ID_2E:          ; 32D0 - 32DF
   call _FCALL            ; 32D0
   .word _COUNT           ; #32d3 2BD2 - COUNT
   .word _LIT             ; #32d5 28C7 - LIT
   .word 0x003F           ; #32d7 003F
   .word _AND             ; #32d9 2764 - AND
   .word _TYPE            ; #32db 31B4 - TYPE
   .word _EXIT            ; #32dd 21A8 - EXIT

NFA_DEFINITIONS: ; 32DF
   .byte 11,"DEFINITIONS"
   .word NFA_ID_2E          ; 32CA
_DEFINITIONS:    ; 32ED - 32FA
   call _FCALL            ; 32ED
   .word _CONTEXT         ; #32f0 20E4 - CONTEXT
   .word __40             ; #32f2 2820 - @
   .word _CURRENT         ; #32f4 20F3 - CURRENT
   .word __21             ; #32f6 2839 - !
   .word _EXIT            ; #32f8 21A8 - EXIT

NFA_LATEST:      ; 32FA
   .byte 6,"LATEST"
   .word NFA_DEFINITIONS  ; 32DF
_LATEST:         ; 3303 - 330E
   call _FCALL            ; 3303
   .word _CURRENT         ; #3306 20F3 - CURRENT
   .word __40             ; #3308 2820 - @
   .word __40             ; #330a 2820 - @
   .word _EXIT            ; #330c 21A8 - EXIT

NFA__21CF:       ; 330E
   .byte 3,"!CF"
   .word NFA_LATEST       ; 32FA
__21CF:          ; 3314 - 3325
   call _FCALL            ; 3314
   .word _LIT             ; #3317 28C7 - LIT
   .word 0x00CD           ; #3319 00CD
   .word _OVER            ; #331b 220D - OVER
   .word _C_21            ; #331d 2846 - C!
   .word _1_2B            ; #331f 231A - 1+
   .word __21             ; #3321 2839 - !
   .word _EXIT            ; #3323 21A8 - EXIT

NFA__28_21CODE_29:; 3325
   .byte 7,"(!CODE)"
   .word NFA__21CF          ; 330E
__28_21CODE_29:  ; 332F - 333A
   call _FCALL            ; 332F
   .word _LATEST          ; #3332 3303 - LATEST
   .word _NAME_3E         ; #3334 2FD6 - NAME>
   .word __21CF           ; #3336 3314 - !CF
   .word _EXIT            ; #3338 21A8 - EXIT

NFA_SMUDGE:      ; 333A
   .byte 6,"SMUDGE"
   .word NFA__28_21CODE_29      ; 3325
_SMUDGE:         ; 3343 - 3350
   call _FCALL            ; 3343
   .word _LATEST          ; #3346 3303 - LATEST
   .word _LIT             ; #3348 28C7 - LIT
   .word 0x0040           ; #334a 0040
   .word _TOGGLE          ; #334c 2982 - TOGGLE
   .word _EXIT            ; #334e 21A8 - EXIT

NFA__28_2E_22_29:; 341A
   .byte 4,"(.\")"
   .word NFA__2DWORD        ; 33F3
__28_2E_22_29:   ; 3421 - 3436
   call _FCALL            ; 3421
   .word _R_40            ; #3424 27CF - R@
   .word _COUNT           ; #3426 2BD2 - COUNT
   .word _DUP             ; #3428 2277 - DUP
   .word _1_2B            ; #342a 231A - 1+
   .word _R_3E            ; #342c 27BC - R>
   .word __2B             ; #342e 22ED - +
   .word __3ER            ; #3430 27A9 - >R
   .word _TYPE            ; #3432 31B4 - TYPE
   .word _EXIT            ; #3434 21A8 - EXIT

NFA_ERASE:       ; 3436
   .byte 5,"ERASE"
   .word NFA__28_2E_22_29         ; 341A
_ERASE:          ; 343E - 3447
   call _FCALL            ; 343E
   .word _0               ; #3441 2B2B - 0
   .word _FILL            ; #3443 2AA1 - FILL
   .word _EXIT            ; #3445 21A8 - EXIT

NFA_TITLE:       ; 34BF
   .byte 5,"TITLE"
   .word NFA__5BCOMPILE_5D    ; 34AA
_TITLE:          ; 34C7 - 3592
   call _FCALL            ; 34C7
   .word _CR              ; #34ca 454C - CR
   .word __28_2E_22_29    ; #34cc 3421 - (.")
   .byte 34
   .stringmap russian,"ФOPT-7970 BEPCИЯ 6.2 OT 19.06.85  "
   .word __28_2E_22_29    ; #34f1 3421 - (.")
   .byte 19
   .stringmap russian,"(CTAHДAPT FORTH-83)"
   .word _CR              ; #3507 454C - CR
   .word __28_2E_22_29    ; #3509 3421 - (.")
   .byte 43
   .stringmap russian,"    B.A.KИPИЛЛИH A.A.KЛУБOBИЧ H.P.HOЗДPУHOB"
   .word _CR              ; #3537 454C - CR
   .word _LIT             ; #3539 28C7 - LIT
   .word 0x0014           ; #353b 0014
   .word _SPACES          ; #353d 32B9 - SPACES
   .word __28_2E_22_29    ; #353f 3421 - (.")
   .byte 7
   .stringmap russian,"BЦ  ЛГУ"
   .word _CR              ; #3549 454C - CR
   .word __28_2E_22_29    ; #354b 3421 - (.")
   .byte 50
   .stringmap russian,"198904 ЛEHИHГPAД ПETPOДBOPEЦ БИБЛИOTEЧHAЯ ПЛ. Д. 2"
   .word _CR              ; #3580 454C - CR
   .word _LIT             ; #3582 28C7 - LIT
   .word l600a            ; #3584 600A
   .word __40             ; #3586 2820 - @
   .word __3FDUP          ; #3588 2284 - ?DUP
   .word __3FBRANCH       ; #358a 2916 - ?BRANCH
   .word @3590            ; #358c 3590
   .word _EXECUTE         ; #358e 21BF - EXECUTE
@3590:
   .word _EXIT            ; #3590 21A8 - EXIT

NFA_CONVERT:     ; 3592
   .byte 7,"CONVERT"
   .word NFA_TITLE        ; 34BF
_CONVERT:        ; 359C - 35DB
   call _FCALL            ; 359C
@359F:
   .word _1_2B            ; #359f 231A - 1+
   .word _DUP             ; #35a1 2277 - DUP
   .word __3ER            ; #35a3 27A9 - >R
   .word _C_40            ; #35a5 282D - C@
   .word _BASE            ; #35a7 20C8 - BASE
   .word __40             ; #35a9 2820 - @
   .word _DIGIT           ; #35ab 272F - DIGIT
   .word __3FBRANCH       ; #35ad 2916 - ?BRANCH
   .word @35D7            ; #35af 35D7
   .word _SWAP            ; #35b1 2238 - SWAP
   .word _BASE            ; #35b3 20C8 - BASE
   .word __40             ; #35b5 2820 - @
   .word __2A             ; #35b7 253C - *
   .word _ROT             ; #35b9 225A - ROT
   .word _BASE            ; #35bb 20C8 - BASE
   .word __40             ; #35bd 2820 - @
   .word _UM_2A           ; #35bf 2568 - UM*
   .word _D_2B            ; #35c1 2472 - D+
   .word _DPL             ; #35c3 20FE - DPL
   .word __40             ; #35c5 2820 - @
   .word _1_2B            ; #35c7 231A - 1+
   .word __3FBRANCH       ; #35c9 2916 - ?BRANCH
   .word @35D1            ; #35cb 35D1
   .word _DPL             ; #35cd 20FE - DPL
   .word _1_2B_21         ; #35cf 28A6 - 1+!
@35D1:
   .word _R_3E            ; #35d1 27BC - R>
   .word _BRANCH          ; #35d3 2904 - BRANCH
   .word @359F            ; #35d5 359F
@35D7:
   .word _R_3E            ; #35d7 27BC - R>
   .word _EXIT            ; #35d9 21A8 - EXIT

NFA_NUMBER:      ; 35DB
   .byte 6,"NUMBER"
   .word NFA_CONVERT      ; 3592
_NUMBER:         ; 35E4 - 364C
   call _FCALL            ; 35E4
   .word _0               ; #35e7 2B2B - 0
   .word _0               ; #35e9 2B2B - 0
   .word _ROT             ; #35eb 225A - ROT
   .word _DUP             ; #35ed 2277 - DUP
   .word _1_2B            ; #35ef 231A - 1+
   .word _C_40            ; #35f1 282D - C@
   .word _LIT             ; #35f3 28C7 - LIT
   .word 0x002D           ; #35f5 002D
   .word __3D             ; #35f7 2409 - =
   .word __3FBRANCH       ; #35f9 2916 - ?BRANCH
   .word @3603            ; #35fb 3603
   .word _1               ; #35fd 2B34 - 1
   .word _BRANCH          ; #35ff 2904 - BRANCH
   .word @3605            ; #3601 3605
@3603:
   .word _0               ; #3603 2B2B - 0
@3605:
   .word _DUP             ; #3605 2277 - DUP
   .word __3ER            ; #3607 27A9 - >R
   .word __2B             ; #3609 22ED - +
   .word __2D1            ; #360b 2B22 - -1
@360D:
   .word _DPL             ; #360d 20FE - DPL
   .word __21             ; #360f 2839 - !
   .word _CONVERT         ; #3611 359C - CONVERT
   .word _DUP             ; #3613 2277 - DUP
   .word _DUP             ; #3615 2277 - DUP
   .word _C_40            ; #3617 282D - C@
   .word _BL              ; #3619 3289 - BL
   .word __3C_3E          ; #361b 2CFA - <>
   .word _SWAP            ; #361d 2238 - SWAP
   .word _0_3D            ; #361f 2421 - 0=
   .word _0_3D            ; #3621 2421 - 0=
   .word _AND             ; #3623 2764 - AND
   .word __3FBRANCH       ; #3625 2916 - ?BRANCH
   .word @3640            ; #3627 3640
   .word _DUP             ; #3629 2277 - DUP
   .word _C_40            ; #362b 282D - C@
   .word _LIT             ; #362d 28C7 - LIT
   .word 0x002E           ; #362f 002E
   .word __3C_3E          ; #3631 2CFA - <>
   .word __28ABORT_22_29  ; #3633 2D61 - (ABORT")
   .byte 4," -? "
   .word _0               ; #363a 2B2B - 0
   .word _BRANCH          ; #363c 2904 - BRANCH
   .word @360D            ; #363e 360D
@3640:
   .word _DROP            ; #3640 222D - DROP
   .word _R_3E            ; #3642 27BC - R>
   .word __3FBRANCH       ; #3644 2916 - ?BRANCH
   .word @364A            ; #3646 364A
   .word _DNEGATE         ; #3648 24C3 - DNEGATE
@364A:
   .word _EXIT            ; #364a 21A8 - EXIT

NFA__3FSTACK:    ; 364C
   .byte 6,"?STACK"
   .word NFA_NUMBER       ; 35DB
__3FSTACK:       ; 3655 - 3677
   call _FCALL            ; 3655
   .word _SP_40           ; #3658 22D6 - SP@
   .word _S0              ; #365a 2088 - S0
   .word __40             ; #365c 2820 - @
   .word _SWAP            ; #365e 2238 - SWAP
   .word _U_3C            ; #3660 239D - U<
   .word __28ABORT_22_29  ; #3662 2D61 - (ABORT")
   .byte 16
   .stringmap russian,"ИCЧEPПAHИE CTEKA"
   .word _EXIT            ; #3675 21A8 - EXIT

NFA_LEAVE:       ; 38AD
   .byte 5,"LEAVE"
   .word NFA__3FPAIRS       ; 388A
_LEAVE:          ; 38B5 - 38C0
   call _FCALL            ; 38B5
   .word _RDROP           ; #38b8 2811 - RDROP
   .word _RDROP           ; #38ba 2811 - RDROP
   .word _RDROP           ; #38bc 2811 - RDROP
   .word _EXIT            ; #38be 21A8 - EXIT

NFA_DEPTH:       ; 390D
   .byte 5,"DEPTH"
   .word NFA_IMMEDIATE    ; 38F4
_DEPTH:          ; 3915 - 392A
   call _FCALL            ; 3915
   .word _SP_40           ; #3918 22D6 - SP@
   .word _S0              ; #391a 2088 - S0
   .word __40             ; #391c 2820 - @
   .word _SWAP            ; #391e 2238 - SWAP
   .word __2D             ; #3920 22F8 - -
   .word _2_2F            ; #3922 2460 - 2/
   .word _0               ; #3924 2B2B - 0
   .word _MAX             ; #3926 2381 - MAX
   .word _EXIT            ; #3928 21A8 - EXIT

NFA_STR:         ; 3DE5
   .byte 3,"STR"
   .word NFA__3FNAME        ; 3D80
_STR:            ; 3DEB - 3E04
   call _FCALL            ; 3DEB
   .word _DUP             ; #3dee 2277 - DUP
   .word _ID_2E           ; #3df0 32D0 - ID.
   .word _LIT             ; #3df2 28C7 - LIT
   .word 0x0022           ; #3df4 0022
   .word _EMIT            ; #3df6 3189 - EMIT
   .word _SPACE           ; #3df8 32A7 - SPACE
   .word _DUP             ; #3dfa 2277 - DUP
   .word _C_40            ; #3dfc 282D - C@
   .word _1_2B            ; #3dfe 231A - 1+
   .word __2B             ; #3e00 22ED - +
   .word _EXIT            ; #3e02 21A8 - EXIT

l44fa:
   call KEY_STATUS ; #44fa cd 12 f8
   jz l44fa        ; #44fd ca fa 44
   call INPUT_KEY  ; #4500 cd 03 f8
   ani 0x7f        ; #4503 e6 7f
   mov l,a         ; #4505 6f
   mvi h,00        ; #4506 26 00
   ret             ; #4508 c9

NFA__28KEY_29:   ; 4521
   .byte 5,"(KEY)"
   .word NFA_B_2DSP         ; 44EE
__28KEY_29:      ; 4529 - 4530
   call l44fa      ; #4529 cd fa 44
   push h          ; #452c e5
   jmp _FNEXT      ; #452d c3 9a 21

NFA__28EMIT_29:  ; 4530
   .byte 6,"(EMIT)"
   .word NFA__28KEY_29        ; 4521
__28EMIT_29:     ; 4539 - 4547
   pop h
   push b          ; #453a c5
   mov c,l         ; #453b 4d
   call PRINT_CHAR ; #453c cd 09 f8
   pop b           ; #453f c1
   jmp _FNEXT      ; #4544 c3 9a 21

NFA_CR:          ; 4547
   .byte 2,"CR"
   .word NFA__28EMIT_29       ; 4530
_CR:             ; 454C - 4561
   call _FCALL            ; 454C
   .word _LIT             ; #454f 28C7 - LIT
   .word 0x000A           ; #4551 000A
   .word _EMIT            ; #4553 3189 - EMIT
   .word _LIT             ; #4555 28C7 - LIT
   .word 0x000D           ; #4557 000D
   .word _EMIT            ; #4559 3189 - EMIT
   .word __3EOUT          ; #455b 216B - >OUT
   .word _0_21            ; #455d 2898 - 0!
   .word _EXIT            ; #455f 21A8 - EXIT

NFA_STANDIO:     ; 458A
   .byte 7,"STANDIO"
   .word NFA_QUERY        ; 4561
_STANDIO:        ; 4594 - None
   call _FCALL      ; #4594 cd 8f 21
   .word _LIT             ; #4597 28C7 - LIT
   .word l6014            ; #4599 6014
   .word __40             ; #459b 2820 - @
   .word __3FDUP          ; #459d 2284 - ?DUP
   .word __3FBRANCH       ; #459f 2916 - ?BRANCH
   .word @45A7            ; #45a1 45A7
   .word _EXECUTE         ; #45a3 21BF - EXECUTE
   .word _EXIT            ; #45a5 21A8 - EXIT
@45A7:
   .word _LIT             ; #45a7 28C7 - LIT
   .word _QUERY           ; #45a9 4569 - QUERY
   .word _INLINP          ; #45ab 2122 - INLINP
   .word __21             ; #45ad 2839 - !
   .word __23TIB          ; #45af 2148 - #TIB
   .word _0_21            ; #45b1 2898 - 0!
   .word __3EIN           ; #45b3 2153 - >IN
   .word _0_21            ; #45b5 2898 - 0!
   .word _LIT             ; #45b7 28C7 - LIT
   .word __28KEY_29       ; #45b9 4529 - (KEY)
   .word _LIT             ; #45bb 28C7 - LIT
   .word l600c            ; #45bd 600C
   .word __21             ; #45bf 2839 - !
   .word _LIT             ; #45c1 28C7 - LIT
   .word __28EMIT_29      ; #45c3 4539 - (EMIT)
   .word _LIT             ; #45c5 28C7 - LIT
   .word l600e            ; #45c7 600E
   .word __21             ; #45c9 2839 - !
   .word _EXIT            ; #45cb 21A8 - EXIT
