; ФОРТ-7970 ВЕРСИЯ 6.2 ОТ 19.06.85 (СТАНДАРТ FORTH-83)
; В.А.КИРИЛЛИН А.А.КЛУБОВИЧ Н.Р.НОЗДРУНОВ
; ВЦ ЛГУ
; 198904 ЛЕНИНГРАД ПЕТРОДВОРЕЦ БИБЛИОТЕЧНАЯ ПЛ. Д. 2

.MEMORYMAP
    DEFAULTSLOT 0
    SLOTSIZE 9689
    SLOT 0 $1FFC
.ENDME

.ROMBANKMAP
    BANKSTOTAL 1
    BANKSIZE 9689
    BANKS 1
.ENDRO

.def NFA_FORTH $6044
.def _FORTH $604c

.BANK 0 SLOT 0
.ORGA $1FFC

   .db 0x20, 0x00, 0x45, 0xD0

   jmp @2006       ; $2000 c3 06 20
   jmp $2040       ; $2003 c3 40 20
@2006:
   lxi d,N_FORTH   ; $2006 11 68 20
   lxi h,NFA_FORTH ; $2009 21 44 60
   mvi b,$11       ; $200c 06 11
@200e:
   ldax d          ; $200e 1a
   mov m,a         ; $200f 77
   inx h           ; $2010 23
   inx d           ; $2011 13
   dcr b           ; $2012 05
   jnz @200e       ; $2013 c2 0e 20
   mvi b,$1a       ; $2016 06 1a
   lxi h,$6000     ; $2018 21 00 60
   sub a           ; $201b 97
@201c:
   mov m,a         ; $201c 77
   inx h           ; $201d 23
   dcr b           ; $201e 05
   jnz @201c       ; $201f c2 1c 20
   lhld $217b      ; $2022 2a 7b 21
   shld $601c      ; $2025 22 1c 60
   lhld $217d      ; $2028 2a 7d 21
   shld $601e      ; $202b 22 1e 60
   lhld $217f      ; $202e 2a 7f 21
   shld $6020      ; $2031 22 20 60
   lhld $2181      ; $2034 2a 81 21
   shld $6024      ; $2037 22 24 60
   lhld $2183      ; $203a 2a 83 21
   shld $6022      ; $203d 22 22 60
   lhld $601e      ; $2040 2a 1e 60
   sphl            ; $2043 f9
   lhld $601c      ; $2044 2a 1c 60
   shld $601a      ; $2047 22 1a 60
   lxi b,l2050     ; $204a 01 50 20
   jmp $219a       ; $204d c3 9a 21

l2050:
   .word _LIT             ; $2050 28C7 - LIT
   .word $6018            ; $2052 6018
   .word __40             ; $2054 2820 - @
   .word __3FDUP          ; $2056 2284 - ?DUP
   .word __3FBRANCH       ; $2058 2916 - ?BRANCH
   .word @2060            ; $205a 2060
   .word _EXECUTE         ; $205c 21BF - EXECUTE
   .word _EXIT            ; $205e 21A8 - EXIT
@2060:
   .word _STANDIO         ; $2060 4594 - STANDIO
   .word _TITLE           ; $2062 34C7 - TITLE
   .word _DECIMAL         ; $2064 3277 - DECIMAL
   .word _QUIT            ; $2066 2D0A - QUIT

N_FORTH:       ; 2068
   .byte 5,"FORTH"
   .word $0000
;_FORTH:             ; 2070 - None
   call VOCABULARY_DOES ; $2070 cd d1 37
   .byte 0x01        ; $2073
   .byte 0x80        ; $2074 nfa (fake)
   .word NFA_STANDIO ; $2075 lfa
   .word $0000       ; $2077 voc-link

NFA_R0:          ; 2079
   .byte 2,"R0"
   .word NFA_FORTH        ; 6044
_R0:             ; 207E - 2083
   call __40     ; 207E
   .word $601C   ; 2081

NFA_S0:          ; 2083
   .byte 2,"S0"
   .word NFA_R0           ; 2079
_S0:             ; 2088 - 208D
   call __40     ; 2088
   .word $601E   ; 208B

NFA_H:           ; 208D
   .byte 1,"H"
   .word NFA_S0           ; 2083
_H:              ; 2091 - 2096
   call __40     ; 2091
   .word $6020   ; 2094

NFA_VOC_2DLINK:  ; 2096
   .byte 8,"VOC-LINK"
   .word NFA_H            ; 208D
_VOC_2DLINK:     ; 20A1 - 20A6
   call __40     ; 20A1
   .word $6022   ; 20A4

NFA_FENCE:       ; 20A6
   .byte 5,"FENCE"
   .word NFA_VOC_2DLINK     ; 2096
_FENCE:          ; 20AE - 20B3
   call __40     ; 20AE
   .word $6024   ; 20B1

NFA_W_2DLINK:    ; 20B3
   .byte 6,"W-LINK"
   .word NFA_FENCE        ; 20A6
_W_2DLINK:       ; 20BC - 20C1
   call __40     ; 20BC
   .word $6026   ; 20BF

NFA_BASE:        ; 20C1
   .byte 4,"BASE"
   .word NFA_W_2DLINK       ; 20B3
_BASE:           ; 20C8 - 20CD
   call __40     ; 20C8
   .word $6028   ; 20CB

NFA_STATE:       ; 20CD
   .byte 5,"STATE"
   .word NFA_BASE         ; 20C1
_STATE:          ; 20D5 - 20DA
   call __40     ; 20D5
   .word $602A   ; 20D8

NFA_CONTEXT:     ; 20DA
   .byte 7,"CONTEXT"
   .word NFA_STATE        ; 20CD
_CONTEXT:        ; 20E4 - 20E9
   call __40     ; 20E4
   .word $602C   ; 20E7

NFA_CURRENT:     ; 20E9
   .byte 7,"CURRENT"
   .word NFA_CONTEXT      ; 20DA
_CURRENT:        ; 20F3 - 20F8
   call __40     ; 20F3
   .word $602E   ; 20F6

NFA_DPL:         ; 20F8
   .byte 3,"DPL"
   .word NFA_CURRENT      ; 20E9
_DPL:            ; 20FE - 2103
   call __40     ; 20FE
   .word $6030   ; 2101

NFA_HLD:         ; 2103
   .byte 3,"HLD"
   .word NFA_DPL          ; 20F8
_HLD:            ; 2109 - 210E
   call __40     ; 2109
   .word $6032   ; 210C

NFA_CSP:         ; 210E
   .byte 3,"CSP"
   .word NFA_HLD          ; 2103
_CSP:            ; 2114 - 2119
   call __40     ; 2114
   .word $6034   ; 2117

NFA_INLINP:      ; 2119
   .byte 6,"INLINP"
   .word NFA_CSP          ; 210E
_INLINP:         ; 2122 - 2127
   call __40     ; 2122
   .word $6036   ; 2125

NFA_OUTLINP:     ; 2127
   .byte 7,"OUTLINP"
   .word NFA_INLINP       ; 2119
_OUTLINP:        ; 2131 - 2136
   call __40     ; 2131
   .word $6038   ; 2134

NFA_INB:         ; 2136
   .byte 3,"INB"
   .word NFA_OUTLINP      ; 2127
_INB:            ; 213C - 2141
   call __40     ; 213C
   .word $603A   ; 213F

NFA__23TIB:      ; 2141
   .byte 4,"#TIB"
   .word NFA_INB          ; 2136
__23TIB:         ; 2148 - 214D
   call __40     ; 2148
   .word $603C   ; 214B

NFA__3EIN:       ; 214D
   .byte 3,">IN"
   .word NFA__23TIB         ; 2141
__3EIN:          ; 2153 - 2158
   call __40     ; 2153
   .word $603E   ; 2156

NFA_SPAN:        ; 2158
   .byte 4,"SPAN"
   .word NFA__3EIN          ; 214D
_SPAN:           ; 215F - 2164
   call __40     ; 215F
   .word $6040   ; 2162

NFA__3EOUT:      ; 2164
   .byte 4,">OUT"
   .word NFA_SPAN         ; 2158
__3EOUT:         ; 216B - 2170
   call __40     ; 216B
   .word $6042   ; 216E

NFA_TIB:         ; 2170
   .byte 3,"TIB"
   .word NFA__3EOUT         ; 2164
_TIB:            ; 2176 - 2185
   call __40     ; 2176
   .word $6099   ; 2179

;!!!
   sub l           ; $217b 95
   mov h,b         ; $217c 60
   dad sp          ; $217d 39
   mov h,c         ; $217e 61
   mov c,l         ; $217f 4d
   mov h,c         ; $2180 61
   mov c,l         ; $2181 4d
   mov h,c         ; $2182 61
   sub c           ; $2183 91
   cmc             ; $2184 3f

NFA_COLD:        ; 2185
   .byte 4,"COLD"
   .word NFA_TIB          ; 2170
_COLD:           ; 218C - 21A1
   jmp $2006       ; $218c c3 06 20

_FCALL:
   lhld $601a      ; $218f 2a 1a 60
   dcx h           ; $2192 2b
   mov m,b         ; $2193 70
   dcx h           ; $2194 2b
   mov m,c         ; $2195 71
   shld $601a      ; $2196 22 1a 60
   pop b           ; $2199 c1
l219a:
   ldax b          ; $219a 0a
   mov l,a         ; $219b 6f
   inx b           ; $219c 03
   ldax b          ; $219d 0a
   mov h,a         ; $219e 67
   inx b           ; $219f 03
   pchl            ; $21a0 e9

NFA_EXIT:        ; 21A1
   .byte 4,"EXIT"
   .word NFA_COLD         ; 2185
_EXIT:           ; 21A8 - 21B5
   lhld $601a      ; $21a8 2a 1a 60
   mov c,m         ; $21ab 4e
   inx h           ; $21ac 23
   mov b,m         ; $21ad 46
   inx h           ; $21ae 23
   shld $601a      ; $21af 22 1a 60
   jmp l219a       ; $21b2 c3 9a 21

NFA_EXECUTE:     ; 21B5
   .byte 7,"EXECUTE"
   .word NFA_EXIT         ; 21A1
_EXECUTE:        ; 21BF - 21C0
   ret

NFA_ASMCALL:     ; 21C0
   .byte 7,"ASMCALL"
   .word NFA_EXECUTE      ; 21B5
_ASMCALL:        ; 21CA - 21EE
   lhld $601a      ; $21ca 2a 1a 60
   dcx h           ; $21cd 2b
   mov m,b         ; $21ce 70
   dcx h           ; $21cf 2b
   mov m,c         ; $21d0 71
   shld $601a      ; $21d1 22 1a 60
   pop h           ; $21d4 e1
   pop b           ; $21d5 c1
   pop d           ; $21d6 d1
   xthl            ; $21d7 e3
   shld $613d      ; $21d8 22 3d 61
   pop h           ; $21db e1
   pop psw         ; $21dc f1
   push h          ; $21dd e5
   lxi h,$21e7     ; $21de 21 e7 21
   xthl            ; $21e1 e3
   push h          ; $21e2 e5
   lhld $613d      ; $21e3 2a 3d 61
   ret             ; $21e6 c9
   push psw        ; $21e7 f5
   push h          ; $21e8 e5
   push d          ; $21e9 d5
   push b          ; $21ea c5
   jmp $21a8       ; $21eb c3 a8 21

NFA_NEXT:        ; 21EE
   .byte 4,"NEXT"
   .word NFA_ASMCALL      ; 21C0
_NEXT:           ; 21F5 - 21FA
   call __40     ; 21F5
   .word l219a   ; 21F8

NFA_CALL:        ; 21FA
   .byte 4,"CALL"
   .word NFA_NEXT         ; 21EE
_CALL:           ; 2201 - 2206
   call __40     ; 2201
   .word _FCALL  ; 2204

NFA_OVER:        ; 2206
   .byte 4,"OVER"
   .word NFA_CALL         ; 21FA
_OVER:           ; 220D - 2215
   pop h           ; $220d e1
   pop d           ; $220e d1
   push d          ; $220f d5
   push h          ; $2210 e5
   push d          ; $2211 d5
   jmp l219a       ; $2212 c3 9a 21

NFA_PICK:        ; 2215
   .byte 4,"PICK"
   .word NFA_OVER         ; 2206
_PICK:           ; 221C - 2226
   pop h           ; $221c e1
   dad h           ; $221d 29
   dad sp          ; $221e 39
   mov e,m         ; $221f 5e
   inx h           ; $2220 23
   mov d,m         ; $2221 56
   push d          ; $2222 d5
   jmp l219a       ; $2223 c3 9a 21

NFA_DROP:        ; 2226
   .byte 4,"DROP"
   .word NFA_PICK         ; 2215
_DROP:           ; 222D - 2231
   pop h           ; $222d e1
   jmp l219a       ; $222e c3 9a 21

NFA_SWAP:        ; 2231
   .byte 4,"SWAP"
   .word NFA_DROP         ; 2226
_SWAP:           ; 2238 - 223E
   pop h           ; $2238 e1
   xthl            ; $2239 e3
   push h          ; $223a e5
   jmp l219a       ; $223b c3 9a 21

NFA_2SWAP:       ; 223E
   .byte 5,"2SWAP"
   .word NFA_SWAP         ; 2231
_2SWAP:          ; 2246 - 2254
   pop d           ; $2246 d1
   pop h           ; $2247 e1
   inx sp          ; $2248 33
   inx sp          ; $2249 33
   xthl            ; $224a e3
   xchg            ; $224b eb
   dcx sp          ; $224c 3b
   dcx sp          ; $224d 3b
   xthl            ; $224e e3
   push d          ; $224f d5
   push h          ; $2250 e5
   jmp $219a       ; $2251 c3 9a 21

NFA_ROT:         ; 2254
   .byte 3,"ROT"
   .word NFA_2SWAP        ; 223E
_ROT:            ; 225A - 2262
   pop d           ; $225a d1
   pop h           ; $225b e1
   xthl            ; $225c e3
   push d          ; $225d d5
   push h          ; $225e e5
   jmp $219a       ; $225f c3 9a 21

NFA__2DROT:      ; 2262
   .byte 4,"-ROT"
   .word NFA_ROT          ; 2254
__2DROT:         ; 2269 - 2271
   pop h           ; $2269 e1
   pop d           ; $226a d1
   xthl            ; $226b e3
   push h          ; $226c e5
   push d          ; $226d d5
   jmp $219a       ; $226e c3 9a 21

NFA_DUP:         ; 2271
   .byte 3,"DUP"
   .word NFA__2DROT         ; 2262
_DUP:            ; 2277 - 227D
   pop h           ; $2277 e1
   push h          ; $2278 e5
   push h          ; $2279 e5
   jmp $219a       ; $227a c3 9a 21

NFA__3FDUP:      ; 227D
   .byte 4,"?DUP"
   .word NFA_DUP          ; 2271
__3FDUP:         ; 2284 - 228F
   pop h           ; $2284 e1
   push h          ; $2285 e5
   mov a,h         ; $2286 7c
   ora l           ; $2287 b5
   jz $219a        ; $2288 ca 9a 21
   push h          ; $228b e5
   jmp $219a       ; $228c c3 9a 21

NFA_2DUP:        ; 228F
   .byte 4,"2DUP"
   .word NFA__3FDUP         ; 227D
_2DUP:           ; 2296 - 229F
   pop h           ; $2296 e1
   pop d           ; $2297 d1
   push d          ; $2298 d5
   push h          ; $2299 e5
   push d          ; $229a d5
   push h          ; $229b e5
   jmp $219a       ; $229c c3 9a 21

NFA_2DROP:       ; 229F
   .byte 5,"2DROP"
   .word NFA_2DUP         ; 228F
_2DROP:          ; 22A7 - 22AC
   pop d           ; $22a7 d1
   pop d           ; $22a8 d1
   jmp $219a       ; $22a9 c3 9a 21

NFA_PRESS:       ; 22AC
   .byte 5,"PRESS"
   .word NFA_2DROP        ; 229F
_PRESS:          ; 22B4 - 22B9
   pop h           ; $22b4 e1
   xthl            ; $22b5 e3
   jmp $219a       ; $22b6 c3 9a 21

NFA_2OVER:       ; 22B9
   .byte 5,"2OVER"
   .word NFA_PRESS        ; 22AC
_2OVER:          ; 22C1 - 22D0
   pop d           ; $22c1 d1
   pop d           ; $22c2 d1
   pop d           ; $22c3 d1
   pop h           ; $22c4 e1
   push h          ; $22c5 e5
   push d          ; $22c6 d5
   dcx sp          ; $22c7 3b
   dcx sp          ; $22c8 3b
   dcx sp          ; $22c9 3b
   dcx sp          ; $22ca 3b
   push h          ; $22cb e5
   push d          ; $22cc d5
   jmp $219a       ; $22cd c3 9a 21

NFA_SP_40:       ; 22D0
   .byte 3,"SP@"
   .word NFA_2OVER        ; 22B9
_SP_40:          ; 22D6 - 22DE
   lxi h,$0000     ; $22d6 21 00 00
   dad sp          ; $22d9 39
   push h          ; $22da e5
   jmp $219a       ; $22db c3 9a 21

NFA_SP_21:       ; 22DE
   .byte 3,"SP!"
   .word NFA_SP_40          ; 22D0
_SP_21:          ; 22E4 - 22E9
   pop h           ; $22e4 e1
   sphl            ; $22e5 f9
   jmp $219a       ; $22e6 c3 9a 21

NFA__2B:         ; 22E9
   .byte 1,"+"
   .word NFA_SP_21          ; 22DE
__2B:            ; 22ED - 22F4
   pop h           ; $22ed e1
   pop d           ; $22ee d1
   dad d           ; $22ef 19
   push h          ; $22f0 e5
   jmp $219a       ; $22f1 c3 9a 21

NFA__2D:         ; 22F4
   .byte 1,"-"
   .word NFA__2B            ; 22E9
__2D:            ; 22F8 - 2304
   pop h           ; $22f8 e1
   pop d           ; $22f9 d1
   mov a,e         ; $22fa 7b
   sub l           ; $22fb 95
   mov l,a         ; $22fc 6f
   mov a,d         ; $22fd 7a
   sbb h           ; $22fe 9c
   mov h,a         ; $22ff 67
   push h          ; $2300 e5
   jmp $219a       ; $2301 c3 9a 21

NFA_NEGATE:      ; 2304
   .byte 6,"NEGATE"
   .word NFA__2D            ; 22F4
_NEGATE:         ; 230D - 2315
   pop h
   call $242f      ; $230e cd 2f 24
   push h          ; $2311 e5
   jmp $219a       ; $2312 c3 9a 21

NFA_1_2B:        ; 2315
   .byte 2,"1+"
   .word NFA_NEGATE       ; 2304
_1_2B:           ; 231A - 2320
   pop h           ; $231a e1
   inx h           ; $231b 23
   push h          ; $231c e5
   jmp $219a       ; $231d c3 9a 21

NFA_2_2B:        ; 2320
   .byte 2,"2+"
   .word NFA_1_2B           ; 2315
_2_2B:           ; 2325 - 232C
   pop h           ; $2325 e1
   inx h           ; $2326 23
   inx h           ; $2327 23
   push h          ; $2328 e5
   jmp $219a       ; $2329 c3 9a 21

NFA_1_2D:        ; 232C
   .byte 2,"1-"
   .word NFA_2_2B           ; 2320
_1_2D:           ; 2331 - 2337
   pop h           ; $2331 e1
   dcx h           ; $2332 2b
   push h          ; $2333 e5
   jmp $219a       ; $2334 c3 9a 21

NFA_2_2D:        ; 2337
   .byte 2,"2-"
   .word NFA_1_2D           ; 232C
_2_2D:           ; 233C - 2343
   pop h           ; $233c e1
   dcx h           ; $233d 2b
   dcx h           ; $233e 2b
   push h          ; $233f e5
   jmp $219a       ; $2340 c3 9a 21

NFA_2_2A:        ; 2343
   .byte 2,"2*"
   .word NFA_2_2D           ; 2337
_2_2A:           ; 2348 - 234E
   pop h           ; $2348 e1
   dad h           ; $2349 29
   push h          ; $234a e5
   jmp $219a       ; $234b c3 9a 21

NFA_ABS:         ; 234E
   .byte 3,"ABS"
   .word NFA_2_2A           ; 2343
_ABS:            ; 2354 - 235E
   pop h           ; $2354 e1
   mov a,h         ; $2355 7c
   ora a           ; $2356 b7
   cm $242f        ; $2357 fc 2f 24
   push h          ; $235a e5
   jmp $219a       ; $235b c3 9a 21

NFA_MIN:         ; 235E
   .byte 3,"MIN"
   .word NFA_ABS          ; 234E
_MIN:            ; 2364 - 237B
   pop d           ; $2364 d1
   pop h           ; $2365 e1
   push d          ; $2366 d5
   mov a,h         ; $2367 7c
   xra d           ; $2368 aa
   jp $2370        ; $2369 f2 70 23
   xra d           ; $236c aa
   jmp $2374       ; $236d c3 74 23
   mov a,l         ; $2370 7d
   sub e           ; $2371 93
   mov a,h         ; $2372 7c
   sbb d           ; $2373 9a
   jp $219a        ; $2374 f2 9a 21
   xthl            ; $2377 e3
   jmp $219a       ; $2378 c3 9a 21

NFA_MAX:         ; 237B
   .byte 3,"MAX"
   .word NFA_MIN          ; 235E
_MAX:            ; 2381 - 2398
   pop h           ; $2381 e1
   pop d           ; $2382 d1
   push d          ; $2383 d5
   mov a,h         ; $2384 7c
   xra d           ; $2385 aa
   jp $238d        ; $2386 f2 8d 23
   xra h           ; $2389 ac
   jmp $2391       ; $238a c3 91 23
   mov a,e         ; $238d 7b
   sub l           ; $238e 95
   mov a,d         ; $238f 7a
   sbb h           ; $2390 9c
   jp $219a        ; $2391 f2 9a 21
   xthl            ; $2394 e3
   jmp $219a       ; $2395 c3 9a 21

NFA_U_3C:        ; 2398
   .byte 2,"U<"
   .word NFA_MAX          ; 237B
_U_3C:           ; 239D - 23AE
   pop d           ; $239d d1
   pop h           ; $239e e1
   mov a,l         ; $239f 7d
   sub e           ; $23a0 93
   mov a,h         ; $23a1 7c
   sbb d           ; $23a2 9a
   lxi h,$ffff     ; $23a3 21 ff ff
   jc $23aa        ; $23a6 da aa 23
   inx h           ; $23a9 23
   push h          ; $23aa e5
   jmp $219a       ; $23ab c3 9a 21

NFA__3C:         ; 23AE
   .byte 1,"<"
   .word NFA_U_3C           ; 2398
__3C:            ; 23B2 - 23D2
   pop h           ; $23b2 e1
   pop d           ; $23b3 d1
   mov a,h         ; $23b4 7c
   xra d           ; $23b5 aa
   jp $23c3        ; $23b6 f2 c3 23
   lxi h,$0000     ; $23b9 21 00 00
   xra d           ; $23bc aa
   jm $23ce        ; $23bd fa ce 23
   jmp $23cd       ; $23c0 c3 cd 23
   mov a,e         ; $23c3 7b
   sub l           ; $23c4 95
   mov a,d         ; $23c5 7a
   sbb h           ; $23c6 9c
   lxi h,$0000     ; $23c7 21 00 00
   jp $23ce        ; $23ca f2 ce 23
   dcx h           ; $23cd 2b
   push h          ; $23ce e5
   jmp $219a       ; $23cf c3 9a 21

NFA__3E:         ; 23D2
   .byte 1,">"
   .word NFA__3C            ; 23AE
__3E:            ; 23D6 - 23DB
   pop d           ; $23d6 d1
   pop h           ; $23d7 e1
   jmp $23b4       ; $23d8 c3 b4 23

NFA_0_3C:        ; 23DB
   .byte 2,"0<"
   .word NFA__3E            ; 23D2
_0_3C:           ; 23E0 - 23EE
   pop h
   mov a,h         ; $23e1 7c
   lxi h,$0000     ; $23e2 21 00 00
   ora a           ; $23e5 b7
   jp $23ea        ; $23e6 f2 ea 23
   dcx h           ; $23e9 2b
   push h          ; $23ea e5
   jmp $219a       ; $23eb c3 9a 21

NFA_0_3E:        ; 23EE
   .byte 2,"0>"
   .word NFA_0_3C           ; 23DB
_0_3E:           ; 23F3 - 2405
   pop d           ; $23f3 d1
   lxi h,$0000     ; $23f4 21 00 00
   mov a,d         ; $23f7 7a
   ora a           ; $23f8 b7
   jm $2401        ; $23f9 fa 01 24
   ora e           ; $23fc b3
   jz $2401        ; $23fd ca 01 24
   dcx h           ; $2400 2b
   push h          ; $2401 e5
   jmp $219a       ; $2402 c3 9a 21

NFA__3D:         ; 2405
   .byte 1,"="
   .word NFA_0_3E           ; 23EE
__3D:            ; 2409 - 241C
   pop h           ; $2409 e1
   pop d           ; $240a d1
   mov a,l         ; $240b 7d
   sub e           ; $240c 93
   mov e,a         ; $240d 5f
   mov a,h         ; $240e 7c
   sbb d           ; $240f 9a
   lxi h,$0000     ; $2410 21 00 00
   ora e           ; $2413 b3
   jnz $2418       ; $2414 c2 18 24
   dcx h           ; $2417 2b
   push h          ; $2418 e5
   jmp $219a       ; $2419 c3 9a 21

NFA_0_3D:        ; 241C
   .byte 2,"0="
   .word NFA__3D            ; 2405
_0_3D:           ; 2421 - 2437
   pop h           ; $2421 e1
   mov a,h         ; $2422 7c
   lxi d,$0000     ; $2423 11 00 00
   ora l           ; $2426 b5
   jnz $242b       ; $2427 c2 2b 24
   dcx d           ; $242a 1b
   push d          ; $242b d5
   jmp $219a       ; $242c c3 9a 21
   mov a,h         ; $242f 7c
   cma             ; $2430 2f
   mov h,a         ; $2431 67
   mov a,l         ; $2432 7d
   cma             ; $2433 2f
   mov l,a         ; $2434 6f
   inx h           ; $2435 23
   ret             ; $2436 c9

NFA__2DTRAILING: ; 2437
   .byte 9,"-TRAILING"
   .word NFA_0_3D           ; 241C
__2DTRAILING:    ; 2443 - 245B
   pop d           ; $2443 d1
   mov a,e         ; $2444 7b
   ora a           ; $2445 b7
   jz $2457        ; $2446 ca 57 24
   pop h           ; $2449 e1
   push h          ; $244a e5
   dad d           ; $244b 19
   dcx h           ; $244c 2b
   mov a,m         ; $244d 7e
   cpi $20         ; $244e fe 20
   jnz $2457       ; $2450 c2 57 24
   dcr e           ; $2453 1d
   jnz $244c       ; $2454 c2 4c 24
   push d          ; $2457 d5
   jmp $219a       ; $2458 c3 9a 21

NFA_2_2F:        ; 245B
   .byte 2,"2/"
   .word NFA__2DTRAILING    ; 2437
_2_2F:           ; 2460 - 246D
   pop h           ; $2460 e1
   mov a,h         ; $2461 7c
   add a           ; $2462 87
   mov a,h         ; $2463 7c
   rar             ; $2464 1f
   mov h,a         ; $2465 67
   mov a,l         ; $2466 7d
   rar             ; $2467 1f
   mov l,a         ; $2468 6f
   push h          ; $2469 e5
   jmp $219a       ; $246a c3 9a 21

NFA_D_2B:        ; 246D
   .byte 2,"D+"
   .word NFA_2_2F           ; 245B
_D_2B:           ; 2472 - 2482
   pop d           ; $2472 d1
   pop h           ; $2473 e1
   xthl            ; $2474 e3
   dad d           ; $2475 19
   pop d           ; $2476 d1
   xthl            ; $2477 e3
   dad d           ; $2478 19
   xthl            ; $2479 e3
   jnc $247e       ; $247a d2 7e 24
   inx h           ; $247d 23
   push h          ; $247e e5
   jmp $219a       ; $247f c3 9a 21

NFA_D_3C:        ; 2482
   .byte 2,"D<"
   .word NFA_D_2B           ; 246D
_D_3C:           ; 2487 - 24B9
   pop d           ; $2487 d1
   pop h           ; $2488 e1
   xthl            ; $2489 e3
   mov a,h         ; $248a 7c
   xra d           ; $248b aa
   jp $249b        ; $248c f2 9b 24
   lxi d,$0000     ; $248f 11 00 00
   xra h           ; $2492 ac
   pop h           ; $2493 e1
   pop h           ; $2494 e1
   jm $24b5        ; $2495 fa b5 24
   jmp $24b4       ; $2498 c3 b4 24
   mov a,l         ; $249b 7d
   sub e           ; $249c 93
   mov l,a         ; $249d 6f
   mov a,h         ; $249e 7c
   sbb d           ; $249f 9a
   mov h,a         ; $24a0 67
   pop d           ; $24a1 d1
   xthl            ; $24a2 e3
   mov a,l         ; $24a3 7d
   sub e           ; $24a4 93
   mov a,h         ; $24a5 7c
   sbb d           ; $24a6 9a
   pop h           ; $24a7 e1
   jnc $24ac       ; $24a8 d2 ac 24
   dcx h           ; $24ab 2b
   mov a,h         ; $24ac 7c
   lxi d,$0000     ; $24ad 11 00 00
   ora a           ; $24b0 b7
   jp $24b5        ; $24b1 f2 b5 24
   dcx d           ; $24b4 1b
   push d          ; $24b5 d5
   jmp $219a       ; $24b6 c3 9a 21

NFA_DNEGATE:     ; 24B9
   .byte 7,"DNEGATE"
   .word NFA_D_3C           ; 2482
