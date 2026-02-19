
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.SECTION "asm" FREE

NFA_ASSEMBLER:   ; 3F7E
   .byte 0x89,"ASSEMBLER" ; IMMEDIATE
   .word NFA_DISFORT      ; 3E04
_ASSEMBLER:      ; 3F8A - 3F93
   call VOCABULARY_DOES ; 3F8A
   .byte 0x01        ; 3F8D
   .byte 0x80        ; 3F8E nfa (fake)
   .word NFA_NEXT_3B ; 3F8F lfa
l3f91:
   .word l6053       ; 3F91 voc-link

NFA_CODE:        ; 3F93
   .byte 0x84,"CODE" ; IMMEDIATE
   .word NFA_ASSEMBLER    ; 3F7E
_CODE:           ; 3F9A - 3FAF
   call _FCALL            ; 3F9A
   .word __3FEXEC         ; #3f9d 3834 - ?EXEC
   .word __21CSP          ; #3f9f 37F9 - !CSP
   .word _CREATE          ; #3fa1 36E3 - CREATE
   .word _CFL             ; #3fa3 2F44 - CFL
   .word _NEGATE          ; #3fa5 230D - NEGATE
   .word _ALLOT           ; #3fa7 2B73 - ALLOT
   .word _SMUDGE          ; #3fa9 3343 - SMUDGE
   .word _ASSEMBLER       ; #3fab 3F8A - ASSEMBLER
   .word _EXIT            ; #3fad 21A8 - EXIT

NFA__3BCODE:     ; 3FAF
   .byte 0x85,";CODE" ; IMMEDIATE
   .word NFA_CODE         ; 3F93
__3BCODE:        ; 3FB7 - 3FC8
   call _FCALL            ; 3FB7
   .word __3FCOMP         ; #3fba 3862 - ?COMP
   .word _COMPILE         ; #3fbc 2BE9 - COMPILE
   .word __28DOES_3E_29   ; #3fbe 3733 - (DOES>)
   .word _ASSEMBLER       ; #3fc0 3F8A - ASSEMBLER
   .word __21CSP          ; #3fc2 37F9 - !CSP
   .word __5B             ; #3fc4 3354 - [
   .word _EXIT            ; #3fc6 21A8 - EXIT

NFA_END_2DCODE:  ; 3FC8
   .byte 0x88,"END-CODE" ; IMMEDIATE
   .word NFA__3BCODE        ; 3FAF
_END_2DCODE:     ; 3FD3 - 44E2
   call _FCALL            ; 3FD3
   .word __3FEXEC         ; #3fd6 3834 - ?EXEC
   .word _SMUDGE          ; #3fd8 3343 - SMUDGE
   .word _CURRENT         ; #3fda 20F3 - CURRENT
   .word __40             ; #3fdc 2820 - @
   .word _CONTEXT         ; #3fde 20E4 - CONTEXT
   .word __21             ; #3fe0 2839 - !
   .word __3FCSP          ; #3fe2 380B - ?CSP
   .word _EXIT            ; #3fe4 21A8 - EXIT

NFA_NEXT_3B:     ; 44C5
   .byte 0x85,"NEXT;" ; IMMEDIATE
   .word aNFA_REPEAT  ; #44A7
_NEXT_3B:        ; 44CD - None
   call _FCALL      ; #44cd cd 8f 21
   .word __3FEXEC         ; #44d0 3834 - ?EXEC
   .word _NEXT            ; #44d2 21F5 - NEXT
   .word a_JMP            ; #44d4 432A - JMP
   .word _CURRENT         ; #44d6 20F3 - CURRENT
   .word __40             ; #44d8 2820 - @
   .word _CONTEXT         ; #44da 20E4 - CONTEXT
   .word __21             ; #44dc 2839 - !
   .word __3FCSP          ; #44de 380B - ?CSP
   .word _EXIT            ; #44e0 21A8 - EXIT

aNFA_8_2A:
   .byte 2,"8*"
   .word l604f
a_8_2A:
   call _FCALL
   .word _DUP             ; DUP
   .word __2B             ; +
   .word _DUP             ; DUP
   .word __2B             ; +
   .word _DUP             ; DUP
   .word __2B             ; +
   .word _EXIT            ; EXIT

aNFA_H:           ; 3FFC
   .byte 1,"H"
   .word aNFA_8_2A           ; 3FE6
