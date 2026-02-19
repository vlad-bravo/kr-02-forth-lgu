
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "vars" FREE

NFA_R0:          ; 2079
   .byte 2,"R0"
   .word NFA_BYE
v_R0:             ; 207E - 2083
   call __40     ; 207E
   .word l601c   ; 2081

NFA_S0:          ; 2083
   .byte 2,"S0"
   .word NFA_R0           ; 2079
v_S0:             ; 2088 - 208D
   call __40     ; 2088
   .word l601e   ; 208B

NFA_H:           ; 208D
   .byte 1,"H"
   .word NFA_S0           ; 2083
v_H:              ; 2091 - 2096
   call __40     ; 2091
   .word l6020   ; 2094

NFA_VOC_2DLINK:  ; 2096
   .byte 8,"VOC-LINK"
   .word NFA_H            ; 208D
v_VOC_2DLINK:     ; 20A1 - 20A6
   call __40     ; 20A1
   .word l6022   ; 20A4

NFA_FENCE:       ; 20A6
   .byte 5,"FENCE"
   .word NFA_VOC_2DLINK     ; 2096
v_FENCE:          ; 20AE - 20B3
   call __40     ; 20AE
   .word l6024   ; 20B1

NFA_W_2DLINK:    ; 20B3
   .byte 6,"W-LINK"
   .word NFA_FENCE        ; 20A6
v_W_2DLINK:       ; 20BC - 20C1
   call __40     ; 20BC
   .word l6026   ; 20BF

NFA_BASE:        ; 20C1
   .byte 4,"BASE"
   .word NFA_W_2DLINK       ; 20B3
v_BASE:           ; 20C8 - 20CD
   call __40     ; 20C8
   .word l6028   ; 20CB

NFA_STATE:       ; 20CD
   .byte 5,"STATE"
   .word NFA_BASE         ; 20C1
v_STATE:          ; 20D5 - 20DA
   call __40     ; 20D5
   .word l602a   ; 20D8

NFA_CONTEXT:     ; 20DA
   .byte 7,"CONTEXT"
   .word NFA_STATE        ; 20CD
v_CONTEXT:        ; 20E4 - 20E9
   call __40     ; 20E4
   .word l602c   ; 20E7

NFA_CURRENT:     ; 20E9
   .byte 7,"CURRENT"
   .word NFA_CONTEXT      ; 20DA
v_CURRENT:        ; 20F3 - 20F8
   call __40     ; 20F3
   .word l602e   ; 20F6

NFA_DPL:         ; 20F8
   .byte 3,"DPL"
   .word NFA_CURRENT      ; 20E9
v_DPL:            ; 20FE - 2103
   call __40     ; 20FE
   .word l6030   ; 2101

NFA_HLD:         ; 2103
   .byte 3,"HLD"
   .word NFA_DPL          ; 20F8
v_HLD:            ; 2109 - 210E
   call __40     ; 2109
   .word l6032   ; 210C

NFA_CSP:         ; 210E
   .byte 3,"CSP"
   .word NFA_HLD          ; 2103
v_CSP:            ; 2114 - 2119
   call __40     ; 2114
   .word l6034   ; 2117

NFA_INLINP:      ; 2119
   .byte 6,"INLINP"
   .word NFA_CSP          ; 210E
v_INLINP:         ; 2122 - 2127
   call __40     ; 2122
   .word l6036   ; 2125

NFA_OUTLINP:     ; 2127
   .byte 7,"OUTLINP"
   .word NFA_INLINP       ; 2119
v_OUTLINP:        ; 2131 - 2136
   call __40     ; 2131
   .word l6038   ; 2134

NFA_INB:         ; 2136
   .byte 3,"INB"
   .word NFA_OUTLINP      ; 2127
v_INB:            ; 213C - 2141
   call __40     ; 213C
   .word l603a   ; 213F

NFA__23TIB:      ; 2141
   .byte 4,"#TIB"
   .word NFA_INB          ; 2136
v__23TIB:         ; 2148 - 214D
   call __40     ; 2148
   .word l603c   ; 214B

NFA__3EIN:       ; 214D
   .byte 3,">IN"
   .word NFA__23TIB         ; 2141