_DNEGATE:        ; 24C3 - 24D8
   pop h           ; $24c3 e1
   xthl            ; $24c4 e3
   mvi d,$00       ; $24c5 16 00
   mov a,d         ; $24c7 7a
   sub l           ; $24c8 95
   mov l,a         ; $24c9 6f
   mov a,d         ; $24ca 7a
   sbb h           ; $24cb 9c
   mov h,a         ; $24cc 67
   xthl            ; $24cd e3
   mov a,d         ; $24ce 7a
   sbb l           ; $24cf 9d
   mov l,a         ; $24d0 6f
   mov a,d         ; $24d1 7a
   sbb h           ; $24d2 9c
   mov h,a         ; $24d3 67
   push h          ; $24d4 e5
   jmp $219a       ; $24d5 c3 9a 21

NFA__2DTEXT:     ; 24D8
   .byte 5,"-TEXT"
   .word NFA_DNEGATE      ; 24B9
__2DTEXT:        ; 24E0 - 250D
   mov h,b         ; $24e0 60
   mov l,c         ; $24e1 69
   pop d           ; $24e2 d1
   pop b           ; $24e3 c1
   xthl            ; $24e4 e3
   xchg            ; $24e5 eb
   mov a,b         ; $24e6 78
   ora c           ; $24e7 b1
   jz $2500        ; $24e8 ca 00 25
   mov a,c         ; $24eb 79
   ora a           ; $24ec b7
   jz $24f1        ; $24ed ca f1 24
   inr b           ; $24f0 04
   ldax d          ; $24f1 1a
   sub m           ; $24f2 96
   jnz $2500       ; $24f3 c2 00 25
   inx d           ; $24f6 13
   inx h           ; $24f7 23
   dcr c           ; $24f8 0d
   jnz $24f1       ; $24f9 c2 f1 24
   dcr b           ; $24fc 05
   jnz $24f1       ; $24fd c2 f1 24
   mov l,a         ; $2500 6f
   mvi h,$00       ; $2501 26 00
   ora a           ; $2503 b7
   jp $2508        ; $2504 f2 08 25
   dcr h           ; $2507 25
   pop b           ; $2508 c1
   push h          ; $2509 e5
   jmp $219a       ; $250a c3 9a 21

NFA_ROLL:        ; 250D
   .byte 4,"ROLL"
   .word NFA__2DTEXT        ; 24D8
_ROLL:           ; 2514 - 2538
   pop h           ; $2514 e1
   mov a,h         ; $2515 7c
   ora l           ; $2516 b5
   jz $219a        ; $2517 ca 9a 21
   inx h           ; $251a 23
   dad h           ; $251b 29
   push h          ; $251c e5
   dad sp          ; $251d 39
   mov e,m         ; $251e 5e
   inx h           ; $251f 23
   mov d,m         ; $2520 56
   xchg            ; $2521 eb
   xthl            ; $2522 e3
   xchg            ; $2523 eb
   push b          ; $2524 c5
   mov b,h         ; $2525 44
   mov c,l         ; $2526 4d
   dcx b           ; $2527 0b
   dcx b           ; $2528 0b
   ldax b          ; $2529 0a
   mov m,a         ; $252a 77
   dcx h           ; $252b 2b
   dcx b           ; $252c 0b
   dcx d           ; $252d 1b
   mov a,d         ; $252e 7a
   ora e           ; $252f b3
   jnz $2529       ; $2530 c2 29 25
   pop b           ; $2533 c1
   pop h           ; $2534 e1
   jmp $219a       ; $2535 c3 9a 21

NFA__2A:         ; 2538
   .byte 1,"*"
   .word NFA_ROLL         ; 250D
__2A:            ; 253C - 2562
   mov h,b         ; $253c 60
   mov l,c         ; $253d 69
   pop b           ; $253e c1
   pop d           ; $253f d1
   push h          ; $2540 e5
   lxi h,$0000     ; $2541 21 00 00
   mov a,c         ; $2544 79
   mvi c,$08       ; $2545 0e 08
   call $2555      ; $2547 cd 55 25
   mov a,b         ; $254a 78
   mvi c,$08       ; $254b 0e 08
   call $2555      ; $254d cd 55 25
   pop b           ; $2550 c1
   push h          ; $2551 e5
   jmp $219a       ; $2552 c3 9a 21
   rar             ; $2555 1f
   jnc $255a       ; $2556 d2 5a 25
   dad d           ; $2559 19
   xchg            ; $255a eb
   dad h           ; $255b 29
   xchg            ; $255c eb
   dcr c           ; $255d 0d
   jnz $2555       ; $255e c2 55 25
   ret             ; $2561 c9

NFA_UM_2A:       ; 2562
   .byte 3,"UM*"
   .word NFA__2A            ; 2538
_UM_2A:          ; 2568 - 2591
   pop h           ; $2568 e1
   pop d           ; $2569 d1
   push b          ; $256a c5
   mov b,d         ; $256b 42
   mov c,e         ; $256c 4b
   call $2576      ; $256d cd 76 25
   pop b           ; $2570 c1
   push d          ; $2571 d5
   push h          ; $2572 e5
   jmp $219a       ; $2573 c3 9a 21
   xra a           ; $2576 af
   mov d,a         ; $2577 57
   mov e,a         ; $2578 5f
   dad h           ; $2579 29
   rar             ; $257a 1f
   xchg            ; $257b eb
   dad h           ; $257c 29
   jnc $2581       ; $257d d2 81 25
   inx d           ; $2580 13
   ral             ; $2581 17
   jnc $258a       ; $2582 d2 8a 25
   dad b           ; $2585 09
   jnc $258a       ; $2586 d2 8a 25
   inx d           ; $2589 13
   xchg            ; $258a eb
   adi $10         ; $258b c6 10
   jnc $2579       ; $258d d2 79 25
   ret             ; $2590 c9

NFA_DU_2FMOD:    ; 2591
   .byte 6,"DU/MOD"
   .word NFA_UM_2A          ; 2562
_DU_2FMOD:       ; 259A - 2677
   lxi h,$6145     ; $259a 21 45 61
   mvi a,$04       ; $259d 3e 04
   pop d           ; $259f d1
   mov m,d         ; $25a0 72
   inx h           ; $25a1 23
   mov m,e         ; $25a2 73
   inx h           ; $25a3 23
   dcr a           ; $25a4 3d
   jnz $259f       ; $25a5 c2 9f 25
   push b          ; $25a8 c5
   lxi b,$0005     ; $25a9 01 05 00
   lxi h,$613f     ; $25ac 21 3f 61
   mvi e,$0a       ; $25af 1e 0a
   push h          ; $25b1 e5
   call $263d      ; $25b2 cd 3d 26
   dad b           ; $25b5 09
   mov m,a         ; $25b6 77
   call $261d      ; $25b7 cd 1d 26
   inr b           ; $25ba 04
   dcr e           ; $25bb 1d
   jz $260a        ; $25bc ca 0a 26
   ani $f0         ; $25bf e6 f0
   jz $25b7        ; $25c1 ca b7 25
   dcr b           ; $25c4 05
   push b          ; $25c5 c5
   lxi h,$613f     ; $25c6 21 3f 61
   call $261d      ; $25c9 cd 1d 26
   lxi h,$6143     ; $25cc 21 43 61
   lxi d,$6148     ; $25cf 11 48 61
   push d          ; $25d2 d5
   push b          ; $25d3 c5
   call $2633      ; $25d4 cd 33 26
   pop b           ; $25d7 c1
   pop h           ; $25d8 e1
   jc $25ef        ; $25d9 da ef 25
   push b          ; $25dc c5
   lxi d,$614d     ; $25dd 11 4d 61
   dcx h           ; $25e0 2b
   dcx d           ; $25e1 1b
   ldax d          ; $25e2 1a
   sbb m           ; $25e3 9e
   stax d          ; $25e4 12
   dcr c           ; $25e5 0d
   jnz $25e0       ; $25e6 c2 e0 25
   dcx h           ; $25e9 2b
   inr m           ; $25ea 34
   pop b           ; $25eb c1
   jmp $25cc       ; $25ec c3 cc 25
   call $261d      ; $25ef cd 1d 26
   dcr b           ; $25f2 05
   jnz $25c6       ; $25f3 c2 c6 25
   lxi h,$6143     ; $25f6 21 43 61
   call $263d      ; $25f9 cd 3d 26
   pop b           ; $25fc c1
   mvi a,$0c       ; $25fd 3e 0c
   mvi c,$0a       ; $25ff 0e 0a
   sub b           ; $2601 90
   mov b,a         ; $2602 47
   call $261d      ; $2603 cd 1d 26
   dcr b           ; $2606 05
   jnz $2603       ; $2607 c2 03 26
   pop h           ; $260a e1
   lxi h,$6146     ; $260b 21 46 61
   pop b           ; $260e c1
   mvi a,$04       ; $260f 3e 04
   mov e,m         ; $2611 5e
   dcx h           ; $2612 2b
   mov d,m         ; $2613 56
   dcx h           ; $2614 2b
   push d          ; $2615 d5
   dcr a           ; $2616 3d
   jnz $2611       ; $2617 c2 11 26
   jmp $219a       ; $261a c3 9a 21
   push b          ; $261d c5
   mvi b,$04       ; $261e 06 04
   push b          ; $2620 c5
   xra a           ; $2621 af
   mov b,a         ; $2622 47
   dad b           ; $2623 09
   dcx h           ; $2624 2b
   mov a,m         ; $2625 7e
   adc a           ; $2626 8f
   mov m,a         ; $2627 77
   dcr c           ; $2628 0d
   jnz $2624       ; $2629 c2 24 26
   pop b           ; $262c c1
   dcr b           ; $262d 05
   jnz $2620       ; $262e c2 20 26
   pop b           ; $2631 c1
   ret             ; $2632 c9
   ldax d          ; $2633 1a
   cmp m           ; $2634 be
   inx h           ; $2635 23
   inx d           ; $2636 13
   rnz             ; $2637 c0
   dcr c           ; $2638 0d
   jnz $2633       ; $2639 c2 33 26
   ret             ; $263c c9
   xra a           ; $263d af
   push h          ; $263e e5
   push b          ; $263f c5
   mov m,a         ; $2640 77
   inx h           ; $2641 23
   dcr c           ; $2642 0d
   jnz $2640       ; $2643 c2 40 26
   pop b           ; $2646 c1
   pop h           ; $2647 e1
   ret             ; $2648 c9
   mov a,h         ; $2649 7c
   ora l           ; $264a b5
   rz              ; $264b c8
   lxi b,$0000     ; $264c 01 00 00
   push b          ; $264f c5
   mov a,e         ; $2650 7b
   sub l           ; $2651 95
   mov a,d         ; $2652 7a
   sbb h           ; $2653 9c
   jc $265c        ; $2654 da 5c 26
   push h          ; $2657 e5
   dad h           ; $2658 29
   jnc $2650       ; $2659 d2 50 26
   lxi h,$0000     ; $265c 21 00 00
   pop b           ; $265f c1
   mov a,b         ; $2660 78
   ora c           ; $2661 b1
   rz              ; $2662 c8
   dad h           ; $2663 29
   push d          ; $2664 d5
   mov a,e         ; $2665 7b
   sub c           ; $2666 91
   mov e,a         ; $2667 5f
   mov a,d         ; $2668 7a
   sbb b           ; $2669 98
   mov d,a         ; $266a 57
   jc $2673        ; $266b da 73 26
   inx h           ; $266e 23
   pop b           ; $266f c1
   jmp $265f       ; $2670 c3 5f 26
   pop d           ; $2673 d1
   jmp $265f       ; $2674 c3 5f 26

NFA__2FMOD:      ; 2677
   .byte 4,"/MOD"
   .word NFA_DU_2FMOD       ; 2591
__2FMOD:         ; 267E - 26BF
   pop h           ; $267e e1
   pop d           ; $267f d1
   push b          ; $2680 c5
   mov a,h         ; $2681 7c
   xra d           ; $2682 aa
   mov a,h         ; $2683 7c
   push psw        ; $2684 f5
   ora a           ; $2685 b7
   cm $242f        ; $2686 fc 2f 24
   push h          ; $2689 e5
   mov a,d         ; $268a 7a
   ora a           ; $268b b7
   xchg            ; $268c eb
   cm $242f        ; $268d fc 2f 24
   xchg            ; $2690 eb
   call $2649      ; $2691 cd 49 26
   pop b           ; $2694 c1
   mov a,d         ; $2695 7a
   ora e           ; $2696 b3
   jnz $26a4       ; $2697 c2 a4 26
   pop psw         ; $269a f1
   cm $242f        ; $269b fc 2f 24
   pop b           ; $269e c1
   push d          ; $269f d5
   push h          ; $26a0 e5
   jmp $219a       ; $26a1 c3 9a 21
   pop psw         ; $26a4 f1
   push psw        ; $26a5 f5
   jp $26b3        ; $26a6 f2 b3 26
   inx h           ; $26a9 23
   call $242f      ; $26aa cd 2f 24
   mov a,c         ; $26ad 79
   sub e           ; $26ae 93
   mov e,a         ; $26af 5f
   mov a,b         ; $26b0 78
   sbb d           ; $26b1 9a
   mov d,a         ; $26b2 57
   pop psw         ; $26b3 f1
   ora a           ; $26b4 b7
   xchg            ; $26b5 eb
   cm $242f        ; $26b6 fc 2f 24
   pop b           ; $26b9 c1
   push h          ; $26ba e5
   push d          ; $26bb d5
   jmp $219a       ; $26bc c3 9a 21

NFA_U_2FMOD:     ; 26BF
   .byte 5,"U/MOD"
   .word NFA__2FMOD         ; 2677
_U_2FMOD:        ; 26C7 - 26D3
   pop h           ; $26c7 e1
   pop d           ; $26c8 d1
   push b          ; $26c9 c5
   call $2649      ; $26ca cd 49 26
   pop b           ; $26cd c1
   push d          ; $26ce d5
   push h          ; $26cf e5
   jmp $219a       ; $26d0 c3 9a 21

NFA__3FWORD:     ; 26D3
   .byte 5,"?WORD"
   .word NFA_U_2FMOD        ; 26BF
__3FWORD:        ; 26DB - 2727
   pop h           ; $26db e1
   pop d           ; $26dc d1
   push b          ; $26dd c5
   push d          ; $26de d5
   mvi b,$00       ; $26df 06 00
   shld $6026      ; $26e1 22 26 60
   mov e,m         ; $26e4 5e
   inx h           ; $26e5 23
   mov d,m         ; $26e6 56
   xchg            ; $26e7 eb
   mov a,h         ; $26e8 7c
   ora l           ; $26e9 b5
   jz $271d        ; $26ea ca 1d 27
   pop d           ; $26ed d1
   push d          ; $26ee d5
   push h          ; $26ef e5
   mov a,m         ; $26f0 7e
   ani $7f         ; $26f1 e6 7f
   mov c,a         ; $26f3 4f
   ldax d          ; $26f4 1a
   cmp c           ; $26f5 b9
   jnz $2713       ; $26f6 c2 13 27
   ora c           ; $26f9 b1
   jz $2708        ; $26fa ca 08 27
   inx h           ; $26fd 23
   inx d           ; $26fe 13
   ldax d          ; $26ff 1a
   cmp m           ; $2700 be
   jnz $2718       ; $2701 c2 18 27
   dcr c           ; $2704 0d
   jnz $26fd       ; $2705 c2 fd 26
   pop h           ; $2708 e1
   pop d           ; $2709 d1
   pop b           ; $270a c1
   push h          ; $270b e5
   lxi h,$ffff     ; $270c 21 ff ff
   push h          ; $270f e5
   jmp $219a       ; $2710 c3 9a 21
   mov a,c         ; $2713 79
   ani $3f         ; $2714 e6 3f
   mov c,a         ; $2716 4f
   inx b           ; $2717 03
   dad b           ; $2718 09
   pop d           ; $2719 d1
   jmp $26e1       ; $271a c3 e1 26
   pop d           ; $271d d1
   pop b           ; $271e c1
   push d          ; $271f d5
   lxi h,$0000     ; $2720 21 00 00
   push h          ; $2723 e5
   jmp $219a       ; $2724 c3 9a 21

NFA_DIGIT:       ; 2727
   .byte 5,"DIGIT"
   .word NFA__3FWORD        ; 26D3
_DIGIT:          ; 272F - 275E
   pop d           ; $272f d1
   pop h           ; $2730 e1
   mov a,l         ; $2731 7d
   cpi $30         ; $2732 fe 30
   jm $2757        ; $2734 fa 57 27
   cpi $3a         ; $2737 fe 3a
   jp $274b        ; $2739 f2 4b 27
   sui $30         ; $273c d6 30
   cmp e           ; $273e bb
   jp $2757        ; $273f f2 57 27
   mov l,a         ; $2742 6f
   push h          ; $2743 e5
   lxi h,$ffff     ; $2744 21 ff ff
   push h          ; $2747 e5
   jmp $219a       ; $2748 c3 9a 21
   cpi $41         ; $274b fe 41
   jm $2757        ; $274d fa 57 27
   sui $41         ; $2750 d6 41
   adi $0a         ; $2752 c6 0a
   jmp $273e       ; $2754 c3 3e 27
   lxi h,$0000     ; $2757 21 00 00
   push h          ; $275a e5
   jmp $219a       ; $275b c3 9a 21

NFA_AND:         ; 275E
   .byte 3,"AND"
   .word NFA_DIGIT        ; 2727
_AND:            ; 2764 - 2770
   pop h           ; $2764 e1
   pop d           ; $2765 d1
   mov a,e         ; $2766 7b
   ana l           ; $2767 a5
   mov l,a         ; $2768 6f
   mov a,d         ; $2769 7a
   ana h           ; $276a a4
   mov h,a         ; $276b 67
   push h          ; $276c e5
   jmp $219a       ; $276d c3 9a 21

NFA_OR:          ; 2770
   .byte 2,"OR"
   .word NFA_AND          ; 275E
_OR:             ; 2775 - 2781
   pop h           ; $2775 e1
   pop d           ; $2776 d1
   mov a,e         ; $2777 7b
   ora l           ; $2778 b5
   mov l,a         ; $2779 6f
   mov a,d         ; $277a 7a
   ora h           ; $277b b4
   mov h,a         ; $277c 67
   push h          ; $277d e5
   jmp $219a       ; $277e c3 9a 21

NFA_XOR:         ; 2781
   .byte 3,"XOR"
   .word NFA_OR           ; 2770
_XOR:            ; 2787 - 2793
   pop h           ; $2787 e1
   pop d           ; $2788 d1
   mov a,e         ; $2789 7b
   xra l           ; $278a ad
   mov l,a         ; $278b 6f
   mov a,d         ; $278c 7a
   xra h           ; $278d ac
   mov h,a         ; $278e 67
   push h          ; $278f e5
   jmp $219a       ; $2790 c3 9a 21

NFA_NOT:         ; 2793
   .byte 3,"NOT"
   .word NFA_XOR          ; 2781
_NOT:            ; 2799 - 27A4
   pop h           ; $2799 e1
   mov a,h         ; $279a 7c
   cma             ; $279b 2f
   mov h,a         ; $279c 67
   mov a,l         ; $279d 7d
   cma             ; $279e 2f
   mov l,a         ; $279f 6f
   push h          ; $27a0 e5
   jmp $219a       ; $27a1 c3 9a 21

NFA__3ER:        ; 27A4
   .byte 2,">R"
   .word NFA_NOT          ; 2793
__3ER:           ; 27A9 - 27B7
   pop d           ; $27a9 d1
   lhld $601a      ; $27aa 2a 1a 60
   dcx h           ; $27ad 2b
   mov m,d         ; $27ae 72
   dcx h           ; $27af 2b
   mov m,e         ; $27b0 73
   shld $601a      ; $27b1 22 1a 60
   jmp $219a       ; $27b4 c3 9a 21

NFA_R_3E:        ; 27B7
   .byte 2,"R>"
   .word NFA__3ER           ; 27A4
_R_3E:           ; 27BC - 27CA
   lhld $601a      ; $27bc 2a 1a 60
   mov e,m         ; $27bf 5e
   inx h           ; $27c0 23
   mov d,m         ; $27c1 56
   inx h           ; $27c2 23
   push d          ; $27c3 d5
   shld $601a      ; $27c4 22 1a 60
   jmp $219a       ; $27c7 c3 9a 21

NFA_R_40:        ; 27CA
   .byte 2,"R@"
   .word NFA_R_3E           ; 27B7
_R_40:           ; 27CF - 27D9
   lhld $601a      ; $27cf 2a 1a 60
   mov e,m         ; $27d2 5e
   inx h           ; $27d3 23
   mov d,m         ; $27d4 56
   push d          ; $27d5 d5
   jmp $219a       ; $27d6 c3 9a 21

NFA_RP_40:       ; 27D9
   .byte 3,"RP@"
   .word NFA_R_40           ; 27CA
_RP_40:          ; 27DF - 27E6
   lhld $601a      ; $27df 2a 1a 60
   push h          ; $27e2 e5
   jmp $219a       ; $27e3 c3 9a 21

NFA_RP_21:       ; 27E6
   .byte 3,"RP!"
   .word NFA_RP_40          ; 27D9
_RP_21:          ; 27EC - 27F3
   pop h           ; $27ec e1
   shld $601a      ; $27ed 22 1a 60
   jmp $219a       ; $27f0 c3 9a 21

NFA_RPICK:       ; 27F3
   .byte 5,"RPICK"
   .word NFA_RP_21          ; 27E6
_RPICK:          ; 27FB - 2809
   pop h           ; $27fb e1
   dad h           ; $27fc 29
   xchg            ; $27fd eb
   lhld $601a      ; $27fe 2a 1a 60
   dad d           ; $2801 19
   mov e,m         ; $2802 5e
   inx h           ; $2803 23
   mov d,m         ; $2804 56
   push d          ; $2805 d5
   jmp $219a       ; $2806 c3 9a 21

NFA_RDROP:       ; 2809
   .byte 5,"RDROP"
   .word NFA_RPICK        ; 27F3
_RDROP:          ; 2811 - 281C
   lhld $601a      ; $2811 2a 1a 60
   inx h           ; $2814 23
   inx h           ; $2815 23
   shld $601a      ; $2816 22 1a 60
   jmp $219a       ; $2819 c3 9a 21

NFA__40:         ; 281C
   .byte 1,"@"
   .word NFA_RDROP        ; 2809
__40:            ; 2820 - 2828
   pop h           ; $2820 e1
   mov e,m         ; $2821 5e
   inx h           ; $2822 23
   mov d,m         ; $2823 56
   push d          ; $2824 d5
   jmp $219a       ; $2825 c3 9a 21

NFA_C_40:        ; 2828
   .byte 2,"C@"
   .word NFA__40            ; 281C
_C_40:           ; 282D - 2835
   pop h           ; $282d e1
   mov e,m         ; $282e 5e
   mvi d,$00       ; $282f 16 00
   push d          ; $2831 d5
   jmp $219a       ; $2832 c3 9a 21

NFA__21:         ; 2835
   .byte 1,"!"
   .word NFA_C_40           ; 2828
__21:            ; 2839 - 2841
   pop h           ; $2839 e1
   pop d           ; $283a d1
   mov m,e         ; $283b 73
   inx h           ; $283c 23
   mov m,d         ; $283d 72
   jmp $219a       ; $283e c3 9a 21

NFA_C_21:        ; 2841
   .byte 2,"C!"
   .word NFA__21            ; 2835
_C_21:           ; 2846 - 284C
   pop h           ; $2846 e1
   pop d           ; $2847 d1
   mov m,e         ; $2848 73
   jmp $219a       ; $2849 c3 9a 21

NFA_2_21:        ; 284C
   .byte 2,"2!"
   .word NFA_C_21           ; 2841
_2_21:           ; 2851 - 285E
   pop h           ; $2851 e1
   pop d           ; $2852 d1
   mov m,e         ; $2853 73
   inx h           ; $2854 23
   mov m,d         ; $2855 72
   inx h           ; $2856 23
   pop d           ; $2857 d1
   mov m,e         ; $2858 73
   inx h           ; $2859 23
   mov m,d         ; $285a 72
   jmp $219a       ; $285b c3 9a 21

NFA_2_40:        ; 285E
   .byte 2,"2@"
   .word NFA_2_21           ; 284C
_2_40:           ; 2863 - 2871
   pop h           ; $2863 e1
   mov e,m         ; $2864 5e
   inx h           ; $2865 23
   mov d,m         ; $2866 56
   inx h           ; $2867 23
   mov a,m         ; $2868 7e
   inx h           ; $2869 23
   mov h,m         ; $286a 66
   mov l,a         ; $286b 6f
   push h          ; $286c e5
   push d          ; $286d d5
   jmp $219a       ; $286e c3 9a 21

NFA__2B_21:      ; 2871
   .byte 2,"+!"
   .word NFA_2_40           ; 285E
__2B_21:         ; 2876 - 2882
   pop h           ; $2876 e1
   pop d           ; $2877 d1
   mov a,m         ; $2878 7e
   add e           ; $2879 83
   mov m,a         ; $287a 77
   inx h           ; $287b 23
   mov a,m         ; $287c 7e
   adc d           ; $287d 8a
   mov m,a         ; $287e 77
   jmp $219a       ; $287f c3 9a 21

NFA__2D_21:      ; 2882
   .byte 2,"-!"
   .word NFA__2B_21           ; 2871
__2D_21:         ; 2887 - 2893
   pop h           ; $2887 e1
   pop d           ; $2888 d1
   mov a,m         ; $2889 7e
   sub e           ; $288a 93
   mov m,a         ; $288b 77
   inx h           ; $288c 23
   mov a,m         ; $288d 7e
   sbb d           ; $288e 9a
   mov m,a         ; $288f 77
   jmp $219a       ; $2890 c3 9a 21

NFA_0_21:        ; 2893
   .byte 2,"0!"
   .word NFA__2D_21           ; 2882
_0_21:           ; 2898 - 28A0
   sub a           ; $2898 97
   pop h           ; $2899 e1
   mov m,a         ; $289a 77
   inx h           ; $289b 23
   mov m,a         ; $289c 77
   jmp $219a       ; $289d c3 9a 21

NFA_1_2B_21:     ; 28A0
   .byte 3,"1+!"
   .word NFA_0_21           ; 2893
_1_2B_21:        ; 28A6 - 28B0
   pop h           ; $28a6 e1
   inr m           ; $28a7 34
   jnz $219a       ; $28a8 c2 9a 21
   inx h           ; $28ab 23
   inr m           ; $28ac 34
   jmp $219a       ; $28ad c3 9a 21

NFA_1_2D_21:     ; 28B0
   .byte 3,"1-!"
   .word NFA_1_2B_21          ; 28A0
_1_2D_21:        ; 28B6 - 28C1
   pop h           ; $28b6 e1
   mov e,m         ; $28b7 5e
   inx h           ; $28b8 23
   mov d,m         ; $28b9 56
   dcx d           ; $28ba 1b
   mov m,d         ; $28bb 72
   dcx h           ; $28bc 2b
   mov m,e         ; $28bd 73
   jmp $219a       ; $28be c3 9a 21

NFA_LIT:         ; 28C1
   .byte 3,"LIT"
   .word NFA_1_2D_21          ; 28B0
_LIT:            ; 28C7 - 28D1
   ldax b          ; $28c7 0a
   mov l,a         ; $28c8 6f
   inx b           ; $28c9 03
   ldax b          ; $28ca 0a
   mov h,a         ; $28cb 67
   inx b           ; $28cc 03
   push h          ; $28cd e5
   jmp $219a       ; $28ce c3 9a 21

NFA_DLIT:        ; 28D1
   .byte 4,"DLIT"
   .word NFA_LIT          ; 28C1
_DLIT:           ; 28D8 - 28E9
   ldax b          ; $28d8 0a
   mov e,a         ; $28d9 5f
   inx b           ; $28da 03
   ldax b          ; $28db 0a
   mov d,a         ; $28dc 57
   inx b           ; $28dd 03
   ldax b          ; $28de 0a
   mov l,a         ; $28df 6f
   inx b           ; $28e0 03
   ldax b          ; $28e1 0a
   mov h,a         ; $28e2 67
   inx b           ; $28e3 03
   push h          ; $28e4 e5
   push d          ; $28e5 d5
   jmp $219a       ; $28e6 c3 9a 21

NFA__28_22_29:   ; 28E9
   .byte 3,"(\")"
   .word NFA_DLIT         ; 28D1
__28_22_29:      ; 28EF - 28FB
   push b          ; $28ef c5
   ldax b          ; $28f0 0a
   mov l,a         ; $28f1 6f
   mvi h,$00       ; $28f2 26 00
   inx h           ; $28f4 23
   dad b           ; $28f5 09
   mov b,h         ; $28f6 44
   mov c,l         ; $28f7 4d
   jmp $219a       ; $28f8 c3 9a 21

NFA_BRANCH:      ; 28FB
   .byte 6,"BRANCH"
   .word NFA__28_22_29          ; 28E9
_BRANCH:         ; 2904 - 290C
   mov h,b         ; $2904 60
   mov l,c         ; $2905 69
   mov c,m         ; $2906 4e
   inx h           ; $2907 23
   mov b,m         ; $2908 46
   jmp $219a       ; $2909 c3 9a 21

NFA__3FBRANCH:   ; 290C
   .byte 7,"?BRANCH"
   .word NFA_BRANCH       ; 28FB
__3FBRANCH:      ; 2916 - 2929
   pop d           ; $2916 d1
   mov a,d         ; $2917 7a
   ora e           ; $2918 b3
   jnz $2924       ; $2919 c2 24 29
   mov h,b         ; $291c 60
   mov l,c         ; $291d 69
   mov c,m         ; $291e 4e
   inx h           ; $291f 23
   mov b,m         ; $2920 46
   jmp $219a       ; $2921 c3 9a 21
   inx b           ; $2924 03
   inx b           ; $2925 03
   jmp $219a       ; $2926 c3 9a 21

NFA_N_3FBRANCH:  ; 2929
   .byte 8,"N?BRANCH"
   .word NFA__3FBRANCH      ; 290C
_N_3FBRANCH:     ; 2934 - 2947
   pop d           ; $2934 d1
   mov a,d         ; $2935 7a
   ora e           ; $2936 b3
   jnz $293f       ; $2937 c2 3f 29
   inx b           ; $293a 03
   inx b           ; $293b 03
   jmp $219a       ; $293c c3 9a 21
   mov h,b         ; $293f 60
   mov l,c         ; $2940 69
   mov c,m         ; $2941 4e 
   inx h           ; $2942 23
   mov b,m         ; $2943 46
   jmp $219a       ; $2944 c3 9a 21