a_H:              ; 4000 - 4005
   call __40     ; 4000
   .word 0004    ; 4003

aNFA_L:           ; 4005
   .byte 1,"L"
   .word aNFA_H            ; 3FFC
a_L:              ; 4009 - 400E
   call __40     ; 4009
   .word 0005    ; 400C

aNFA_A:           ; 400E
   .byte 1,"A"
   .word aNFA_L            ; 4005
a_A:              ; 4012 - 4017
   call __40     ; 4012
   .word 0007    ; 4015

aNFA_PSW:         ; 4017
   .byte 3,"PSW"
   .word aNFA_A            ; 400E
a_PSW:            ; 401D - 4022
   call __40     ; 401D
   .word 0006    ; 4020

aNFA_D:           ; 4022
   .byte 1,"D"
   .word aNFA_PSW          ; 4017
a_D:              ; 4026 - 402B
   call __40     ; 4026
   .word 0002    ; 4029

aNFA_E:           ; 402B
   .byte 1,"E"
   .word aNFA_D            ; 4022
a_E:              ; 402F - 4034
   call __40     ; 402F
   .word 0003    ; 4032

aNFA_B:           ; 4034
   .byte 1,"B"
   .word aNFA_E            ; 402B
a_B:              ; 4038 - 403D
   call __40     ; 4038
   .word 0000    ; 403B

aNFA_C:           ; 403D
   .byte 1,"C"
   .word aNFA_B            ; 4034
a_C:              ; 4041 - 4046
   call __40     ; 4041
   .word 0001    ; 4044

aNFA_M:           ; 4046
   .byte 1,"M"
   .word aNFA_C            ; 403D
a_M:              ; 404A - 404F
   call __40     ; 404A
   .word 0006    ; 404D

aNFA_SP:          ; 404F
   .byte 2,"SP"
   .word aNFA_M            ; 4046
a_SP:             ; 4054 - 4059
   call __40     ; 4054
   .word 0006    ; 4057

aNFA_1MI:         ; 4059
   .byte 3,"1MI"
   .word aNFA_SP           ; 404F
a_1MI:            ; 405F - 4071
   call _FCALL            ; 405F
   .word _CREATE          ; #4062 36E3 - CREATE
   .word _C_2C            ; #4064 2B92 - C,
   .word __28DOES_3E_29   ; #4066 3733 - (DOES>)
DOES_1MI:
   call _FCALL      ; #4068 cd 8f 21
   .word _C_40            ; #406b 282D - C@
   .word _C_2C            ; #406d 2B92 - C,
   .word _EXIT            ; #406f 21A8 - EXIT

aNFA_2MI:         ; 4071
   .byte 3,"2MI"
   .word aNFA_1MI          ; 4059
a_2MI:            ; 4077 - 408B
   call _FCALL            ; 4077
   .word _CREATE          ; #407a 36E3 - CREATE
   .word _C_2C            ; #407c 2B92 - C,
   .word __28DOES_3E_29   ; #407e 3733 - (DOES>)
DOES_2MI:
   call _FCALL      ; #4080 cd 8f 21
   .word _C_40            ; #4083 282D - C@
   .word __2B             ; #4085 22ED - +
   .word _C_2C            ; #4087 2B92 - C,
   .word _EXIT            ; #4089 21A8 - EXIT

aNFA_3MI:         ; 408B
   .byte 3,"3MI"
   .word aNFA_2MI          ; 4071
a_3MI:            ; 4091 - 40A9
   call _FCALL            ; 4091
   .word _CREATE          ; #4094 36E3 - CREATE
   .word _C_2C            ; #4096 2B92 - C,
   .word __28DOES_3E_29   ; #4098 3733 - (DOES>)
DOES_3MI:
   call _FCALL      ; #409a cd 8f 21
   .word _C_40            ; #409d 282D - C@
   .word _SWAP            ; #409f 2238 - SWAP
   .word a_8_2A           ; #40a1 3FEB - 8*
   .word __2B             ; #40a3 22ED - +
   .word _C_2C            ; #40a5 2B92 - C,
   .word _EXIT            ; #40a7 21A8 - EXIT

aNFA_4MI:         ; 40A9
   .byte 3,"4MI"
   .word aNFA_3MI          ; 408B