v__3EIN:          ; 2153 - 2158
   call __40     ; 2153
   .word l603e   ; 2156

NFA_SPAN:        ; 2158
   .byte 4,"SPAN"
   .word NFA__3EIN          ; 214D
v_SPAN:           ; 215F - 2164
   call __40     ; 215F
   .word l6040   ; 2162

NFA__3EOUT:      ; 2164
   .byte 4,">OUT"
   .word NFA_SPAN         ; 2158
v__3EOUT:         ; 216B - 2170
   call __40     ; 216B
   .word l6042   ; 216E

NFA_TIB:         ; 2170
   .byte 3,"TIB"
   .word NFA__3EOUT         ; 2164
v_TIB:            ; 2176 - 2185
   call __40     ; 2176
   .word l6099   ; 2179

NFA_NEXT:        ; 21EE
   .byte 4,"NEXT"
   .word NFA_ASMCALL      ; 21C0
v_NEXT:           ; 21F5 - 21FA
   call __40     ; 21F5
   .word _FNEXT  ; 21F8

NFA_CALL:        ; 21FA
   .byte 4,"CALL"
   .word NFA_NEXT         ; 21EE
v_CALL:           ; 2201 - 2206
   call __40     ; 2201
   .word _FCALL  ; 2204

NFA__2D1:        ; 2B1D
   .byte 2,"-1"
   .word NFA_ENCLOSE      ; 2AD5
v__2D1:           ; 2B22 - 2B27
   call __40     ; 2B22
   .word 0xFFFF  ; 2B25

NFA_0:           ; 2B27
   .byte 1,"0"
   .word NFA__2D1           ; 2B1D
v_0:              ; 2B2B - 2B30
   call __40     ; 2B2B
   .word 0000    ; 2B2E

NFA_1:           ; 2B30
   .byte 1,"1"
   .word NFA_0            ; 2B27
v_1:              ; 2B34 - 2B39
   call __40     ; 2B34
   .word 0001    ; 2B37

NFA_2:           ; 2B39
   .byte 1,"2"
   .word NFA_1            ; 2B30
v_2:              ; 2B3D - 2B42
   call __40     ; 2B3D
   .word 0002    ; 2B40

NFA_TRUE:        ; 2B42
   .byte 4,"TRUE"
   .word NFA_2            ; 2B39
v_TRUE:           ; 2B49 - 2B4E
   call __40     ; 2B49
   .word 0xFFFF  ; 2B4C

NFA_FALSE:       ; 2B4E
   .byte 5,"FALSE"
   .word NFA_TRUE         ; 2B42
v_FALSE:          ; 2B56 - 2B5B
   call __40     ; 2B56
   .word 0000    ; 2B59

NFA_F_2DCODE:    ; 3232
   .byte 6,"F-CODE"
   .word NFA_FORTH_2D83     ; 320C
v_F_2DCODE:       ; 323B - 3240
   call __40     ; 323B
   .word l2000   ; 323E

NFA_F_2DDATA:    ; 3240
   .byte 6,"F-DATA"
   .word NFA_F_2DCODE       ; 3232
v_F_2DDATA:       ; 3249 - 324E
   call __40     ; 3249
   .word l6000   ; 324C

NFA_CFL:         ; 2F3E
   .byte 3,"CFL"
   .word NFA_U_2E           ; 2F30
v_CFL:            ; 2F44 - 2F49
   call __40     ; 2F44
   .word 0003    ; 2F47

NFA_BL:          ; 3284
   .byte 2,"BL"
   .word NFA_DECIMAL      ; 326D
v_BL:             ; 3289 - 328E
   call __40     ; 3289
   .word 0x0020  ; 328C

NFA_ST_2DC:      ; 44E2
   .byte 4,"ST-C"
   .word NFA_END_2DCODE     ; 3FC8
v_ST_2DC:         ; 44E9 - 44EE
   call __40     ; 44E9
   .word 0x000D  ; 44EC

NFA_B_2DSP:      ; 44EE
   .byte 4,"B-SP"
   .word NFA_ST_2DC         ; 44E2
v_B_2DSP:         ; 44F5 - 4521
   call __40     ; 44F5
   .word 0x0008  ; 44F8

.ENDS
