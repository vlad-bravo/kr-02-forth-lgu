; ФОРТ-7970 ВЕРСИЯ 6.2 ОТ 19.06.85 (СТАНДАРТ FORTH-83)
; В.А.КИРИЛЛИН А.А.КЛУБОВИЧ Н.Р.НОЗДРУНОВ
; ВЦ ЛГУ
; 198904 ЛЕНИНГРАД ПЕТРОДВОРЕЦ БИБЛИОТЕЧНАЯ ПЛ. Д. 2

.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.BANK 0 SLOT 0
.ORGA 0x0000

.DEF PREV_NFA NFA_FORTH
.DEF PREFIX PREFIX_FORTH

l2000:
   jmp _COLD

NFA "COLD"
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
;   lhld l2183
;   shld l6022
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
   .word _STANDIO, _TITLE, _HEX, _QUIT

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

NFA "EXIT"
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
   .word LATEST_NFA  ; #2075 lfa
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
;l2183:
;   .word l3f91

NFA "EXECUTE"
   ret

NFA "ASMCALL"
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

NFA "OVER"
   pop h           ; #220d e1
   pop d           ; #220e d1
   push d          ; #220f d5
   push h          ; #2210 e5
   push d          ; #2211 d5
   jmp _FNEXT      ; #2212 c3 9a 21

NFA "PICK"
   pop h           ; #221c e1
   dad h           ; #221d 29
   dad sp          ; #221e 39
   mov e,m         ; #221f 5e
   inx h           ; #2220 23
   mov d,m         ; #2221 56
   push d          ; #2222 d5
   jmp _FNEXT      ; #2223 c3 9a 21

NFA "DROP"
   pop h           ; #222d e1
   jmp _FNEXT      ; #222e c3 9a 21

NFA "SWAP"
   pop h           ; #2238 e1
   xthl            ; #2239 e3
   push h          ; #223a e5
   jmp _FNEXT      ; #223b c3 9a 21

NFA "2SWAP"
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

NFA "ROT"
   pop d           ; #225a d1
   pop h           ; #225b e1
   xthl            ; #225c e3
   push d          ; #225d d5
   push h          ; #225e e5
   jmp _FNEXT      ; #225f c3 9a 21

NFA2 "-ROT", "_2DROT"
   pop h           ; #2269 e1
   pop d           ; #226a d1
   xthl            ; #226b e3
   push h          ; #226c e5
   push d          ; #226d d5
   jmp _FNEXT      ; #226e c3 9a 21

NFA "DUP"
   pop h           ; #2277 e1
   push h          ; #2278 e5
   push h          ; #2279 e5
   jmp _FNEXT      ; #227a c3 9a 21

NFA2 "?DUP", "_3FDUP"
   pop h           ; #2284 e1
   push h          ; #2285 e5
   mov a,h         ; #2286 7c
   ora l           ; #2287 b5
   jz _FNEXT       ; #2288 ca 9a 21
   push h          ; #228b e5
   jmp _FNEXT      ; #228c c3 9a 21

NFA "2DUP"
   pop h           ; #2296 e1
   pop d           ; #2297 d1
   push d          ; #2298 d5
   push h          ; #2299 e5
   push d          ; #229a d5
   push h          ; #229b e5
   jmp _FNEXT      ; #229c c3 9a 21

NFA "2DROP"
   pop d           ; #22a7 d1
   pop d           ; #22a8 d1
   jmp _FNEXT      ; #22a9 c3 9a 21

NFA "PRESS"
   pop h           ; #22b4 e1
   xthl            ; #22b5 e3
   jmp _FNEXT      ; #22b6 c3 9a 21

NFA "2OVER"
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

NFA2 "SP@", "SP_40"
   lxi h,0000      ; #22d6 21 00 00
   dad sp          ; #22d9 39
   push h          ; #22da e5
   jmp _FNEXT      ; #22db c3 9a 21

NFA2 "SP!", "SP_21"
   pop h           ; #22e4 e1
   sphl            ; #22e5 f9
   jmp _FNEXT      ; #22e6 c3 9a 21

NFA2 "-TRAILING", "_2DTRAILING"
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

NFA2 "-TEXT", "_2DTEXT"
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

NFA "ROLL"
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

NFA2 "?WORD", "_3FWORD"
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

