
.include "memorymap.inc"
.include "ext_names.inc"
.include "..\src\ramdefs.inc"
.include "..\src\monitor.inc"

.stringmaptable russian "russian.tbl"

.SECTION "utils" FREE

NFA_DUMP:        ; 3B2A
   .byte 4,"DUMP"
   .word NFA_REPEAT       ; 3B0C
_DUMP:           ; 3B31 - 3BA4
   call _FCALL            ; 3B31
   .word _BASE            ; #3b34 20C8 - BASE
   .word __40             ; #3b36 2820 - @
   .word __2DROT          ; #3b38 2269 - -ROT
   .word _HEX             ; #3b3a 3260 - HEX
   .word _LIT             ; #3b3c 28C7 - LIT
   .word 0x0010           ; #3b3e 0010
   .word _U_2F            ; #3b40 2C62 - U/
   .word _1_2B            ; #3b42 231A - 1+
   .word _0               ; #3b44 2B2B - 0
   .word __28DO_29        ; #3b46 2991 - (DO)
   .word @3B9C            ; #3b48 3B9C
@3B4A:
   .word _CR              ; #3b4a 454C - CR
   .word _DUP             ; #3b4c 2277 - DUP
   .word _DUP             ; #3b4e 2277 - DUP
   .word _LIT             ; #3b50 28C7 - LIT
   .word 0004             ; #3b52 0004
   .word __2E0            ; #3b54 2EEA - .0
   .word _SPACE           ; #3b56 32A7 - SPACE
   .word _SPACE           ; #3b58 32A7 - SPACE
   .word _LIT             ; #3b5a 28C7 - LIT
   .word 0004             ; #3b5c 0004
   .word _0               ; #3b5e 2B2B - 0
   .word __28DO_29        ; #3b60 2991 - (DO)
   .word @3B84            ; #3b62 3B84
@3B64:
   .word _LIT             ; #3b64 28C7 - LIT
   .word 0004             ; #3b66 0004
   .word _0               ; #3b68 2B2B - 0
   .word __28DO_29        ; #3b6a 2991 - (DO)
   .word @3B7E            ; #3b6c 3B7E
@3B6E:
   .word _DUP             ; #3b6e 2277 - DUP
   .word _C_40            ; #3b70 282D - C@
   .word _2               ; #3b72 2B3D - 2
   .word __2E0            ; #3b74 2EEA - .0
   .word _SPACE           ; #3b76 32A7 - SPACE
   .word _1_2B            ; #3b78 231A - 1+
   .word __28LOOP_29      ; #3b7a 29DA - (LOOP)
   .word @3B6E            ; #3b7c 3B6E
@3B7E:
   .word _SPACE           ; #3b7e 32A7 - SPACE
   .word __28LOOP_29      ; #3b80 29DA - (LOOP)
   .word @3B64            ; #3b82 3B64
@3B84:
   .word _SWAP            ; #3b84 2238 - SWAP
   .word _LIT             ; #3b86 28C7 - LIT
   .word 0x002A           ; #3b88 002A
   .word _EMIT            ; #3b8a 3189 - EMIT
   .word _LIT             ; #3b8c 28C7 - LIT
   .word 0x0010           ; #3b8e 0010
   .word _PTYPE           ; #3b90 3157 - PTYPE
   .word _LIT             ; #3b92 28C7 - LIT
   .word 0x002A           ; #3b94 002A
   .word _EMIT            ; #3b96 3189 - EMIT
   .word __28LOOP_29      ; #3b98 29DA - (LOOP)
   .word @3B4A            ; #3b9a 3B4A
@3B9C:
   .word _DROP            ; #3b9c 222D - DROP
   .word _BASE            ; #3b9e 20C8 - BASE
   .word __21             ; #3ba0 2839 - !
   .word _EXIT            ; #3ba2 21A8 - EXIT

NFA_NLIST:       ; 3BA4
   .byte 5,"NLIST"
   .word NFA_DUMP         ; 3B2A
_NLIST:          ; 3BAC - 3BF5
   call _FCALL            ; 3BAC