a_4MI:            ; 40AF - 40C3
   call _FCALL            ; 40AF
   .word _CREATE          ; #40b2 36E3 - CREATE
   .word _C_2C            ; #40b4 2B92 - C,
   .word __28DOES_3E_29   ; #40b6 3733 - (DOES>)
DOES_4MI:
   call _FCALL      ; #40b8 cd 8f 21
   .word _C_40            ; #40bb 282D - C@
   .word _C_2C            ; #40bd 2B92 - C,
   .word _C_2C            ; #40bf 2B92 - C,
   .word _EXIT            ; #40c1 21A8 - EXIT

aNFA_5MI:         ; 40C3
   .byte 3,"5MI"
   .word aNFA_4MI          ; 40A9
a_5MI:            ; 40C9 - 40DD
   call _FCALL            ; 40C9
   .word _CREATE          ; #40cc 36E3 - CREATE
   .word _C_2C            ; #40ce 2B92 - C,
   .word __28DOES_3E_29   ; #40d0 3733 - (DOES>)
DOES_5MI:
   call _FCALL      ; #40d2 cd 8f 21
   .word _C_40            ; #40d5 282D - C@
   .word _C_2C            ; #40d7 2B92 - C,
   .word __2C             ; #40d9 2B80 - ,
   .word _EXIT            ; #40db 21A8 - EXIT

aNFA_NOP:         ; 40DD
   .byte 3,"NOP"
   .word aNFA_5MI          ; 40C3
a_NOP:            ; 40E3 - 40E7
   call DOES_1MI   ; #40e3 cd 68 40
   nop             ; #40e6 00      

aNFA_HLT:         ; 40E7
   .byte 3,"HLT"
   .word aNFA_NOP          ; 40DD
a_HLT:            ; 40ED - 40F1
   call DOES_1MI   ; #40ed cd 68 40
   hlt             ; #40f0 76      

aNFA_DI:          ; 40F1
   .byte 2,"DI"
   .word aNFA_HLT          ; 40E7
a_DI:             ; 40F6 - 40FA
   call DOES_1MI   ; #40f6 cd 68 40
   di              ; #40f9 f3      

aNFA_EI:          ; 40FA
   .byte 2,"EI"
   .word aNFA_DI           ; 40F1
a_EI:             ; 40FF - 4103
   call DOES_1MI   ; #40ff cd 68 40
   ei              ; #4102 fb      

aNFA_RLC:         ; 4103
   .byte 3,"RLC"
   .word aNFA_EI           ; 40FA
a_RLC:            ; 4109 - 410D
   call DOES_1MI   ; #4109 cd 68 40
   rlc             ; #410c 07      

aNFA_RRC:         ; 410D
   .byte 3,"RRC"
   .word aNFA_RLC          ; 4103
a_RRC:            ; 4113 - 4117
   call DOES_1MI   ; #4113 cd 68 40
   rrc             ; #4116 0f      

aNFA_RAL:         ; 4117
   .byte 3,"RAL"
   .word aNFA_RRC          ; 410D
a_RAL:            ; 411D - 4121
   call DOES_1MI   ; #411d cd 68 40
   ral             ; #4120 17      

aNFA_RAR:         ; 4121
   .byte 3,"RAR"
   .word aNFA_RAL          ; 4117
a_RAR:            ; 4127 - 412B
   call DOES_1MI   ; #4127 cd 68 40
   rar             ; #412a 1f      

aNFA_PCHL:        ; 412B
   .byte 4,"PCHL"
   .word aNFA_RAR          ; 4121
a_PCHL:           ; 4132 - 4136
   call DOES_1MI   ; #4132 cd 68 40
   pchl            ; #4135 e9      

aNFA_SPHL:        ; 4136
   .byte 4,"SPHL"
   .word aNFA_PCHL         ; 412B
a_SPHL:           ; 413D - 4141
   call DOES_1MI   ; #413d cd 68 40
   sphl            ; #4140 f9      

aNFA_XTHL:        ; 4141
   .byte 4,"XTHL"
   .word aNFA_SPHL         ; 4136
a_XTHL:           ; 4148 - 414C
   call DOES_1MI   ; #4148 cd 68 40
   xthl            ; #414b e3      

aNFA_XCHG:        ; 414C
   .byte 4,"XCHG"
   .word aNFA_XTHL         ; 4141