NFA "DIGIT"
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

NFA2 ">R", "_3ER"
   pop d           ; #27a9 d1
   lhld l601a      ; #27aa 2a 1a 60
   dcx h           ; #27ad 2b
   mov m,d         ; #27ae 72
   dcx h           ; #27af 2b
   mov m,e         ; #27b0 73
   shld l601a      ; #27b1 22 1a 60
   jmp _FNEXT      ; #27b4 c3 9a 21

NFA2 "R>", "R_3E"
   lhld l601a      ; #27bc 2a 1a 60
   mov e,m         ; #27bf 5e
   inx h           ; #27c0 23
   mov d,m         ; #27c1 56
   inx h           ; #27c2 23
   push d          ; #27c3 d5
   shld l601a      ; #27c4 22 1a 60
   jmp _FNEXT      ; #27c7 c3 9a 21

NFA2 "R@", "R_40"
   lhld l601a      ; #27cf 2a 1a 60
   mov e,m         ; #27d2 5e
   inx h           ; #27d3 23
   mov d,m         ; #27d4 56
   push d          ; #27d5 d5
   jmp _FNEXT      ; #27d6 c3 9a 21

NFA2 "RP@", "RP_40"
   lhld l601a      ; #27df 2a 1a 60
   push h          ; #27e2 e5
   jmp _FNEXT      ; #27e3 c3 9a 21

NFA2 "RP!", "RP_21"
   pop h           ; #27ec e1
   shld l601a      ; #27ed 22 1a 60
   jmp _FNEXT      ; #27f0 c3 9a 21

NFA "RPICK"
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

NFA "RDROP"
   lhld l601a      ; #2811 2a 1a 60
   inx h           ; #2814 23
   inx h           ; #2815 23
   shld l601a      ; #2816 22 1a 60
   jmp _FNEXT      ; #2819 c3 9a 21

NFA2 "@", "_40"
   pop h           ; #2820 e1
   mov e,m         ; #2821 5e
   inx h           ; #2822 23
   mov d,m         ; #2823 56
   push d          ; #2824 d5
   jmp _FNEXT      ; #2825 c3 9a 21

NFA2 "C@", "C_40"
   pop h           ; #282d e1
   mov e,m         ; #282e 5e
   mvi d,00        ; #282f 16 00
   push d          ; #2831 d5
   jmp _FNEXT      ; #2832 c3 9a 21

NFA2 "!", "_21"
   pop h           ; #2839 e1
   pop d           ; #283a d1
   mov m,e         ; #283b 73
   inx h           ; #283c 23
   mov m,d         ; #283d 72
   jmp _FNEXT      ; #283e c3 9a 21

NFA2 "C!", "C_21"
   pop h           ; #2846 e1
   pop d           ; #2847 d1
   mov m,e         ; #2848 73
   jmp _FNEXT      ; #2849 c3 9a 21

NFA2 "2!", "2_21"
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

NFA2 "2@", "2_40"
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

NFA2 "+!", "_2B_21"
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

NFA2 "-!", "_2D_21"
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

NFA2 "0!", "0_21"
   sub a           ; #2898 97
   pop h           ; #2899 e1
   mov m,a         ; #289a 77
   inx h           ; #289b 23
   mov m,a         ; #289c 77
   jmp _FNEXT      ; #289d c3 9a 21

NFA2 "1+!", "1_2B_21"
   pop h           ; #28a6 e1
   inr m           ; #28a7 34
   jnz _FNEXT      ; #28a8 c2 9a 21
   inx h           ; #28ab 23
   inr m           ; #28ac 34
   jmp _FNEXT      ; #28ad c3 9a 21

NFA2 "1-!", "1_2D_21"
   pop h           ; #28b6 e1
   mov e,m         ; #28b7 5e
   inx h           ; #28b8 23
   mov d,m         ; #28b9 56
   dcx d           ; #28ba 1b
   mov m,d         ; #28bb 72
   dcx h           ; #28bc 2b
   mov m,e         ; #28bd 73
   jmp _FNEXT      ; #28be c3 9a 21

NFA "LIT"
   ldax b          ; #28c7 0a
   mov l,a         ; #28c8 6f
   inx b           ; #28c9 03
   ldax b          ; #28ca 0a
   mov h,a         ; #28cb 67
   inx b           ; #28cc 03
   push h          ; #28cd e5
   jmp _FNEXT      ; #28ce c3 9a 21

