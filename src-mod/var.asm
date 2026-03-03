
.include "memorymap.inc"
.include "ext_names.inc"
.include "nfa.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "vars" FREE

.DEF PREV_NFA PREV_NFA_VAR
.DEF PREFIX PREFIX_VAR

NFA "R0"
   call __40
   .word l601c

NFA "S0"
   call __40
   .word l601e

NFA "H"
   call __40
   .word l6020

NFA2 "VOC-LINK", "VOC_2DLINK"
   call __40
   .word l6022

NFA "FENCE"
   call __40
   .word l6024

NFA2 "W-LINK", "W_2DLINK"
   call __40
   .word l6026

NFA "BASE"
   call __40
   .word l6028

NFA "STATE"
   call __40
   .word l602a

NFA "CONTEXT"
   call __40
   .word l602c

NFA "CURRENT"
   call __40
   .word l602e

NFA "DPL"
   call __40
   .word l6030

NFA "HLD"
   call __40
   .word l6032

NFA "CSP"
   call __40
   .word l6034

NFA "INLINP"
   call __40
   .word l6036

NFA "OUTLINP"
   call __40
   .word l6038

NFA "INB"
   call __40
   .word l603a

NFA2 "#TIB", "_23TIB"
   call __40
   .word l603c

NFA2 ">IN", "_3EIN"
   call __40
   .word l603e

NFA "SPAN"
   call __40
   .word l6040

NFA2 ">OUT", "_3EOUT"
   call __40
   .word l6042

NFA "TIB"
   call __40
   .word l6099

NFA "NEXT"
   call __40
   .word _FNEXT

NFA "CALL"
   call __40
   .word _FCALL

NFA2 "-1", "_2D1"
   call __40
   .word 0xFFFF

NFA "0"
   call __40
   .word 0

NFA "1"
   call __40
   .word 1

NFA "2"
   call __40
   .word 2

NFA "TRUE"
   call __40
   .word 0xFFFF

NFA "FALSE"
   call __40
   .word 0

NFA2 "F-CODE", "F_2DCODE"
   call __40
   .word l2000

NFA2 "F-DATA", "F_2DDATA"
   call __40
   .word l6000

NFA "CFL"
   call __40
   .word 3

NFA "BL"
   call __40
   .word 0x20

NFA2 "ST-C", "ST_2DC"
   call __40
   .word 0x0D

NFA2 "B-SP", "B_2DSP"
   call __40
   .word 0x08

.ENDS
