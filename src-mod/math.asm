
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "math" FREE

NFA__2B:         ; 22E9
   .byte 1,"+"
   .word NFA_SP_21          ; 22DE
m__2B:            ; 22ED - 22F4
   pop h           ; #22ed e1
   pop d           ; #22ee d1
   dad d           ; #22ef 19
   push h          ; #22f0 e5
   jmp _FNEXT      ; #22f1 c3 9a 21

NFA__2D:         ; 22F4
   .byte 1,"-"
   .word NFA__2B            ; 22E9
m__2D:            ; 22F8 - 2304
   pop h           ; #22f8 e1
   pop d           ; #22f9 d1
   mov a,e         ; #22fa 7b
   sub l           ; #22fb 95
   mov l,a         ; #22fc 6f
   mov a,d         ; #22fd 7a
   sbb h           ; #22fe 9c
   mov h,a         ; #22ff 67
   push h          ; #2300 e5
   jmp _FNEXT      ; #2301 c3 9a 21

NFA_NEGATE:      ; 2304
   .byte 6,"NEGATE"
   .word NFA__2D            ; 22F4
m_NEGATE:         ; 230D - 2315
   pop h
   call l242f      ; #230e cd 2f 24
   push h          ; #2311 e5
   jmp _FNEXT      ; #2312 c3 9a 21

NFA_1_2B:        ; 2315
   .byte 2,"1+"
   .word NFA_NEGATE       ; 2304
m_1_2B:           ; 231A - 2320
   pop h           ; #231a e1
   inx h           ; #231b 23
   push h          ; #231c e5
   jmp _FNEXT      ; #231d c3 9a 21

NFA_2_2B:        ; 2320
   .byte 2,"2+"
   .word NFA_1_2B           ; 2315
m_2_2B:           ; 2325 - 232C
   pop h           ; #2325 e1
   inx h           ; #2326 23
   inx h           ; #2327 23
   push h          ; #2328 e5
   jmp _FNEXT      ; #2329 c3 9a 21

NFA_1_2D:        ; 232C
   .byte 2,"1-"
   .word NFA_2_2B           ; 2320
m_1_2D:           ; 2331 - 2337
   pop h           ; #2331 e1
   dcx h           ; #2332 2b
   push h          ; #2333 e5
   jmp _FNEXT      ; #2334 c3 9a 21

NFA_2_2D:        ; 2337
   .byte 2,"2-"
   .word NFA_1_2D           ; 232C
m_2_2D:           ; 233C - 2343
   pop h           ; #233c e1
   dcx h           ; #233d 2b
   dcx h           ; #233e 2b
   push h          ; #233f e5
   jmp _FNEXT      ; #2340 c3 9a 21

NFA_2_2A:        ; 2343
   .byte 2,"2*"
   .word NFA_2_2D           ; 2337
m_2_2A:           ; 2348 - 234E
   pop h           ; #2348 e1
   dad h           ; #2349 29
   push h          ; #234a e5
   jmp _FNEXT      ; #234b c3 9a 21

NFA_ABS:         ; 234E
   .byte 3,"ABS"
   .word NFA_2_2A           ; 2343
m_ABS:            ; 2354 - 235E
   pop h           ; #2354 e1
   mov a,h         ; #2355 7c
   ora a           ; #2356 b7
   cm l242f        ; #2357 fc 2f 24
   push h          ; #235a e5
   jmp _FNEXT      ; #235b c3 9a 21

NFA_MIN:         ; 235E
   .byte 3,"MIN"
   .word NFA_ABS          ; 234E
m_MIN:            ; 2364 - 237B
   pop d           ; #2364 d1
   pop h           ; #2365 e1
   push d          ; #2366 d5
   mov a,h         ; #2367 7c
   xra d           ; #2368 aa
   jp @2370        ; #2369 f2 70 23
   xra d           ; #236c aa
   jmp @2374       ; #236d c3 74 23
@2370:
   mov a,l         ; #2370 7d
   sub e           ; #2371 93
   mov a,h         ; #2372 7c
   sbb d           ; #2373 9a
@2374:
   jp _FNEXT       ; #2374 f2 9a 21
   xthl            ; #2377 e3
   jmp _FNEXT      ; #2378 c3 9a 21

NFA_MAX:         ; 237B
   .byte 3,"MAX"
   .word NFA_MIN          ; 235E
