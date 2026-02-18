
.include "memorymap.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "vars" FREE

NFA_R0:          ; 2079
   .byte 2,"R0"
   .word NFA_BYE
_R0:             ; 207E - 2083
   call __40     ; 207E
   .word l601c   ; 2081

NFA_S0:          ; 2083
   .byte 2,"S0"
   .word NFA_R0           ; 2079
_S0:             ; 2088 - 208D
   call __40     ; 2088
   .word l601e   ; 208B

NFA_H:           ; 208D
   .byte 1,"H"
   .word NFA_S0           ; 2083
_H:              ; 2091 - 2096
   call __40     ; 2091
   .word l6020   ; 2094

NFA_VOC_2DLINK:  ; 2096
   .byte 8,"VOC-LINK"
   .word NFA_H            ; 208D
_VOC_2DLINK:     ; 20A1 - 20A6
   call __40     ; 20A1
   .word l6022   ; 20A4

NFA_FENCE:       ; 20A6
   .byte 5,"FENCE"
   .word NFA_VOC_2DLINK     ; 2096
_FENCE:          ; 20AE - 20B3
   call __40     ; 20AE
   .word l6024   ; 20B1

NFA_W_2DLINK:    ; 20B3
   .byte 6,"W-LINK"
   .word NFA_FENCE        ; 20A6
_W_2DLINK:       ; 20BC - 20C1
   call __40     ; 20BC
   .word l6026   ; 20BF

NFA_BASE:        ; 20C1
   .byte 4,"BASE"
   .word NFA_W_2DLINK       ; 20B3
_BASE:           ; 20C8 - 20CD
   call __40     ; 20C8
   .word l6028   ; 20CB

NFA_STATE:       ; 20CD
   .byte 5,"STATE"
   .word NFA_BASE         ; 20C1
_STATE:          ; 20D5 - 20DA
   call __40     ; 20D5
   .word l602a   ; 20D8

NFA_CONTEXT:     ; 20DA
   .byte 7,"CONTEXT"
   .word NFA_STATE        ; 20CD
_CONTEXT:        ; 20E4 - 20E9
   call __40     ; 20E4
   .word l602c   ; 20E7

NFA_CURRENT:     ; 20E9
   .byte 7,"CURRENT"
   .word NFA_CONTEXT      ; 20DA
_CURRENT:        ; 20F3 - 20F8
   call __40     ; 20F3
   .word l602e   ; 20F6

NFA_DPL:         ; 20F8
   .byte 3,"DPL"
   .word NFA_CURRENT      ; 20E9
_DPL:            ; 20FE - 2103
   call __40     ; 20FE
   .word l6030   ; 2101

NFA_HLD:         ; 2103
   .byte 3,"HLD"
   .word NFA_DPL          ; 20F8
_HLD:            ; 2109 - 210E
   call __40     ; 2109
   .word l6032   ; 210C

NFA_CSP:         ; 210E
   .byte 3,"CSP"
   .word NFA_HLD          ; 2103
_CSP:            ; 2114 - 2119
   call __40     ; 2114
   .word l6034   ; 2117

NFA_INLINP:      ; 2119
   .byte 6,"INLINP"
   .word NFA_CSP          ; 210E
_INLINP:         ; 2122 - 2127
   call __40     ; 2122
   .word l6036   ; 2125

NFA_OUTLINP:     ; 2127
   .byte 7,"OUTLINP"
   .word NFA_INLINP       ; 2119
_OUTLINP:        ; 2131 - 2136
   call __40     ; 2131
   .word l6038   ; 2134

NFA_INB:         ; 2136
   .byte 3,"INB"
   .word NFA_OUTLINP      ; 2127
_INB:            ; 213C - 2141
   call __40     ; 213C
   .word l603a   ; 213F

NFA__23TIB:      ; 2141
   .byte 4,"#TIB"
   .word NFA_INB          ; 2136
__23TIB:         ; 2148 - 214D
   call __40     ; 2148
   .word l603c   ; 214B

NFA__3EIN:       ; 214D
   .byte 3,">IN"
   .word NFA__23TIB         ; 2141
__3EIN:          ; 2153 - 2158
   call __40     ; 2153
   .word l603e   ; 2156

NFA_SPAN:        ; 2158
   .byte 4,"SPAN"
   .word NFA__3EIN          ; 214D
_SPAN:           ; 215F - 2164
   call __40     ; 215F
   .word l6040   ; 2162

NFA__3EOUT:      ; 2164
   .byte 4,">OUT"
   .word NFA_SPAN         ; 2158
__3EOUT:         ; 216B - 2170
   call __40     ; 216B
   .word l6042   ; 216E

NFA_TIB:         ; 2170
   .byte 3,"TIB"
   .word NFA__3EOUT         ; 2164
_TIB:            ; 2176 - 2185
   call __40     ; 2176
   .word l6099   ; 2179

.ENDS