a_XCHG:           ; 4153 - 4157
   call DOES_1MI   ; #4153 cd 68 40
   xchg            ; #4156 eb      

aNFA_DAA:         ; 4157
   .byte 3,"DAA"
   .word aNFA_XCHG         ; 414C
a_DAA:            ; 415D - 4161
   call DOES_1MI   ; #415d cd 68 40
   daa             ; #4160 27      

aNFA_CMA:         ; 4161
   .byte 3,"CMA"
   .word aNFA_DAA          ; 4157
a_CMA:            ; 4167 - 416B
   call DOES_1MI   ; #4167 cd 68 40
   cma             ; #416a 2f      

aNFA_STC:         ; 416B
   .byte 3,"STC"
   .word aNFA_CMA          ; 4161
a_STC:            ; 4171 - 4175
   call DOES_1MI   ; #4171 cd 68 40
   stc             ; #4174 37      

aNFA_CMC:         ; 4175
   .byte 3,"CMC"
   .word aNFA_STC          ; 416B
a_CMC:            ; 417B - 417F
   call DOES_1MI   ; #417b cd 68 40
   cmc             ; #417e 3f      

aNFA_ADD:         ; 417F
   .byte 3,"ADD"
   .word aNFA_CMC          ; 4175
a_ADD:            ; 4185 - 4189
   call DOES_2MI   ; #4185 cd 80 40
   add b           ; #4188 80      

aNFA_ADC:         ; 4189
   .byte 3,"ADC"
   .word aNFA_ADD          ; 417F
a_ADC:            ; 418F - 4193
   call DOES_2MI   ; #418f cd 80 40
   adc b           ; #4192 88      

aNFA_SUB:         ; 4193
   .byte 3,"SUB"
   .word aNFA_ADC          ; 4189
a_SUB:            ; 4199 - 419D
   call DOES_2MI   ; #4199 cd 80 40
   sub b           ; #419c 90      

aNFA_SBB:         ; 419D
   .byte 3,"SBB"
   .word aNFA_SUB          ; 4193
a_SBB:            ; 41A3 - 41A7
   call DOES_2MI   ; #41a3 cd 80 40
   sbb b           ; #41a6 98      

aNFA_ANA:         ; 41A7
   .byte 3,"ANA"
   .word aNFA_SBB          ; 419D
a_ANA:            ; 41AD - 41B1
   call DOES_2MI   ; #41ad cd 80 40
   ana b           ; #41b0 a0      

aNFA_XRA:         ; 41B1
   .byte 3,"XRA"
   .word aNFA_ANA          ; 41A7
a_XRA:            ; 41B7 - 41BB
   call DOES_2MI   ; #41b7 cd 80 40
   xra b           ; #41ba a8      

aNFA_ORA:         ; 41BB
   .byte 3,"ORA"
   .word aNFA_XRA          ; 41B1
a_ORA:            ; 41C1 - 41C5
   call DOES_2MI   ; #41c1 cd 80 40
   ora b           ; #41c4 b0      

aNFA_CMP:         ; 41C5
   .byte 3,"CMP"
   .word aNFA_ORA          ; 41BB
a_CMP:            ; 41CB - 41CF
   call DOES_2MI   ; #41cb cd 80 40
   cmp b           ; #41ce b8      

aNFA_DAD:         ; 41CF
   .byte 3,"DAD"
   .word aNFA_CMP          ; 41C5
a_DAD:            ; 41D5 - 41D9
   call DOES_3MI   ; #41d5 cd 9a 40
   dad b           ; #41d8 09      

aNFA_POP:         ; 41D9
   .byte 3,"POP"
   .word aNFA_DAD          ; 41CF
a_POP:            ; 41DF - 41E3
   call DOES_3MI   ; #41df cd 9a 40
   pop b           ; #41e2 c1      

aNFA_PUSH:        ; 41E3
   .byte 4,"PUSH"
   .word aNFA_POP          ; 41D9
a_PUSH:           ; 41EA - 41EE
   call DOES_3MI   ; #41ea cd 9a 40
   push b          ; #41ed c5      

aNFA_STAX:        ; 41EE
   .byte 4,"STAX"
   .word aNFA_PUSH         ; 41E3
a_STAX:           ; 41F5 - 41F9
   call DOES_3MI   ; #41f5 cd 9a 40
   stax b          ; #41f8 02      