m_MAX:            ; 2381 - 2398
   pop h           ; #2381 e1
   pop d           ; #2382 d1
   push d          ; #2383 d5
   mov a,h         ; #2384 7c
   xra d           ; #2385 aa
   jp @238d        ; #2386 f2 8d 23
   xra h           ; #2389 ac
   jmp @2391       ; #238a c3 91 23
@238d:
   mov a,e         ; #238d 7b
   sub l           ; #238e 95
   mov a,d         ; #238f 7a
   sbb h           ; #2390 9c
@2391:
   jp _FNEXT       ; #2391 f2 9a 21
   xthl            ; #2394 e3
   jmp _FNEXT      ; #2395 c3 9a 21

NFA_U_3C:        ; 2398
   .byte 2,"U<"
   .word NFA_MAX          ; 237B
m_U_3C:           ; 239D - 23AE
   pop d           ; #239d d1
   pop h           ; #239e e1
   mov a,l         ; #239f 7d
   sub e           ; #23a0 93
   mov a,h         ; #23a1 7c
   sbb d           ; #23a2 9a
   lxi h,0xffff    ; #23a3 21 ff ff
   jc @23aa        ; #23a6 da aa 23
   inx h           ; #23a9 23
@23aa:
   push h          ; #23aa e5
   jmp _FNEXT      ; #23ab c3 9a 21

NFA__3C:         ; 23AE
   .byte 1,"<"
   .word NFA_U_3C           ; 2398
m__3C:            ; 23B2 - 23D2
   pop h           ; #23b2 e1
   pop d           ; #23b3 d1
l23b4:
   mov a,h         ; #23b4 7c
   xra d           ; #23b5 aa
   jp @23c3        ; #23b6 f2 c3 23
   lxi h,0000      ; #23b9 21 00 00
   xra d           ; #23bc aa
   jm @23ce        ; #23bd fa ce 23
   jmp @23cd       ; #23c0 c3 cd 23
@23c3:
   mov a,e         ; #23c3 7b
   sub l           ; #23c4 95
   mov a,d         ; #23c5 7a
   sbb h           ; #23c6 9c
   lxi h,0000      ; #23c7 21 00 00
   jp @23ce        ; #23ca f2 ce 23
@23cd:
   dcx h           ; #23cd 2b
@23ce:
   push h          ; #23ce e5
   jmp _FNEXT      ; #23cf c3 9a 21

NFA__3E:         ; 23D2
   .byte 1,">"
   .word NFA__3C            ; 23AE
m__3E:            ; 23D6 - 23DB
   pop d           ; #23d6 d1
   pop h           ; #23d7 e1
   jmp l23b4       ; #23d8 c3 b4 23

NFA_0_3C:        ; 23DB
   .byte 2,"0<"
   .word NFA__3E            ; 23D2
m_0_3C:           ; 23E0 - 23EE
   pop h
   mov a,h         ; #23e1 7c
   lxi h,0000      ; #23e2 21 00 00
   ora a           ; #23e5 b7
   jp @23ea        ; #23e6 f2 ea 23
   dcx h           ; #23e9 2b
@23ea:
   push h          ; #23ea e5
   jmp _FNEXT      ; #23eb c3 9a 21

NFA_0_3E:        ; 23EE
   .byte 2,"0>"
   .word NFA_0_3C           ; 23DB
m_0_3E:           ; 23F3 - 2405
   pop d           ; #23f3 d1
   lxi h,0000      ; #23f4 21 00 00
   mov a,d         ; #23f7 7a
   ora a           ; #23f8 b7
   jm @2401        ; #23f9 fa 01 24
   ora e           ; #23fc b3
   jz @2401        ; #23fd ca 01 24
   dcx h           ; #2400 2b
@2401:
   push h          ; #2401 e5
   jmp _FNEXT      ; #2402 c3 9a 21

NFA__3D:         ; 2405
   .byte 1,"="
   .word NFA_0_3E           ; 23EE
m__3D:            ; 2409 - 241C
   pop h           ; #2409 e1
   pop d           ; #240a d1
   mov a,l         ; #240b 7d
   sub e           ; #240c 93
   mov e,a         ; #240d 5f
   mov a,h         ; #240e 7c
   sbb d           ; #240f 9a
   lxi h,0000      ; #2410 21 00 00
   ora e           ; #2413 b3
   jnz @2418       ; #2414 c2 18 24
   dcx h           ; #2417 2b
@2418:
   push h          ; #2418 e5
   jmp _FNEXT      ; #2419 c3 9a 21

NFA_0_3D:        ; 241C
   .byte 2,"0="
   .word NFA__3D            ; 2405