NFA_I:           ; 2947
   .byte 1,"I"
   .word NFA_N_3FBRANCH     ; 2929
_I:              ; 294B - 2955
   lhld $601a      ; $294b 2a 1a 60
   mov e,m         ; $294e 5e
   inx h           ; $294f 23
   mov d,m         ; $2950 56
   push d          ; $2951 d5
   jmp $219a       ; $2952 c3 9a 21

NFA_J:           ; 2955
   .byte 1,"J"
   .word NFA_I            ; 2947
_J:              ; 2959 - 2967
   lhld $601a      ; $2959 2a 1a 60
   lxi d,$0006     ; $295c 11 06 00
   dad d           ; $295f 19
   mov e,m         ; $2960 5e
   inx h           ; $2961 23
   mov d,m         ; $2962 56
   push d          ; $2963 d5
   jmp $219a       ; $2964 c3 9a 21

NFA_K:           ; 2967
   .byte 1,"K"
   .word NFA_J            ; 2955
_K:              ; 296B - 2979
   lhld $601a      ; $296b 2a 1a 60
   lxi d,$000c     ; $296e 11 0c 00
   dad d           ; $2971 19
   mov e,m         ; $2972 5e
   inx h           ; $2973 23
   mov d,m         ; $2974 56
   push d          ; $2975 d5
   jmp $219a       ; $2976 c3 9a 21

NFA_TOGGLE:      ; 2979
   .byte 6,"TOGGLE"
   .word NFA_K            ; 2967
_TOGGLE:         ; 2982 - 298A
   pop d           ; $2982 d1
   mov a,e         ; $2983 7b
   pop h           ; $2984 e1
   xra m           ; $2985 ae
   mov m,a         ; $2986 77
   jmp $219a       ; $2987 c3 9a 21

NFA__28DO_29:    ; 298A
   .byte 4,"(DO)"
   .word NFA_TOGGLE       ; 2979
__28DO_29:       ; 2991 - 29B0
   pop h           ; $2991 e1
   xthl            ; $2992 e3
   push h          ; $2993 e5
   lhld $601a      ; $2994 2a 1a 60
   ldax b          ; $2997 0a
   mov d,a         ; $2998 57
   inx b           ; $2999 03
   ldax b          ; $299a 0a
   inx b           ; $299b 03
   dcx h           ; $299c 2b
   mov m,a         ; $299d 77
   dcx h           ; $299e 2b
   mov m,d         ; $299f 72
   pop d           ; $29a0 d1
   dcx h           ; $29a1 2b
   mov m,d         ; $29a2 72
   dcx h           ; $29a3 2b
   mov m,e         ; $29a4 73
   pop d           ; $29a5 d1
   dcx h           ; $29a6 2b
   mov m,d         ; $29a7 72
   dcx h           ; $29a8 2b
   mov m,e         ; $29a9 73
   shld $601a      ; $29aa 22 1a 60
   jmp $219a       ; $29ad c3 9a 21

NFA__28_3FDO_29: ; 29B0
   .byte 5,"(?DO)"
   .word NFA__28DO_29         ; 298A
__28_3FDO_29:    ; 29B8 - 29D1
   pop h           ; $29b8 e1
   pop d           ; $29b9 d1
   push d          ; $29ba d5
   push h          ; $29bb e5
   mov a,l         ; $29bc 7d
   cmp e           ; $29bd bb
   jnz $2991       ; $29be c2 91 29
   mov a,h         ; $29c1 7c
   cmp d           ; $29c2 ba
   jnz $2991       ; $29c3 c2 91 29
   ldax b          ; $29c6 0a
   mov d,a         ; $29c7 57
   inx b           ; $29c8 03
   ldax b          ; $29c9 0a
   mov b,a         ; $29ca 47
   mov c,d         ; $29cb 4a
   pop h           ; $29cc e1
   pop h           ; $29cd e1
   jmp $219a       ; $29ce c3 9a 21

NFA__28LOOP_29:  ; 29D1
   .byte 6,"(LOOP)"
   .word NFA__28_3FDO_29        ; 29B0
__28LOOP_29:     ; 29DA - 2A05
   lhld $601a      ; $29da 2a 1a 60
   mov e,m         ; $29dd 5e
   inx h           ; $29de 23
   mov d,m         ; $29df 56
   inx h           ; $29e0 23
   inx d           ; $29e1 13
   mov a,m         ; $29e2 7e
   inx h           ; $29e3 23
   cmp e           ; $29e4 bb
   jnz $29f8       ; $29e5 c2 f8 29
   mov a,m         ; $29e8 7e
   cmp d           ; $29e9 ba
   jnz $29f8       ; $29ea c2 f8 29
   inx h           ; $29ed 23
   inx h           ; $29ee 23
   inx h           ; $29ef 23
   shld $601a      ; $29f0 22 1a 60
   inx b           ; $29f3 03
   inx b           ; $29f4 03
   jmp $219a       ; $29f5 c3 9a 21
   dcx h           ; $29f8 2b
   dcx h           ; $29f9 2b
   mov m,d         ; $29fa 72
   dcx h           ; $29fb 2b
   mov m,e         ; $29fc 73
   mov h,b         ; $29fd 60
   mov l,c         ; $29fe 69
   mov c,m         ; $29ff 4e
   inx h           ; $2a00 23
   mov b,m         ; $2a01 46
   jmp $219a       ; $2a02 c3 9a 21

NFA__28_2BLOOP_29:; 2A05
   .byte 7,"(+LOOP)"
   .word NFA__28LOOP_29       ; 29D1
__28_2BLOOP_29:  ; 2A0F - 2A20
   pop h           ; $2a0f e1
   push b          ; $2a10 c5
   xchg            ; $2a11 eb
   lhld $601a      ; $2a12 2a 1a 60
   mov c,m         ; $2a15 4e
   inx h           ; $2a16 23
   mov b,m         ; $2a17 46
   inx h           ; $2a18 23
   xchg            ; $2a19 eb
   dad b           ; $2a1a 09
   xchg            ; $2a1b eb
   pop b           ; $2a1c c1
   jmp $29e2       ; $2a1d c3 e2 29

NFA_CMOVE:       ; 2A20
   .byte 5,"CMOVE"
   .word NFA__28_2BLOOP_29      ; 2A05
_CMOVE:          ; 2A28 - 2A48
   mov h,b         ; $2a28 60
   mov l,c         ; $2a29 69
   pop b           ; $2a2a c1
   pop d           ; $2a2b d1
   xthl            ; $2a2c e3
   mov a,c         ; $2a2d 79
   ora b           ; $2a2e b0
   jz $2a44        ; $2a2f ca 44 2a
   mov a,c         ; $2a32 79
   ora a           ; $2a33 b7
   jz $2a38        ; $2a34 ca 38 2a
   inr b           ; $2a37 04
   mov a,m         ; $2a38 7e
   stax d          ; $2a39 12
   inx h           ; $2a3a 23
   inx d           ; $2a3b 13
   dcr c           ; $2a3c 0d
   jnz $2a38       ; $2a3d c2 38 2a
   dcr b           ; $2a40 05
   jnz $2a38       ; $2a41 c2 38 2a
   pop b           ; $2a44 c1
   jmp $219a       ; $2a45 c3 9a 21

NFA_CMOVE_3E:    ; 2A48
   .byte 6,"CMOVE>"
   .word NFA_CMOVE        ; 2A20
_CMOVE_3E:       ; 2A51 - 2A78
   mov h,b         ; $2a51 60
   mov l,c         ; $2a52 69
   pop b           ; $2a53 c1
   pop d           ; $2a54 d1
   xthl            ; $2a55 e3
   mov a,c         ; $2a56 79
   ora b           ; $2a57 b0
   jz $2a74        ; $2a58 ca 74 2a
   dad b           ; $2a5b 09
   xchg            ; $2a5c eb
   dad b           ; $2a5d 09
   mov a,c         ; $2a5e 79
   ora a           ; $2a5f b7
   jz $2a64        ; $2a60 ca 64 2a
   inr b           ; $2a63 04
   dcx h           ; $2a64 2b
   dcx d           ; $2a65 1b
   ldax d          ; $2a66 1a
   mov m,a         ; $2a67 77
   dcr c           ; $2a68 0d
   jnz $2a64       ; $2a69 c2 64 2a
   dcr b           ; $2a6c 05
   jnz $2a64       ; $2a6d c2 64 2a
   pop b           ; $2a70 c1
   jmp $219a       ; $2a71 c3 9a 21
   pop b           ; $2a74 c1
   jmp $219a       ; $2a75 c3 9a 21

NFA__3CCMOVE_3E: ; 2A78
   .byte 7,"<CMOVE>"
   .word NFA_CMOVE_3E       ; 2A48
__3CCMOVE_3E:    ; 2A82 - 2A9A
   mov h,b         ; $2a82 60
   mov l,c         ; $2a83 69
   pop b           ; $2a84 c1
   pop d           ; $2a85 d1
   xthl            ; $2a86 e3
   mov a,c         ; $2a87 79
   ora b           ; $2a88 b0
   jz $2a96        ; $2a89 ca 96 2a
   mov a,l         ; $2a8c 7d
   sub e           ; $2a8d 93
   mov a,h         ; $2a8e 7c
   sbb d           ; $2a8f 9a
   jnc $2a32       ; $2a90 d2 32 2a
   jmp $2a5b       ; $2a93 c3 5b 2a
   pop b           ; $2a96 c1
   jmp $219a       ; $2a97 c3 9a 21

NFA_FILL:        ; 2A9A
   .byte 4,"FILL"
   .word NFA__3CCMOVE_3E      ; 2A78
_FILL:           ; 2AA1 - 2ABD
   pop d
   pop h
   mov a,h         ; $2aa3 7c
   ora l           ; $2aa4 b5
   jnz $2aac       ; $2aa5 c2 ac 2a
   pop h           ; $2aa8 e1
   jmp $219a       ; $2aa9 c3 9a 21
   mov a,e         ; $2aac 7b
   pop d           ; $2aad d1
   dcx h           ; $2aae 2b
   push b          ; $2aaf c5
   lxi b,$ffff     ; $2ab0 01 ff ff
   stax d          ; $2ab3 12
   inx d           ; $2ab4 13
   dad b           ; $2ab5 09
   jc $2ab3        ; $2ab6 da b3 2a
   pop b           ; $2ab9 c1
   jmp $219a       ; $2aba c3 9a 21

NFA_0_3EBL:      ; 2ABD
   .byte 4,"0>BL"
   .word NFA_FILL         ; 2A9A
_0_3EBL:         ; 2AC4 - 2AD5
   pop d
   pop h
   mov a,m         ; $2ac6 7e
   ora a           ; $2ac7 b7
   jnz $2acd       ; $2ac8 c2 cd 2a
   mvi m,$20       ; $2acb 36 20
   inx h           ; $2acd 23
   dcr e           ; $2ace 1d
   jnz $2ac6       ; $2acf c2 c6 2a
   jmp $219a       ; $2ad2 c3 9a 21

NFA_ENCLOSE:     ; 2AD5
   .byte 7,"ENCLOSE"
   .word NFA_0_3EBL         ; 2ABD
_ENCLOSE:        ; 2ADF - 2B1D
   mov h,b         ; $2adf 60
   mov l,c         ; $2ae0 69
   pop b           ; $2ae1 c1
   pop d           ; $2ae2 d1
   xthl            ; $2ae3 e3
   xchg            ; $2ae4 eb
   dcx b           ; $2ae5 0b
   mov a,b         ; $2ae6 78
   ora a           ; $2ae7 b7
   jm $2b15        ; $2ae8 fa 15 2b
   mov a,m         ; $2aeb 7e 
   cmp e           ; $2aec bb
   dcx b           ; $2aed 0b
   inx h           ; $2aee 23
   jz $2ae6        ; $2aef ca e6 2a
   push h          ; $2af2 e5
   mov a,b         ; $2af3 78
   ora a           ; $2af4 b7
   jm $2b00        ; $2af5 fa 00 2b
   mov a,m         ; $2af8 7e
   cmp e           ; $2af9 bb
   dcx b           ; $2afa 0b
   inx h           ; $2afb 23
   jnz $2af3       ; $2afc c2 f3 2a
   dcx h           ; $2aff 2b
   pop d           ; $2b00 d1
   dcx d           ; $2b01 1b
   pop b           ; $2b02 c1
   push d          ; $2b03 d5
   push h          ; $2b04 e5
   mov a,l         ; $2b05 7d
   sub e           ; $2b06 93
   mov l,a         ; $2b07 6f
   mov a,h         ; $2b08 7c
   sbb d           ; $2b09 9a
   mov h,a         ; $2b0a 67
   xthl            ; $2b0b e3
   inx h           ; $2b0c 23
   push h          ; $2b0d e5
   lxi h,$ffff     ; $2b0e 21 ff ff
   push h          ; $2b11 e5
   jmp $219a       ; $2b12 c3 9a 21
   pop b           ; $2b15 c1
   lxi h,$0000     ; $2b16 21 00 00
   push h          ; $2b19 e5
   jmp $219a       ; $2b1a c3 9a 21

NFA__2D1:        ; 2B1D
   .byte 2,"-1"
   .word NFA_ENCLOSE      ; 2AD5
__2D1:           ; 2B22 - 2B27
   call __40     ; 2B22
   .word $FFFF   ; 2B25

NFA_0:           ; 2B27
   .byte 1,"0"
   .word NFA__2D1           ; 2B1D
_0:              ; 2B2B - 2B30
   call __40     ; 2B2B
   .word $0000   ; 2B2E

NFA_1:           ; 2B30
   .byte 1,"1"
   .word NFA_0            ; 2B27
_1:              ; 2B34 - 2B39
   call __40     ; 2B34
   .word $0001   ; 2B37

NFA_2:           ; 2B39
   .byte 1,"2"
   .word NFA_1            ; 2B30
_2:              ; 2B3D - 2B42
   call __40     ; 2B3D
   .word $0002   ; 2B40

NFA_TRUE:        ; 2B42
   .byte 4,"TRUE"
   .word NFA_2            ; 2B39
_TRUE:           ; 2B49 - 2B4E
   call __40     ; 2B49
   .word $FFFF   ; 2B4C

NFA_FALSE:       ; 2B4E
   .byte 5,"FALSE"
   .word NFA_TRUE         ; 2B42
_FALSE:          ; 2B56 - 2B5B
   call __40     ; 2B56
   .word $0000   ; 2B59

NFA_HERE:        ; 2B5B
   .byte 4,"HERE"
   .word NFA_FALSE        ; 2B4E
_HERE:           ; 2B62 - 2B6B
   call _FCALL            ; 2B62
   .word _H               ; $2b65 2091 - H
   .word __40             ; $2b67 2820 - @
   .word _EXIT            ; $2b69 21A8 - EXIT

NFA_ALLOT:       ; 2B6B
   .byte 5,"ALLOT"
   .word NFA_HERE         ; 2B5B
_ALLOT:          ; 2B73 - 2B7C
   call _FCALL            ; 2B73
   .word _H               ; $2b76 2091 - H
   .word __2B_21          ; $2b78 2876 - +!
   .word _EXIT            ; $2b7a 21A8 - EXIT

NFA__2C:         ; 2B7C
   .byte 1,","
   .word NFA_ALLOT        ; 2B6B
__2C:            ; 2B80 - 2B8D
   call _FCALL            ; 2B80
   .word _HERE            ; $2b83 2B62 - HERE
   .word _2               ; $2b85 2B3D - 2
   .word _ALLOT           ; $2b87 2B73 - ALLOT
   .word __21             ; $2b89 2839 - !
   .word _EXIT            ; $2b8b 21A8 - EXIT

NFA_C_2C:        ; 2B8D
   .byte 2,"C,"
   .word NFA__2C            ; 2B7C
_C_2C:           ; 2B92 - 2B9F
   call _FCALL            ; 2B92
   .word _HERE            ; $2b95 2B62 - HERE
   .word _1               ; $2b97 2B34 - 1
   .word _ALLOT           ; $2b99 2B73 - ALLOT
   .word _C_21            ; $2b9b 2846 - C!
   .word _EXIT            ; $2b9d 21A8 - EXIT

NFA__22_2C:      ; 2B9F
   .byte 2,"\","
   .word NFA_C_2C           ; 2B8D
__22_2C:         ; 2BA4 - 2BB7
   call _FCALL            ; 2BA4
   .word _HERE            ; $2ba7 2B62 - HERE
   .word _OVER            ; $2ba9 220D - OVER
   .word _C_40            ; $2bab 282D - C@
   .word _1_2B            ; $2bad 231A - 1+
   .word _DUP             ; $2baf 2277 - DUP
   .word _ALLOT           ; $2bb1 2B73 - ALLOT
   .word _CMOVE           ; $2bb3 2A28 - CMOVE
   .word _EXIT            ; $2bb5 21A8 - EXIT

NFA_PAD:         ; 2BB7
   .byte 3,"PAD"
   .word NFA__22_2C           ; 2B9F
_PAD:            ; 2BBD - 2BCA
   call _FCALL            ; 2BBD
   .word _HERE            ; $2bc0 2B62 - HERE
   .word _LIT             ; $2bc2 28C7 - LIT
   .word $0040            ; $2bc4 0040
   .word __2B             ; $2bc6 22ED - +
   .word _EXIT            ; $2bc8 21A8 - EXIT
'
NFA_COUNT:       ; 2BCA
   .byte 5,"COUNT"
   .word NFA_PAD          ; 2BB7
_COUNT:          ; 2BD2 - 2BDF
   call _FCALL            ; 2BD2
   .word _DUP             ; $2bd5 2277 - DUP
   .word _1_2B            ; $2bd7 231A - 1+
   .word _SWAP            ; $2bd9 2238 - SWAP
   .word _C_40            ; $2bdb 282D - C@
   .word _EXIT            ; $2bdd 21A8 - EXIT

NFA_COMPILE:     ; 2BDF
   .byte 7,"COMPILE"
   .word NFA_COUNT        ; 2BCA
_COMPILE:        ; 2BE9 - 2BFA
   call _FCALL            ; 2BE9
   .word _R_3E            ; $2bec 27BC - R>
   .word _DUP             ; $2bee 2277 - DUP
   .word _2_2B            ; $2bf0 2325 - 2+
   .word __3ER            ; $2bf2 27A9 - >R
   .word __40             ; $2bf4 2820 - @
   .word __2C             ; $2bf6 2B80 - ,
   .word _EXIT            ; $2bf8 21A8 - EXIT

NFA_S_3ED:       ; 2BFA
   .byte 3,"S>D"
   .word NFA_COMPILE      ; 2BDF
_S_3ED:          ; 2C00 - 2C09
   call _FCALL            ; 2C00
   .word _DUP             ; $2c03 2277 - DUP
   .word _0_3C            ; $2c05 23E0 - 0<
   .word _EXIT            ; $2c07 21A8 - EXIT

NFA_M_2A:        ; 2C09
   .byte 2,"M*"
   .word NFA_S_3ED          ; 2BFA
_M_2A:           ; 2C0E - 2C2B
   call _FCALL            ; 2C0E
   .word _2DUP            ; $2c11 2296 - 2DUP
   .word _XOR             ; $2c13 2787 - XOR
   .word __3ER            ; $2c15 27A9 - >R
   .word _ABS             ; $2c17 2354 - ABS
   .word _SWAP            ; $2c19 2238 - SWAP
   .word _ABS             ; $2c1b 2354 - ABS
   .word _UM_2A           ; $2c1d 2568 - UM*
   .word _R_3E            ; $2c1f 27BC - R>
   .word _0_3C            ; $2c21 23E0 - 0<
   .word __3FBRANCH       ; $2c23 2916 - ?BRANCH
   .word $2C29            ; $2c25 2C29
   .word _DNEGATE         ; $2c27 24C3 - DNEGATE
   .word _EXIT            ; $2c29 21A8 - EXIT

NFA__2F:         ; 2C2B
   .byte 1,"/"
   .word NFA_M_2A           ; 2C09
__2F:            ; 2C2F - 2C38
   call _FCALL            ; 2C2F
   .word __2FMOD          ; $2c32 267E - /MOD
   .word _PRESS           ; $2c34 22B4 - PRESS
   .word _EXIT            ; $2c36 21A8 - EXIT

NFA_MOD:         ; 2C38
   .byte 3,"MOD"
   .word NFA__2F            ; 2C2B
_MOD:            ; 2C3E - 2C47
   call _FCALL            ; 2C3E
   .word __2FMOD          ; $2c41 267E - /MOD
   .word _DROP            ; $2c43 222D - DROP
   .word _EXIT            ; $2c45 21A8 - EXIT

NFA_DABS:        ; 2C47
   .byte 4,"DABS"
   .word NFA_MOD          ; 2C38
_DABS:           ; 2C4E - 2C5D
   call _FCALL            ; 2C4E
   .word _DUP             ; $2c51 2277 - DUP
   .word _0_3C            ; $2c53 23E0 - 0<
   .word __3FBRANCH       ; $2c55 2916 - ?BRANCH
   .word $2C5B            ; $2c57 2C5B
   .word _DNEGATE         ; $2c59 24C3 - DNEGATE
   .word _EXIT            ; $2c5b 21A8 - EXIT

NFA_U_2F:        ; 2C5D
   .byte 2,"U/"
   .word NFA_DABS         ; 2C47
_U_2F:           ; 2C62 - 2C6B
   call _FCALL            ; 2C62
   .word _U_2FMOD         ; $2c65 26C7 - U/MOD
   .word _PRESS           ; $2c67 22B4 - PRESS
   .word _EXIT            ; $2c69 21A8 - EXIT

NFA_UM_2FMOD:    ; 2C6B
   .byte 6,"UM/MOD"
   .word NFA_U_2F           ; 2C5D
_UM_2FMOD:       ; 2C74 - 2C81
   call _FCALL            ; 2C74
   .word _0               ; $2c77 2B2B - 0
   .word _DU_2FMOD        ; $2c79 259A - DU/MOD
   .word _DROP            ; $2c7b 222D - DROP
   .word _PRESS           ; $2c7d 22B4 - PRESS
   .word _EXIT            ; $2c7f 21A8 - EXIT

NFA_M_2FMOD:     ; 2C81
   .byte 5,"M/MOD"
   .word NFA_UM_2FMOD       ; 2C6B
_M_2FMOD:        ; 2C89 - 2CD2
   call _FCALL            ; 2C89
   .word __3FDUP          ; $2c8c 2284 - ?DUP
   .word __3FBRANCH       ; $2c8e 2916 - ?BRANCH
   .word $2CD0            ; $2c90 2CD0
   .word _DUP             ; $2c92 2277 - DUP
   .word __3ER            ; $2c94 27A9 - >R
   .word _2DUP            ; $2c96 2296 - 2DUP
   .word _XOR             ; $2c98 2787 - XOR
   .word __3ER            ; $2c9a 27A9 - >R
   .word __3ER            ; $2c9c 27A9 - >R
   .word _DABS            ; $2c9e 2C4E - DABS
   .word _R_40            ; $2ca0 27CF - R@
   .word _ABS             ; $2ca2 2354 - ABS
   .word _UM_2FMOD        ; $2ca4 2C74 - UM/MOD
   .word _SWAP            ; $2ca6 2238 - SWAP
   .word _R_3E            ; $2ca8 27BC - R>
   .word _0_3C            ; $2caa 23E0 - 0<
   .word __3FBRANCH       ; $2cac 2916 - ?BRANCH
   .word $2CB2            ; $2cae 2CB2
   .word _NEGATE          ; $2cb0 230D - NEGATE
   .word _SWAP            ; $2cb2 2238 - SWAP
   .word _R_3E            ; $2cb4 27BC - R>
   .word _0_3C            ; $2cb6 23E0 - 0<
   .word __3FBRANCH       ; $2cb8 2916 - ?BRANCH
   .word $2CCE            ; $2cba 2CCE
   .word _NEGATE          ; $2cbc 230D - NEGATE
   .word _OVER            ; $2cbe 220D - OVER
   .word __3FBRANCH       ; $2cc0 2916 - ?BRANCH
   .word $2CCE            ; $2cc2 2CCE
   .word _1_2D            ; $2cc4 2331 - 1-
   .word _R_40            ; $2cc6 27CF - R@
   .word _ROT             ; $2cc8 225A - ROT
   .word __2D             ; $2cca 22F8 - -
   .word _SWAP            ; $2ccc 2238 - SWAP
   .word _RDROP           ; $2cce 2811 - RDROP
   .word _EXIT            ; $2cd0 21A8 - EXIT

NFA__2A_2FMOD:   ; 2CD2
   .byte 5,"*/MOD"
   .word NFA_M_2FMOD        ; 2C81
__2A_2FMOD:      ; 2CDA - 2CE7
   call _FCALL            ; 2CDA
   .word __3ER            ; $2cdd 27A9 - >R
   .word _M_2A            ; $2cdf 2C0E - M*
   .word _R_3E            ; $2ce1 27BC - R>
   .word _M_2FMOD         ; $2ce3 2C89 - M/MOD
   .word _EXIT            ; $2ce5 21A8 - EXIT

NFA__2A_2F:      ; 2CE7
   .byte 2,"*/"
   .word NFA__2A_2FMOD        ; 2CD2
__2A_2F:         ; 2CEC - 2CF5
   call _FCALL            ; 2CEC
   .word __2A_2FMOD       ; $2cef 2CDA - */MOD
   .word _PRESS           ; $2cf1 22B4 - PRESS
   .word _EXIT            ; $2cf3 21A8 - EXIT

NFA__3C_3E:      ; 2CF5
   .byte 2,"<>"
   .word NFA__2A_2F           ; 2CE7
__3C_3E:         ; 2CFA - 2D03
   call _FCALL            ; 2CFA
   .word __3D             ; $2cfd 2409 - =
   .word _0_3D            ; $2cff 2421 - 0=
   .word _EXIT            ; $2d01 21A8 - EXIT

NFA_QUIT:        ; 2D03
   .byte 4,"QUIT"
   .word NFA__3C_3E           ; 2CF5