@3BAF:
   .word __40             ; #3baf 2820 - @
   .word _DUP             ; #3bb1 2277 - DUP
   .word __3FBRANCH       ; #3bb3 2916 - ?BRANCH
   .word @3BF1            ; #3bb5 3BF1
   .word _DUP             ; #3bb7 2277 - DUP
   .word _COUNT           ; #3bb9 2BD2 - COUNT
   .word _LIT             ; #3bbb 28C7 - LIT
   .word 0x003F           ; #3bbd 003F
   .word _AND             ; #3bbf 2764 - AND
   .word _DUP             ; #3bc1 2277 - DUP
   .word _LIT             ; #3bc3 28C7 - LIT
   .word 0008             ; #3bc5 0008
   .word __2F             ; #3bc7 2C2F - /
   .word _1_2B            ; #3bc9 231A - 1+
   .word _LIT             ; #3bcb 28C7 - LIT
   .word 0008             ; #3bcd 0008
   .word __2A             ; #3bcf 253C - *
   .word _OVER            ; #3bd1 220D - OVER
   .word __2D             ; #3bd3 22F8 - -
   .word __2DROT          ; #3bd5 2269 - -ROT
   .word _TYPE            ; #3bd7 31B4 - TYPE
   .word _SPACES          ; #3bd9 32B9 - SPACES
   .word _N_3ELINK        ; #3bdb 3008 - N>LINK
;   .word __3EOUT          ; #3bdd 216B - >OUT
;   .word __40             ; #3bdf 2820 - @
;   .word _LIT             ; #3be1 28C7 - LIT
;   .word 63
;   .word _U_3C            ; #3be5 239D - U<
;   .word _N_3FBRANCH      ; #3be7 2934 - N?BRANCH
;   .word @3BED            ; #3be9 3BED
;   .word _CR              ; #3beb 454C - CR
;@3BED:
   .word _BRANCH          ; #3bed 2904 - BRANCH
   .word @3BAF            ; #3bef 3BAF
@3BF1:
   .word _DROP            ; #3bf1 222D - DROP
   .word _EXIT            ; #3bf3 21A8 - EXIT

NFA_VLIST:       ; 3BF5
   .byte 5,"VLIST"
   .word NFA_NLIST        ; 3BA4
_VLIST:          ; 3BFD - 3C08
   call _FCALL            ; 3BFD
   .word _CONTEXT, __40, _NLIST, _EXIT

NFA__2D_2D:      ; 3C08
   .byte 0x82,"--" ; IMMEDIATE
   .word NFA_VLIST        ; 3BF5
__2D_2D:         ; 3C0D - 3C1A
   call _FCALL            ; 3C0D
   .word __23TIB          ; #3c10 2148 - #TIB
   .word __40             ; #3c12 2820 - @
   .word __3EIN           ; #3c14 2153 - >IN
   .word __21             ; #3c16 2839 - !
   .word _EXIT            ; #3c18 21A8 - EXIT

NFA_DISFORT:     ; 3E04
   .byte 7,"DISFORT"
   .word NFA_STR          ; 3DE5
_DISFORT:        ; 3E0E - 3F7E
   call _FCALL            ; 3E0E
   .word _CR              ; #3e11 454C - CR
   .word __3ER            ; #3e13 27A9 - >R
   .word _R_40            ; #3e15 27CF - R@
   .word _C_40            ; #3e17 282D - C@
   .word _LIT             ; #3e19 28C7 - LIT
   .word 0x00CD           ; #3e1b 00CD
   .word __3C_3E          ; #3e1d 2CFA - <>
   .word __3FBRANCH       ; #3e1f 2916 - ?BRANCH
   .word @3E44            ; #3e21 3E44
   .word _R_3E            ; #3e23 27BC - R>
   .word __3FNAME         ; #3e25 3D88 - ?NAME
   .word __28_2E_22_29    ; #3e27 3421 - (.")
   .byte 24
   .stringmap russian,"ACCEMБЛEPHOE OПPEДEЛEHИE"
   .word _EXIT            ; #3e42 21A8 - EXIT
@3E44:
   .word _R_40            ; #3e44 27CF - R@
   .word _1_2B            ; #3e46 231A - 1+
   .word __40             ; #3e48 2820 - @
   .word _DUP             ; #3e4a 2277 - DUP
   .word _CALL            ; #3e4c 2201 - CALL
   .word __3D             ; #3e4e 2409 - =
   .word __3FBRANCH       ; #3e50 2916 - ?BRANCH
   .word @3F16            ; #3e52 3F16
   .word __28_2E_22_29    ; #3e54 3421 - (.")
   .byte 2,": "
   .word _DROP            ; #3e59 222D - DROP
   .word _R_3E            ; #3e5b 27BC - R>
   .word _DUP             ; #3e5d 2277 - DUP
   .word __3FNAME         ; #3e5f 3D88 - ?NAME
   .word _CFL             ; #3e61 2F44 - CFL
   .word __2B             ; #3e63 22ED - +