m_0_3D:           ; 2421 - 2437
   pop h           ; #2421 e1
   mov a,h         ; #2422 7c
   lxi d,0000      ; #2423 11 00 00
   ora l           ; #2426 b5
   jnz @242b       ; #2427 c2 2b 24
   dcx d           ; #242a 1b
@242b:
   push d          ; #242b d5
   jmp _FNEXT      ; #242c c3 9a 21
l242f:
   mov a,h         ; #242f 7c
   cma             ; #2430 2f
   mov h,a         ; #2431 67
   mov a,l         ; #2432 7d
   cma             ; #2433 2f
   mov l,a         ; #2434 6f
   inx h           ; #2435 23
   ret             ; #2436 c9

NFA_2_2F:        ; 245B
   .byte 2,"2/"
   .word NFA__2DTRAILING    ; 2437
m_2_2F:           ; 2460 - 246D
   pop h           ; #2460 e1
   mov a,h         ; #2461 7c
   add a           ; #2462 87
   mov a,h         ; #2463 7c
   rar             ; #2464 1f
   mov h,a         ; #2465 67
   mov a,l         ; #2466 7d
   rar             ; #2467 1f
   mov l,a         ; #2468 6f
   push h          ; #2469 e5
   jmp _FNEXT      ; #246a c3 9a 21

NFA_D_2B:        ; 246D
   .byte 2,"D+"
   .word NFA_2_2F           ; 245B
m_D_2B:           ; 2472 - 2482
   pop d           ; #2472 d1
   pop h           ; #2473 e1
   xthl            ; #2474 e3
   dad d           ; #2475 19
   pop d           ; #2476 d1
   xthl            ; #2477 e3
   dad d           ; #2478 19
   xthl            ; #2479 e3
   jnc @247e       ; #247a d2 7e 24
   inx h           ; #247d 23
@247e:
   push h          ; #247e e5
   jmp _FNEXT      ; #247f c3 9a 21

NFA_D_3C:        ; 2482
   .byte 2,"D<"
   .word NFA_D_2B           ; 246D
m_D_3C:           ; 2487 - 24B9
   pop d           ; #2487 d1
   pop h           ; #2488 e1
   xthl            ; #2489 e3
   mov a,h         ; #248a 7c
   xra d           ; #248b aa
   jp @249b        ; #248c f2 9b 24
   lxi d,0000      ; #248f 11 00 00
   xra h           ; #2492 ac
   pop h           ; #2493 e1
   pop h           ; #2494 e1
   jm @24b5        ; #2495 fa b5 24
   jmp @24b4       ; #2498 c3 b4 24
@249b:
   mov a,l         ; #249b 7d
   sub e           ; #249c 93
   mov l,a         ; #249d 6f
   mov a,h         ; #249e 7c
   sbb d           ; #249f 9a
   mov h,a         ; #24a0 67
   pop d           ; #24a1 d1
   xthl            ; #24a2 e3
   mov a,l         ; #24a3 7d
   sub e           ; #24a4 93
   mov a,h         ; #24a5 7c
   sbb d           ; #24a6 9a
   pop h           ; #24a7 e1
   jnc @24ac       ; #24a8 d2 ac 24
   dcx h           ; #24ab 2b
@24ac:
   mov a,h         ; #24ac 7c
   lxi d,0000      ; #24ad 11 00 00
   ora a           ; #24b0 b7
   jp @24b5        ; #24b1 f2 b5 24
@24b4:
   dcx d           ; #24b4 1b
@24b5:
   push d          ; #24b5 d5
   jmp _FNEXT      ; #24b6 c3 9a 21

NFA_DNEGATE:     ; 24B9
   .byte 7,"DNEGATE"
   .word NFA_D_3C           ; 2482
m_DNEGATE:        ; 24C3 - 24D8
   pop h           ; #24c3 e1
   xthl            ; #24c4 e3
   mvi d,00        ; #24c5 16 00
   mov a,d         ; #24c7 7a
   sub l           ; #24c8 95
   mov l,a         ; #24c9 6f
   mov a,d         ; #24ca 7a
   sbb h           ; #24cb 9c
   mov h,a         ; #24cc 67
   xthl            ; #24cd e3
   mov a,d         ; #24ce 7a
   sbb l           ; #24cf 9d
   mov l,a         ; #24d0 6f
   mov a,d         ; #24d1 7a
   sbb h           ; #24d2 9c
   mov h,a         ; #24d3 67
   push h          ; #24d4 e5
   jmp _FNEXT      ; #24d5 c3 9a 21