aNFA_LDAX:        ; 41F9
   .byte 4,"LDAX"
   .word aNFA_STAX         ; 41EE
a_LDAX:           ; 4200 - 4204
   call DOES_3MI   ; #4200 cd 9a 40
   ldax b          ; #4203 0a      

aNFA_INR:         ; 4204
   .byte 3,"INR"
   .word aNFA_LDAX         ; 41F9
a_INR:            ; 420A - 420E
   call DOES_3MI   ; #420a cd 9a 40
   inr b           ; #420d 04      

aNFA_DCR:         ; 420E
   .byte 3,"DCR"
   .word aNFA_INR          ; 4204
a_DCR:            ; 4214 - 4218
   call DOES_3MI   ; #4214 cd 9a 40
   dcr b           ; #4217 05      

aNFA_INX:         ; 4218
   .byte 3,"INX"
   .word aNFA_DCR          ; 420E
a_INX:            ; 421E - 4222
   call DOES_3MI   ; #421e cd 9a 40
   inx b           ; #4221 03      

aNFA_DCX:         ; 4222
   .byte 3,"DCX"
   .word aNFA_INX          ; 4218
a_DCX:            ; 4228 - 422C
   call DOES_3MI   ; #4228 cd 9a 40
   dcx b           ; #422b 0b      

aNFA_RST:         ; 422C
   .byte 3,"RST"
   .word aNFA_DCX          ; 4222
a_RST:            ; 4232 - 4236
   call DOES_3MI   ; #4232 cd 9a 40
   .db 0xc7        ; #4235 c7      

aNFA_OUT:         ; 4236
   .byte 3,"OUT"
   .word aNFA_RST          ; 422C
a_OUT:            ; 423C - 4240
   call DOES_4MI   ; #423c cd b8 40
   .db 0xd3        ; #423f d3

aNFA_IN:          ; 4240
   .byte 2,"IN"
   .word aNFA_OUT          ; 4236
a_IN:             ; 4245 - 4249
   call DOES_4MI   ; #4245 cd b8 40
   .db 0xdb        ; #4248 db

aNFA_ADI:         ; 4249
   .byte 3,"ADI"
   .word aNFA_IN           ; 4240
a_ADI:            ; 424F - 4253
   call DOES_4MI   ; #424f cd b8 40
   .db 0xc6        ; #4252 c6

aNFA_ACI:         ; 4253
   .byte 3,"ACI"
   .word aNFA_ADI          ; 4249
a_ACI:            ; 4259 - 425D
   call DOES_4MI   ; #4259 cd b8 40
   .db 0xce        ; #425c ce

aNFA_SUI:         ; 425D
   .byte 3,"SUI"
   .word aNFA_ACI          ; 4253
a_SUI:            ; 4263 - 4267
   call DOES_4MI   ; #4263 cd b8 40
   .db 0xd6        ; #4266 d6

aNFA_SBI:         ; 4267
   .byte 3,"SBI"
   .word aNFA_SUI          ; 425D
a_SBI:            ; 426D - 4271
   call DOES_4MI   ; #426d cd b8 40
   .db 0xde        ; #4270 de

aNFA_ANI:         ; 4271
   .byte 3,"ANI"
   .word aNFA_SBI          ; 4267
a_ANI:            ; 4277 - 427B
   call DOES_4MI   ; #4277 cd b8 40
   .db 0xe6        ; #427a e6

aNFA_XRI:         ; 427B
   .byte 3,"XRI"
   .word aNFA_ANI          ; 4271
a_XRI:            ; 4281 - 4285
   call DOES_4MI   ; #4281 cd b8 40
   .db 0xee        ; #4284 ee

aNFA_ORI:         ; 4285
   .byte 3,"ORI"
   .word aNFA_XRI          ; 427B
a_ORI:            ; 428B - 428F
   call DOES_4MI   ; #428b cd b8 40
   .db 0xf6        ; #428e f6

aNFA_CPI:         ; 428F
   .byte 3,"CPI"
   .word aNFA_ORI          ; 4285
a_CPI:            ; 4295 - 4299
   call DOES_4MI   ; #4295 cd b8 40
   .db 0xfe        ; #4298 fe

aNFA_SHLD:        ; 4299
   .byte 4,"SHLD"
   .word aNFA_CPI          ; 428F
a_SHLD:           ; 42A0 - 42A4
   call DOES_5MI   ; #42a0 cd d2 40
   .db 0x22        ; #42a3 22