@3E65:
   .word _DUP             ; #3e65 2277 - DUP
   .word __40             ; #3e67 2820 - @
   .word _LIT             ; #3e69 28C7 - LIT
   .word _EXIT            ; #3e6b 21A8 - EXIT
   .word __3C_3E          ; #3e6d 2CFA - <>
   .word __3FBRANCH       ; #3e6f 2916 - ?BRANCH
   .word @3F0A            ; #3e71 3F0A
   .word _DUP             ; #3e73 2277 - DUP
   .word _DUP             ; #3e75 2277 - DUP
   .word __40             ; #3e77 2820 - @
   .word _LIT             ; #3e79 28C7 - LIT
   .word __28_22_29       ; #3e7b 28EF - (")
   .word __3D             ; #3e7d 2409 - =
   .word __3FBRANCH       ; #3e7f 2916 - ?BRANCH
   .word @3E93            ; #3e81 3E93
   .word _LIT             ; #3e83 28C7 - LIT
   .word 0x0022           ; #3e85 0022
   .word _EMIT            ; #3e87 3189 - EMIT
   .word _SPACE           ; #3e89 32A7 - SPACE
   .word _2_2B            ; #3e8b 2325 - 2+
   .word _STR             ; #3e8d 3DEB - STR
   .word _BRANCH          ; #3e8f 2904 - BRANCH
   .word @3F06            ; #3e91 3F06
@3E93:
   .word _DUP             ; #3e93 2277 - DUP
   .word __40             ; #3e95 2820 - @
   .word _LIT             ; #3e97 28C7 - LIT
   .word __28_2E_22_29    ; #3e99 3421 - (.")
   .word __3D             ; #3e9b 2409 - =
   .word __3FBRANCH       ; #3e9d 2916 - ?BRANCH
   .word @3EB7            ; #3e9f 3EB7
   .word _LIT             ; #3ea1 28C7 - LIT
   .word 0x002E           ; #3ea3 002E
   .word _EMIT            ; #3ea5 3189 - EMIT
   .word _LIT             ; #3ea7 28C7 - LIT
   .word 0x0022           ; #3ea9 0022
   .word _EMIT            ; #3eab 3189 - EMIT
   .word _SPACE           ; #3ead 32A7 - SPACE
   .word _2_2B            ; #3eaf 2325 - 2+
   .word _STR             ; #3eb1 3DEB - STR
   .word _BRANCH          ; #3eb3 2904 - BRANCH
   .word @3F06            ; #3eb5 3F06
@3EB7:
   .word _DUP             ; #3eb7 2277 - DUP
   .word __40             ; #3eb9 2820 - @
   .word _LIT             ; #3ebb 28C7 - LIT
   .word __28ABORT_22_29  ; #3ebd 2D61 - (ABORT")
   .word __3D             ; #3ebf 2409 - =
   .word __3FBRANCH       ; #3ec1 2916 - ?BRANCH
   .word @3EDB            ; #3ec3 3EDB
   .word __28_2E_22_29    ; #3ec5 3421 - (.")
   .byte 5,"ABORT"
   .word _LIT             ; #3ecd 28C7 - LIT
   .word 0x0022           ; #3ecf 0022
   .word _EMIT            ; #3ed1 3189 - EMIT
   .word _2_2B            ; #3ed3 2325 - 2+
   .word _STR             ; #3ed5 3DEB - STR
   .word _BRANCH          ; #3ed7 2904 - BRANCH
   .word @3F06            ; #3ed9 3F06
@3EDB:
   .word _DUP             ; #3edb 2277 - DUP
   .word __40             ; #3edd 2820 - @
   .word _LIT             ; #3edf 28C7 - LIT
   .word _LIT             ; #3ee1 28C7 - LIT
   .word __3D             ; #3ee3 2409 - =
   .word __3FBRANCH       ; #3ee5 2916 - ?BRANCH
   .word @3EFE            ; #3ee7 3EFE
   .word __28_2E_22_29    ; #3ee9 3421 - (.")
   .byte 4,"LIT "
   .word _2_2B            ; #3ef0 2325 - 2+
   .word _DUP             ; #3ef2 2277 - DUP
   .word __40             ; #3ef4 2820 - @
   .word __3FNAME         ; #3ef6 3D88 - ?NAME
   .word _2_2B            ; #3ef8 2325 - 2+
   .word _BRANCH          ; #3efa 2904 - BRANCH
   .word @3F06            ; #3efc 3F06
@3EFE:
   .word _DUP             ; #3efe 2277 - DUP
   .word __40             ; #3f00 2820 - @
   .word __3FNAME         ; #3f02 3D88 - ?NAME
   .word _2_2B            ; #3f04 2325 - 2+
@3F06:
   .word _BRANCH          ; #3f06 2904 - BRANCH
   .word @3E65            ; #3f08 3E65
@3F0A:
   .word __28_2E_22_29    ; #3f0a 3421 - (.")
   .byte 1,";"
   .word _CR              ; #3f0e 454C - CR
   .word _DROP            ; #3f10 222D - DROP
   .word _BRANCH          ; #3f12 2904 - BRANCH
   .word @3F7C            ; #3f14 3F7C