NFA__2A:         ; 2538
   .byte 1,"*"
   .word NFA_ROLL         ; 250D
m__2A:            ; 253C - 2562
   mov h,b         ; #253c 60
   mov l,c         ; #253d 69
   pop b           ; #253e c1
   pop d           ; #253f d1
   push h          ; #2540 e5
   lxi h,0000      ; #2541 21 00 00
   mov a,c         ; #2544 79
   mvi c,08        ; #2545 0e 08
   call @2555      ; #2547 cd 55 25
   mov a,b         ; #254a 78
   mvi c,08        ; #254b 0e 08
   call @2555      ; #254d cd 55 25
   pop b           ; #2550 c1
   push h          ; #2551 e5
   jmp _FNEXT      ; #2552 c3 9a 21
@2555:
   rar             ; #2555 1f
   jnc @255a       ; #2556 d2 5a 25
   dad d           ; #2559 19
@255a:
   xchg            ; #255a eb
   dad h           ; #255b 29
   xchg            ; #255c eb
   dcr c           ; #255d 0d
   jnz @2555       ; #255e c2 55 25
   ret             ; #2561 c9

NFA_UM_2A:       ; 2562
   .byte 3,"UM*"
   .word NFA__2A            ; 2538
m_UM_2A:          ; 2568 - 2591
   pop h           ; #2568 e1
   pop d           ; #2569 d1
   push b          ; #256a c5
   mov b,d         ; #256b 42
   mov c,e         ; #256c 4b
   call @2576      ; #256d cd 76 25
   pop b           ; #2570 c1
   push d          ; #2571 d5
   push h          ; #2572 e5
   jmp _FNEXT      ; #2573 c3 9a 21
@2576:
   xra a           ; #2576 af
   mov d,a         ; #2577 57
   mov e,a         ; #2578 5f
@2579:
   dad h           ; #2579 29
   rar             ; #257a 1f
   xchg            ; #257b eb
   dad h           ; #257c 29
   jnc @2581       ; #257d d2 81 25
   inx d           ; #2580 13
@2581:
   ral             ; #2581 17
   jnc @258a       ; #2582 d2 8a 25
   dad b           ; #2585 09
   jnc @258a       ; #2586 d2 8a 25
   inx d           ; #2589 13
@258a:
   xchg            ; #258a eb
   adi 0x10        ; #258b c6 10
   jnc @2579       ; #258d d2 79 25
   ret             ; #2590 c9

NFA_DU_2FMOD:    ; 2591
   .byte 6,"DU/MOD"
   .word NFA_UM_2A          ; 2562
m_DU_2FMOD:       ; 259A - 2677
   lxi h,l6145     ; #259a 21 45 61
   mvi a,04        ; #259d 3e 04
@259f:
   pop d           ; #259f d1
   mov m,d         ; #25a0 72
   inx h           ; #25a1 23
   mov m,e         ; #25a2 73
   inx h           ; #25a3 23
   dcr a           ; #25a4 3d
   jnz @259f       ; #25a5 c2 9f 25
   push b          ; #25a8 c5
   lxi b,0005      ; #25a9 01 05 00
   lxi h,l613f     ; #25ac 21 3f 61
   mvi e,0x0a      ; #25af 1e 0a
   push h          ; #25b1 e5
   call @263d      ; #25b2 cd 3d 26
   dad b           ; #25b5 09
   mov m,a         ; #25b6 77
@25b7:
   call @261d      ; #25b7 cd 1d 26
   inr b           ; #25ba 04
   dcr e           ; #25bb 1d
   jz @260a        ; #25bc ca 0a 26
   ani 0xf0        ; #25bf e6 f0
   jz @25b7        ; #25c1 ca b7 25
   dcr b           ; #25c4 05
   push b          ; #25c5 c5
@25c6:
   lxi h,l613f     ; #25c6 21 3f 61
   call @261d      ; #25c9 cd 1d 26
@25cc:
   lxi h,l6143     ; #25cc 21 43 61
   lxi d,l6148     ; #25cf 11 48 61
   push d          ; #25d2 d5
   push b          ; #25d3 c5
   call @2633      ; #25d4 cd 33 26
   pop b           ; #25d7 c1
   pop h           ; #25d8 e1
   jc @25ef        ; #25d9 da ef 25
   push b          ; #25dc c5
   lxi d,l614d     ; #25dd 11 4d 61