aNFA_LHLD:        ; 42A4
   .byte 4,"LHLD"
   .word aNFA_SHLD         ; 4299
a_LHLD:           ; 42AB - 42AF
   call DOES_5MI   ; #42ab cd d2 40
   .db 0x2a        ; #42ae 2a

aNFA_STA:         ; 42AF
   .byte 3,"STA"
   .word aNFA_LHLD         ; 42A4
a_STA:            ; 42B5 - 42B9
   call DOES_5MI   ; #42b5 cd d2 40
   .db 0x32        ; #42b8 32

aNFA_LDA:         ; 42B9
   .byte 3,"LDA"
   .word aNFA_STA          ; 42AF
a_LDA:            ; 42BF - 42C3
   call DOES_5MI   ; #42bf cd d2 40
   .db 0x3a        ; #42c2 3a

aNFA_CNZ:         ; 42C3
   .byte 3,"CNZ"
   .word aNFA_LDA          ; 42B9
a_CNZ:            ; 42C9 - 42CD
   call DOES_5MI   ; #42c9 cd d2 40
   .db 0xc4        ; #42cc c4

aNFA_CZ:          ; 42CD
   .byte 2,"CZ"
   .word aNFA_CNZ          ; 42C3
a_CZ:             ; 42D2 - 42D6
   call DOES_5MI   ; #42d2 cd d2 40
   .db 0xcc        ; #42d5 cc

aNFA_CNC:         ; 42D6
   .byte 3,"CNC"
   .word aNFA_CZ           ; 42CD
a_CNC:            ; 42DC - 42E0
   call DOES_5MI   ; #42dc cd d2 40
   .db 0xd4        ; #42df d4

aNFA_CC:          ; 42E0
   .byte 2,"CC"
   .word aNFA_CNC          ; 42D6
a_CC:             ; 42E5 - 42E9
   call DOES_5MI   ; #42e5 cd d2 40
   .db 0xdc        ; #42e8 dc

aNFA_CPO:         ; 42E9
   .byte 3,"CPO"
   .word aNFA_CC           ; 42E0
a_CPO:            ; 42EF - 42F3
   call DOES_5MI   ; #42ef cd d2 40
   .db 0xe4        ; #42f2 e4

aNFA_CPE:         ; 42F3
   .byte 3,"CPE"
   .word aNFA_CPO          ; 42E9
a_CPE:            ; 42F9 - 42FD
   call DOES_5MI   ; #42f9 cd d2 40
   .db 0xec        ; #42fc ec

aNFA_CP:          ; 42FD
   .byte 2,"CP"
   .word aNFA_CPE          ; 42F3
a_CP:             ; 4302 - 4306
   call DOES_5MI   ; #4302 cd d2 40
   .db 0xf4        ; #4305 f4

aNFA_CM:          ; 4306
   .byte 2,"CM"
   .word aNFA_CP           ; 42FD
a_CM:             ; 430B - 430F
   call DOES_5MI   ; #430b cd d2 40
   .db 0xfc        ; #430e fc

aNFA_CALL:        ; 430F
   .byte 4,"CALL"
   .word aNFA_CM           ; 4306
a_CALL:           ; 4316 - 431A
   call DOES_5MI   ; #4316 cd d2 40
   .db 0xcd        ; #4319 cd

aNFA_RET:         ; 431A
   .byte 3,"RET"
   .word aNFA_CALL         ; 430F
a_RET:            ; 4320 - 4324
   call DOES_1MI   ; #4320 cd 68 40
   ret             ; #4323 c9      

aNFA_JMP:         ; 4324
   .byte 3,"JMP"
   .word aNFA_RET          ; 431A
a_JMP:            ; 432A - 432E
   call DOES_5MI   ; #432a cd d2 40
   .db 0xc3        ; #432d c3

aNFA_RNZ:         ; 432E
   .byte 3,"RNZ"
   .word aNFA_JMP          ; 4324
a_RNZ:            ; 4334 - 4338
   call DOES_1MI   ; #4334 cd 68 40
   rnz             ; #4337 c0      

aNFA_RZ:          ; 4338
   .byte 2,"RZ"
   .word aNFA_RNZ          ; 432E
a_RZ:             ; 433D - 4341
   call DOES_1MI   ; #433d cd 68 40
   rz              ; #4340 c8      