_QUIT:           ; 2D0A - 2D33
   call _FCALL            ; 2D0A
   .word _LIT             ; $2d0d 28C7 - LIT
   .word $6000            ; $2d0f 6000
   .word __40             ; $2d11 2820 - @
   .word __3FDUP          ; $2d13 2284 - ?DUP
   .word __3FBRANCH       ; $2d15 2916 - ?BRANCH
   .word $2D1B            ; $2d17 2D1B
   .word _EXECUTE         ; $2d19 21BF - EXECUTE
   .word _R0              ; $2d1b 207E - R0
   .word __40             ; $2d1d 2820 - @
   .word _RP_21           ; $2d1f 27EC - RP!
   .word _STANDIO         ; $2d21 4594 - STANDIO
   .word _CR              ; $2d23 454C - CR
   .word __5B             ; $2d25 3354 - [
   .word _FORTH           ; $2d27 604C - FORTH
   .word _DEFINITIONS     ; $2d29 32ED - DEFINITIONS
   .word _INTERPRET       ; $2d2b 3683 - INTERPRET
   .word _BRANCH          ; $2d2d 2904 - BRANCH
   .word $2D2B            ; $2d2f 2D2B
   .word _EXIT            ; $2d31 21A8 - EXIT

NFA_ABORT:       ; 2D33
   .byte 5,"ABORT"
   .word NFA_QUIT         ; 2D03
_ABORT:          ; 2D3B - 2D56
   call _FCALL            ; 2D3B
   .word _LIT             ; $2d3e 28C7 - LIT
   .word $6002            ; $2d40 6002
   .word __40             ; $2d42 2820 - @
   .word __3FDUP          ; $2d44 2284 - ?DUP
   .word __3FBRANCH       ; $2d46 2916 - ?BRANCH
   .word $2D4C            ; $2d48 2D4C
   .word _EXECUTE         ; $2d4a 21BF - EXECUTE
   .word _S0              ; $2d4c 2088 - S0
   .word __40             ; $2d4e 2820 - @
   .word _SP_21           ; $2d50 22E4 - SP!
   .word _QUIT            ; $2d52 2D0A - QUIT
   .word _EXIT            ; $2d54 21A8 - EXIT

NFA__28ABORT_22_29:; 2D56
   .byte 8,"(ABORT\")"
   .word NFA_ABORT        ; 2D33
__28ABORT_22_29: ; 2D61 - 2D86
   call _FCALL            ; 2D61
   .word __3FBRANCH       ; $2d64 2916 - ?BRANCH
   .word $2D78            ; $2d66 2D78
   .word _HERE            ; $2d68 2B62 - HERE
   .word _ID_2E           ; $2d6a 32D0 - ID.
   .word _SPACE           ; $2d6c 32A7 - SPACE
   .word _R_3E            ; $2d6e 27BC - R>
   .word _ID_2E           ; $2d70 32D0 - ID.
   .word _ABORT           ; $2d72 2D3B - ABORT
   .word _BRANCH          ; $2d74 2904 - BRANCH
   .word $2D84            ; $2d76 2D84
   .word _R_3E            ; $2d78 27BC - R>
   .word _DUP             ; $2d7a 2277 - DUP
   .word _C_40            ; $2d7c 282D - C@
   .word _1_2B            ; $2d7e 231A - 1+
   .word __2B             ; $2d80 22ED - +
   .word __3ER            ; $2d82 27A9 - >R
   .word _EXIT            ; $2d84 21A8 - EXIT

NFA_ABORT_22:    ; 2D86
   .byte 0x86,"ABORT\"" ; IMMEDIATE
   .word NFA__28ABORT_22_29     ; 2D56
_ABORT_22:       ; 2D8F - 2DA2
   call _FCALL            ; 2D8F
   .word __3FCOMP         ; $2d92 3862 - ?COMP
   .word _COMPILE         ; $2d94 2BE9 - COMPILE
   .word __28ABORT_22_29  ; $2d96 2D61 - (ABORT")
   .word _LIT             ; $2d98 28C7 - LIT
   .word $0022            ; $2d9a 0022
   .word _WORD            ; $2d9c 302A - WORD
   .word __22_2C          ; $2d9e 2BA4 - ",
   .word _EXIT            ; $2da0 21A8 - EXIT

NFA__23_3E:      ; 2DA2
   .byte 2,"#>"
   .word NFA_ABORT_22       ; 2D86
__23_3E:         ; 2DA7 - 2DB8
   call _FCALL            ; 2DA7
   .word _2DROP           ; $2daa 22A7 - 2DROP
   .word _HLD             ; $2dac 2109 - HLD
   .word __40             ; $2dae 2820 - @
   .word _PAD             ; $2db0 2BBD - PAD
   .word _OVER            ; $2db2 220D - OVER
   .word __2D             ; $2db4 22F8 - -
   .word _EXIT            ; $2db6 21A8 - EXIT

NFA__3C_23:      ; 2DB8
   .byte 2,"<#"
   .word NFA__23_3E           ; 2DA2
__3C_23:         ; 2DBD - 2DC8
   call _FCALL            ; 2DBD
   .word _PAD             ; $2dc0 2BBD - PAD
   .word _HLD             ; $2dc2 2109 - HLD
   .word __21             ; $2dc4 2839 - !
   .word _EXIT            ; $2dc6 21A8 - EXIT

NFA_HOLD:        ; 2DC8
   .byte 4,"HOLD"
   .word NFA__3C_23           ; 2DB8
_HOLD:           ; 2DCF - 2DDE
   call _FCALL            ; 2DCF
   .word _HLD             ; $2dd2 2109 - HLD
   .word _1_2D_21         ; $2dd4 28B6 - 1-!
   .word _HLD             ; $2dd6 2109 - HLD
   .word __40             ; $2dd8 2820 - @
   .word _C_21            ; $2dda 2846 - C!
   .word _EXIT            ; $2ddc 21A8 - EXIT

NFA_SIGN:        ; 2DDE
   .byte 4,"SIGN"
   .word NFA_HOLD         ; 2DC8
_SIGN:           ; 2DE5 - 2DF6
   call _FCALL            ; 2DE5
   .word _0_3C            ; $2de8 23E0 - 0<
   .word __3FBRANCH       ; $2dea 2916 - ?BRANCH
   .word $2DF4            ; $2dec 2DF4
   .word _LIT             ; $2dee 28C7 - LIT
   .word $002D            ; $2df0 002D
   .word _HOLD            ; $2df2 2DCF - HOLD
   .word _EXIT            ; $2df4 21A8 - EXIT

NFA__3EDIG:      ; 2DF6
   .byte 4,">DIG"
   .word NFA_SIGN         ; 2DDE
__3EDIG:         ; 2DFD - 2E1C
   call _FCALL            ; 2DFD
   .word _LIT             ; $2e00 28C7 - LIT
   .word $0009            ; $2e02 0009
   .word _OVER            ; $2e04 220D - OVER
   .word _U_3C            ; $2e06 239D - U<
   .word __3FBRANCH       ; $2e08 2916 - ?BRANCH
   .word $2E14            ; $2e0a 2E14
   .word _LIT             ; $2e0c 28C7 - LIT
   .word $0037            ; $2e0e 0037
   .word _BRANCH          ; $2e10 2904 - BRANCH
   .word $2E18            ; $2e12 2E18
   .word _LIT             ; $2e14 28C7 - LIT
   .word $0030            ; $2e16 0030
   .word __2B             ; $2e18 22ED - +
   .word _EXIT            ; $2e1a 21A8 - EXIT

NFA__23:         ; 2E1C
   .byte 1,"#"
   .word NFA__3EDIG         ; 2DF6
__23:            ; 2E20 - 2E37
   call _FCALL            ; 2E20
   .word _BASE            ; $2e23 20C8 - BASE
   .word __40             ; $2e25 2820 - @
   .word _0               ; $2e27 2B2B - 0
   .word _DU_2FMOD        ; $2e29 259A - DU/MOD
   .word _ROT             ; $2e2b 225A - ROT
   .word _DROP            ; $2e2d 222D - DROP
   .word _ROT             ; $2e2f 225A - ROT
   .word __3EDIG          ; $2e31 2DFD - >DIG
   .word _HOLD            ; $2e33 2DCF - HOLD
   .word _EXIT            ; $2e35 21A8 - EXIT

NFA__23_2E:      ; 2E37
   .byte 2,"#."
   .word NFA__23            ; 2E1C
__23_2E:         ; 2E3C - 2E4D
   call _FCALL            ; 2E3C
   .word _BASE            ; $2e3f 20C8 - BASE
   .word __40             ; $2e41 2820 - @
   .word _U_2FMOD         ; $2e43 26C7 - U/MOD
   .word _SWAP            ; $2e45 2238 - SWAP
   .word __3EDIG          ; $2e47 2DFD - >DIG
   .word _HOLD            ; $2e49 2DCF - HOLD
   .word _EXIT            ; $2e4b 21A8 - EXIT

NFA__23_2ES:     ; 2E4D
   .byte 3,"#.S"
   .word NFA__23_2E           ; 2E37
__23_2ES:        ; 2E53 - 2E62
   call _FCALL            ; 2E53
   .word __23_2E          ; $2e56 2E3C - #.
   .word _DUP             ; $2e58 2277 - DUP
   .word _0_3D            ; $2e5a 2421 - 0=
   .word __3FBRANCH       ; $2e5c 2916 - ?BRANCH
   .word $2E56            ; $2e5e 2E56
   .word _EXIT            ; $2e60 21A8 - EXIT

NFA__23S:        ; 2E62
   .byte 2,"#S"
   .word NFA__23_2ES          ; 2E4D
__23S:           ; 2E67 - 2E78
   call _FCALL            ; 2E67
   .word __23             ; $2e6a 2E20 - #
   .word _2DUP            ; $2e6c 2296 - 2DUP
   .word _OR              ; $2e6e 2775 - OR
   .word _0_3D            ; $2e70 2421 - 0=
   .word __3FBRANCH       ; $2e72 2916 - ?BRANCH
   .word $2E6A            ; $2e74 2E6A
   .word _EXIT            ; $2e76 21A8 - EXIT

NFA_D_2ER:       ; 2E78
   .byte 3,"D.R"
   .word NFA__23S           ; 2E62
_D_2ER:          ; 2E7E - 2E9F
   call _FCALL            ; 2E7E
   .word __3ER            ; $2e81 27A9 - >R
   .word _DUP             ; $2e83 2277 - DUP
   .word __3ER            ; $2e85 27A9 - >R
   .word _DABS            ; $2e87 2C4E - DABS
   .word __3C_23          ; $2e89 2DBD - <#
   .word __23S            ; $2e8b 2E67 - #S
   .word _R_3E            ; $2e8d 27BC - R>
   .word _SIGN            ; $2e8f 2DE5 - SIGN
   .word __23_3E          ; $2e91 2DA7 - #>
   .word _R_3E            ; $2e93 27BC - R>
   .word _OVER            ; $2e95 220D - OVER
   .word __2D             ; $2e97 22F8 - -
   .word _SPACES          ; $2e99 32B9 - SPACES
   .word _TYPE            ; $2e9b 31B4 - TYPE
   .word _EXIT            ; $2e9d 21A8 - EXIT

NFA_D_2E:        ; 2E9F
   .byte 2,"D."
   .word NFA_D_2ER          ; 2E78
_D_2E:           ; 2EA4 - 2EBD
   call _FCALL            ; 2EA4
   .word _DUP             ; $2ea7 2277 - DUP
   .word __3ER            ; $2ea9 27A9 - >R
   .word _DABS            ; $2eab 2C4E - DABS
   .word __3C_23          ; $2ead 2DBD - <#
   .word __23S            ; $2eaf 2E67 - #S
   .word _R_3E            ; $2eb1 27BC - R>
   .word _SIGN            ; $2eb3 2DE5 - SIGN
   .word __23_3E          ; $2eb5 2DA7 - #>
   .word _TYPE            ; $2eb7 31B4 - TYPE
   .word _SPACE           ; $2eb9 32A7 - SPACE
   .word _EXIT            ; $2ebb 21A8 - EXIT

NFA__2ER:        ; 2EBD
   .byte 2,".R"
   .word NFA_D_2E           ; 2E9F
__2ER:           ; 2EC2 - 2EE5
   call _FCALL            ; 2EC2
   .word __3ER            ; $2ec5 27A9 - >R
   .word _DUP             ; $2ec7 2277 - DUP
   .word __3ER            ; $2ec9 27A9 - >R
   .word _ABS             ; $2ecb 2354 - ABS
   .word __3C_23          ; $2ecd 2DBD - <#
   .word __23_2ES         ; $2ecf 2E53 - #.S
   .word _R_3E            ; $2ed1 27BC - R>
   .word _SIGN            ; $2ed3 2DE5 - SIGN
   .word _0               ; $2ed5 2B2B - 0
   .word __23_3E          ; $2ed7 2DA7 - #>
   .word _R_3E            ; $2ed9 27BC - R>
   .word _OVER            ; $2edb 220D - OVER
   .word __2D             ; $2edd 22F8 - -
   .word _SPACES          ; $2edf 32B9 - SPACES
   .word _TYPE            ; $2ee1 31B4 - TYPE
   .word _EXIT            ; $2ee3 21A8 - EXIT

NFA__2E0:        ; 2EE5
   .byte 2,".0"
   .word NFA__2ER           ; 2EBD
__2E0:           ; 2EEA - 2F11
   call _FCALL            ; 2EEA
   .word __3ER            ; $2eed 27A9 - >R
   .word __3C_23          ; $2eef 2DBD - <#
   .word __23_2ES         ; $2ef1 2E53 - #.S
   .word _0               ; $2ef3 2B2B - 0
   .word __23_3E          ; $2ef5 2DA7 - #>
   .word _R_3E            ; $2ef7 27BC - R>
   .word _OVER            ; $2ef9 220D - OVER
   .word __2D             ; $2efb 22F8 - -
   .word _0               ; $2efd 2B2B - 0
   .word __28_3FDO_29     ; $2eff 29B8 - (?DO)
   .word $2F0D            ; $2f01 2F0D
   .word _LIT             ; $2f03 28C7 - LIT
   .word $0030            ; $2f05 0030
   .word _EMIT            ; $2f07 3189 - EMIT
   .word __28LOOP_29      ; $2f09 29DA - (LOOP)
   .word $2F03            ; $2f0b 2F03
   .word _TYPE            ; $2f0d 31B4 - TYPE
   .word _EXIT            ; $2f0f 21A8 - EXIT

NFA__2E:         ; 2F11
   .byte 1,"."
   .word NFA__2E0           ; 2EE5
__2E:            ; 2F15 - 2F30
   call _FCALL            ; 2F15
   .word _DUP             ; $2f18 2277 - DUP
   .word __3ER            ; $2f1a 27A9 - >R
   .word _ABS             ; $2f1c 2354 - ABS
   .word __3C_23          ; $2f1e 2DBD - <#
   .word __23_2ES         ; $2f20 2E53 - #.S
   .word _R_3E            ; $2f22 27BC - R>
   .word _SIGN            ; $2f24 2DE5 - SIGN
   .word _0               ; $2f26 2B2B - 0
   .word __23_3E          ; $2f28 2DA7 - #>
   .word _TYPE            ; $2f2a 31B4 - TYPE
   .word _SPACE           ; $2f2c 32A7 - SPACE
   .word _EXIT            ; $2f2e 21A8 - EXIT

NFA_U_2E:        ; 2F30
   .byte 2,"U."
   .word NFA__2E            ; 2F11
_U_2E:           ; 2F35 - 2F3E
   call _FCALL            ; 2F35
   .word _0               ; $2f38 2B2B - 0
   .word _D_2E            ; $2f3a 2EA4 - D.
   .word _EXIT            ; $2f3c 21A8 - EXIT

NFA_CFL:         ; 2F3E
   .byte 3,"CFL"
   .word NFA_U_2E           ; 2F30
_CFL:            ; 2F44 - 2F49
   call __40     ; 2F44
   .word $0003   ; 2F47

NFA_TRAVERSE:    ; 2F49
   .byte 8,"TRAVERSE"
   .word NFA_CFL          ; 2F3E
_TRAVERSE:       ; 2F54 - 2F99
   call _FCALL            ; 2F54
   .word _1_2D            ; $2f57 2331 - 1-
   .word _N_3FBRANCH      ; $2f59 2934 - N?BRANCH
   .word $2F6B            ; $2f5b 2F6B
   .word _COUNT           ; $2f5d 2BD2 - COUNT
   .word _LIT             ; $2f5f 28C7 - LIT
   .word $003F            ; $2f61 003F
   .word _AND             ; $2f63 2764 - AND
   .word __2B             ; $2f65 22ED - +
   .word _BRANCH          ; $2f67 2904 - BRANCH
   .word $2F97            ; $2f69 2F97
   .word _LIT             ; $2f6b 28C7 - LIT
   .word $0020            ; $2f6d 0020
   .word _2               ; $2f6f 2B3D - 2
   .word __28DO_29        ; $2f71 2991 - (DO)
   .word $2F97            ; $2f73 2F97
   .word _DUP             ; $2f75 2277 - DUP
   .word _I               ; $2f77 294B - I
   .word __2D             ; $2f79 22F8 - -
   .word _C_40            ; $2f7b 282D - C@
   .word _LIT             ; $2f7d 28C7 - LIT
   .word $007F            ; $2f7f 007F
   .word _AND             ; $2f81 2764 - AND
   .word _1_2B            ; $2f83 231A - 1+
   .word _I               ; $2f85 294B - I
   .word __3D             ; $2f87 2409 - =
   .word __3FBRANCH       ; $2f89 2916 - ?BRANCH
   .word $2F93            ; $2f8b 2F93
   .word _I               ; $2f8d 294B - I
   .word __2D             ; $2f8f 22F8 - -
   .word _LEAVE           ; $2f91 38B5 - LEAVE
   .word __28LOOP_29      ; $2f93 29DA - (LOOP)
   .word $2F75            ; $2f95 2F75
   .word _EXIT            ; $2f97 21A8 - EXIT

NFA__3EBODY:     ; 2F99
   .byte 5,">BODY"
   .word NFA_TRAVERSE     ; 2F49
__3EBODY:        ; 2FA1 - 2FAA
   call _FCALL            ; 2FA1
   .word _CFL             ; $2fa4 2F44 - CFL
   .word __2B             ; $2fa6 22ED - +
   .word _EXIT            ; $2fa8 21A8 - EXIT

NFA_BODY_3E:     ; 2FAA
   .byte 5,"BODY>"
   .word NFA__3EBODY        ; 2F99
_BODY_3E:        ; 2FB2 - 2FBB
   call _FCALL            ; 2FB2
   .word _CFL             ; $2fb5 2F44 - CFL
   .word __2D             ; $2fb7 22F8 - -
   .word _EXIT            ; $2fb9 21A8 - EXIT

NFA__3ENAME:     ; 2FBB
   .byte 5,">NAME"
   .word NFA_BODY_3E        ; 2FAA
__3ENAME:        ; 2FC3 - 2FCE
   call _FCALL            ; 2FC3
   .word _2_2D            ; $2fc6 233C - 2-
   .word __2D1            ; $2fc8 2B22 - -1
   .word _TRAVERSE        ; $2fca 2F54 - TRAVERSE
   .word _EXIT            ; $2fcc 21A8 - EXIT

NFA_NAME_3E:     ; 2FCE
   .byte 5,"NAME>"
   .word NFA__3ENAME        ; 2FBB
_NAME_3E:        ; 2FD6 - 2FE1
   call _FCALL            ; 2FD6
   .word _1               ; $2fd9 2B34 - 1
   .word _TRAVERSE        ; $2fdb 2F54 - TRAVERSE
   .word _2_2B            ; $2fdd 2325 - 2+
   .word _EXIT            ; $2fdf 21A8 - EXIT

NFA__3ELINK:     ; 2FE1
   .byte 5,">LINK"
   .word NFA_NAME_3E        ; 2FCE
__3ELINK:        ; 2FE9 - 2FF0
   call _FCALL            ; 2FE9
   .word _2_2D            ; $2fec 233C - 2-
   .word _EXIT            ; $2fee 21A8 - EXIT

NFA_LINK_3E:     ; 2FF0
   .byte 5,"LINK>"
   .word NFA__3ELINK        ; 2FE1
_LINK_3E:        ; 2FF8 - 2FFF
   call _FCALL            ; 2FF8
   .word _2_2B            ; $2ffb 2325 - 2+
   .word _EXIT            ; $2ffd 21A8 - EXIT

NFA_N_3ELINK:    ; 2FFF
   .byte 6,"N>LINK"
   .word NFA_LINK_3E        ; 2FF0
_N_3ELINK:       ; 3008 - 3011
   call _FCALL            ; 3008
   .word _1               ; $300b 2B34 - 1
   .word _TRAVERSE        ; $300d 2F54 - TRAVERSE
   .word _EXIT            ; $300f 21A8 - EXIT

NFA_L_3ENAME:    ; 3011
   .byte 6,"L>NAME"
   .word NFA_N_3ELINK       ; 2FFF
_L_3ENAME:       ; 301A - 3023
   call _FCALL            ; 301A
   .word __2D1            ; $301d 2B22 - -1
   .word _TRAVERSE        ; $301f 2F54 - TRAVERSE
   .word _EXIT            ; $3021 21A8 - EXIT

NFA_WORD:        ; 3023
   .byte 4,"WORD"
   .word NFA_L_3ENAME       ; 3011
_WORD:           ; 302A - 308D
   call _FCALL            ; 302A
   .word _LIT             ; $302d 28C7 - LIT
   .word $6016            ; $302f 6016
   .word __40             ; $3031 2820 - @
   .word __3FDUP          ; $3033 2284 - ?DUP
   .word __3FBRANCH       ; $3035 2916 - ?BRANCH
   .word $303D            ; $3037 303D
   .word _EXECUTE         ; $3039 21BF - EXECUTE
   .word _EXIT            ; $303b 21A8 - EXIT
   .word _TIB             ; $303d 2176 - TIB
   .word __3EIN           ; $303f 2153 - >IN
   .word __40             ; $3041 2820 - @
   .word __2B             ; $3043 22ED - +
   .word __23TIB          ; $3045 2148 - #TIB
   .word __40             ; $3047 2820 - @
   .word __3EIN           ; $3049 2153 - >IN
   .word __40             ; $304b 2820 - @
   .word __2D             ; $304d 22F8 - -
   .word _ENCLOSE         ; $304f 2ADF - ENCLOSE
   .word __3FBRANCH       ; $3051 2916 - ?BRANCH
   .word $3061            ; $3053 3061
   .word _TIB             ; $3055 2176 - TIB
   .word __2D             ; $3057 22F8 - -
   .word __3EIN           ; $3059 2153 - >IN
   .word __21             ; $305b 2839 - !
   .word _BRANCH          ; $305d 2904 - BRANCH
   .word $306D            ; $305f 306D
   .word __23TIB          ; $3061 2148 - #TIB
   .word __40             ; $3063 2820 - @
   .word __3EIN           ; $3065 2153 - >IN
   .word __21             ; $3067 2839 - !
   .word _0               ; $3069 2B2B - 0
   .word _0               ; $306b 2B2B - 0
   .word _DUP             ; $306d 2277 - DUP
   .word _HERE            ; $306f 2B62 - HERE
   .word _C_21            ; $3071 2846 - C!
   .word _HERE            ; $3073 2B62 - HERE
   .word _1_2B            ; $3075 231A - 1+
   .word _SWAP            ; $3077 2238 - SWAP
   .word _CMOVE           ; $3079 2A28 - CMOVE
   .word _HERE            ; $307b 2B62 - HERE
   .word _BL              ; $307d 3289 - BL
   .word _OVER            ; $307f 220D - OVER
   .word _DUP             ; $3081 2277 - DUP
   .word _C_40            ; $3083 282D - C@
   .word _1_2B            ; $3085 231A - 1+
   .word __2B             ; $3087 22ED - +
   .word _C_21            ; $3089 2846 - C!
   .word _EXIT            ; $308b 21A8 - EXIT

NFA_INLINE:      ; 308D
   .byte 6,"INLINE"
   .word NFA_WORD         ; 3023
_INLINE:         ; 3096 - 30B9
   call _FCALL            ; 3096
   .word _INLINP          ; $3099 2122 - INLINP
   .word __40             ; $309b 2820 - @
   .word _EXECUTE         ; $309d 21BF - EXECUTE
   .word __3FBRANCH       ; $309f 2916 - ?BRANCH
   .word $30B5            ; $30a1 30B5
   .word __3EIN           ; $30a3 2153 - >IN
   .word __21             ; $30a5 2839 - !
   .word __23TIB          ; $30a7 2148 - #TIB
   .word __21             ; $30a9 2839 - !
   .word _INB             ; $30ab 213C - INB
   .word __21             ; $30ad 2839 - !
   .word _TRUE            ; $30af 2B49 - TRUE
   .word _BRANCH          ; $30b1 2904 - BRANCH
   .word $30B7            ; $30b3 30B7
   .word _FALSE           ; $30b5 2B56 - FALSE
   .word _EXIT            ; $30b7 21A8 - EXIT

NFA_EXPECT:      ; 30B9
   .byte 6,"EXPECT"
   .word NFA_INLINE       ; 308D
_EXPECT:         ; 30C2 - 3139
   call _FCALL            ; 30C2
   .word __3ER            ; $30c5 27A9 - >R
   .word _DUP             ; $30c7 2277 - DUP
   .word _R_3E            ; $30c9 27BC - R>
   .word _0               ; $30cb 2B2B - 0
   .word __28_3FDO_29     ; $30cd 29B8 - (?DO)
   .word $312F            ; $30cf 312F
   .word _KEY             ; $30d1 31A0 - KEY
   .word _DUP             ; $30d3 2277 - DUP
   .word _B_2DSP          ; $30d5 44F5 - B-SP
   .word __3D             ; $30d7 2409 - =
   .word __3FBRANCH       ; $30d9 2916 - ?BRANCH
   .word $310B            ; $30db 310B
   .word __3ER            ; $30dd 27A9 - >R
   .word _2DUP            ; $30df 2296 - 2DUP
   .word __3D             ; $30e1 2409 - =
   .word _N_3FBRANCH      ; $30e3 2934 - N?BRANCH
   .word $30FF            ; $30e5 30FF
   .word _R_3E            ; $30e7 27BC - R>
   .word _DUP             ; $30e9 2277 - DUP
   .word _EMIT            ; $30eb 3189 - EMIT
   .word _BL              ; $30ed 3289 - BL
   .word _EMIT            ; $30ef 3189 - EMIT
   .word _EMIT            ; $30f1 3189 - EMIT
   .word _1_2D            ; $30f3 2331 - 1-
   .word _R_3E            ; $30f5 27BC - R>
   .word _1_2D            ; $30f7 2331 - 1-
   .word __3ER            ; $30f9 27A9 - >R
   .word _BRANCH          ; $30fb 2904 - BRANCH
   .word $3101            ; $30fd 3101
   .word _RDROP           ; $30ff 2811 - RDROP
   .word _R_3E            ; $3101 27BC - R>
   .word _1_2D            ; $3103 2331 - 1-
   .word __3ER            ; $3105 27A9 - >R
   .word _BRANCH          ; $3107 2904 - BRANCH
   .word $312B            ; $3109 312B
   .word _DUP             ; $310b 2277 - DUP
   .word _ST_2DC          ; $310d 44E9 - ST-C
   .word __3D             ; $310f 2409 - =
   .word __3FBRANCH       ; $3111 2916 - ?BRANCH
   .word $3121            ; $3113 3121
   .word _DROP            ; $3115 222D - DROP
   .word _BL              ; $3117 3289 - BL
   .word _EMIT            ; $3119 3189 - EMIT
   .word _LEAVE           ; $311b 38B5 - LEAVE
   .word _BRANCH          ; $311d 2904 - BRANCH
   .word $312B            ; $311f 312B
   .word _DUP             ; $3121 2277 - DUP
   .word _EMIT            ; $3123 3189 - EMIT
   .word _OVER            ; $3125 220D - OVER
   .word _C_21            ; $3127 2846 - C!
   .word _1_2B            ; $3129 231A - 1+
   .word __28LOOP_29      ; $312b 29DA - (LOOP)
   .word $30D1            ; $312d 30D1
   .word _SWAP            ; $312f 2238 - SWAP
   .word __2D             ; $3131 22F8 - -
   .word _SPAN            ; $3133 215F - SPAN
   .word __21             ; $3135 2839 - !
   .word _EXIT            ; $3137 21A8 - EXIT

NFA__3EPRT:      ; 3139
   .byte 4,">PRT"
   .word NFA_EXPECT       ; 30B9
__3EPRT:         ; 3140 - 314F
   call _FCALL            ; 3140
   .word _LIT             ; $3143 28C7 - LIT
   .word $007F            ; $3145 007F
   .word _MAX             ; $3147 2381 - MAX
   .word _BL              ; $3149 3289 - BL
   .word _MAX             ; $314b 2381 - MAX
   .word _EXIT            ; $314d 21A8 - EXIT

NFA_PTYPE:       ; 314F
   .byte 5,"PTYPE"
   .word NFA__3EPRT         ; 3139
_PTYPE:          ; 3157 - 3172
   call _FCALL            ; 3157
   .word _0               ; $315a 2B2B - 0
   .word __28_3FDO_29     ; $315c 29B8 - (?DO)
   .word $316E            ; $315e 316E
   .word _DUP             ; $3160 2277 - DUP
   .word _C_40            ; $3162 282D - C@
   .word __3EPRT          ; $3164 3140 - >PRT
   .word _EMIT            ; $3166 3189 - EMIT
   .word _1_2B            ; $3168 231A - 1+
   .word __28LOOP_29      ; $316a 29DA - (LOOP)
   .word $3160            ; $316c 3160
   .word _DROP            ; $316e 222D - DROP
   .word _EXIT            ; $3170 21A8 - EXIT

NFA_:            ; 3172
   .byte 0x80,"" ; IMMEDIATE
   .word NFA_PTYPE        ; 314F
_:               ; 3175 - 3182
   call _FCALL            ; 3175
   .word _INLINE          ; $3178 3096 - INLINE
   .word _N_3FBRANCH      ; $317a 2934 - N?BRANCH
   .word @3180            ; $317c 3180
   .word _RDROP           ; $317e 2811 - RDROP
@3180:
   .word _EXIT            ; $3180 21A8 - EXIT

NFA_EMIT:        ; 3182
   .byte 4,"EMIT"
   .word NFA_             ; 3172
_EMIT:           ; 3189 - 319A
   call _FCALL            ; 3189
   .word _LIT             ; $318c 28C7 - LIT
   .word $600E            ; $318e 600E
   .word __40             ; $3190 2820 - @
   .word _EXECUTE         ; $3192 21BF - EXECUTE
   .word __3EOUT          ; $3194 216B - >OUT
   .word _1_2B_21         ; $3196 28A6 - 1+!
   .word _EXIT            ; $3198 21A8 - EXIT

NFA_KEY:         ; 319A
   .byte 3,"KEY"
   .word $3182 ;NFA_EMIT         ; 3182
_KEY:            ; 31A0 - 31AD
   call _FCALL            ; 31A0
   .word _LIT             ; $31a3 28C7 - LIT
   .word $600C            ; $31a5 600C
   .word __40             ; $31a7 2820 - @
   .word _EXECUTE         ; $31a9 21BF - EXECUTE
   .word _EXIT            ; $31ab 21A8 - EXIT

NFA_TYPE:        ; 31AD
   .byte 4,"TYPE"
   .word NFA_KEY          ; 319A
_TYPE:           ; 31B4 - 31DD
   call _FCALL            ; 31B4
   .word _LIT             ; $31b7 28C7 - LIT
   .word $6012            ; $31b9 6012
   .word __40             ; $31bb 2820 - @
   .word __3FDUP          ; $31bd 2284 - ?DUP
   .word __3FBRANCH       ; $31bf 2916 - ?BRANCH
   .word $31C7            ; $31c1 31C7
   .word _EXECUTE         ; $31c3 21BF - EXECUTE
   .word _EXIT            ; $31c5 21A8 - EXIT
   .word _0               ; $31c7 2B2B - 0
   .word __28_3FDO_29     ; $31c9 29B8 - (?DO)
   .word $31D9            ; $31cb 31D9
   .word _DUP             ; $31cd 2277 - DUP
   .word _C_40            ; $31cf 282D - C@
   .word _EMIT            ; $31d1 3189 - EMIT
   .word _1_2B            ; $31d3 231A - 1+
   .word __28LOOP_29      ; $31d5 29DA - (LOOP)
   .word $31CD            ; $31d7 31CD
   .word _DROP            ; $31d9 222D - DROP
   .word _EXIT            ; $31db 21A8 - EXIT

NFA__3ECH:       ; 31DD
   .byte 3,">CH"
   .word NFA_TYPE         ; 31AD
__3ECH:          ; 31E3 - 320C
   call _FCALL            ; 31E3
   .word __3EIN           ; $31e6 2153 - >IN
   .word __40             ; $31e8 2820 - @
   .word _DUP             ; $31ea 2277 - DUP
   .word __23TIB          ; $31ec 2148 - #TIB
   .word __40             ; $31ee 2820 - @
   .word _U_3C            ; $31f0 239D - U<
   .word _N_3FBRANCH      ; $31f2 2934 - N?BRANCH
   .word $31FE            ; $31f4 31FE
   .word _DROP            ; $31f6 222D - DROP
   .word _FALSE           ; $31f8 2B56 - FALSE
   .word _BRANCH          ; $31fa 2904 - BRANCH
   .word $320A            ; $31fc 320A
   .word _TIB             ; $31fe 2176 - TIB
   .word __2B             ; $3200 22ED - +
   .word _C_40            ; $3202 282D - C@
   .word __3EIN           ; $3204 2153 - >IN
   .word _1_2B_21         ; $3206 28A6 - 1+!
   .word _TRUE            ; $3208 2B49 - TRUE
   .word _EXIT            ; $320a 21A8 - EXIT

NFA_FORTH_2D83:  ; 320C
   .byte 8,"FORTH-83"
   .word NFA__3ECH          ; 31DD
_FORTH_2D83:     ; 3217 - 3232
   call _FCALL            ; 3217
   .word _CR              ; $321a 454C - CR
   .word __28_2E_22_29    ; $321c 3421 - (.")
   .byte 17,"CTAH",0xe4,"APT FORTH-83"
   .word _EXIT            ; $3230 21A8 - EXIT

NFA_F_2DCODE:    ; 3232
   .byte 6,"F-CODE"
   .word NFA_FORTH_2D83     ; 320C
_F_2DCODE:       ; 323B - 3240
   call __40     ; 323B
   .word $2000   ; 323E

NFA_F_2DDATA:    ; 3240
   .byte 6,"F-DATA"
   .word NFA_F_2DCODE       ; 3232
_F_2DDATA:       ; 3249 - 324E
   call __40     ; 3249
   .word $6000   ; 324C

NFA__3BS:        ; 324E
   .byte 2,";S"
   .word NFA_F_2DDATA       ; 3240
__3BS:           ; 3253 - 325A
   call _FCALL            ; 3253
   .word _RDROP           ; $3256 2811 - RDROP
   .word _EXIT            ; $3258 21A8 - EXIT

NFA_HEX:         ; 325A
   .byte 3,"HEX"
   .word NFA__3BS           ; 324E
_HEX:            ; 3260 - 326D
   call _FCALL            ; 3260
   .word _LIT             ; $3263 28C7 - LIT
   .word $0010            ; $3265 0010
   .word _BASE            ; $3267 20C8 - BASE
   .word __21             ; $3269 2839 - !
   .word _EXIT            ; $326b 21A8 - EXIT

NFA_DECIMAL:     ; 326D
   .byte 7,"DECIMAL"
   .word NFA_HEX          ; 325A
_DECIMAL:        ; 3277 - 3284
   call _FCALL            ; 3277
   .word _LIT             ; $327a 28C7 - LIT
   .word $000A            ; $327c 000A
   .word _BASE            ; $327e 20C8 - BASE
   .word __21             ; $3280 2839 - !
   .word _EXIT            ; $3282 21A8 - EXIT

NFA_BL:          ; 3284
   .byte 2,"BL"
   .word NFA_DECIMAL      ; 326D
_BL:             ; 3289 - 328E
   call __40     ; 3289
   .word $0020   ; 328C

NFA_BLANK:       ; 328E
   .byte 5,"BLANK"
   .word NFA_BL           ; 3284
_BLANK:          ; 3296 - 329F
   call _FCALL            ; 3296
   .word _BL              ; $3299 3289 - BL
   .word _FILL            ; $329b 2AA1 - FILL
   .word _EXIT            ; $329d 21A8 - EXIT

NFA_SPACE:       ; 329F
   .byte 5,"SPACE"
   .word NFA_BLANK        ; 328E
_SPACE:          ; 32A7 - 32B0
   call _FCALL            ; 32A7
   .word _BL              ; $32aa 3289 - BL
   .word _EMIT            ; $32ac 3189 - EMIT
   .word _EXIT            ; $32ae 21A8 - EXIT

NFA_SPACES:      ; 32B0
   .byte 6,"SPACES"
   .word NFA_SPACE        ; 329F
_SPACES:         ; 32B9 - 32CA
   call _FCALL            ; 32B9
   .word _0               ; $32bc 2B2B - 0
   .word __28_3FDO_29     ; $32be 29B8 - (?DO)
   .word $32C8            ; $32c0 32C8
   .word _SPACE           ; $32c2 32A7 - SPACE
   .word __28LOOP_29      ; $32c4 29DA - (LOOP)
   .word $32C2            ; $32c6 32C2
   .word _EXIT            ; $32c8 21A8 - EXIT

NFA_ID_2E:       ; 32CA
   .byte 3,"ID."
   .word NFA_SPACES       ; 32B0
_ID_2E:          ; 32D0 - 32DF
   call _FCALL            ; 32D0
   .word _COUNT           ; $32d3 2BD2 - COUNT
   .word _LIT             ; $32d5 28C7 - LIT
   .word $003F            ; $32d7 003F
   .word _AND             ; $32d9 2764 - AND
   .word _TYPE            ; $32db 31B4 - TYPE
   .word _EXIT            ; $32dd 21A8 - EXIT

NFA_DEFINITIONS: ; 32DF
   .byte 11,"DEFINITIONS"
   .word NFA_ID_2E          ; 32CA
_DEFINITIONS:    ; 32ED - 32FA
   call _FCALL            ; 32ED
   .word _CONTEXT         ; $32f0 20E4 - CONTEXT
   .word __40             ; $32f2 2820 - @
   .word _CURRENT         ; $32f4 20F3 - CURRENT
   .word __21             ; $32f6 2839 - !
   .word _EXIT            ; $32f8 21A8 - EXIT

NFA_LATEST:      ; 32FA
   .byte 6,"LATEST"
   .word NFA_DEFINITIONS  ; 32DF
_LATEST:         ; 3303 - 330E
   call _FCALL            ; 3303
   .word _CURRENT         ; $3306 20F3 - CURRENT
   .word __40             ; $3308 2820 - @
   .word __40             ; $330a 2820 - @
   .word _EXIT            ; $330c 21A8 - EXIT

NFA__21CF:       ; 330E
   .byte 3,"!CF"
   .word NFA_LATEST       ; 32FA
__21CF:          ; 3314 - 3325
   call _FCALL            ; 3314
   .word _LIT             ; $3317 28C7 - LIT
   .word $00CD            ; $3319 00CD
   .word _OVER            ; $331b 220D - OVER
   .word _C_21            ; $331d 2846 - C!
   .word _1_2B            ; $331f 231A - 1+
   .word __21             ; $3321 2839 - !
   .word _EXIT            ; $3323 21A8 - EXIT

NFA__28_21CODE_29:; 3325
   .byte 7,"(!CODE)"
   .word NFA__21CF          ; 330E
__28_21CODE_29:  ; 332F - 333A
   call _FCALL            ; 332F
   .word _LATEST          ; $3332 3303 - LATEST
   .word _NAME_3E         ; $3334 2FD6 - NAME>
   .word __21CF           ; $3336 3314 - !CF
   .word _EXIT            ; $3338 21A8 - EXIT

NFA_SMUDGE:      ; 333A
   .byte 6,"SMUDGE"
   .word NFA__28_21CODE_29      ; 3325
_SMUDGE:         ; 3343 - 3350
   call _FCALL            ; 3343
   .word _LATEST          ; $3346 3303 - LATEST
   .word _LIT             ; $3348 28C7 - LIT
   .word $0040            ; $334a 0040
   .word _TOGGLE          ; $334c 2982 - TOGGLE
   .word _EXIT            ; $334e 21A8 - EXIT

NFA__5B:         ; 3350
   .byte 0x81,"[" ; IMMEDIATE
   .word NFA_SMUDGE       ; 333A
__5B:            ; 3354 - 335D
   call _FCALL            ; 3354
   .word _STATE           ; $3357 20D5 - STATE
   .word _0_21            ; $3359 2898 - 0!
   .word _EXIT            ; $335b 21A8 - EXIT

NFA__5D:         ; 335D
   .byte 1,"]"
   .word NFA__5B            ; 3350
__5D:            ; 3361 - 336C
   call _FCALL            ; 3361
   .word __2D1            ; $3364 2B22 - -1
   .word _STATE           ; $3366 20D5 - STATE
   .word __21             ; $3368 2839 - !
   .word _EXIT            ; $336a 21A8 - EXIT

NFA_FIND:        ; 336C
   .byte 4,"FIND"
   .word NFA__5D            ; 335D
_FIND:           ; 3373 - 33D6
   call _FCALL            ; 3373
   .word _LIT             ; $3376 28C7 - LIT
   .word $6006            ; $3378 6006
   .word __40             ; $337a 2820 - @
   .word __3FDUP          ; $337c 2284 - ?DUP
   .word __3FBRANCH       ; $337e 2916 - ?BRANCH
   .word $3386            ; $3380 3386
   .word _EXECUTE         ; $3382 21BF - EXECUTE
   .word _EXIT            ; $3384 21A8 - EXIT
   .word _CONTEXT         ; $3386 20E4 - CONTEXT
   .word __40             ; $3388 2820 - @
   .word __3FWORD         ; $338a 26DB - ?WORD
   .word __3FBRANCH       ; $338c 2916 - ?BRANCH
   .word $3396            ; $338e 3396
   .word _TRUE            ; $3390 2B49 - TRUE
   .word _BRANCH          ; $3392 2904 - BRANCH
   .word $33B0            ; $3394 33B0
   .word _CURRENT         ; $3396 20F3 - CURRENT
   .word __40             ; $3398 2820 - @
   .word _DUP             ; $339a 2277 - DUP
   .word _CONTEXT         ; $339c 20E4 - CONTEXT
   .word __40             ; $339e 2820 - @
   .word __3D             ; $33a0 2409 - =
   .word _N_3FBRANCH      ; $33a2 2934 - N?BRANCH
   .word $33AC            ; $33a4 33AC
   .word __3FWORD         ; $33a6 26DB - ?WORD
   .word _BRANCH          ; $33a8 2904 - BRANCH
   .word $33B0            ; $33aa 33B0
   .word _DROP            ; $33ac 222D - DROP
   .word _FALSE           ; $33ae 2B56 - FALSE
   .word __3FBRANCH       ; $33b0 2916 - ?BRANCH
   .word $33D2            ; $33b2 33D2
   .word _DUP             ; $33b4 2277 - DUP
   .word _NAME_3E         ; $33b6 2FD6 - NAME>
   .word _SWAP            ; $33b8 2238 - SWAP
   .word _C_40            ; $33ba 282D - C@
   .word _LIT             ; $33bc 28C7 - LIT
   .word $0080            ; $33be 0080
   .word _AND             ; $33c0 2764 - AND
   .word __3FBRANCH       ; $33c2 2916 - ?BRANCH
   .word $33CC            ; $33c4 33CC
   .word _1               ; $33c6 2B34 - 1
   .word _BRANCH          ; $33c8 2904 - BRANCH
   .word $33CE            ; $33ca 33CE
   .word __2D1            ; $33cc 2B22 - -1
   .word _BRANCH          ; $33ce 2904 - BRANCH
   .word $33D4            ; $33d0 33D4
   .word _FALSE           ; $33d2 2B56 - FALSE
   .word _EXIT            ; $33d4 21A8 - EXIT

NFA__2BWORD:     ; 33D6
   .byte 5,"+WORD"
   .word NFA_FIND         ; 336C
__2BWORD:        ; 33DE - 33F3
   call _FCALL            ; 33DE
   .word _HERE            ; $33e1 2B62 - HERE
   .word _ROT             ; $33e3 225A - ROT
   .word __22_2C          ; $33e5 2BA4 - ",
   .word _SWAP            ; $33e7 2238 - SWAP
   .word _DUP             ; $33e9 2277 - DUP
   .word __40             ; $33eb 2820 - @
   .word __2C             ; $33ed 2B80 - ,
   .word __21             ; $33ef 2839 - !
   .word _EXIT            ; $33f1 21A8 - EXIT

NFA__2DWORD:     ; 33F3
   .byte 5,"-WORD"
   .word NFA__2BWORD        ; 33D6
__2DWORD:        ; 33FB - 341A
   call _FCALL            ; 33FB
   .word __3FWORD         ; $33fe 26DB - ?WORD
   .word __3FBRANCH       ; $3400 2916 - ?BRANCH
   .word $3414            ; $3402 3414
   .word _N_3ELINK        ; $3404 3008 - N>LINK
   .word __40             ; $3406 2820 - @
   .word _W_2DLINK        ; $3408 20BC - W-LINK
   .word __40             ; $340a 2820 - @
   .word __21             ; $340c 2839 - !
   .word _TRUE            ; $340e 2B49 - TRUE
   .word _BRANCH          ; $3410 2904 - BRANCH
   .word $3418            ; $3412 3418
   .word _DROP            ; $3414 222D - DROP
   .word _FALSE           ; $3416 2B56 - FALSE
   .word _EXIT            ; $3418 21A8 - EXIT

NFA__28_2E_22_29:; 341A
   .byte 4,"(.\")"
   .word NFA__2DWORD        ; 33F3
__28_2E_22_29:   ; 3421 - 3436
   call _FCALL            ; 3421
   .word _R_40            ; $3424 27CF - R@
   .word _COUNT           ; $3426 2BD2 - COUNT
   .word _DUP             ; $3428 2277 - DUP
   .word _1_2B            ; $342a 231A - 1+
   .word _R_3E            ; $342c 27BC - R>
   .word __2B             ; $342e 22ED - +
   .word __3ER            ; $3430 27A9 - >R
   .word _TYPE            ; $3432 31B4 - TYPE
   .word _EXIT            ; $3434 21A8 - EXIT

NFA_ERASE:       ; 3436
   .byte 5,"ERASE"
   .word NFA__28_2E_22_29         ; 341A
_ERASE:          ; 343E - 3447
   call _FCALL            ; 343E
   .word _0               ; $3441 2B2B - 0
   .word _FILL            ; $3443 2AA1 - FILL
   .word _EXIT            ; $3445 21A8 - EXIT

NFA__27:         ; 3447
   .byte 1,"'"
   .word NFA_ERASE        ; 3436
__27:            ; 344B - 345E
   call _FCALL            ; 344B
   .word _BL              ; $344e 3289 - BL
   .word _WORD            ; $3450 302A - WORD
   .word _FIND            ; $3452 3373 - FIND
   .word _0_3D            ; $3454 2421 - 0=
   .word __28ABORT_22_29  ; $3456 2D61 - (ABORT")
   .byte 3,"-? "
   .word _EXIT            ; $345c 21A8 - EXIT

NFA__5B_27_5D:   ; 345E
   .byte 0x83,"[']" ; IMMEDIATE
   .word NFA__27            ; 3447
__5B_27_5D:      ; 3464 - 346D
   call _FCALL            ; 3464
   .word __27             ; $3467 344B - '
   .word _LITERAL         ; $3469 3477 - LITERAL
   .word _EXIT            ; $346b 21A8 - EXIT

NFA_LITERAL:     ; 346D
   .byte 0x87,"LITERAL" ; IMMEDIATE
   .word NFA__5B_27_5D          ; 345E
_LITERAL:        ; 3477 - 348A
   call _FCALL            ; 3477
   .word _STATE           ; $347a 20D5 - STATE
   .word __40             ; $347c 2820 - @
   .word __3FBRANCH       ; $347e 2916 - ?BRANCH
   .word $3488            ; $3480 3488
   .word _COMPILE         ; $3482 2BE9 - COMPILE
   .word _LIT             ; $3484 28C7 - LIT
   .word __2C             ; $3486 2B80 - ,
   .word _EXIT            ; $3488 21A8 - EXIT

NFA_DLITERAL:    ; 348A
   .byte 0x88,"DLITERAL" ; IMMEDIATE
   .word NFA_LITERAL      ; 346D
_DLITERAL:       ; 3495 - 34AA
   call _FCALL            ; 3495
   .word _STATE           ; $3498 20D5 - STATE
   .word __40             ; $349a 2820 - @
   .word __3FBRANCH       ; $349c 2916 - ?BRANCH
   .word $34A8            ; $349e 34A8
   .word _COMPILE         ; $34a0 2BE9 - COMPILE
   .word _DLIT            ; $34a2 28D8 - DLIT
   .word __2C             ; $34a4 2B80 - ,
   .word __2C             ; $34a6 2B80 - ,
   .word _EXIT            ; $34a8 21A8 - EXIT

NFA__5BCOMPILE_5D:; 34AA
   .byte 0x89,"[COMPILE]" ; IMMEDIATE
   .word NFA_DLITERAL     ; 348A
__5BCOMPILE_5D:  ; 34B6 - 34BF
   call _FCALL            ; 34B6
   .word __27             ; $34b9 344B - '
   .word __2C             ; $34bb 2B80 - ,
   .word _EXIT            ; $34bd 21A8 - EXIT

NFA_TITLE:       ; 34BF
   .byte 5,"TITLE"
   .word NFA__5BCOMPILE_5D    ; 34AA
_TITLE:          ; 34C7 - 3592
   call _FCALL            ; 34C7
   .word _CR              ; $34ca 454C - CR
   .word __28_2E_22_29    ; $34cc 3421 - (.")
   .byte 34,0xe6,"OPT-7970 BEPC",0xe9,0xf1," 6.2 OT 19.06.85  "
   .word __28_2E_22_29    ; $34f1 3421 - (.")
   .byte 19,"(CTAH",0xe4,"APT FORTH-83)"
   .word _CR              ; $3507 454C - CR
   .word __28_2E_22_29    ; $3509 3421 - (.")
   .byte 43,"    B.A.K",0xe9,"P",0xe9,0xec,0xec,0xe9,"H A.A.K",0xec,0xf5,0xe2,"OB",0xe9,0xfe," H.P.HO",0xfa,0xe4,"P",0xf5,"HOB"
   .word _CR              ; $3537 454C - CR
   .word _LIT             ; $3539 28C7 - LIT
   .word $0014            ; $353b 0014
   .word _SPACES          ; $353d 32B9 - SPACES
   .word __28_2E_22_29    ; $353f 3421 - (.")
   .byte 7,"B",0xe3,"  ",0xec,0xe7,0xf5
   .word _CR              ; $3549 454C - CR
   .word __28_2E_22_29    ; $354b 3421 - (.")
   .byte 50,"198904 ",0xec,"EH",0xe9,"H",0xe7,"PA",0xe4," ",0xf0,"ETPO",0xe4,"BOPE",0xe3," ",0xe2,0xe9,0xe2,0xec,0xe9,"OTE",0xfe,"HA",0xf1," ",0xf0,0xec,". ",0xe4,". 2"
   .word _CR              ; $3580 454C - CR
   .word _LIT             ; $3582 28C7 - LIT
   .word $600A            ; $3584 600A
   .word __40             ; $3586 2820 - @
   .word __3FDUP          ; $3588 2284 - ?DUP
   .word __3FBRANCH       ; $358a 2916 - ?BRANCH
   .word $3590            ; $358c 3590
   .word _EXECUTE         ; $358e 21BF - EXECUTE
   .word _EXIT            ; $3590 21A8 - EXIT

NFA_CONVERT:     ; 3592
   .byte 7,"CONVERT"
   .word NFA_TITLE        ; 34BF
_CONVERT:        ; 359C - 35DB
   call _FCALL            ; 359C
   .word _1_2B            ; $359f 231A - 1+
   .word _DUP             ; $35a1 2277 - DUP
   .word __3ER            ; $35a3 27A9 - >R
   .word _C_40            ; $35a5 282D - C@
   .word _BASE            ; $35a7 20C8 - BASE
   .word __40             ; $35a9 2820 - @
   .word _DIGIT           ; $35ab 272F - DIGIT
   .word __3FBRANCH       ; $35ad 2916 - ?BRANCH
   .word $35D7            ; $35af 35D7
   .word _SWAP            ; $35b1 2238 - SWAP
   .word _BASE            ; $35b3 20C8 - BASE
   .word __40             ; $35b5 2820 - @
   .word __2A             ; $35b7 253C - *
   .word _ROT             ; $35b9 225A - ROT
   .word _BASE            ; $35bb 20C8 - BASE
   .word __40             ; $35bd 2820 - @
   .word _UM_2A           ; $35bf 2568 - UM*
   .word _D_2B            ; $35c1 2472 - D+
   .word _DPL             ; $35c3 20FE - DPL
   .word __40             ; $35c5 2820 - @
   .word _1_2B            ; $35c7 231A - 1+
   .word __3FBRANCH       ; $35c9 2916 - ?BRANCH
   .word $35D1            ; $35cb 35D1
   .word _DPL             ; $35cd 20FE - DPL
   .word _1_2B_21         ; $35cf 28A6 - 1+!
   .word _R_3E            ; $35d1 27BC - R>
   .word _BRANCH          ; $35d3 2904 - BRANCH
   .word $359F            ; $35d5 359F
   .word _R_3E            ; $35d7 27BC - R>
   .word _EXIT            ; $35d9 21A8 - EXIT

NFA_NUMBER:      ; 35DB
   .byte 6,"NUMBER"
   .word NFA_CONVERT      ; 3592
_NUMBER:         ; 35E4 - 364C
   call _FCALL            ; 35E4
   .word _0               ; $35e7 2B2B - 0
   .word _0               ; $35e9 2B2B - 0
   .word _ROT             ; $35eb 225A - ROT
   .word _DUP             ; $35ed 2277 - DUP
   .word _1_2B            ; $35ef 231A - 1+
   .word _C_40            ; $35f1 282D - C@
   .word _LIT             ; $35f3 28C7 - LIT
   .word $002D            ; $35f5 002D
   .word __3D             ; $35f7 2409 - =
   .word __3FBRANCH       ; $35f9 2916 - ?BRANCH
   .word $3603            ; $35fb 3603
   .word _1               ; $35fd 2B34 - 1
   .word _BRANCH          ; $35ff 2904 - BRANCH
   .word $3605            ; $3601 3605
   .word _0               ; $3603 2B2B - 0
   .word _DUP             ; $3605 2277 - DUP
   .word __3ER            ; $3607 27A9 - >R
   .word __2B             ; $3609 22ED - +
   .word __2D1            ; $360b 2B22 - -1
   .word _DPL             ; $360d 20FE - DPL
   .word __21             ; $360f 2839 - !
   .word _CONVERT         ; $3611 359C - CONVERT
   .word _DUP             ; $3613 2277 - DUP
   .word _DUP             ; $3615 2277 - DUP
   .word _C_40            ; $3617 282D - C@
   .word _BL              ; $3619 3289 - BL
   .word __3C_3E          ; $361b 2CFA - <>
   .word _SWAP            ; $361d 2238 - SWAP
   .word _0_3D            ; $361f 2421 - 0=
   .word _0_3D            ; $3621 2421 - 0=
   .word _AND             ; $3623 2764 - AND
   .word __3FBRANCH       ; $3625 2916 - ?BRANCH
   .word $3640            ; $3627 3640
   .word _DUP             ; $3629 2277 - DUP
   .word _C_40            ; $362b 282D - C@
   .word _LIT             ; $362d 28C7 - LIT
   .word $002E            ; $362f 002E
   .word __3C_3E          ; $3631 2CFA - <>
   .word __28ABORT_22_29  ; $3633 2D61 - (ABORT")
   .byte 4," -? "
   .word _0               ; $363a 2B2B - 0
   .word _BRANCH          ; $363c 2904 - BRANCH
   .word $360D            ; $363e 360D
   .word _DROP            ; $3640 222D - DROP
   .word _R_3E            ; $3642 27BC - R>
   .word __3FBRANCH       ; $3644 2916 - ?BRANCH
   .word $364A            ; $3646 364A
   .word _DNEGATE         ; $3648 24C3 - DNEGATE
   .word _EXIT            ; $364a 21A8 - EXIT

NFA__3FSTACK:    ; 364C
   .byte 6,"?STACK"
   .word NFA_NUMBER       ; 35DB
__3FSTACK:       ; 3655 - 3677
   call _FCALL            ; 3655
   .word _SP_40           ; $3658 22D6 - SP@
   .word _S0              ; $365a 2088 - S0
   .word __40             ; $365c 2820 - @
   .word _SWAP            ; $365e 2238 - SWAP
   .word _U_3C            ; $3660 239D - U<
   .word __28ABORT_22_29  ; $3662 2D61 - (ABORT")
   .byte 16,"\xe9C\xfeEP\xf0AH\xe9E CTEKA"
   .word _EXIT            ; $3675 21A8 - EXIT

NFA_INTERPRET:   ; 3677
   .byte 9,"INTERPRET"
   .word NFA__3FSTACK       ; 364C
_INTERPRET:      ; 3683 - 36DA
   call _FCALL            ; 3683
   .word _LIT             ; $3686 28C7 - LIT
   .word $6004            ; $3688 6004
   .word __40             ; $368a 2820 - @
   .word __3FDUP          ; $368c 2284 - ?DUP
   .word __3FBRANCH       ; $368e 2916 - ?BRANCH
   .word $3696            ; $3690 3696
   .word _EXECUTE         ; $3692 21BF - EXECUTE
   .word _EXIT            ; $3694 21A8 - EXIT
   .word _BL              ; $3696 3289 - BL
   .word _WORD            ; $3698 302A - WORD
   .word _FIND            ; $369a 3373 - FIND
   .word _DUP             ; $369c 2277 - DUP
   .word __3FBRANCH       ; $369e 2916 - ?BRANCH
   .word $36BA            ; $36a0 36BA
   .word _0_3C            ; $36a2 23E0 - 0<
   .word _STATE           ; $36a4 20D5 - STATE
   .word __40             ; $36a6 2820 - @
   .word _AND             ; $36a8 2764 - AND
   .word __3FBRANCH       ; $36aa 2916 - ?BRANCH
   .word $36B4            ; $36ac 36B4
   .word __2C             ; $36ae 2B80 - ,
   .word _BRANCH          ; $36b0 2904 - BRANCH
   .word $36B6            ; $36b2 36B6
   .word _EXECUTE         ; $36b4 21BF - EXECUTE
   .word _BRANCH          ; $36b6 2904 - BRANCH
   .word $36D2            ; $36b8 36D2
   .word _DROP            ; $36ba 222D - DROP
   .word _NUMBER          ; $36bc 35E4 - NUMBER
   .word _DPL             ; $36be 20FE - DPL
   .word __40             ; $36c0 2820 - @
   .word _1_2B            ; $36c2 231A - 1+
   .word __3FBRANCH       ; $36c4 2916 - ?BRANCH
   .word $36CE            ; $36c6 36CE
   .word _DLITERAL        ; $36c8 3495 - DLITERAL
   .word _BRANCH          ; $36ca 2904 - BRANCH
   .word $36D2            ; $36cc 36D2
   .word _DROP            ; $36ce 222D - DROP
   .word _LITERAL         ; $36d0 3477 - LITERAL
   .word __3FSTACK        ; $36d2 3655 - ?STACK
   .word _BRANCH          ; $36d4 2904 - BRANCH
   .word $3696            ; $36d6 3696
   .word _EXIT            ; $36d8 21A8 - EXIT

NFA_CREATE:      ; 36DA
   .byte 6,"CREATE"
   .word NFA_INTERPRET    ; 3677
_CREATE:         ; 36E3 - 3718
   call _FCALL            ; 36E3
   .word _BL              ; $36e6 3289 - BL
   .word _WORD            ; $36e8 302A - WORD
   .word _DUP             ; $36ea 2277 - DUP
   .word _FIND            ; $36ec 3373 - FIND
   .word _PRESS           ; $36ee 22B4 - PRESS
   .word __3FBRANCH       ; $36f0 2916 - ?BRANCH
   .word $370C            ; $36f2 370C
   .word _DUP             ; $36f4 2277 - DUP
   .word _ID_2E           ; $36f6 32D0 - ID.
   .word __28_2E_22_29    ; $36f8 3421 - (.")
   .byte 15," \xf5\xf6E O\xf0PE\xe4E\xecEH "
   .word _CR              ; $370a 454C - CR
   .word _CURRENT         ; $370c 20F3 - CURRENT
   .word __40             ; $370e 2820 - @
   .word __2BWORD         ; $3710 33DE - +WORD
   .word _CFL             ; $3712 2F44 - CFL
   .word _ALLOT           ; $3714 2B73 - ALLOT
   .word _EXIT            ; $3716 21A8 - EXIT

NFA__3CBUILDS:   ; 3718
   .byte 7,"<BUILDS"
   .word NFA_CREATE       ; 36DA
__3CBUILDS:      ; 3722 - 3729
   call _FCALL            ; 3722
   .word _CREATE          ; $3725 36E3 - CREATE
   .word _EXIT            ; $3727 21A8 - EXIT

NFA__28DOES_3E_29:; 3729
   .byte 7,"(DOES>)"
   .word NFA__3CBUILDS      ; 3718
__28DOES_3E_29:  ; 3733 - 373C
   call _FCALL            ; 3733
   .word _R_3E            ; $3736 27BC - R>
   .word __28_21CODE_29   ; $3738 332F - (!CODE)
   .word _EXIT            ; $373a 21A8 - EXIT

NFA_DOES_3E:     ; 373C
   .byte 0x85,"DOES>" ; IMMEDIATE
   .word NFA__28DOES_3E_29      ; 3729
_DOES_3E:        ; 3744 - 3757
   call _FCALL            ; 3744
   .word _COMPILE         ; $3747 2BE9 - COMPILE
   .word __28DOES_3E_29   ; $3749 3733 - (DOES>)
   .word _CALL            ; $374b 2201 - CALL
   .word _HERE            ; $374d 2B62 - HERE
   .word __21CF           ; $374f 3314 - !CF
   .word _CFL             ; $3751 2F44 - CFL
   .word _ALLOT           ; $3753 2B73 - ALLOT
   .word _EXIT            ; $3755 21A8 - EXIT

NFA_CONSTANT:    ; 3757
   .byte 8,"CONSTANT"
   .word NFA_DOES_3E        ; 373C
_CONSTANT:       ; 3762 - 3771
   call _FCALL            ; 3762
   .word _CREATE          ; $3765 36E3 - CREATE
   .word __2C             ; $3767 2B80 - ,
   .word _LIT             ; $3769 28C7 - LIT
   .word __40             ; $376b 2820 - @
   .word __28_21CODE_29   ; $376d 332F - (!CODE)
   .word _EXIT            ; $376f 21A8 - EXIT

NFA_VARIABLE:    ; 3771
   .byte 8,"VARIABLE"
   .word NFA_CONSTANT     ; 3757
_VARIABLE:       ; 377C - 378B
   call _FCALL            ; 377C
   .word _CREATE          ; $377f 36E3 - CREATE
   .word _0               ; $3781 2B2B - 0
   .word __2C             ; $3783 2B80 - ,
   .word _NEXT            ; $3785 21F5 - NEXT
   .word __28_21CODE_29   ; $3787 332F - (!CODE)
   .word _EXIT            ; $3789 21A8 - EXIT

NFA_VOCABULARY:  ; 378B
   .byte 10,"VOCABULARY"
   .word NFA_VARIABLE     ; 3771
_VOCABULARY:     ; 3798 - 37DC
   call _FCALL            ; 3798
   .word _LIT             ; $379b 28C7 - LIT
   .word $6008            ; $379d 6008
   .word __40             ; $379f 2820 - @
   .word __3FDUP          ; $37a1 2284 - ?DUP
   .word __3FBRANCH       ; $37a3 2916 - ?BRANCH
   .word $37AB            ; $37a5 37AB
   .word _EXECUTE         ; $37a7 21BF - EXECUTE
   .word _EXIT            ; $37a9 21A8 - EXIT
   .word _CREATE          ; $37ab 36E3 - CREATE
   .word _LIT             ; $37ad 28C7 - LIT
   .word $0001            ; $37af 0001
   .word _C_2C            ; $37b1 2B92 - C,
   .word _LIT             ; $37b3 28C7 - LIT
   .word $0080            ; $37b5 0080
   .word _C_2C            ; $37b7 2B92 - C,
   .word _CURRENT         ; $37b9 20F3 - CURRENT
   .word __40             ; $37bb 2820 - @
   .word _2               ; $37bd 2B3D - 2
   .word __2D             ; $37bf 22F8 - -
   .word __2C             ; $37c1 2B80 - ,
   .word _HERE            ; $37c3 2B62 - HERE
   .word _VOC_2DLINK      ; $37c5 20A1 - VOC-LINK
   .word __40             ; $37c7 2820 - @
   .word __2C             ; $37c9 2B80 - ,
   .word _VOC_2DLINK      ; $37cb 20A1 - VOC-LINK
   .word __21             ; $37cd 2839 - !
   .word __28DOES_3E_29   ; $37cf 3733 - (DOES>)
VOCABULARY_DOES:
   call $218f      ; $37d1 cd 8f 21
   .word _2_2B            ; $37d4 2325 - 2+
   .word _CONTEXT         ; $37d6 20E4 - CONTEXT
   .word __21             ; $37d8 2839 - !
   .word _EXIT            ; $37da 21A8 - EXIT

NFA_STRING:      ; 37DC
   .byte 6,"STRING"
   .word NFA_VOCABULARY   ; 378B
_STRING:         ; 37E5 - 37F2
   call _FCALL            ; 37E5
   .word _CREATE          ; $37e8 36E3 - CREATE
   .word __22_2C          ; $37ea 2BA4 - ",
   .word _NEXT            ; $37ec 21F5 - NEXT
   .word __28_21CODE_29   ; $37ee 332F - (!CODE)
   .word _EXIT            ; $37f0 21A8 - EXIT

NFA__21CSP:      ; 37F2
   .byte 4,"!CSP"
   .word NFA_STRING       ; 37DC
__21CSP:         ; 37F9 - 3804
   call _FCALL            ; 37F9
   .word _SP_40           ; $37fc 22D6 - SP@
   .word _CSP             ; $37fe 2114 - CSP
   .word __21             ; $3800 2839 - !
   .word _EXIT            ; $3802 21A8 - EXIT

NFA__3FCSP:      ; 3804
   .byte 4,"?CSP"
   .word NFA__21CSP         ; 37F2
__3FCSP:         ; 380B - 382C
   call _FCALL            ; 380B
   .word _SP_40           ; $380e 22D6 - SP@
   .word _CSP             ; $3810 2114 - CSP
   .word __40             ; $3812 2820 - @
   .word _XOR             ; $3814 2787 - XOR
   .word __28ABORT_22_29  ; $3816 2D61 - (ABORT")
   .byte 17,"C",0xe2,"O",0xea," CTEKA ",0xf0,"O CSP"
   .word _EXIT            ; $382a 21A8 - EXIT

NFA__3FEXEC:     ; 382C
   .byte 5,"?EXEC"
   .word NFA__3FCSP         ; 3804
__3FEXEC:        ; 3834 - 385A
   call _FCALL            ; 3834
   .word _STATE           ; $3837 20D5 - STATE
   .word __40             ; $3839 2820 - @
   .word __28ABORT_22_29  ; $383b 2D61 - (ABORT")
   .byte 26," TPE",0xe2,0xf5,"ET PE",0xf6,0xe9,"MA B",0xf9,0xf0,"O",0xec,"HEH",0xe9,0xf1
   .word _EXIT            ; $3858 21A8 - EXIT

NFA__3FCOMP:     ; 385A
   .byte 5,"?COMP"
   .word NFA__3FEXEC        ; 382C
__3FCOMP:        ; 3862 - 388A
   call _FCALL            ; 3862
   .word _STATE           ; $3865 20D5 - STATE
   .word __40             ; $3867 2820 - @
   .word _0_3D            ; $3869 2421 - 0=
   .word __28ABORT_22_29  ; $386b 2D61 - (ABORT")
   .byte 26," TPE",0xe2,0xf5,"ET PE",0xf6,0xe9,"MA KOM",0xf0,0xe9,0xec,0xf1,0xe3,0xe9,0xe9
   .word _EXIT            ; $3888 21A8 - EXIT

NFA__3FPAIRS:    ; 388A
   .byte 6,"?PAIRS"
   .word NFA__3FCOMP        ; 385A
__3FPAIRS:       ; 3893 - 38AD
   call _FCALL            ; 3893
   .word _XOR             ; $3896 2787 - XOR
   .word __28ABORT_22_29  ; $3898 2D61 - (ABORT")
   .byte 16," HE",0xf0,"APHA",0xf1," CKO",0xe2,"KA"
   .word _EXIT            ; $38ab 21A8 - EXIT

NFA_LEAVE:       ; 38AD
   .byte 5,"LEAVE"
   .word NFA__3FPAIRS       ; 388A
_LEAVE:          ; 38B5 - 38C0
   call _FCALL            ; 38B5
   .word _RDROP           ; $38b8 2811 - RDROP
   .word _RDROP           ; $38ba 2811 - RDROP
   .word _RDROP           ; $38bc 2811 - RDROP
   .word _EXIT            ; $38be 21A8 - EXIT

NFA__3A:         ; 38C0
   .byte 0x81,":" ; IMMEDIATE
   .word NFA_LEAVE        ; 38AD
__3A:            ; 38C4 - 38DF
   call _FCALL            ; 38C4
   .word __3FEXEC         ; $38c7 3834 - ?EXEC
   .word __21CSP          ; $38c9 37F9 - !CSP
   .word _CURRENT         ; $38cb 20F3 - CURRENT
   .word __40             ; $38cd 2820 - @
   .word _CONTEXT         ; $38cf 20E4 - CONTEXT
   .word __21             ; $38d1 2839 - !
   .word _CREATE          ; $38d3 36E3 - CREATE
   .word _SMUDGE          ; $38d5 3343 - SMUDGE
   .word __5D             ; $38d7 3361 - ]
   .word _CALL            ; $38d9 2201 - CALL
   .word __28_21CODE_29   ; $38db 332F - (!CODE)
   .word _EXIT            ; $38dd 21A8 - EXIT

NFA__3B:         ; 38DF
   .byte 0x81,";" ; IMMEDIATE
   .word NFA__3A            ; 38C0
__3B:            ; 38E3 - 38F4
   call _FCALL            ; 38E3
   .word __3FCOMP         ; $38e6 3862 - ?COMP
   .word __3FCSP          ; $38e8 380B - ?CSP
   .word _COMPILE         ; $38ea 2BE9 - COMPILE
   .word _EXIT            ; $38ec 21A8 - EXIT
   .word _SMUDGE          ; $38ee 3343 - SMUDGE
   .word __5B             ; $38f0 3354 - [
   .word _EXIT            ; $38f2 21A8 - EXIT

NFA_IMMEDIATE:   ; 38F4
   .byte 9,"IMMEDIATE"
   .word NFA__3B            ; 38DF
_IMMEDIATE:      ; 3900 - 390D
   call _FCALL            ; 3900
   .word _LATEST          ; $3903 3303 - LATEST
   .word _LIT             ; $3905 28C7 - LIT
   .word $0080            ; $3907 0080
   .word _TOGGLE          ; $3909 2982 - TOGGLE
   .word _EXIT            ; $390b 21A8 - EXIT

NFA_DEPTH:       ; 390D
   .byte 5,"DEPTH"
   .word NFA_IMMEDIATE    ; 38F4
_DEPTH:          ; 3915 - 392A
   call _FCALL            ; 3915
   .word _SP_40           ; $3918 22D6 - SP@
   .word _S0              ; $391a 2088 - S0
   .word __40             ; $391c 2820 - @
   .word _SWAP            ; $391e 2238 - SWAP
   .word __2D             ; $3920 22F8 - -
   .word _2_2F            ; $3922 2460 - 2/
   .word _0               ; $3924 2B2B - 0
   .word _MAX             ; $3926 2381 - MAX
   .word _EXIT            ; $3928 21A8 - EXIT

NFA_C_22:        ; 392A
   .byte 0x82,"C\"" ; IMMEDIATE
   .word NFA_DEPTH        ; 390D
_C_22:           ; 392F - 393E
   call _FCALL            ; 392F
   .word _BL              ; $3932 3289 - BL
   .word _WORD            ; $3934 302A - WORD
   .word _1_2B            ; $3936 231A - 1+
   .word _C_40            ; $3938 282D - C@
   .word _LITERAL         ; $393a 3477 - LITERAL
   .word _EXIT            ; $393c 21A8 - EXIT

NFA__2E_22:      ; 393E
   .byte 0x82,".\"" ; IMMEDIATE
   .word NFA_C_22           ; 392A
__2E_22:         ; 3943 - 3956
   call _FCALL            ; 3943
   .word __3FCOMP         ; $3946 3862 - ?COMP
   .word _COMPILE         ; $3948 2BE9 - COMPILE
   .word __28_2E_22_29    ; $394a 3421 - (.")
   .word _LIT             ; $394c 28C7 - LIT
   .word $0022            ; $394e 0022
   .word _WORD            ; $3950 302A - WORD
   .word __22_2C          ; $3952 2BA4 - ",
   .word _EXIT            ; $3954 21A8 - EXIT

NFA__22:         ; 3956
   .byte 0x81,"\"" ; IMMEDIATE
   .word NFA__2E_22           ; 393E
__22:            ; 395A - 3989
   call _FCALL            ; 395A
   .word _STATE           ; $395d 20D5 - STATE
   .word __40             ; $395f 2820 - @
   .word __3FBRANCH       ; $3961 2916 - ?BRANCH
   .word $3975            ; $3963 3975
   .word _COMPILE         ; $3965 2BE9 - COMPILE
   .word __28_22_29       ; $3967 28EF - (")
   .word _LIT             ; $3969 28C7 - LIT
   .word $0022            ; $396b 0022
   .word _WORD            ; $396d 302A - WORD
   .word __22_2C          ; $396f 2BA4 - ",
   .word _BRANCH          ; $3971 2904 - BRANCH
   .word $3987            ; $3973 3987
   .word _LIT             ; $3975 28C7 - LIT
   .word $0022            ; $3977 0022
   .word _WORD            ; $3979 302A - WORD
   .word _PAD             ; $397b 2BBD - PAD
   .word _OVER            ; $397d 220D - OVER
   .word _C_40            ; $397f 282D - C@
   .word _1_2B            ; $3981 231A - 1+
   .word _CMOVE           ; $3983 2A28 - CMOVE
   .word _PAD             ; $3985 2BBD - PAD
   .word _EXIT            ; $3987 21A8 - EXIT

NFA__2E_28:      ; 3989
   .byte 0x82,".(" ; IMMEDIATE
   .word NFA__22            ; 3956
__2E_28:         ; 398E - 399D
   call _FCALL            ; 398E
   .word _LIT             ; $3991 28C7 - LIT
   .word $0029            ; $3993 0029
   .word _WORD            ; $3995 302A - WORD
   .word _COUNT           ; $3997 2BD2 - COUNT
   .word _TYPE            ; $3999 31B4 - TYPE
   .word _EXIT            ; $399b 21A8 - EXIT

NFA__3EMARK:     ; 399D
   .byte 5,">MARK"
   .word NFA__2E_28           ; 3989
__3EMARK:        ; 39A5 - 39B0
   call _FCALL            ; 39A5
   .word _HERE            ; $39a8 2B62 - HERE
   .word _0               ; $39aa 2B2B - 0
   .word __2C             ; $39ac 2B80 - ,
   .word _EXIT            ; $39ae 21A8 - EXIT

NFA__3ERESOLVE:  ; 39B0
   .byte 8,">RESOLVE"
   .word NFA__3EMARK        ; 399D
__3ERESOLVE:     ; 39BB - 39C6
   call _FCALL            ; 39BB
   .word _HERE            ; $39be 2B62 - HERE
   .word _SWAP            ; $39c0 2238 - SWAP
   .word __21             ; $39c2 2839 - !
   .word _EXIT            ; $39c4 21A8 - EXIT

NFA__3CMARK:     ; 39C6
   .byte 5,"<MARK"
   .word NFA__3ERESOLVE     ; 39B0
__3CMARK:        ; 39CE - 39D5
   call _FCALL            ; 39CE
   .word _HERE            ; $39d1 2B62 - HERE
   .word _EXIT            ; $39d3 21A8 - EXIT

NFA__3CRESOLVE:  ; 39D5
   .byte 8,"<RESOLVE"
   .word NFA__3CMARK        ; 39C6
__3CRESOLVE:     ; 39E0 - 39E7
   call _FCALL            ; 39E0
   .word __2C             ; $39e3 2B80 - ,
   .word _EXIT            ; $39e5 21A8 - EXIT

NFA_IF:          ; 39E7
   .byte 0x82,"IF" ; IMMEDIATE
   .word NFA__3CRESOLVE     ; 39D5
_IF:             ; 39EC - 39FB
   call _FCALL            ; 39EC
   .word __3FCOMP         ; $39ef 3862 - ?COMP
   .word _COMPILE         ; $39f1 2BE9 - COMPILE
   .word __3FBRANCH       ; $39f3 2916 - ?BRANCH
   .word __3EMARK         ; $39f5 39A5 - >MARK
   .word _2               ; $39f7 2B3D - 2
   .word _EXIT            ; $39f9 21A8 - EXIT

NFA_IFNOT:       ; 39FB
   .byte 0x85,"IFNOT" ; IMMEDIATE
   .word NFA_IF           ; 39E7
_IFNOT:          ; 3A03 - 3A12
   call _FCALL            ; 3A03
   .word __3FCOMP         ; $3a06 3862 - ?COMP
   .word _COMPILE         ; $3a08 2BE9 - COMPILE
   .word _N_3FBRANCH      ; $3a0a 2934 - N?BRANCH
   .word __3EMARK         ; $3a0c 39A5 - >MARK
   .word _2               ; $3a0e 2B3D - 2
   .word _EXIT            ; $3a10 21A8 - EXIT

NFA_ELSE:        ; 3A12
   .byte 0x84,"ELSE" ; IMMEDIATE
   .word NFA_IFNOT        ; 39FB
_ELSE:           ; 3A19 - 3A30
   call _FCALL            ; 3A19
   .word __3FCOMP         ; $3a1c 3862 - ?COMP
   .word _2               ; $3a1e 2B3D - 2
   .word __3FPAIRS        ; $3a20 3893 - ?PAIRS
   .word _COMPILE         ; $3a22 2BE9 - COMPILE
   .word _BRANCH          ; $3a24 2904 - BRANCH
   .word __3EMARK         ; $3a26 39A5 - >MARK
   .word _SWAP            ; $3a28 2238 - SWAP
   .word __3ERESOLVE      ; $3a2a 39BB - >RESOLVE
   .word _2               ; $3a2c 2B3D - 2
   .word _EXIT            ; $3a2e 21A8 - EXIT

NFA_THEN:        ; 3A30
   .byte 0x84,"THEN" ; IMMEDIATE
   .word NFA_ELSE         ; 3A12
_THEN:           ; 3A37 - 3A44
   call _FCALL            ; 3A37
   .word __3FCOMP         ; $3a3a 3862 - ?COMP
   .word _2               ; $3a3c 2B3D - 2
   .word __3FPAIRS        ; $3a3e 3893 - ?PAIRS
   .word __3ERESOLVE      ; $3a40 39BB - >RESOLVE
   .word _EXIT            ; $3a42 21A8 - EXIT

NFA_BEGIN:       ; 3A44
   .byte 0x85,"BEGIN" ; IMMEDIATE
   .word NFA_THEN         ; 3A30
_BEGIN:          ; 3A4C - 3A57
   call _FCALL            ; 3A4C
   .word __3FCOMP         ; $3a4f 3862 - ?COMP
   .word __3CMARK         ; $3a51 39CE - <MARK
   .word _1               ; $3a53 2B34 - 1
   .word _EXIT            ; $3a55 21A8 - EXIT

NFA_AGAIN:       ; 3A57
   .byte 0x85,"AGAIN" ; IMMEDIATE
   .word NFA_BEGIN        ; 3A44
_AGAIN:          ; 3A5F - 3A70
   call _FCALL            ; 3A5F
   .word __3FCOMP         ; $3a62 3862 - ?COMP
   .word _1               ; $3a64 2B34 - 1
   .word __3FPAIRS        ; $3a66 3893 - ?PAIRS
   .word _COMPILE         ; $3a68 2BE9 - COMPILE
   .word _BRANCH          ; $3a6a 2904 - BRANCH
   .word __3CRESOLVE      ; $3a6c 39E0 - <RESOLVE
   .word _EXIT            ; $3a6e 21A8 - EXIT

NFA_DO:          ; 3A70
   .byte 0x82,"DO" ; IMMEDIATE
   .word NFA_AGAIN        ; 3A57
_DO:             ; 3A75 - 3A88
   call _FCALL            ; 3A75
   .word __3FCOMP         ; $3a78 3862 - ?COMP
   .word _COMPILE         ; $3a7a 2BE9 - COMPILE
   .word __28DO_29        ; $3a7c 2991 - (DO)
   .word __3EMARK         ; $3a7e 39A5 - >MARK
   .word __3CMARK         ; $3a80 39CE - <MARK
   .word _LIT             ; $3a82 28C7 - LIT
   .word $0003            ; $3a84 0003
   .word _EXIT            ; $3a86 21A8 - EXIT

NFA__3FDO:       ; 3A88
   .byte 0x83,"?DO" ; IMMEDIATE
   .word NFA_DO           ; 3A70
__3FDO:          ; 3A8E - 3AA1
   call _FCALL            ; 3A8E
   .word __3FCOMP         ; $3a91 3862 - ?COMP
   .word _COMPILE         ; $3a93 2BE9 - COMPILE
   .word __28_3FDO_29     ; $3a95 29B8 - (?DO)
   .word __3EMARK         ; $3a97 39A5 - >MARK
   .word __3CMARK         ; $3a99 39CE - <MARK
   .word _LIT             ; $3a9b 28C7 - LIT
   .word $0003            ; $3a9d 0003
   .word _EXIT            ; $3a9f 21A8 - EXIT

NFA_LOOP:        ; 3AA1
   .byte 0x84,"LOOP" ; IMMEDIATE
   .word NFA__3FDO          ; 3A88
_LOOP:           ; 3AA8 - 3ABD
   call _FCALL            ; 3AA8
   .word __3FCOMP         ; $3aab 3862 - ?COMP
   .word _LIT             ; $3aad 28C7 - LIT
   .word $0003            ; $3aaf 0003
   .word __3FPAIRS        ; $3ab1 3893 - ?PAIRS
   .word _COMPILE         ; $3ab3 2BE9 - COMPILE
   .word __28LOOP_29      ; $3ab5 29DA - (LOOP)
   .word __3CRESOLVE      ; $3ab7 39E0 - <RESOLVE
   .word __3ERESOLVE      ; $3ab9 39BB - >RESOLVE
   .word _EXIT            ; $3abb 21A8 - EXIT

NFA__2BLOOP:     ; 3ABD
   .byte 0x85,"+LOOP" ; IMMEDIATE
   .word NFA_LOOP         ; 3AA1
__2BLOOP:        ; 3AC5 - 3ADA
   call _FCALL            ; 3AC5
   .word __3FCOMP         ; $3ac8 3862 - ?COMP
   .word _LIT             ; $3aca 28C7 - LIT
   .word $0003            ; $3acc 0003
   .word __3FPAIRS        ; $3ace 3893 - ?PAIRS
   .word _COMPILE         ; $3ad0 2BE9 - COMPILE
   .word __28_2BLOOP_29   ; $3ad2 2A0F - (+LOOP)
   .word __3CRESOLVE      ; $3ad4 39E0 - <RESOLVE
   .word __3ERESOLVE      ; $3ad6 39BB - >RESOLVE
   .word _EXIT            ; $3ad8 21A8 - EXIT

NFA_UNTIL:       ; 3ADA
   .byte 0x85,"UNTIL" ; IMMEDIATE
   .word NFA__2BLOOP        ; 3ABD
_UNTIL:          ; 3AE2 - 3AF3
   call _FCALL            ; 3AE2
   .word __3FCOMP         ; $3ae5 3862 - ?COMP
   .word _1               ; $3ae7 2B34 - 1
   .word __3FPAIRS        ; $3ae9 3893 - ?PAIRS
   .word _COMPILE         ; $3aeb 2BE9 - COMPILE
   .word __3FBRANCH       ; $3aed 2916 - ?BRANCH
   .word __3CRESOLVE      ; $3aef 39E0 - <RESOLVE
   .word _EXIT            ; $3af1 21A8 - EXIT

NFA_WHILE:       ; 3AF3
   .byte 0x85,"WHILE" ; IMMEDIATE
   .word NFA_UNTIL        ; 3ADA
_WHILE:          ; 3AFB - 3B0C
   call _FCALL            ; 3AFB
   .word __3FCOMP         ; $3afe 3862 - ?COMP
   .word _1               ; $3b00 2B34 - 1
   .word __3FPAIRS        ; $3b02 3893 - ?PAIRS
   .word _1               ; $3b04 2B34 - 1
   .word _IF              ; $3b06 39EC - IF
   .word _2_2B            ; $3b08 2325 - 2+
   .word _EXIT            ; $3b0a 21A8 - EXIT

NFA_REPEAT:      ; 3B0C
   .byte 0x86,"REPEAT" ; IMMEDIATE
   .word NFA_WHILE        ; 3AF3
_REPEAT:         ; 3B15 - 3B2A
   call _FCALL            ; 3B15
   .word __3FCOMP         ; $3b18 3862 - ?COMP
   .word __3ER            ; $3b1a 27A9 - >R
   .word __3ER            ; $3b1c 27A9 - >R
   .word _AGAIN           ; $3b1e 3A5F - AGAIN
   .word _R_3E            ; $3b20 27BC - R>
   .word _R_3E            ; $3b22 27BC - R>
   .word _2_2D            ; $3b24 233C - 2-
   .word _THEN            ; $3b26 3A37 - THEN
   .word _EXIT            ; $3b28 21A8 - EXIT

NFA_DUMP:        ; 3B2A
   .byte 4,"DUMP"
   .word NFA_REPEAT       ; 3B0C
_DUMP:           ; 3B31 - 3BA4
   call _FCALL            ; 3B31
   .word _BASE            ; $3b34 20C8 - BASE
   .word __40             ; $3b36 2820 - @
   .word __2DROT          ; $3b38 2269 - -ROT
   .word _HEX             ; $3b3a 3260 - HEX
   .word _LIT             ; $3b3c 28C7 - LIT
   .word $0010            ; $3b3e 0010
   .word _U_2F            ; $3b40 2C62 - U/
   .word _1_2B            ; $3b42 231A - 1+
   .word _0               ; $3b44 2B2B - 0
   .word __28DO_29        ; $3b46 2991 - (DO)
   .word $3B9C            ; $3b48 3B9C
   .word _CR              ; $3b4a 454C - CR
   .word _DUP             ; $3b4c 2277 - DUP
   .word _DUP             ; $3b4e 2277 - DUP
   .word _LIT             ; $3b50 28C7 - LIT
   .word $0004            ; $3b52 0004
   .word __2E0            ; $3b54 2EEA - .0
   .word _SPACE           ; $3b56 32A7 - SPACE
   .word _SPACE           ; $3b58 32A7 - SPACE
   .word _LIT             ; $3b5a 28C7 - LIT
   .word $0004            ; $3b5c 0004
   .word _0               ; $3b5e 2B2B - 0
   .word __28DO_29        ; $3b60 2991 - (DO)
   .word $3B84            ; $3b62 3B84
   .word _LIT             ; $3b64 28C7 - LIT
   .word $0004            ; $3b66 0004
   .word _0               ; $3b68 2B2B - 0
   .word __28DO_29        ; $3b6a 2991 - (DO)
   .word $3B7E            ; $3b6c 3B7E
   .word _DUP             ; $3b6e 2277 - DUP
   .word _C_40            ; $3b70 282D - C@
   .word _2               ; $3b72 2B3D - 2
   .word __2E0            ; $3b74 2EEA - .0
   .word _SPACE           ; $3b76 32A7 - SPACE
   .word _1_2B            ; $3b78 231A - 1+
   .word __28LOOP_29      ; $3b7a 29DA - (LOOP)
   .word $3B6E            ; $3b7c 3B6E
   .word _SPACE           ; $3b7e 32A7 - SPACE
   .word __28LOOP_29      ; $3b80 29DA - (LOOP)
   .word $3B64            ; $3b82 3B64
   .word _SWAP            ; $3b84 2238 - SWAP
   .word _LIT             ; $3b86 28C7 - LIT
   .word $002A            ; $3b88 002A
   .word _EMIT            ; $3b8a 3189 - EMIT
   .word _LIT             ; $3b8c 28C7 - LIT
   .word $0010            ; $3b8e 0010
   .word _PTYPE           ; $3b90 3157 - PTYPE
   .word _LIT             ; $3b92 28C7 - LIT
   .word $002A            ; $3b94 002A
   .word _EMIT            ; $3b96 3189 - EMIT
   .word __28LOOP_29      ; $3b98 29DA - (LOOP)
   .word $3B4A            ; $3b9a 3B4A
   .word _DROP            ; $3b9c 222D - DROP
   .word _BASE            ; $3b9e 20C8 - BASE
   .word __21             ; $3ba0 2839 - !
   .word _EXIT            ; $3ba2 21A8 - EXIT

NFA_NLIST:       ; 3BA4
   .byte 5,"NLIST"
   .word NFA_DUMP         ; 3B2A
_NLIST:          ; 3BAC - 3BF5
   call _FCALL            ; 3BAC
   .word __40             ; $3baf 2820 - @
   .word _DUP             ; $3bb1 2277 - DUP
   .word __3FBRANCH       ; $3bb3 2916 - ?BRANCH
   .word $3BF1            ; $3bb5 3BF1
   .word _DUP             ; $3bb7 2277 - DUP
   .word _COUNT           ; $3bb9 2BD2 - COUNT
   .word _LIT             ; $3bbb 28C7 - LIT
   .word $003F            ; $3bbd 003F
   .word _AND             ; $3bbf 2764 - AND
   .word _DUP             ; $3bc1 2277 - DUP
   .word _LIT             ; $3bc3 28C7 - LIT
   .word $0008            ; $3bc5 0008
   .word __2F             ; $3bc7 2C2F - /
   .word _1_2B            ; $3bc9 231A - 1+
   .word _LIT             ; $3bcb 28C7 - LIT
   .word $0008            ; $3bcd 0008
   .word __2A             ; $3bcf 253C - *
   .word _OVER            ; $3bd1 220D - OVER
   .word __2D             ; $3bd3 22F8 - -
   .word __2DROT          ; $3bd5 2269 - -ROT
   .word _TYPE            ; $3bd7 31B4 - TYPE
   .word _SPACES          ; $3bd9 32B9 - SPACES
   .word _N_3ELINK        ; $3bdb 3008 - N>LINK
   .word __3EOUT          ; $3bdd 216B - >OUT
   .word __40             ; $3bdf 2820 - @
   .word _LIT             ; $3be1 28C7 - LIT
   .word $0040            ; $3be3 0040
   .word _U_3C            ; $3be5 239D - U<
   .word _N_3FBRANCH      ; $3be7 2934 - N?BRANCH
   .word $3BED            ; $3be9 3BED
   .word _CR              ; $3beb 454C - CR
   .word _BRANCH          ; $3bed 2904 - BRANCH
   .word $3BAF            ; $3bef 3BAF
   .word _DROP            ; $3bf1 222D - DROP
   .word _EXIT            ; $3bf3 21A8 - EXIT

NFA_VLIST:       ; 3BF5
   .byte 5,"VLIST"
   .word NFA_NLIST        ; 3BA4
_VLIST:          ; 3BFD - 3C08
   call _FCALL            ; 3BFD
   .word _CONTEXT         ; $3c00 20E4 - CONTEXT
   .word __40             ; $3c02 2820 - @
   .word _NLIST           ; $3c04 3BAC - NLIST
   .word _EXIT            ; $3c06 21A8 - EXIT

NFA__2D_2D:      ; 3C08
   .byte 0x82,"--" ; IMMEDIATE
   .word NFA_VLIST        ; 3BF5
__2D_2D:         ; 3C0D - 3C1A
   call _FCALL            ; 3C0D
   .word __23TIB          ; $3c10 2148 - #TIB
   .word __40             ; $3c12 2820 - @
   .word __3EIN           ; $3c14 2153 - >IN
   .word __21             ; $3c16 2839 - !
   .word _EXIT            ; $3c18 21A8 - EXIT

NFA_S_2E:        ; 3C1A
   .byte 2,"S."
   .word NFA__2D_2D           ; 3C08
_S_2E:           ; 3C1F - 3C58
   call _FCALL            ; 3C1F
   .word _DEPTH           ; $3c22 3915 - DEPTH
   .word __3FDUP          ; $3c24 2284 - ?DUP
   .word __3FBRANCH       ; $3c26 2916 - ?BRANCH
   .word $3C48            ; $3c28 3C48
   .word _1_2B            ; $3c2a 231A - 1+
   .word _1               ; $3c2c 2B34 - 1
   .word __28DO_29        ; $3c2e 2991 - (DO)
   .word $3C44            ; $3c30 3C44
   .word _S0              ; $3c32 2088 - S0
   .word __40             ; $3c34 2820 - @
   .word _I               ; $3c36 294B - I
   .word _2_2A            ; $3c38 2348 - 2*
   .word __2D             ; $3c3a 22F8 - -
   .word __40             ; $3c3c 2820 - @
   .word __2E             ; $3c3e 2F15 - .
   .word __28LOOP_29      ; $3c40 29DA - (LOOP)
   .word $3C32            ; $3c42 3C32
   .word _BRANCH          ; $3c44 2904 - BRANCH
   .word $3C56            ; $3c46 3C56
   .word __28_2E_22_29    ; $3c48 3421 - (.")
   .byte 9,"CTEK ",0xf0,0xf5,"CT"
   .word _CR              ; $3c54 454C - CR
   .word _EXIT            ; $3c56 21A8 - EXIT

NFA__28:         ; 3C58
   .byte 0x81,"(" ; IMMEDIATE
   .word NFA_S_2E           ; 3C1A
__28:            ; 3C5C - 3C69
   call _FCALL            ; 3C5C
   .word _LIT             ; $3c5f 28C7 - LIT
   .word $0029            ; $3c61 0029
   .word _WORD            ; $3c63 302A - WORD
   .word _DROP            ; $3c65 222D - DROP
   .word _EXIT            ; $3c67 21A8 - EXIT

NFA__3FCURRENT:  ; 3C69
   .byte 8,"?CURRENT"
   .word NFA__28            ; 3C58
__3FCURRENT:     ; 3C74 - 3C88
   call _FCALL            ; 3C74
   .word _CURRENT         ; $3c77 20F3 - CURRENT
   .word __40             ; $3c79 2820 - @
   .word __3FWORD         ; $3c7b 26DB - ?WORD
   .word _0_3D            ; $3c7d 2421 - 0=
   .word __28ABORT_22_29  ; $3c7f 2D61 - (ABORT")
   .byte 4," - ?"
   .word _EXIT            ; $3c86 21A8 - EXIT

NFA_SCRATCH:     ; 3C88
   .byte 0x87,"SCRATCH" ; IMMEDIATE
   .word NFA__3FCURRENT     ; 3C69
_SCRATCH:        ; 3C92 - 3CAC
   call _FCALL            ; 3C92
   .word __3FEXEC         ; $3c95 3834 - ?EXEC
   .word _BL              ; $3c97 3289 - BL
   .word _WORD            ; $3c99 302A - WORD
   .word _CURRENT         ; $3c9b 20F3 - CURRENT
   .word __40             ; $3c9d 2820 - @
   .word __2DWORD         ; $3c9f 33FB - -WORD
   .word _0_3D            ; $3ca1 2421 - 0=
   .word __28ABORT_22_29  ; $3ca3 2D61 - (ABORT")
   .byte 4," - ?"
   .word _EXIT            ; $3caa 21A8 - EXIT

NFA_JOIN:        ; 3CAC
   .byte 0x84,"JOIN" ; IMMEDIATE
   .word NFA_SCRATCH      ; 3C88
_JOIN:           ; 3CB3 - 3CCA
   call _FCALL            ; 3CB3
   .word __3FEXEC         ; $3cb6 3834 - ?EXEC
   .word _BL              ; $3cb8 3289 - BL
   .word _WORD            ; $3cba 302A - WORD
   .word __3FCURRENT      ; $3cbc 3C74 - ?CURRENT
   .word _N_3ELINK        ; $3cbe 3008 - N>LINK
   .word __40             ; $3cc0 2820 - @
   .word _LATEST          ; $3cc2 3303 - LATEST
   .word _N_3ELINK        ; $3cc4 3008 - N>LINK
   .word __21             ; $3cc6 2839 - !
   .word _EXIT            ; $3cc8 21A8 - EXIT

NFA_NEW:         ; 3CCA
   .byte 0x83,"NEW" ; IMMEDIATE
   .word NFA_JOIN         ; 3CAC
_NEW:            ; 3CD0 - 3D07
   call _FCALL            ; 3CD0
   .word __3FEXEC         ; $3cd3 3834 - ?EXEC
   .word _BL              ; $3cd5 3289 - BL
   .word _WORD            ; $3cd7 302A - WORD
   .word _DUP             ; $3cd9 2277 - DUP
   .word __3FCURRENT      ; $3cdb 3C74 - ?CURRENT
   .word _CURRENT         ; $3cdd 20F3 - CURRENT
   .word __40             ; $3cdf 2820 - @
   .word __3ER            ; $3ce1 27A9 - >R
   .word _DUP             ; $3ce3 2277 - DUP
   .word _N_3ELINK        ; $3ce5 3008 - N>LINK
   .word _CURRENT         ; $3ce7 20F3 - CURRENT
   .word __21             ; $3ce9 2839 - !
   .word _NAME_3E         ; $3ceb 2FD6 - NAME>
   .word _SWAP            ; $3ced 2238 - SWAP
   .word __3FCURRENT      ; $3cef 3C74 - ?CURRENT
   .word _NAME_3E         ; $3cf1 2FD6 - NAME>
   .word _LIT             ; $3cf3 28C7 - LIT
   .word $00C3            ; $3cf5 00C3
   .word _OVER            ; $3cf7 220D - OVER
   .word _C_21            ; $3cf9 2846 - C!
   .word _1_2B            ; $3cfb 231A - 1+
   .word __21             ; $3cfd 2839 - !
   .word _R_3E            ; $3cff 27BC - R>
   .word _CURRENT         ; $3d01 20F3 - CURRENT
   .word __21             ; $3d03 2839 - !
   .word _EXIT            ; $3d05 21A8 - EXIT

NFA_FORGET:      ; 3D07
   .byte 6,"FORGET"
   .word NFA_NEW          ; 3CCA
_FORGET:         ; 3D10 - 3D80
   call _FCALL            ; 3D10
   .word _BL              ; $3d13 3289 - BL
   .word _WORD            ; $3d15 302A - WORD
   .word __3FCURRENT      ; $3d17 3C74 - ?CURRENT
   .word _DUP             ; $3d19 2277 - DUP
   .word _FENCE           ; $3d1b 20AE - FENCE
   .word __40             ; $3d1d 2820 - @
   .word _U_3C            ; $3d1f 239D - U<
   .word __28ABORT_22_29  ; $3d21 2D61 - (ABORT")
   .byte 14,"B",0xf9,"XO",0xe4," ",0xfa,"A FENCE"
   .word __3ER            ; $3d32 27A9 - >R
   .word _VOC_2DLINK      ; $3d34 20A1 - VOC-LINK
   .word __40             ; $3d36 2820 - @
   .word _R_40            ; $3d38 27CF - R@
   .word _OVER            ; $3d3a 220D - OVER
   .word _U_3C            ; $3d3c 239D - U<
   .word __3FBRANCH       ; $3d3e 2916 - ?BRANCH
   .word $3D52            ; $3d40 3D52
   .word _FORTH           ; $3d42 604C - FORTH
   .word _DEFINITIONS     ; $3d44 32ED - DEFINITIONS
   .word __40             ; $3d46 2820 - @
   .word _DUP             ; $3d48 2277 - DUP
   .word _VOC_2DLINK      ; $3d4a 20A1 - VOC-LINK
   .word __21             ; $3d4c 2839 - !
   .word _BRANCH          ; $3d4e 2904 - BRANCH
   .word $3D38            ; $3d50 3D38
   .word _DUP             ; $3d52 2277 - DUP
   .word _LIT             ; $3d54 28C7 - LIT
   .word $0004            ; $3d56 0004
   .word __2D             ; $3d58 22F8 - -
   .word _N_3ELINK        ; $3d5a 3008 - N>LINK
   .word __40             ; $3d5c 2820 - @
   .word _DUP             ; $3d5e 2277 - DUP
   .word _R_40            ; $3d60 27CF - R@
   .word _U_3C            ; $3d62 239D - U<
   .word __3FBRANCH       ; $3d64 2916 - ?BRANCH
   .word $3D5A            ; $3d66 3D5A
   .word _OVER            ; $3d68 220D - OVER
   .word _2_2D            ; $3d6a 233C - 2-
   .word __21             ; $3d6c 2839 - !
   .word __40             ; $3d6e 2820 - @
   .word __3FDUP          ; $3d70 2284 - ?DUP
   .word _0_3D            ; $3d72 2421 - 0=
   .word __3FBRANCH       ; $3d74 2916 - ?BRANCH
   .word $3D52            ; $3d76 3D52
   .word _R_3E            ; $3d78 27BC - R>
   .word _H               ; $3d7a 2091 - H
   .word __21             ; $3d7c 2839 - !
   .word _EXIT            ; $3d7e 21A8 - EXIT

NFA__3FNAME:     ; 3D80
   .byte 5,"?NAME"
   .word NFA_FORGET       ; 3D07
__3FNAME:        ; 3D88 - 3DE5
   call _FCALL            ; 3D88
   .word _F_2DCODE        ; $3d8b 323B - F-CODE
   .word _OVER            ; $3d8d 220D - OVER
   .word _U_3C            ; $3d8f 239D - U<
   .word _OVER            ; $3d91 220D - OVER
   .word _F_2DDATA        ; $3d93 3249 - F-DATA
   .word _LIT             ; $3d95 28C7 - LIT
   .word $3000            ; $3d97 3000
   .word __2B             ; $3d99 22ED - +
   .word _U_3C            ; $3d9b 239D - U<
   .word _AND             ; $3d9d 2764 - AND
   .word __3FBRANCH       ; $3d9f 2916 - ?BRANCH
   .word $3DE1            ; $3da1 3DE1
   .word _DUP             ; $3da3 2277 - DUP
   .word _2_2D            ; $3da5 233C - 2-
   .word _1_2D            ; $3da7 2331 - 1-
   .word _LIT             ; $3da9 28C7 - LIT
   .word $0010            ; $3dab 0010
   .word _1               ; $3dad 2B34 - 1
   .word __28DO_29        ; $3daf 2991 - (DO)
   .word $3DD9            ; $3db1 3DD9
   .word _1_2D            ; $3db3 2331 - 1-
   .word _DUP             ; $3db5 2277 - DUP
   .word _C_40            ; $3db7 282D - C@
   .word _LIT             ; $3db9 28C7 - LIT
   .word $007F            ; $3dbb 007F
   .word _AND             ; $3dbd 2764 - AND
   .word _I               ; $3dbf 294B - I
   .word __3D             ; $3dc1 2409 - =
   .word __3FBRANCH       ; $3dc3 2916 - ?BRANCH
   .word $3DD5            ; $3dc5 3DD5
   .word _PRESS           ; $3dc7 22B4 - PRESS
   .word _ID_2E           ; $3dc9 32D0 - ID.
   .word _SPACE           ; $3dcb 32A7 - SPACE
   .word _RDROP           ; $3dcd 2811 - RDROP
   .word _RDROP           ; $3dcf 2811 - RDROP
   .word _RDROP           ; $3dd1 2811 - RDROP
   .word _EXIT            ; $3dd3 21A8 - EXIT
   .word __28LOOP_29      ; $3dd5 29DA - (LOOP)
   .word $3DB3            ; $3dd7 3DB3
   .word _DROP            ; $3dd9 222D - DROP
   .word __2E             ; $3ddb 2F15 - .
   .word _BRANCH          ; $3ddd 2904 - BRANCH
   .word $3DE3            ; $3ddf 3DE3
   .word __2E             ; $3de1 2F15 - .
   .word _EXIT            ; $3de3 21A8 - EXIT

NFA_STR:         ; 3DE5
   .byte 3,"STR"
   .word NFA__3FNAME        ; 3D80
_STR:            ; 3DEB - 3E04
   call _FCALL            ; 3DEB
   .word _DUP             ; $3dee 2277 - DUP
   .word _ID_2E           ; $3df0 32D0 - ID.
   .word _LIT             ; $3df2 28C7 - LIT
   .word $0022            ; $3df4 0022
   .word _EMIT            ; $3df6 3189 - EMIT
   .word _SPACE           ; $3df8 32A7 - SPACE
   .word _DUP             ; $3dfa 2277 - DUP
   .word _C_40            ; $3dfc 282D - C@
   .word _1_2B            ; $3dfe 231A - 1+
   .word __2B             ; $3e00 22ED - +
   .word _EXIT            ; $3e02 21A8 - EXIT

NFA_DISFORT:     ; 3E04
   .byte 7,"DISFORT"
   .word NFA_STR          ; 3DE5
_DISFORT:        ; 3E0E - 3F7E
   call _FCALL            ; 3E0E
   .word _CR              ; $3e11 454C - CR
   .word __3ER            ; $3e13 27A9 - >R
   .word _R_40            ; $3e15 27CF - R@
   .word _C_40            ; $3e17 282D - C@
   .word _LIT             ; $3e19 28C7 - LIT
   .word $00CD            ; $3e1b 00CD
   .word __3C_3E          ; $3e1d 2CFA - <>
   .word __3FBRANCH       ; $3e1f 2916 - ?BRANCH
   .word $3E44            ; $3e21 3E44
   .word _R_3E            ; $3e23 27BC - R>
   .word __3FNAME         ; $3e25 3D88 - ?NAME
   .word __28_2E_22_29    ; $3e27 3421 - (.")
   .byte 24,"ACCEM",0xe2,0xec,"EPHOE O",0xf0,"PE",0xe4,"E",0xec,"EH",0xe9,"E"
   .word _EXIT            ; $3e42 21A8 - EXIT
   .word _R_40            ; $3e44 27CF - R@
   .word _1_2B            ; $3e46 231A - 1+
   .word __40             ; $3e48 2820 - @
   .word _DUP             ; $3e4a 2277 - DUP
   .word _CALL            ; $3e4c 2201 - CALL
   .word __3D             ; $3e4e 2409 - =
   .word __3FBRANCH       ; $3e50 2916 - ?BRANCH
   .word $3F16            ; $3e52 3F16
   .word __28_2E_22_29    ; $3e54 3421 - (.")
   .byte 2,": "
   .word _DROP            ; $3e59 222D - DROP
   .word _R_3E            ; $3e5b 27BC - R>
   .word _DUP             ; $3e5d 2277 - DUP
   .word __3FNAME         ; $3e5f 3D88 - ?NAME
   .word _CFL             ; $3e61 2F44 - CFL
   .word __2B             ; $3e63 22ED - +
   .word _DUP             ; $3e65 2277 - DUP
   .word __40             ; $3e67 2820 - @
   .word _LIT             ; $3e69 28C7 - LIT
   .word _EXIT            ; $3e6b 21A8 - EXIT
   .word __3C_3E          ; $3e6d 2CFA - <>
   .word __3FBRANCH       ; $3e6f 2916 - ?BRANCH
   .word $3F0A            ; $3e71 3F0A
   .word _DUP             ; $3e73 2277 - DUP
   .word _DUP             ; $3e75 2277 - DUP
   .word __40             ; $3e77 2820 - @
   .word _LIT             ; $3e79 28C7 - LIT
   .word __28_22_29       ; $3e7b 28EF - (")
   .word __3D             ; $3e7d 2409 - =
   .word __3FBRANCH       ; $3e7f 2916 - ?BRANCH
   .word $3E93            ; $3e81 3E93
   .word _LIT             ; $3e83 28C7 - LIT
   .word $0022            ; $3e85 0022
   .word _EMIT            ; $3e87 3189 - EMIT
   .word _SPACE           ; $3e89 32A7 - SPACE
   .word _2_2B            ; $3e8b 2325 - 2+
   .word _STR             ; $3e8d 3DEB - STR
   .word _BRANCH          ; $3e8f 2904 - BRANCH
   .word $3F06            ; $3e91 3F06
   .word _DUP             ; $3e93 2277 - DUP
   .word __40             ; $3e95 2820 - @
   .word _LIT             ; $3e97 28C7 - LIT
   .word __28_2E_22_29    ; $3e99 3421 - (.")
   .word __3D             ; $3e9b 2409 - =
   .word __3FBRANCH       ; $3e9d 2916 - ?BRANCH
   .word $3EB7            ; $3e9f 3EB7
   .word _LIT             ; $3ea1 28C7 - LIT
   .word $002E            ; $3ea3 002E
   .word _EMIT            ; $3ea5 3189 - EMIT
   .word _LIT             ; $3ea7 28C7 - LIT
   .word $0022            ; $3ea9 0022
   .word _EMIT            ; $3eab 3189 - EMIT
   .word _SPACE           ; $3ead 32A7 - SPACE
   .word _2_2B            ; $3eaf 2325 - 2+
   .word _STR             ; $3eb1 3DEB - STR
   .word _BRANCH          ; $3eb3 2904 - BRANCH
   .word $3F06            ; $3eb5 3F06
   .word _DUP             ; $3eb7 2277 - DUP
   .word __40             ; $3eb9 2820 - @
   .word _LIT             ; $3ebb 28C7 - LIT
   .word __28ABORT_22_29  ; $3ebd 2D61 - (ABORT")
   .word __3D             ; $3ebf 2409 - =
   .word __3FBRANCH       ; $3ec1 2916 - ?BRANCH
   .word $3EDB            ; $3ec3 3EDB
   .word __28_2E_22_29    ; $3ec5 3421 - (.")
   .byte 5,"ABORT"
   .word _LIT             ; $3ecd 28C7 - LIT
   .word $0022            ; $3ecf 0022
   .word _EMIT            ; $3ed1 3189 - EMIT
   .word _2_2B            ; $3ed3 2325 - 2+
   .word _STR             ; $3ed5 3DEB - STR
   .word _BRANCH          ; $3ed7 2904 - BRANCH
   .word $3F06            ; $3ed9 3F06
   .word _DUP             ; $3edb 2277 - DUP
   .word __40             ; $3edd 2820 - @
   .word _LIT             ; $3edf 28C7 - LIT
   .word _LIT             ; $3ee1 28C7 - LIT
   .word __3D             ; $3ee3 2409 - =
   .word __3FBRANCH       ; $3ee5 2916 - ?BRANCH
   .word $3EFE            ; $3ee7 3EFE
   .word __28_2E_22_29    ; $3ee9 3421 - (.")
   .byte 4,"LIT "
   .word _2_2B            ; $3ef0 2325 - 2+
   .word _DUP             ; $3ef2 2277 - DUP
   .word __40             ; $3ef4 2820 - @
   .word __3FNAME         ; $3ef6 3D88 - ?NAME
   .word _2_2B            ; $3ef8 2325 - 2+
   .word _BRANCH          ; $3efa 2904 - BRANCH
   .word $3F06            ; $3efc 3F06
   .word _DUP             ; $3efe 2277 - DUP
   .word __40             ; $3f00 2820 - @
   .word __3FNAME         ; $3f02 3D88 - ?NAME
   .word _2_2B            ; $3f04 2325 - 2+
   .word _BRANCH          ; $3f06 2904 - BRANCH
   .word $3E65            ; $3f08 3E65
   .word __28_2E_22_29    ; $3f0a 3421 - (.")
   .byte 1,";"
   .word _CR              ; $3f0e 454C - CR
   .word _DROP            ; $3f10 222D - DROP
   .word _BRANCH          ; $3f12 2904 - BRANCH
   .word $3F7C            ; $3f14 3F7C
   .word _R_3E            ; $3f16 27BC - R>
   .word __3FNAME         ; $3f18 3D88 - ?NAME
   .word _DUP             ; $3f1a 2277 - DUP
   .word _NEXT            ; $3f1c 21F5 - NEXT
   .word __3D             ; $3f1e 2409 - =
   .word __3FBRANCH       ; $3f20 2916 - ?BRANCH
   .word $3F38            ; $3f22 3F38
   .word __28_2E_22_29    ; $3f24 3421 - (.")
   .byte 13,"- ",0xf0,"EPEMEHHA",0xf1," "
   .word _BRANCH          ; $3f34 2904 - BRANCH
   .word $3F7C            ; $3f36 3F7C
   .word _LIT             ; $3f38 28C7 - LIT
   .word __40             ; $3f3a 2820 - @
   .word __3D             ; $3f3c 2409 - =
   .word __3FBRANCH       ; $3f3e 2916 - ?BRANCH
   .word $3F56            ; $3f40 3F56
   .word __28_2E_22_29    ; $3f42 3421 - (.")
   .byte 13,"- KOHCTAHTA  "
   .word _BRANCH          ; $3f52 2904 - BRANCH
   .word $3F7C            ; $3f54 3F7C
   .word __28_2E_22_29    ; $3f56 3421 - (.")
   .byte 35,"- O",0xf0,"PE",0xe4,"E",0xec,"EH",0xe9,"E ",0xfe,"EPE",0xfa," CREATE - DOES> "
   .word _EXIT            ; $3f7c 21A8 - EXIT

NFA_ASSEMBLER:   ; 3F7E
   .byte 0x89,"ASSEMBLER" ; IMMEDIATE
   .word NFA_DISFORT      ; 3E04
_ASSEMBLER:      ; 3F8A - 3F93
   call VOCABULARY_DOES ; 3F8A
   .byte 0x01        ; 3F8D
   .byte 0x80        ; 3F8E nfa (fake)
   .word NFA_NEXT_3B ; 3F8F lfa
   .word $6053       ; 3F91 voc-link

NFA_CODE:        ; 3F93
   .byte 0x84,"CODE" ; IMMEDIATE
   .word NFA_ASSEMBLER    ; 3F7E
_CODE:           ; 3F9A - 3FAF
   call _FCALL            ; 3F9A
   .word __3FEXEC         ; $3f9d 3834 - ?EXEC
   .word __21CSP          ; $3f9f 37F9 - !CSP
   .word _CREATE          ; $3fa1 36E3 - CREATE
   .word _CFL             ; $3fa3 2F44 - CFL
   .word _NEGATE          ; $3fa5 230D - NEGATE
   .word _ALLOT           ; $3fa7 2B73 - ALLOT
   .word _SMUDGE          ; $3fa9 3343 - SMUDGE
   .word _ASSEMBLER       ; $3fab 3F8A - ASSEMBLER
   .word _EXIT            ; $3fad 21A8 - EXIT

NFA__3BCODE:     ; 3FAF
   .byte 0x85,";CODE" ; IMMEDIATE
   .word NFA_CODE         ; 3F93
__3BCODE:        ; 3FB7 - 3FC8
   call _FCALL            ; 3FB7
   .word __3FCOMP         ; $3fba 3862 - ?COMP
   .word _COMPILE         ; $3fbc 2BE9 - COMPILE
   .word __28DOES_3E_29   ; $3fbe 3733 - (DOES>)
   .word _ASSEMBLER       ; $3fc0 3F8A - ASSEMBLER
   .word __21CSP          ; $3fc2 37F9 - !CSP
   .word __5B             ; $3fc4 3354 - [
   .word _EXIT            ; $3fc6 21A8 - EXIT

NFA_END_2DCODE:  ; 3FC8
   .byte 0x88,"END-CODE" ; IMMEDIATE
   .word NFA__3BCODE        ; 3FAF
_END_2DCODE:     ; 3FD3 - 44E2
   call _FCALL            ; 3FD3
   .word __3FEXEC         ; $3fd6 3834 - ?EXEC
   .word _SMUDGE          ; $3fd8 3343 - SMUDGE
   .word _CURRENT         ; $3fda 20F3 - CURRENT
   .word __40             ; $3fdc 2820 - @
   .word _CONTEXT         ; $3fde 20E4 - CONTEXT
   .word __21             ; $3fe0 2839 - !
   .word __3FCSP          ; $3fe2 380B - ?CSP
   .word _EXIT            ; $3fe4 21A8 - EXIT

aNFA_8_2A:          ; 3FE6
   .byte 2,"8*"
   .word $604f      ; $3fe9
a_8_2A:
   call _FCALL      ; $3feb cd 8f 21
   .word _DUP             ; $3fee 2277 - DUP
   .word __2B             ; $3ff0 22ED - +
   .word _DUP             ; $3ff2 2277 - DUP
   .word __2B             ; $3ff4 22ED - +
   .word _DUP             ; $3ff6 2277 - DUP
   .word __2B             ; $3ff8 22ED - +
   .word _EXIT            ; $3ffa 21A8 - EXIT

aNFA_H:           ; 3FFC
   .byte 1,"H"
   .word aNFA_8_2A           ; 3FE6
a_H:              ; 4000 - 4005
   call __40     ; 4000
   .word $0004   ; 4003

aNFA_L:           ; 4005
   .byte 1,"L"
   .word aNFA_H            ; 3FFC
a_L:              ; 4009 - 400E
   call __40     ; 4009
   .word $0005   ; 400C

aNFA_A:           ; 400E
   .byte 1,"A"
   .word aNFA_L            ; 4005
a_A:              ; 4012 - 4017
   call __40     ; 4012
   .word $0007   ; 4015

aNFA_PSW:         ; 4017
   .byte 3,"PSW"
   .word aNFA_A            ; 400E
a_PSW:            ; 401D - 4022
   call __40     ; 401D
   .word $0006   ; 4020

aNFA_D:           ; 4022
   .byte 1,"D"
   .word aNFA_PSW          ; 4017
a_D:              ; 4026 - 402B
   call __40     ; 4026
   .word $0002   ; 4029

aNFA_E:           ; 402B
   .byte 1,"E"
   .word aNFA_D            ; 4022
a_E:              ; 402F - 4034
   call __40     ; 402F
   .word $0003   ; 4032

aNFA_B:           ; 4034
   .byte 1,"B"
   .word aNFA_E            ; 402B
a_B:              ; 4038 - 403D
   call __40     ; 4038
   .word $0000   ; 403B

aNFA_C:           ; 403D
   .byte 1,"C"
   .word aNFA_B            ; 4034
a_C:              ; 4041 - 4046
   call __40     ; 4041
   .word $0001   ; 4044

aNFA_M:           ; 4046
   .byte 1,"M"
   .word aNFA_C            ; 403D
a_M:              ; 404A - 404F
   call __40     ; 404A
   .word $0006   ; 404D

aNFA_SP:          ; 404F
   .byte 2,"SP"
   .word aNFA_M            ; 4046
a_SP:             ; 4054 - 4059
   call __40     ; 4054
   .word $0006   ; 4057

aNFA_1MI:         ; 4059
   .byte 3,"1MI"
   .word aNFA_SP           ; 404F
a_1MI:            ; 405F - 4071
   call _FCALL            ; 405F
   .word _CREATE          ; $4062 36E3 - CREATE
   .word _C_2C            ; $4064 2B92 - C,
   .word __28DOES_3E_29   ; $4066 3733 - (DOES>)
l4068:
   call $218f      ; $4068 cd 8f 21
   .word _C_40            ; $406b 282D - C@
   .word _C_2C            ; $406d 2B92 - C,
   .word _EXIT            ; $406f 21A8 - EXIT

aNFA_2MI:         ; 4071
   .byte 3,"2MI"
   .word aNFA_1MI          ; 4059
a_2MI:            ; 4077 - 408B
   call _FCALL            ; 4077
   .word _CREATE          ; $407a 36E3 - CREATE
   .word _C_2C            ; $407c 2B92 - C,
   .word __28DOES_3E_29   ; $407e 3733 - (DOES>)
l4080:
   call $218f      ; $4080 cd 8f 21
   .word _C_40            ; $4083 282D - C@
   .word __2B             ; $4085 22ED - +
   .word _C_2C            ; $4087 2B92 - C,
   .word _EXIT            ; $4089 21A8 - EXIT

aNFA_3MI:         ; 408B
   .byte 3,"3MI"
   .word aNFA_2MI          ; 4071
a_3MI:            ; 4091 - 40A9
   call _FCALL            ; 4091
   .word _CREATE          ; $4094 36E3 - CREATE
   .word _C_2C            ; $4096 2B92 - C,
   .word __28DOES_3E_29   ; $4098 3733 - (DOES>)
l409a:
   call $218f      ; $409a cd 8f 21
   .word _C_40            ; $409d 282D - C@
   .word _SWAP            ; $409f 2238 - SWAP
   .word a_8_2A           ; $40a1 3FEB - 8*
   .word __2B             ; $40a3 22ED - +
   .word _C_2C            ; $40a5 2B92 - C,
   .word _EXIT            ; $40a7 21A8 - EXIT

aNFA_4MI:         ; 40A9
   .byte 3,"4MI"
   .word aNFA_3MI          ; 408B
a_4MI:            ; 40AF - 40C3
   call _FCALL            ; 40AF
   .word _CREATE          ; $40b2 36E3 - CREATE
   .word _C_2C            ; $40b4 2B92 - C,
   .word __28DOES_3E_29   ; $40b6 3733 - (DOES>)
l40b8:
   call $218f      ; $40b8 cd 8f 21
   .word _C_40            ; $40bb 282D - C@
   .word _C_2C            ; $40bd 2B92 - C,
   .word _C_2C            ; $40bf 2B92 - C,
   .word _EXIT            ; $40c1 21A8 - EXIT

aNFA_5MI:         ; 40C3
   .byte 3,"5MI"
   .word aNFA_4MI          ; 40A9
a_5MI:            ; 40C9 - 40DD
   call _FCALL            ; 40C9
   .word _CREATE          ; $40cc 36E3 - CREATE
   .word _C_2C            ; $40ce 2B92 - C,
   .word __28DOES_3E_29   ; $40d0 3733 - (DOES>)
l40d2:
   call $218f      ; $40d2 cd 8f 21
   .word _C_40            ; $40d5 282D - C@
   .word _C_2C            ; $40d7 2B92 - C,
   .word __2C             ; $40d9 2B80 - ,
   .word _EXIT            ; $40db 21A8 - EXIT

aNFA_NOP:         ; 40DD
   .byte 3,"NOP"
   .word aNFA_5MI          ; 40C3
a_NOP:            ; 40E3 - 40E7
   call $4068      ; $40e3 cd 68 40
   nop             ; $40e6 00      

aNFA_HLT:         ; 40E7
   .byte 3,"HLT"
   .word aNFA_NOP          ; 40DD
a_HLT:            ; 40ED - 40F1
   call $4068      ; $40ed cd 68 40
   hlt             ; $40f0 76      

aNFA_DI:          ; 40F1
   .byte 2,"DI"
   .word aNFA_HLT          ; 40E7
a_DI:             ; 40F6 - 40FA
   call $4068      ; $40f6 cd 68 40
   di              ; $40f9 f3      

aNFA_EI:          ; 40FA
   .byte 2,"EI"
   .word aNFA_DI           ; 40F1
a_EI:             ; 40FF - 4103
   call $4068      ; $40ff cd 68 40
   ei              ; $4102 fb      

aNFA_RLC:         ; 4103
   .byte 3,"RLC"
   .word aNFA_EI           ; 40FA
a_RLC:            ; 4109 - 410D
   call $4068      ; $4109 cd 68 40
   rlc             ; $410c 07      

aNFA_RRC:         ; 410D
   .byte 3,"RRC"
   .word aNFA_RLC          ; 4103
a_RRC:            ; 4113 - 4117
   call $4068      ; $4113 cd 68 40
   rrc             ; $4116 0f      

aNFA_RAL:         ; 4117
   .byte 3,"RAL"
   .word aNFA_RRC          ; 410D
a_RAL:            ; 411D - 4121
   call $4068      ; $411d cd 68 40
   ral             ; $4120 17      

aNFA_RAR:         ; 4121
   .byte 3,"RAR"
   .word aNFA_RAL          ; 4117
a_RAR:            ; 4127 - 412B
   call $4068      ; $4127 cd 68 40
   rar             ; $412a 1f      

aNFA_PCHL:        ; 412B
   .byte 4,"PCHL"
   .word aNFA_RAR          ; 4121
a_PCHL:           ; 4132 - 4136
   call $4068      ; $4132 cd 68 40
   pchl            ; $4135 e9      

aNFA_SPHL:        ; 4136
   .byte 4,"SPHL"
   .word aNFA_PCHL         ; 412B
a_SPHL:           ; 413D - 4141
   call $4068      ; $413d cd 68 40
   sphl            ; $4140 f9      

aNFA_XTHL:        ; 4141
   .byte 4,"XTHL"
   .word aNFA_SPHL         ; 4136
a_XTHL:           ; 4148 - 414C
   call $4068      ; $4148 cd 68 40
   xthl            ; $414b e3      

aNFA_XCHG:        ; 414C
   .byte 4,"XCHG"
   .word aNFA_XTHL         ; 4141
a_XCHG:           ; 4153 - 4157
   call $4068      ; $4153 cd 68 40
   xchg            ; $4156 eb      

aNFA_DAA:         ; 4157
   .byte 3,"DAA"
   .word aNFA_XCHG         ; 414C
a_DAA:            ; 415D - 4161
   call $4068      ; $415d cd 68 40
   daa             ; $4160 27      

aNFA_CMA:         ; 4161
   .byte 3,"CMA"
   .word aNFA_DAA          ; 4157
a_CMA:            ; 4167 - 416B
   call $4068      ; $4167 cd 68 40
   cma             ; $416a 2f      

aNFA_STC:         ; 416B
   .byte 3,"STC"
   .word aNFA_CMA          ; 4161
a_STC:            ; 4171 - 4175
   call $4068      ; $4171 cd 68 40
   stc             ; $4174 37      

aNFA_CMC:         ; 4175
   .byte 3,"CMC"
   .word aNFA_STC          ; 416B
a_CMC:            ; 417B - 417F
   call $4068      ; $417b cd 68 40
   cmc             ; $417e 3f      

aNFA_ADD:         ; 417F
   .byte 3,"ADD"
   .word aNFA_CMC          ; 4175
a_ADD:            ; 4185 - 4189
   call $4080      ; $4185 cd 80 40
   add b           ; $4188 80      

aNFA_ADC:         ; 4189
   .byte 3,"ADC"
   .word aNFA_ADD          ; 417F
a_ADC:            ; 418F - 4193
   call $4080      ; $418f cd 80 40
   adc b           ; $4192 88      

aNFA_SUB:         ; 4193
   .byte 3,"SUB"
   .word aNFA_ADC          ; 4189
a_SUB:            ; 4199 - 419D
   call $4080      ; $4199 cd 80 40
   sub b           ; $419c 90      

aNFA_SBB:         ; 419D
   .byte 3,"SBB"
   .word aNFA_SUB          ; 4193
a_SBB:            ; 41A3 - 41A7
   call $4080      ; $41a3 cd 80 40
   sbb b           ; $41a6 98      

aNFA_ANA:         ; 41A7
   .byte 3,"ANA"
   .word aNFA_SBB          ; 419D
a_ANA:            ; 41AD - 41B1
   call $4080      ; $41ad cd 80 40
   ana b           ; $41b0 a0      

aNFA_XRA:         ; 41B1
   .byte 3,"XRA"
   .word aNFA_ANA          ; 41A7
a_XRA:            ; 41B7 - 41BB
   call $4080      ; $41b7 cd 80 40
   xra b           ; $41ba a8      

aNFA_ORA:         ; 41BB
   .byte 3,"ORA"
   .word aNFA_XRA          ; 41B1
a_ORA:            ; 41C1 - 41C5
   call $4080      ; $41c1 cd 80 40
   ora b           ; $41c4 b0      

aNFA_CMP:         ; 41C5
   .byte 3,"CMP"
   .word aNFA_ORA          ; 41BB
a_CMP:            ; 41CB - 41CF
   call $4080      ; $41cb cd 80 40
   cmp b           ; $41ce b8      

aNFA_DAD:         ; 41CF
   .byte 3,"DAD"
   .word aNFA_CMP          ; 41C5
a_DAD:            ; 41D5 - 41D9
   call $409a      ; $41d5 cd 9a 40
   dad b           ; $41d8 09      

aNFA_POP:         ; 41D9
   .byte 3,"POP"
   .word aNFA_DAD          ; 41CF
a_POP:            ; 41DF - 41E3
   call $409a      ; $41df cd 9a 40
   pop b           ; $41e2 c1      

aNFA_PUSH:        ; 41E3
   .byte 4,"PUSH"
   .word aNFA_POP          ; 41D9
a_PUSH:           ; 41EA - 41EE
   call $409a      ; $41ea cd 9a 40
   push b          ; $41ed c5      

aNFA_STAX:        ; 41EE
   .byte 4,"STAX"
   .word aNFA_PUSH         ; 41E3
a_STAX:           ; 41F5 - 41F9
   call $409a      ; $41f5 cd 9a 40
   stax b          ; $41f8 02      

aNFA_LDAX:        ; 41F9
   .byte 4,"LDAX"
   .word aNFA_STAX         ; 41EE
a_LDAX:           ; 4200 - 4204
   call $409a      ; $4200 cd 9a 40
   ldax b          ; $4203 0a      

aNFA_INR:         ; 4204
   .byte 3,"INR"
   .word aNFA_LDAX         ; 41F9
a_INR:            ; 420A - 420E
   call $409a      ; $420a cd 9a 40
   inr b           ; $420d 04      

aNFA_DCR:         ; 420E
   .byte 3,"DCR"
   .word aNFA_INR          ; 4204
a_DCR:            ; 4214 - 4218
   call $409a      ; $4214 cd 9a 40
   dcr b           ; $4217 05      

aNFA_INX:         ; 4218
   .byte 3,"INX"
   .word aNFA_DCR          ; 420E
a_INX:            ; 421E - 4222
   call $409a      ; $421e cd 9a 40
   inx b           ; $4221 03      

aNFA_DCX:         ; 4222
   .byte 3,"DCX"
   .word aNFA_INX          ; 4218
a_DCX:            ; 4228 - 422C
   call $409a      ; $4228 cd 9a 40
   dcx b           ; $422b 0b      

aNFA_RST:         ; 422C
   .byte 3,"RST"
   .word aNFA_DCX          ; 4222
a_RST:            ; 4232 - 4236
   call $409a      ; $4232 cd 9a 40
   .db $c7         ; $4235 c7      

aNFA_OUT:         ; 4236
   .byte 3,"OUT"
   .word aNFA_RST          ; 422C
a_OUT:            ; 423C - 4240
   call $40b8      ; $423c cd b8 40
   .db $d3         ; $423f d3

aNFA_IN:          ; 4240
   .byte 2,"IN"
   .word aNFA_OUT          ; 4236
a_IN:             ; 4245 - 4249
   call $40b8      ; $4245 cd b8 40
   .db $db         ; $4248 db

aNFA_ADI:         ; 4249
   .byte 3,"ADI"
   .word aNFA_IN           ; 4240
a_ADI:            ; 424F - 4253
   call $40b8      ; $424f cd b8 40
   .db $c6         ; $4252 c6

aNFA_ACI:         ; 4253
   .byte 3,"ACI"
   .word aNFA_ADI          ; 4249
a_ACI:            ; 4259 - 425D
   call $40b8      ; $4259 cd b8 40
   .db $ce         ; $425c ce

aNFA_SUI:         ; 425D
   .byte 3,"SUI"
   .word aNFA_ACI          ; 4253
a_SUI:            ; 4263 - 4267
   call $40b8      ; $4263 cd b8 40
   .db $d6         ; $4266 d6

aNFA_SBI:         ; 4267
   .byte 3,"SBI"
   .word aNFA_SUI          ; 425D
a_SBI:            ; 426D - 4271
   call $40b8      ; $426d cd b8 40
   .db $de         ; $4270 de

aNFA_ANI:         ; 4271
   .byte 3,"ANI"
   .word aNFA_SBI          ; 4267
a_ANI:            ; 4277 - 427B
   call $40b8      ; $4277 cd b8 40
   .db $e6         ; $427a e6

aNFA_XRI:         ; 427B
   .byte 3,"XRI"
   .word aNFA_ANI          ; 4271
a_XRI:            ; 4281 - 4285
   call $40b8      ; $4281 cd b8 40
   .db $ee         ; $4284 ee

aNFA_ORI:         ; 4285
   .byte 3,"ORI"
   .word aNFA_XRI          ; 427B
a_ORI:            ; 428B - 428F
   call $40b8      ; $428b cd b8 40
   .db $f6         ; $428e f6

aNFA_CPI:         ; 428F
   .byte 3,"CPI"
   .word aNFA_ORI          ; 4285
a_CPI:            ; 4295 - 4299
   call $40b8      ; $4295 cd b8 40
   .db $fe         ; $4298 fe

aNFA_SHLD:        ; 4299
   .byte 4,"SHLD"
   .word aNFA_CPI          ; 428F
a_SHLD:           ; 42A0 - 42A4
   call $40d2      ; $42a0 cd d2 40
   .db $22         ; $42a3 22

aNFA_LHLD:        ; 42A4
   .byte 4,"LHLD"
   .word aNFA_SHLD         ; 4299
a_LHLD:           ; 42AB - 42AF
   call $40d2      ; $42ab cd d2 40
   .db $2a         ; $42ae 2a

aNFA_STA:         ; 42AF
   .byte 3,"STA"
   .word aNFA_LHLD         ; 42A4
a_STA:            ; 42B5 - 42B9
   call $40d2      ; $42b5 cd d2 40
   .db $32         ; $42b8 32

aNFA_LDA:         ; 42B9
   .byte 3,"LDA"
   .word aNFA_STA          ; 42AF
a_LDA:            ; 42BF - 42C3
   call $40d2      ; $42bf cd d2 40
   .db $3a         ; $42c2 3a

aNFA_CNZ:         ; 42C3
   .byte 3,"CNZ"
   .word aNFA_LDA          ; 42B9
a_CNZ:            ; 42C9 - 42CD
   call $40d2      ; $42c9 cd d2 40
   .db $c4         ; $42cc c4

aNFA_CZ:          ; 42CD
   .byte 2,"CZ"
   .word aNFA_CNZ          ; 42C3
a_CZ:             ; 42D2 - 42D6
   call $40d2      ; $42d2 cd d2 40
   .db $cc         ; $42d5 cc

aNFA_CNC:         ; 42D6
   .byte 3,"CNC"
   .word aNFA_CZ           ; 42CD
a_CNC:            ; 42DC - 42E0
   call $40d2      ; $42dc cd d2 40
   .db $d4         ; $42df d4

aNFA_CC:          ; 42E0
   .byte 2,"CC"
   .word aNFA_CNC          ; 42D6
a_CC:             ; 42E5 - 42E9
   call $40d2      ; $42e5 cd d2 40
   .db $dc         ; $42e8 dc

aNFA_CPO:         ; 42E9
   .byte 3,"CPO"
   .word aNFA_CC           ; 42E0
a_CPO:            ; 42EF - 42F3
   call $40d2      ; $42ef cd d2 40
   .db $e4         ; $42f2 e4

aNFA_CPE:         ; 42F3
   .byte 3,"CPE"
   .word aNFA_CPO          ; 42E9
a_CPE:            ; 42F9 - 42FD
   call $40d2      ; $42f9 cd d2 40
   .db $ec         ; $42fc ec

aNFA_CP:          ; 42FD
   .byte 2,"CP"
   .word aNFA_CPE          ; 42F3
a_CP:             ; 4302 - 4306
   call $40d2      ; $4302 cd d2 40
   .db $f4         ; $4305 f4

aNFA_CM:          ; 4306
   .byte 2,"CM"
   .word aNFA_CP           ; 42FD
a_CM:             ; 430B - 430F
   call $40d2      ; $430b cd d2 40
   .db $fc         ; $430e fc

aNFA_CALL:        ; 430F
   .byte 4,"CALL"
   .word aNFA_CM           ; 4306
a_CALL:           ; 4316 - 431A
   call $40d2      ; $4316 cd d2 40
   .db $cd         ; $4319 cd

aNFA_RET:         ; 431A
   .byte 3,"RET"
   .word aNFA_CALL         ; 430F
a_RET:            ; 4320 - 4324
   call $4068      ; $4320 cd 68 40
   ret             ; $4323 c9      

aNFA_JMP:         ; 4324
   .byte 3,"JMP"
   .word aNFA_RET          ; 431A
a_JMP:            ; 432A - 432E
   call $40d2      ; $432a cd d2 40
   .db $c3         ; $432d c3

aNFA_RNZ:         ; 432E
   .byte 3,"RNZ"
   .word aNFA_JMP          ; 4324
a_RNZ:            ; 4334 - 4338
   call $4068      ; $4334 cd 68 40
   rnz             ; $4337 c0      

aNFA_RZ:          ; 4338
   .byte 2,"RZ"
   .word aNFA_RNZ          ; 432E
a_RZ:             ; 433D - 4341
   call $4068      ; $433d cd 68 40
   rz              ; $4340 c8      

aNFA_RNC:         ; 4341
   .byte 3,"RNC"
   .word aNFA_RZ           ; 4338
a_RNC:            ; 4347 - 434B
   call $4068      ; $4347 cd 68 40
   rnc             ; $434a d0      

aNFA_RC:          ; 434B
   .byte 2,"RC"
   .word aNFA_RNC          ; 4341
a_RC:             ; 4350 - 4354
   call $4068      ; $4350 cd 68 40
   rc              ; $4353 d8      

aNFA_RPO:         ; 4354
   .byte 3,"RPO"
   .word aNFA_RC           ; 434B
a_RPO:            ; 435A - 435E
   call $4068      ; $435a cd 68 40
   rpo             ; $435d e0      

aNFA_RPE:         ; 435E
   .byte 3,"RPE"
   .word aNFA_RPO          ; 4354
a_RPE:            ; 4364 - 4368
   call $4068      ; $4364 cd 68 40
   rpe             ; $4367 e8      

aNFA_RP:          ; 4368
   .byte 2,"RP"
   .word aNFA_RPE          ; 435E
a_RP:             ; 436D - 4371
   call $4068      ; $436d cd 68 40
   rp              ; $4370 f0      

aNFA_RM:          ; 4371
   .byte 2,"RM"
   .word aNFA_RP           ; 4368
a_RM:             ; 4376 - 437A
   call $4068      ; $4376 cd 68 40
   rm              ; $4379 f8      

aNFA_MOV:         ; 437A
   .byte 3,"MOV"
   .word aNFA_RM           ; 4371
a_MOV:            ; 4380 - 4393
   call _FCALL            ; 4380
   .word _SWAP            ; $4383 2238 - SWAP
   .word a_8_2A           ; $4385 3FEB - 8*
   .word _LIT             ; $4387 28C7 - LIT
   .word $0040            ; $4389 0040
   .word __2B             ; $438b 22ED - +
   .word __2B             ; $438d 22ED - +
   .word _C_2C            ; $438f 2B92 - C,
   .word _EXIT            ; $4391 21A8 - EXIT

aNFA_MVI:         ; 4393
   .byte 3,"MVI"
   .word aNFA_MOV          ; 437A
a_MVI:            ; 4399 - 43AC
   call _FCALL            ; 4399
   .word _SWAP            ; $439c 2238 - SWAP
   .word a_8_2A           ; $439e 3FEB - 8*
   .word _LIT             ; $43a0 28C7 - LIT
   .word $0006            ; $43a2 0006
   .word __2B             ; $43a4 22ED - +
   .word _C_2C            ; $43a6 2B92 - C,
   .word _C_2C            ; $43a8 2B92 - C,
   .word _EXIT            ; $43aa 21A8 - EXIT

aNFA_LXI:         ; 43AC
   .byte 3,"LXI"
   .word aNFA_MVI          ; 4393
a_LXI:            ; 43B2 - 43C3
   call _FCALL            ; 43B2
   .word _SWAP            ; $43b5 2238 - SWAP
   .word a_8_2A           ; $43b7 3FEB - 8*
   .word _1               ; $43b9 2B34 - 1
   .word __2B             ; $43bb 22ED - +
   .word _C_2C            ; $43bd 2B92 - C,
   .word __2C             ; $43bf 2B80 - ,
   .word _EXIT            ; $43c1 21A8 - EXIT

aNFA_0_3D:        ; 43C3
   .byte 2,"0="
   .word aNFA_LXI          ; 43AC
a_0_3D:           ; 43C8 - 43CD
   call __40     ; 43C8
   .word $00C2   ; 43CB

aNFA_CS:          ; 43CD
   .byte 2,"CS"
   .word aNFA_0_3D           ; 43C3
a_CS:             ; 43D2 - 43D7
   call __40     ; 43D2
   .word $00D2   ; 43D5

aNFA_PE:          ; 43D7
   .byte 2,"PE"
   .word aNFA_CS           ; 43CD
a_PE:             ; 43DC - 43E1
   call __40     ; 43DC
   .word $00E2   ; 43DF

aNFA_0_3C:        ; 43E1
   .byte 2,"0<"
   .word aNFA_PE           ; 43D7
a_0_3C:           ; 43E6 - 43EB
   call __40     ; 43E6
   .word $00F2   ; 43E9

aNFA_NOT:         ; 43EB
   .byte 3,"NOT"
   .word aNFA_0_3C           ; 43E1
a_NOT:            ; 43F1 - 43FC
   call _FCALL            ; 43F1
   .word _LIT             ; $43f4 28C7 - LIT
   .word $0008            ; $43f6 0008
   .word __2B             ; $43f8 22ED - +
   .word _EXIT            ; $43fa 21A8 - EXIT

aNFA_THEN:        ; 43FC
   .byte 4,"THEN"
   .word aNFA_NOT          ; 43EB
a_THEN:           ; 4403 - 4412
   call _FCALL            ; 4403
   .word _2               ; $4406 2B3D - 2
   .word __3FPAIRS        ; $4408 3893 - ?PAIRS
   .word _HERE            ; $440a 2B62 - HERE
   .word _SWAP            ; $440c 2238 - SWAP
   .word __21             ; $440e 2839 - !
   .word _EXIT            ; $4410 21A8 - EXIT

aNFA_ENDIF:       ; 4412
   .byte 5,"ENDIF"
   .word aNFA_THEN         ; 43FC
a_ENDIF:          ; 441A - 4421
   call _FCALL            ; 441A
   .word a_THEN           ; $441d 4403 - THEN
   .word _EXIT            ; $441f 21A8 - EXIT

aNFA_IF:          ; 4421
   .byte 2,"IF"
   .word aNFA_ENDIF        ; 4412
a_IF:             ; 4426 - 4435
   call _FCALL            ; 4426
   .word _C_2C            ; $4429 2B92 - C,
   .word _HERE            ; $442b 2B62 - HERE
   .word _0               ; $442d 2B2B - 0
   .word __2C             ; $442f 2B80 - ,
   .word _2               ; $4431 2B3D - 2
   .word _EXIT            ; $4433 21A8 - EXIT

aNFA_ELSE:        ; 4435
   .byte 4,"ELSE"
   .word aNFA_IF           ; 4421
a_ELSE:           ; 443C - 4453
   call _FCALL            ; 443C
   .word _2               ; $443f 2B3D - 2
   .word __3FPAIRS        ; $4441 3893 - ?PAIRS
   .word _LIT             ; $4443 28C7 - LIT
   .word $00C3            ; $4445 00C3
   .word a_IF             ; $4447 4426 - IF
   .word _ROT             ; $4449 225A - ROT
   .word _SWAP            ; $444b 2238 - SWAP
   .word a_THEN           ; $444d 4403 - THEN
   .word _2               ; $444f 2B3D - 2
   .word _EXIT            ; $4451 21A8 - EXIT

aNFA_BEGIN:       ; 4453
   .byte 5,"BEGIN"
   .word aNFA_ELSE         ; 4435
a_BEGIN:          ; 445B - 4464
   call _FCALL            ; 445B
   .word _HERE            ; $445e 2B62 - HERE
   .word _1               ; $4460 2B34 - 1
   .word _EXIT            ; $4462 21A8 - EXIT

aNFA_UNTIL:       ; 4464
   .byte 5,"UNTIL"
   .word aNFA_BEGIN        ; 4453
a_UNTIL:          ; 446C - 447B
   call _FCALL            ; 446C
   .word _SWAP            ; $446f 2238 - SWAP
   .word _1               ; $4471 2B34 - 1
   .word __3FPAIRS        ; $4473 3893 - ?PAIRS
   .word _C_2C            ; $4475 2B92 - C,
   .word __2C             ; $4477 2B80 - ,
   .word _EXIT            ; $4479 21A8 - EXIT

aNFA_AGAIN:       ; 447B
   .byte 5,"AGAIN"
   .word aNFA_UNTIL        ; 4464
a_AGAIN:          ; 4483 - 4494
   call _FCALL            ; 4483
   .word _1               ; $4486 2B34 - 1
   .word __3FPAIRS        ; $4488 3893 - ?PAIRS
   .word _LIT             ; $448a 28C7 - LIT
   .word $00C3            ; $448c 00C3
   .word _C_2C            ; $448e 2B92 - C,
   .word __2C             ; $4490 2B80 - ,
   .word _EXIT            ; $4492 21A8 - EXIT

aNFA_WHILE:       ; 4494
   .byte 5,"WHILE"
   .word aNFA_AGAIN        ; 447B
a_WHILE:          ; 449C - 44A7
   call _FCALL            ; 449C
   .word a_IF             ; $449f 4426 - IF
   .word _2               ; $44a1 2B3D - 2
   .word __2B             ; $44a3 22ED - +
   .word _EXIT            ; $44a5 21A8 - EXIT

aNFA_REPEAT:      ; 44A7
   .byte 6,"REPEAT"
   .word aNFA_WHILE        ; 4494
a_REPEAT:         ; 44B0 - 44C5
   call _FCALL            ; 44B0
   .word __3ER            ; $44b3 27A9 - >R
   .word __3ER            ; $44b5 27A9 - >R
   .word a_AGAIN          ; $44b7 4483 - AGAIN
   .word _R_3E            ; $44b9 27BC - R>
   .word _R_3E            ; $44bb 27BC - R>
   .word _2               ; $44bd 2B3D - 2
   .word __2D             ; $44bf 22F8 - -
   .word a_THEN           ; $44c1 4403 - THEN
   .word _EXIT            ; $44c3 21A8 - EXIT

NFA_NEXT_3B:     ; 44C5
   .byte 0x85,"NEXT;" ; IMMEDIATE
   .word aNFA_REPEAT  ; $44A7
_NEXT_3B:        ; 44CD - None
   call $218f      ; $44cd cd 8f 21
   .word __3FEXEC         ; $44d0 3834 - ?EXEC
   .word _NEXT            ; $44d2 21F5 - NEXT
   .word a_JMP            ; $44d4 432A - JMP
   .word _CURRENT         ; $44d6 20F3 - CURRENT
   .word __40             ; $44d8 2820 - @
   .word _CONTEXT         ; $44da 20E4 - CONTEXT
   .word __21             ; $44dc 2839 - !
   .word __3FCSP          ; $44de 380B - ?CSP
   .word _EXIT            ; $44e0 21A8 - EXIT

NFA_ST_2DC:      ; 44E2
   .byte 4,"ST-C"
   .word NFA_END_2DCODE     ; 3FC8
_ST_2DC:         ; 44E9 - 44EE
   call __40     ; 44E9
   .word $000D   ; 44EC

NFA_B_2DSP:      ; 44EE
   .byte 4,"B-SP"
   .word NFA_ST_2DC         ; 44E2
_B_2DSP:         ; 44F5 - 4521
   call __40     ; 44F5
   .word $0008   ; 44F8

l44fa:
   call $f812      ; $44fa cd 12 f8
   jz l44fa        ; $44fd ca fa 44
   call $f803      ; $4500 cd 03 f8
   ani $7f         ; $4503 e6 7f
   mov l,a         ; $4505 6f
   mvi h,$00       ; $4506 26 00
   ret             ; $4508 c9
   nop             ; $4509 00
   stax b          ; $450a 02
   nop             ; $450b 00
   nop             ; $450c 00
   nop             ; $450d 00
   nop             ; $450e 00
   nop             ; $450f 00
   nop             ; $4510 00
   nop             ; $4511 00
   nop             ; $4512 00
   nop             ; $4513 00
   nop             ; $4514 00
   call l44fa      ; $4515 cd fa 44
   mov a,l         ; $4518 7d
   cpi $43         ; $4519 fe 43
   jz $2006        ; $451b ca 06 20
   jmp $2040       ; $451e c3 40 20

NFA__28KEY_29:   ; 4521
   .byte 5,"(KEY)"
   .word NFA_B_2DSP         ; 44EE
__28KEY_29:      ; 4529 - 4530
   call l44fa      ; $4529 cd fa 44
   push h          ; $452c e5
   jmp $219a       ; $452d c3 9a 21

NFA__28EMIT_29:  ; 4530
   .byte 6,"(EMIT)"
   .word NFA__28KEY_29        ; 4521
__28EMIT_29:     ; 4539 - 4547
   pop h
   push b          ; $453a c5
   mov c,l         ; $453b 4d
   call $f809      ; $453c cd 09 f8
   pop b           ; $453f c1
   nop             ; $4540 00
   nop             ; $4541 00
   nop             ; $4542 00
   nop             ; $4543 00
   jmp $219a       ; $4544 c3 9a 21

NFA_CR:          ; 4547
   .byte 2,"CR"
   .word NFA__28EMIT_29       ; 4530
_CR:             ; 454C - 4561
   call _FCALL            ; 454C
   .word _LIT             ; $454f 28C7 - LIT
   .word $000A            ; $4551 000A
   .word _EMIT            ; $4553 3189 - EMIT
   .word _LIT             ; $4555 28C7 - LIT
   .word $000D            ; $4557 000D
   .word _EMIT            ; $4559 3189 - EMIT
   .word __3EOUT          ; $455b 216B - >OUT
   .word _0_21            ; $455d 2898 - 0!
   .word _EXIT            ; $455f 21A8 - EXIT

NFA_QUERY:       ; 4561
   .byte 5,"QUERY"
   .word NFA_CR           ; 4547
_QUERY:          ; 4569 - 458A
   call _FCALL            ; 4569
   .word _CR              ; $456c 454C - CR
   .word _LIT             ; $456e 28C7 - LIT
   .word $003E            ; $4570 003E
   .word _EMIT            ; $4572 3189 - EMIT
   .word _TIB             ; $4574 2176 - TIB
   .word _LIT             ; $4576 28C7 - LIT
   .word $004F            ; $4578 004F
   .word _EXPECT          ; $457a 30C2 - EXPECT
   .word _CR              ; $457c 454C - CR
   .word _TIB             ; $457e 2176 - TIB
   .word _SPAN            ; $4580 215F - SPAN
   .word __40             ; $4582 2820 - @
   .word _0               ; $4584 2B2B - 0
   .word _TRUE            ; $4586 2B49 - TRUE
   .word _EXIT            ; $4588 21A8 - EXIT

NFA_STANDIO:     ; 458A
   .byte 7,"STANDIO"
   .word NFA_QUERY        ; 4561
_STANDIO:        ; 4594 - None
   call $218f      ; $4594 cd 8f 21
   .word _LIT             ; $4597 28C7 - LIT
   .word $6014            ; $4599 6014
   .word __40             ; $459b 2820 - @
   .word __3FDUP          ; $459d 2284 - ?DUP
   .word __3FBRANCH       ; $459f 2916 - ?BRANCH
   .word $45A7            ; $45a1 45A7
   .word _EXECUTE         ; $45a3 21BF - EXECUTE
   .word _EXIT            ; $45a5 21A8 - EXIT
   .word _LIT             ; $45a7 28C7 - LIT
   .word _QUERY           ; $45a9 4569 - QUERY
   .word _INLINP          ; $45ab 2122 - INLINP
   .word __21             ; $45ad 2839 - !
   .word __23TIB          ; $45af 2148 - #TIB
   .word _0_21            ; $45b1 2898 - 0!
   .word __3EIN           ; $45b3 2153 - >IN
   .word _0_21            ; $45b5 2898 - 0!
   .word _LIT             ; $45b7 28C7 - LIT
   .word __28KEY_29       ; $45b9 4529 - (KEY)
   .word _LIT             ; $45bb 28C7 - LIT
   .word $600C            ; $45bd 600C
   .word __21             ; $45bf 2839 - !
   .word _LIT             ; $45c1 28C7 - LIT
   .word __28EMIT_29      ; $45c3 4539 - (EMIT)
   .word _LIT             ; $45c5 28C7 - LIT
   .word $600E            ; $45c7 600E
   .word __21             ; $45c9 2839 - !
   .word _EXIT            ; $45cb 21A8 - EXIT

;!!!
   inx b           ; $45cd 03      
   nop             ; $45ce 00      
   nop             ; $45cf 00
   rst 7           ; $45d0 ff
   nop             ; $45d1 00
   ani $9c         ; $45d2 e6 9c
   mov m,l         ; $45d4 75  
