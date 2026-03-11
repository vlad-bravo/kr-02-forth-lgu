.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "TESTS_F" FREE

.DEF PREV_NFA PREV_NFA_TESTS_F
.DEF PREFIX PREFIX_TESTS_F

;\ Тесты
NFA "HH"
   call _FCALL
   .word __28_22_29     ; (")
   .byte 12
   .stringmap russian,"HELLO, HABR!"
   .word _COUNT         ; COUNT
   .word _TYPE          ; TYPE
   .word _EXIT          ; EXIT

;\ division, floored
;\     Integer division in which the remainder carries  the  sign  of
;\     the  divisor  or  is zero,  and the quotient is rounded to its
;\     arithmetic floor.  Note that,  except for error conditions, n1
;\     n2  SWAP  OVER /MOD ROT * + is identical to n1.  See:  "floor,
;\     arithmetic" Examples:
;\          dividend  divisor  remainder  quotient
;\            10        7        3          1
;\           -10        7        4         -2
;\            10       -7       -4         -2
;\           -10       -7       -3          1
NFA2 "STD-TEST1", "STD_2DTEST1"
   call _FCALL
   .word _LIT,0x100     ; 100
   .word _LIT,0x17      ; 17
   .word _SWAP          ; SWAP
   .word _OVER          ; OVER
   .word __2FMOD        ; /MOD
   .word _ROT           ; ROT
   .word __2A           ; *
   .word __2B           ; +
   .word __2E           ; .
   .word _EXIT          ; EXIT

NFA "TESTS"
   call _FCALL
   .word _STD_2DTEST1   ; STD-TEST1
   .word _EXIT          ; EXIT

.ENDS