@3F16:
   .word _R_3E            ; #3f16 27BC - R>
   .word __3FNAME         ; #3f18 3D88 - ?NAME
   .word _DUP             ; #3f1a 2277 - DUP
   .word _NEXT            ; #3f1c 21F5 - NEXT
   .word __3D             ; #3f1e 2409 - =
   .word __3FBRANCH       ; #3f20 2916 - ?BRANCH
   .word @3F38            ; #3f22 3F38
   .word __28_2E_22_29    ; #3f24 3421 - (.")
   .byte 13
   .stringmap russian,"- ПEPEMEHHAЯ "
   .word _BRANCH          ; #3f34 2904 - BRANCH
   .word @3F7C            ; #3f36 3F7C
@3F38:
   .word _LIT             ; #3f38 28C7 - LIT
   .word __40             ; #3f3a 2820 - @
   .word __3D             ; #3f3c 2409 - =
   .word __3FBRANCH       ; #3f3e 2916 - ?BRANCH
   .word @3F56            ; #3f40 3F56
   .word __28_2E_22_29    ; #3f42 3421 - (.")
   .byte 13,"- KOHCTAHTA  "
   .word _BRANCH          ; #3f52 2904 - BRANCH
   .word @3F7C            ; #3f54 3F7C
@3F56:
   .word __28_2E_22_29    ; #3f56 3421 - (.")
   .byte 35
   .stringmap russian,"- OПPEДEЛEHИE ЧEPEЗ CREATE - DOES> "
@3F7C:
   .word _EXIT            ; #3f7c 21A8 - EXIT

NFA__3FNAME:     ; 3D80
   .byte 5,"?NAME"
   .word NFA_FORGET       ; 3D07
__3FNAME:        ; 3D88 - 3DE5
   call _FCALL            ; 3D88
   .word _F_2DCODE        ; #3d8b 323B - F-CODE
   .word _OVER            ; #3d8d 220D - OVER
   .word _U_3C            ; #3d8f 239D - U<
   .word _OVER            ; #3d91 220D - OVER
   .word _F_2DDATA        ; #3d93 3249 - F-DATA
   .word _LIT             ; #3d95 28C7 - LIT
   .word 0x3000           ; #3d97 3000
   .word __2B             ; #3d99 22ED - +
   .word _U_3C            ; #3d9b 239D - U<
   .word _AND             ; #3d9d 2764 - AND
   .word __3FBRANCH       ; #3d9f 2916 - ?BRANCH
   .word @3DE1            ; #3da1 3DE1
   .word _DUP             ; #3da3 2277 - DUP
   .word _2_2D            ; #3da5 233C - 2-
   .word _1_2D            ; #3da7 2331 - 1-
   .word _LIT             ; #3da9 28C7 - LIT
   .word 0x0010           ; #3dab 0010
   .word _1               ; #3dad 2B34 - 1
   .word __28DO_29        ; #3daf 2991 - (DO)
   .word @3DD9            ; #3db1 3DD9
@3DB3:
   .word _1_2D            ; #3db3 2331 - 1-
   .word _DUP             ; #3db5 2277 - DUP
   .word _C_40            ; #3db7 282D - C@
   .word _LIT             ; #3db9 28C7 - LIT
   .word 0x007F           ; #3dbb 007F
   .word _AND             ; #3dbd 2764 - AND
   .word _I               ; #3dbf 294B - I
   .word __3D             ; #3dc1 2409 - =
   .word __3FBRANCH       ; #3dc3 2916 - ?BRANCH
   .word @3DD5            ; #3dc5 3DD5
   .word _PRESS           ; #3dc7 22B4 - PRESS
   .word _ID_2E           ; #3dc9 32D0 - ID.
   .word _SPACE           ; #3dcb 32A7 - SPACE
   .word _RDROP           ; #3dcd 2811 - RDROP
   .word _RDROP           ; #3dcf 2811 - RDROP
   .word _RDROP           ; #3dd1 2811 - RDROP
   .word _EXIT            ; #3dd3 21A8 - EXIT
@3DD5:
   .word __28LOOP_29      ; #3dd5 29DA - (LOOP)
   .word @3DB3            ; #3dd7 3DB3
@3DD9:
   .word _DROP            ; #3dd9 222D - DROP
   .word __2E             ; #3ddb 2F15 - .
   .word _BRANCH          ; #3ddd 2904 - BRANCH
   .word @3DE3            ; #3ddf 3DE3
@3DE1:
   .word __2E             ; #3de1 2F15 - .
@3DE3:
   .word _EXIT            ; #3de3 21A8 - EXIT

.ENDS
