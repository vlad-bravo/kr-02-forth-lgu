
.include "forth_defs.inc"
.include "interpret_defs.inc"
.include "math_defs.inc"
.include "tests_defs.inc"
.include "utils_defs.inc"

; From var.asm
.def _R0 v_R0
.def _S0 v_S0
.def _H v_H
.def _HLD v_HLD
.def _VOC_2DLINK v_VOC_2DLINK
.def _FENCE v_FENCE
.def _W_2DLINK v_W_2DLINK
.def _BASE v_BASE
.def _STATE v_STATE
.def _CONTEXT v_CONTEXT
.def _CURRENT v_CURRENT
.def _DPL v_DPL
.def _CSP v_CSP
.def _INLINP v_INLINP
.def _OUTLINP v_OUTLINP
.def _INB v_INB
.def __23TIB v__23TIB
.def __3EIN v__3EIN
.def _SPAN v_SPAN
.def __3EOUT v__3EOUT
.def _TIB v_TIB
.def _NEXT v_NEXT
.def _CALL v_CALL
.def __2D1 v__2D1
.def _0 v_0
.def _1 v_1
.def _2 v_2
.def _TRUE v_TRUE
.def _FALSE v_FALSE
.def _F_2DCODE v_F_2DCODE
.def _F_2DDATA v_F_2DDATA
.def _CFL v_CFL
.def _BL v_BL
.def _ST_2DC v_ST_2DC
.def _B_2DSP v_B_2DSP

; From math.asm
.def __2B m__2B
.def __2D m__2D
.def _NEGATE m_NEGATE
.def _1_2B m_1_2B
.def _2_2B m_2_2B
.def _1_2D m_1_2D
.def _2_2D m_2_2D
.def _2_2A m_2_2A
.def _ABS m_ABS
.def _MIN m_MIN
.def _MAX m_MAX
.def _U_3C m_U_3C
.def __3C m__3C
.def __3E m__3E
.def _0_3C m_0_3C
.def _0_3E m_0_3E
.def __3D m__3D
.def _0_3D m_0_3D
.def _2_2F m_2_2F
.def _D_2B m_D_2B
.def _D_3C m_D_3C
.def _DNEGATE m_DNEGATE
.def __2A m__2A
.def _UM_2A m_UM_2A
.def _DU_2FMOD m_DU_2FMOD
.def __2FMOD m__2FMOD
.def _U_2FMOD m_U_2FMOD
.def _AND m_AND
.def _OR m_OR
.def _XOR m_XOR
.def _NOT m_NOT

; From life_manual.asm
.def _VIDMEM l_VIDMEM
.def _SIZE l_SIZE
.def _WIDTH l_WIDTH
.def _HEIGHT l_HEIGHT
.def _LIVE l_LIVE
.def _DEAD l_DEAD
.def _SLIVE l_SLIVE
.def _SDEAD l_SDEAD
.def _PLIVE l_PLIVE
.def _PDEAD l_PDEAD
.def _CHECKLIVE l_CHECKLIVE
.def _COUNTNEIGHBORS l_COUNTNEIGHBORS