NFA "DLIT"
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

NFA2 "(\")", "_28_22_29"
   push b          ; #28ef c5
   ldax b          ; #28f0 0a
   mov l,a         ; #28f1 6f
   mvi h,00        ; #28f2 26 00
   inx h           ; #28f4 23
   dad b           ; #28f5 09
   mov b,h         ; #28f6 44
   mov c,l         ; #28f7 4d
   jmp _FNEXT      ; #28f8 c3 9a 21

NFA "BRANCH"
   mov h,b         ; #2904 60
   mov l,c         ; #2905 69
   mov c,m         ; #2906 4e
   inx h           ; #2907 23
   mov b,m         ; #2908 46
   jmp _FNEXT      ; #2909 c3 9a 21

NFA2 "?BRANCH", "_3FBRANCH"
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

NFA2 "N?BRANCH", "N_3FBRANCH"
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

NFA "I"
   lhld l601a      ; #294b 2a 1a 60
   mov e,m         ; #294e 5e
   inx h           ; #294f 23
   mov d,m         ; #2950 56
   push d          ; #2951 d5
   jmp _FNEXT      ; #2952 c3 9a 21

NFA "J"
   lhld l601a      ; #2959 2a 1a 60
   lxi d,0006      ; #295c 11 06 00
   dad d           ; #295f 19
   mov e,m         ; #2960 5e
   inx h           ; #2961 23
   mov d,m         ; #2962 56
   push d          ; #2963 d5
   jmp _FNEXT      ; #2964 c3 9a 21

NFA "K"
   lhld l601a      ; #296b 2a 1a 60
   lxi d,0x000c    ; #296e 11 0c 00
   dad d           ; #2971 19
   mov e,m         ; #2972 5e
   inx h           ; #2973 23
   mov d,m         ; #2974 56
   push d          ; #2975 d5
   jmp _FNEXT      ; #2976 c3 9a 21

NFA "TOGGLE"
   pop d           ; #2982 d1
   mov a,e         ; #2983 7b
   pop h           ; #2984 e1
   xra m           ; #2985 ae
   mov m,a         ; #2986 77
   jmp _FNEXT      ; #2987 c3 9a 21

NFA2 "(DO)", "_28DO_29"
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

NFA2 "(?DO)", "_28_3FDO_29"
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

NFA2 "(LOOP)", "_28LOOP_29"
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

NFA2 "(+LOOP)", "_28_2BLOOP_29"
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

NFA "CMOVE"
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

NFA2 "CMOVE>", "CMOVE_3E"
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

NFA2 "<CMOVE>", "_3CCMOVE_3E"
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

NFA "FILL"
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

NFA2 "0>BL", "0_3EBL"
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

NFA "TRAVERSE"
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

NFA "WORD"
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

NFA "INLINE"
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

NFA "EXPECT"
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

NFA "CONVERT"
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

NFA "NUMBER"
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

l44fa:
   call KEY_STATUS ; #44fa cd 12 f8
   jz l44fa        ; #44fd ca fa 44
   call INPUT_KEY  ; #4500 cd 03 f8
   ani 0x7f        ; #4503 e6 7f
   mov l,a         ; #4505 6f
   mvi h,00        ; #4506 26 00
   ret             ; #4508 c9

NFA2 "(KEY)", "_28KEY_29"
   call l44fa      ; #4529 cd fa 44
   push h          ; #452c e5
   jmp _FNEXT      ; #452d c3 9a 21

NFA2 "(EMIT)", "_28EMIT_29"
   pop h
   push b          ; #453a c5
   mov c,l         ; #453b 4d
   call PRINT_CHAR ; #453c cd 09 f8
   pop b           ; #453f c1
   jmp _FNEXT      ; #4544 c3 9a 21

NFA2 "", "", IMMEDIATE
   call _FCALL            ; 3175
   .word _INLINE          ; #3178 3096 - INLINE
   .word _N_3FBRANCH      ; #317a 2934 - N?BRANCH
   .word @3180            ; #317c 3180
   .word _RDROP           ; #317e 2811 - RDROP
@3180:
   .word _EXIT            ; #3180 21A8 - EXIT

NFA "ENCLOSE"
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