aNFA_RNC:         ; 4341
   .byte 3,"RNC"
   .word aNFA_RZ           ; 4338
a_RNC:            ; 4347 - 434B
   call DOES_1MI   ; #4347 cd 68 40
   rnc             ; #434a d0      

aNFA_RC:          ; 434B
   .byte 2,"RC"
   .word aNFA_RNC          ; 4341
a_RC:             ; 4350 - 4354
   call DOES_1MI   ; #4350 cd 68 40
   rc              ; #4353 d8      

aNFA_RPO:         ; 4354
   .byte 3,"RPO"
   .word aNFA_RC           ; 434B
a_RPO:            ; 435A - 435E
   call DOES_1MI   ; #435a cd 68 40
   rpo             ; #435d e0      

aNFA_RPE:         ; 435E
   .byte 3,"RPE"
   .word aNFA_RPO          ; 4354
a_RPE:            ; 4364 - 4368
   call DOES_1MI   ; #4364 cd 68 40
   rpe             ; #4367 e8      

aNFA_RP:          ; 4368
   .byte 2,"RP"
   .word aNFA_RPE          ; 435E
a_RP:             ; 436D - 4371
   call DOES_1MI   ; #436d cd 68 40
   rp              ; #4370 f0      

aNFA_RM:          ; 4371
   .byte 2,"RM"
   .word aNFA_RP           ; 4368
a_RM:             ; 4376 - 437A
   call DOES_1MI   ; #4376 cd 68 40
   rm              ; #4379 f8      

aNFA_MOV:         ; 437A
   .byte 3,"MOV"
   .word aNFA_RM           ; 4371
a_MOV:            ; 4380 - 4393
   call _FCALL            ; 4380
   .word _SWAP            ; #4383 2238 - SWAP
   .word a_8_2A           ; #4385 3FEB - 8*
   .word _LIT             ; #4387 28C7 - LIT
   .word 0x0040           ; #4389 0040
   .word __2B             ; #438b 22ED - +
   .word __2B             ; #438d 22ED - +
   .word _C_2C            ; #438f 2B92 - C,
   .word _EXIT            ; #4391 21A8 - EXIT

aNFA_MVI:         ; 4393
   .byte 3,"MVI"
   .word aNFA_MOV          ; 437A
a_MVI:            ; 4399 - 43AC
   call _FCALL            ; 4399
   .word _SWAP            ; #439c 2238 - SWAP
   .word a_8_2A           ; #439e 3FEB - 8*
   .word _LIT             ; #43a0 28C7 - LIT
   .word 0006             ; #43a2 0006
   .word __2B             ; #43a4 22ED - +
   .word _C_2C            ; #43a6 2B92 - C,
   .word _C_2C            ; #43a8 2B92 - C,
   .word _EXIT            ; #43aa 21A8 - EXIT

aNFA_LXI:         ; 43AC
   .byte 3,"LXI"
   .word aNFA_MVI          ; 4393
a_LXI:            ; 43B2 - 43C3
   call _FCALL            ; 43B2
   .word _SWAP            ; #43b5 2238 - SWAP
   .word a_8_2A           ; #43b7 3FEB - 8*
   .word _1               ; #43b9 2B34 - 1
   .word __2B             ; #43bb 22ED - +
   .word _C_2C            ; #43bd 2B92 - C,
   .word __2C             ; #43bf 2B80 - ,
   .word _EXIT            ; #43c1 21A8 - EXIT

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
   .word _LIT             ; #43f4 28C7 - LIT
   .word $0008            ; #43f6 0008
   .word __2B             ; #43f8 22ED - +
   .word _EXIT            ; #43fa 21A8 - EXIT

aNFA_THEN:        ; 43FC
   .byte 4,"THEN"
   .word aNFA_NOT          ; 43EB
a_THEN:           ; 4403 - 4412
   call _FCALL            ; 4403
   .word _2               ; #4406 2B3D - 2
   .word __3FPAIRS        ; #4408 3893 - ?PAIRS
   .word _HERE            ; #440a 2B62 - HERE
   .word _SWAP            ; #440c 2238 - SWAP
   .word __21             ; #440e 2839 - !
   .word _EXIT            ; #4410 21A8 - EXIT

aNFA_ENDIF:       ; 4412
   .byte 5,"ENDIF"
   .word aNFA_THEN         ; 43FC