@25e0:
   dcx h           ; #25e0 2b
   dcx d           ; #25e1 1b
   ldax d          ; #25e2 1a
   sbb m           ; #25e3 9e
   stax d          ; #25e4 12
   dcr c           ; #25e5 0d
   jnz @25e0       ; #25e6 c2 e0 25
   dcx h           ; #25e9 2b
   inr m           ; #25ea 34
   pop b           ; #25eb c1
   jmp @25cc       ; #25ec c3 cc 25
@25ef:
   call @261d      ; #25ef cd 1d 26
   dcr b           ; #25f2 05
   jnz @25c6       ; #25f3 c2 c6 25
   lxi h,l6143     ; #25f6 21 43 61
   call @263d      ; #25f9 cd 3d 26
   pop b           ; #25fc c1
   mvi a,0x0c      ; #25fd 3e 0c
   mvi c,0x0a      ; #25ff 0e 0a
   sub b           ; #2601 90
   mov b,a         ; #2602 47
@2603:
   call @261d      ; #2603 cd 1d 26
   dcr b           ; #2606 05
   jnz @2603       ; #2607 c2 03 26
@260a:
   pop h           ; #260a e1
   lxi h,l6146     ; #260b 21 46 61
   pop b           ; #260e c1
   mvi a,04        ; #260f 3e 04
@2611:
   mov e,m         ; #2611 5e
   dcx h           ; #2612 2b
   mov d,m         ; #2613 56
   dcx h           ; #2614 2b
   push d          ; #2615 d5
   dcr a           ; #2616 3d
   jnz @2611       ; #2617 c2 11 26
   jmp _FNEXT      ; #261a c3 9a 21
@261d:
   push b          ; #261d c5
   mvi b,04        ; #261e 06 04
@2620:
   push b          ; #2620 c5
   xra a           ; #2621 af
   mov b,a         ; #2622 47
   dad b           ; #2623 09
@2624:
   dcx h           ; #2624 2b
   mov a,m         ; #2625 7e
   adc a           ; #2626 8f
   mov m,a         ; #2627 77
   dcr c           ; #2628 0d
   jnz @2624       ; #2629 c2 24 26
   pop b           ; #262c c1
   dcr b           ; #262d 05
   jnz @2620       ; #262e c2 20 26
   pop b           ; #2631 c1
   ret             ; #2632 c9
@2633:
   ldax d          ; #2633 1a
   cmp m           ; #2634 be
   inx h           ; #2635 23
   inx d           ; #2636 13
   rnz             ; #2637 c0
   dcr c           ; #2638 0d
   jnz @2633       ; #2639 c2 33 26
   ret             ; #263c c9
@263d:
   xra a           ; #263d af
   push h          ; #263e e5
   push b          ; #263f c5
@2640:
   mov m,a         ; #2640 77
   inx h           ; #2641 23
   dcr c           ; #2642 0d
   jnz @2640       ; #2643 c2 40 26
   pop b           ; #2646 c1
   pop h           ; #2647 e1
   ret             ; #2648 c9
l2649:
   mov a,h         ; #2649 7c
   ora l           ; #264a b5
   rz              ; #264b c8
   lxi b,0000      ; #264c 01 00 00
   push b          ; #264f c5
@2650:
   mov a,e         ; #2650 7b
   sub l           ; #2651 95
   mov a,d         ; #2652 7a
   sbb h           ; #2653 9c
   jc @265c        ; #2654 da 5c 26
   push h          ; #2657 e5
   dad h           ; #2658 29
   jnc @2650       ; #2659 d2 50 26
@265c:
   lxi h,0000      ; #265c 21 00 00
@265f:
   pop b           ; #265f c1
   mov a,b         ; #2660 78
   ora c           ; #2661 b1
   rz              ; #2662 c8
   dad h           ; #2663 29
   push d          ; #2664 d5
   mov a,e         ; #2665 7b
   sub c           ; #2666 91
   mov e,a         ; #2667 5f
   mov a,d         ; #2668 7a
   sbb b           ; #2669 98
   mov d,a         ; #266a 57
   jc @2673        ; #266b da 73 26
   inx h           ; #266e 23
   pop b           ; #266f c1
   jmp @265f       ; #2670 c3 5f 26
@2673:
   pop d           ; #2673 d1
   jmp @265f       ; #2674 c3 5f 26

NFA__2FMOD:      ; 2677
   .byte 4,"/MOD"
   .word NFA_DU_2FMOD       ; 2591
m__2FMOD:         ; 267E - 26BF
   pop h           ; #267e e1
   pop d           ; #267f d1
   push b          ; #2680 c5
   mov a,h         ; #2681 7c
   xra d           ; #2682 aa
   mov a,h         ; #2683 7c
   push psw        ; #2684 f5
   ora a           ; #2685 b7
   cm l242f        ; #2686 fc 2f 24
   push h          ; #2689 e5
   mov a,d         ; #268a 7a
   ora a           ; #268b b7
   xchg            ; #268c eb
   cm l242f        ; #268d fc 2f 24
   xchg            ; #2690 eb
   call l2649      ; #2691 cd 49 26
   pop b           ; #2694 c1
   mov a,d         ; #2695 7a
   ora e           ; #2696 b3
   jnz @26a4       ; #2697 c2 a4 26
   pop psw         ; #269a f1
   cm l242f        ; #269b fc 2f 24
   pop b           ; #269e c1
   push d          ; #269f d5
   push h          ; #26a0 e5
   jmp _FNEXT      ; #26a1 c3 9a 21
@26a4:
   pop psw         ; #26a4 f1
   push psw        ; #26a5 f5
   jp @26b3        ; #26a6 f2 b3 26
   inx h           ; #26a9 23
   call l242f      ; #26aa cd 2f 24
   mov a,c         ; #26ad 79
   sub e           ; #26ae 93
   mov e,a         ; #26af 5f
   mov a,b         ; #26b0 78
   sbb d           ; #26b1 9a
   mov d,a         ; #26b2 57
@26b3:
   pop psw         ; #26b3 f1
   ora a           ; #26b4 b7
   xchg            ; #26b5 eb
   cm l242f        ; #26b6 fc 2f 24
   pop b           ; #26b9 c1
   push h          ; #26ba e5
   push d          ; #26bb d5
   jmp _FNEXT      ; #26bc c3 9a 21

NFA_U_2FMOD:     ; 26BF
   .byte 5,"U/MOD"
   .word NFA__2FMOD         ; 2677
m_U_2FMOD:        ; 26C7 - 26D3
   pop h           ; #26c7 e1
   pop d           ; #26c8 d1
   push b          ; #26c9 c5
   call l2649      ; #26ca cd 49 26
   pop b           ; #26cd c1
   push d          ; #26ce d5
   push h          ; #26cf e5
   jmp _FNEXT      ; #26d0 c3 9a 21

NFA_AND:         ; 275E
   .byte 3,"AND"
   .word NFA_DIGIT        ; 2727
m_AND:            ; 2764 - 2770
   pop h           ; #2764 e1
   pop d           ; #2765 d1
   mov a,e         ; #2766 7b
   ana l           ; #2767 a5
   mov l,a         ; #2768 6f
   mov a,d         ; #2769 7a
   ana h           ; #276a a4
   mov h,a         ; #276b 67
   push h          ; #276c e5
   jmp _FNEXT      ; #276d c3 9a 21

NFA_OR:          ; 2770
   .byte 2,"OR"
   .word NFA_AND          ; 275E
m_OR:             ; 2775 - 2781
   pop h           ; #2775 e1
   pop d           ; #2776 d1
   mov a,e         ; #2777 7b
   ora l           ; #2778 b5
   mov l,a         ; #2779 6f
   mov a,d         ; #277a 7a
   ora h           ; #277b b4
   mov h,a         ; #277c 67
   push h          ; #277d e5
   jmp _FNEXT      ; #277e c3 9a 21

NFA_XOR:         ; 2781
   .byte 3,"XOR"
   .word NFA_OR           ; 2770
m_XOR:            ; 2787 - 2793
   pop h           ; #2787 e1
   pop d           ; #2788 d1
   mov a,e         ; #2789 7b
   xra l           ; #278a ad
   mov l,a         ; #278b 6f
   mov a,d         ; #278c 7a
   xra h           ; #278d ac
   mov h,a         ; #278e 67
   push h          ; #278f e5
   jmp _FNEXT      ; #2790 c3 9a 21

NFA_NOT:         ; 2793
   .byte 3,"NOT"
   .word NFA_XOR          ; 2781
m_NOT:            ; 2799 - 27A4
   pop h           ; #2799 e1
   mov a,h         ; #279a 7c
   cma             ; #279b 2f
   mov h,a         ; #279c 67
   mov a,l         ; #279d 7d
   cma             ; #279e 2f
   mov l,a         ; #279f 6f
   push h          ; #27a0 e5
   jmp _FNEXT      ; #27a1 c3 9a 21

.ENDS