a_ENDIF:          ; 441A - 4421
   call _FCALL            ; 441A
   .word a_THEN           ; #441d 4403 - THEN
   .word _EXIT            ; #441f 21A8 - EXIT

aNFA_IF:          ; 4421
   .byte 2,"IF"
   .word aNFA_ENDIF        ; 4412
a_IF:             ; 4426 - 4435
   call _FCALL            ; 4426
   .word _C_2C            ; #4429 2B92 - C,
   .word _HERE            ; #442b 2B62 - HERE
   .word _0               ; #442d 2B2B - 0
   .word __2C             ; #442f 2B80 - ,
   .word _2               ; #4431 2B3D - 2
   .word _EXIT            ; #4433 21A8 - EXIT

aNFA_ELSE:        ; 4435
   .byte 4,"ELSE"
   .word aNFA_IF           ; 4421
a_ELSE:           ; 443C - 4453
   call _FCALL            ; 443C
   .word _2               ; #443f 2B3D - 2
   .word __3FPAIRS        ; #4441 3893 - ?PAIRS
   .word _LIT             ; #4443 28C7 - LIT
   .word $00C3            ; #4445 00C3
   .word a_IF             ; #4447 4426 - IF
   .word _ROT             ; #4449 225A - ROT
   .word _SWAP            ; #444b 2238 - SWAP
   .word a_THEN           ; #444d 4403 - THEN
   .word _2               ; #444f 2B3D - 2
   .word _EXIT            ; #4451 21A8 - EXIT

aNFA_BEGIN:       ; 4453
   .byte 5,"BEGIN"
   .word aNFA_ELSE         ; 4435
a_BEGIN:          ; 445B - 4464
   call _FCALL            ; 445B
   .word _HERE            ; #445e 2B62 - HERE
   .word _1               ; #4460 2B34 - 1
   .word _EXIT            ; #4462 21A8 - EXIT

aNFA_UNTIL:       ; 4464
   .byte 5,"UNTIL"
   .word aNFA_BEGIN        ; 4453
a_UNTIL:          ; 446C - 447B
   call _FCALL            ; 446C
   .word _SWAP            ; #446f 2238 - SWAP
   .word _1               ; #4471 2B34 - 1
   .word __3FPAIRS        ; #4473 3893 - ?PAIRS
   .word _C_2C            ; #4475 2B92 - C,
   .word __2C             ; #4477 2B80 - ,
   .word _EXIT            ; #4479 21A8 - EXIT

aNFA_AGAIN:       ; 447B
   .byte 5,"AGAIN"
   .word aNFA_UNTIL        ; 4464
a_AGAIN:          ; 4483 - 4494
   call _FCALL            ; 4483
   .word _1               ; #4486 2B34 - 1
   .word __3FPAIRS        ; #4488 3893 - ?PAIRS
   .word _LIT             ; #448a 28C7 - LIT
   .word $00C3            ; #448c 00C3
   .word _C_2C            ; #448e 2B92 - C,
   .word __2C             ; #4490 2B80 - ,
   .word _EXIT            ; #4492 21A8 - EXIT

aNFA_WHILE:       ; 4494
   .byte 5,"WHILE"
   .word aNFA_AGAIN        ; 447B
a_WHILE:          ; 449C - 44A7
   call _FCALL            ; 449C
   .word a_IF             ; #449f 4426 - IF
   .word _2               ; #44a1 2B3D - 2
   .word __2B             ; #44a3 22ED - +
   .word _EXIT            ; #44a5 21A8 - EXIT

aNFA_REPEAT:      ; 44A7
   .byte 6,"REPEAT"
   .word aNFA_WHILE        ; 4494
a_REPEAT:         ; 44B0 - 44C5
   call _FCALL            ; 44B0
   .word __3ER            ; #44b3 27A9 - >R
   .word __3ER            ; #44b5 27A9 - >R
   .word a_AGAIN          ; #44b7 4483 - AGAIN
   .word _R_3E            ; #44b9 27BC - R>
   .word _R_3E            ; #44bb 27BC - R>
   .word _2               ; #44bd 2B3D - 2
   .word __2D             ; #44bf 22F8 - -
   .word a_THEN           ; #44c1 4403 - THEN
   .word _EXIT            ; #44c3 21A8 - EXIT

.ENDS
