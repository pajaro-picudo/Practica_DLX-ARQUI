.data
;; INICIO VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN
wIteraciones: .word 5
potencias16: .space 5*4
kpor8: .space 5*4
kpor8mas1: .space 5*4
kpor8mas4: .space 5*4
kpor8mas5: .space 5*4
kpor8mas6: .space 5*4
calculoA: .space 5*4
calculoB: .space 5*4
calculoC: .space 5*4
calculoD: .space 5*4
calculoE: .space 5*4
calculoBCDE: .space 5*4
calculoITE: .space 5*4
calculoPI: .space 5*4
;; FIN VARIABLES ENTRADA Y SALIDA

;; Constantes
valor8: .word 8
float1: .float 1.0
float2: .float 2.0
float4: .float 4.0
floatInv16: .float 0.0625

.text
.global main
main:
    LW R1, wIteraciones(R0)
    BEQZ R1, fin_programa

    LF F1, float1(R0)
    LF F2, float2(R0)
    LF F4, float4(R0)
    LF F16, floatInv16(R0)
    SUBF F31, F1, F1
    MOVF F30, F1
    ADDI R24, R0, 8

    ;; Iteración 0
    ADDI R20, R0, 0
    ADDI R22, R0, 1
    SW potencias16(R20), R22
    MOVF F10, F30
    SF calculoA(R20), F10
    ADDI R25, R0, 0
    SW kpor8(R20), R25
    ADDI R5, R25, 1
    ADDI R6, R25, 4
    ADDI R7, R25, 5
    ADDI R8, R25, 6
    SW kpor8mas1(R20), R5
    SW kpor8mas4(R20), R6
    SW kpor8mas5(R20), R7
    SW kpor8mas6(R20), R8
    MOVI2FP F11, R5
    CVTI2F F11, F11
    DIVF F12, F4, F11
    SF calculoB(R20), F12
    MOVI2FP F13, R6
    CVTI2F F13, F13
    DIVF F14, F2, F13
    SF calculoC(R20), F14
    MOVI2FP F15, R7
    CVTI2F F15, F15
    DIVF F17, F1, F15
    SF calculoD(R20), F17
    MOVI2FP F18, R8
    CVTI2F F18, F18
    DIVF F19, F1, F18
    SF calculoE(R20), F19
    SUBF F21, F12, F14
    SUBF F21, F21, F17
    SUBF F21, F21, F19
    SF calculoBCDE(R20), F21
    MULTF F22, F10, F21
    SF calculoITE(R20), F22
    ADDF F31, F31, F22
    SF calculoPI(R20), F31
    MULTF F30, F30, F16

    ;; Iteración 1
    ADDI R20, R0, 4
    SLLI R22, R22, 4
    SW potencias16(R20), R22
    MOVF F10, F30
    SF calculoA(R20), F10
    ADDI R23, R0, 1
    MULT R25, R23, R24
    SW kpor8(R20), R25
    ADDI R5, R25, 1
    ADDI R6, R25, 4
    ADDI R7, R25, 5
    ADDI R8, R25, 6
    SW kpor8mas1(R20), R5
    SW kpor8mas4(R20), R6
    SW kpor8mas5(R20), R7
    SW kpor8mas6(R20), R8
    MOVI2FP F11, R5
    CVTI2F F11, F11
    DIVF F12, F4, F11
    SF calculoB(R20), F12
    MOVI2FP F13, R6
    CVTI2F F13, F13
    DIVF F14, F2, F13
    SF calculoC(R20), F14
    MOVI2FP F15, R7
    CVTI2F F15, F15
    DIVF F17, F1, F15
    SF calculoD(R20), F17
    MOVI2FP F18, R8
    CVTI2F F18, F18
    DIVF F19, F1, F18
    SF calculoE(R20), F19
    SUBF F21, F12, F14
    SUBF F21, F21, F17
    SUBF F21, F21, F19
    SF calculoBCDE(R20), F21
    MULTF F22, F10, F21
    SF calculoITE(R20), F22
    ADDF F31, F31, F22
    SF calculoPI(R20), F31
    MULTF F30, F30, F16

    ;; Iteración 2
    ADDI R20, R0, 8
    SLLI R22, R22, 4
    SW potencias16(R20), R22
    MOVF F10, F30
    SF calculoA(R20), F10
    ADDI R23, R0, 2
    MULT R25, R23, R24
    SW kpor8(R20), R25
    ADDI R5, R25, 1
    ADDI R6, R25, 4
    ADDI R7, R25, 5
    ADDI R8, R25, 6
    SW kpor8mas1(R20), R5
    SW kpor8mas4(R20), R6
    SW kpor8mas5(R20), R7
    SW kpor8mas6(R20), R8
    MOVI2FP F11, R5
    CVTI2F F11, F11
    DIVF F12, F4, F11
    SF calculoB(R20), F12
    MOVI2FP F13, R6
    CVTI2F F13, F13
    DIVF F14, F2, F13
    SF calculoC(R20), F14
    MOVI2FP F15, R7
    CVTI2F F15, F15
    DIVF F17, F1, F15
    SF calculoD(R20), F17
    MOVI2FP F18, R8
    CVTI2F F18, F18
    DIVF F19, F1, F18
    SF calculoE(R20), F19
    SUBF F21, F12, F14
    SUBF F21, F21, F17
    SUBF F21, F21, F19
    SF calculoBCDE(R20), F21
    MULTF F22, F10, F21
    SF calculoITE(R20), F22
    ADDF F31, F31, F22
    SF calculoPI(R20), F31
    MULTF F30, F30, F16

    ;; Iteración 3
    ADDI R20, R0, 12
    SLLI R22, R22, 4
    SW potencias16(R20), R22
    MOVF F10, F30
    SF calculoA(R20), F10
    ADDI R23, R0, 3
    MULT R25, R23, R24
    SW kpor8(R20), R25
    ADDI R5, R25, 1
    ADDI R6, R25, 4
    ADDI R7, R25, 5
    ADDI R8, R25, 6
    SW kpor8mas1(R20), R5
    SW kpor8mas4(R20), R6
    SW kpor8mas5(R20), R7
    SW kpor8mas6(R20), R8
    MOVI2FP F11, R5
    CVTI2F F11, F11
    DIVF F12, F4, F11
    SF calculoB(R20), F12
    MOVI2FP F13, R6
    CVTI2F F13, F13
    DIVF F14, F2, F13
    SF calculoC(R20), F14
    MOVI2FP F15, R7
    CVTI2F F15, F15
    DIVF F17, F1, F15
    SF calculoD(R20), F17
    MOVI2FP F18, R8
    CVTI2F F18, F18
    DIVF F19, F1, F18
    SF calculoE(R20), F19
    SUBF F21, F12, F14
    SUBF F21, F21, F17
    SUBF F21, F21, F19
    SF calculoBCDE(R20), F21
    MULTF F22, F10, F21
    SF calculoITE(R20), F22
    ADDF F31, F31, F22
    SF calculoPI(R20), F31
    MULTF F30, F30, F16

    ;; Iteración 4
    ADDI R20, R0, 16
    SLLI R22, R22, 4
    SW potencias16(R20), R22
    MOVF F10, F30
    SF calculoA(R20), F10
    ADDI R23, R0, 4
    MULT R25, R23, R24
    SW kpor8(R20), R25
    ADDI R5, R25, 1
    ADDI R6, R25, 4
    ADDI R7, R25, 5
    ADDI R8, R25, 6
    SW kpor8mas1(R20), R5
    SW kpor8mas4(R20), R6
    SW kpor8mas5(R20), R7
    SW kpor8mas6(R20), R8
    MOVI2FP F11, R5
    CVTI2F F11, F11
    DIVF F12, F4, F11
    SF calculoB(R20), F12
    MOVI2FP F13, R6
    CVTI2F F13, F13
    DIVF F14, F2, F13
    SF calculoC(R20), F14
    MOVI2FP F15, R7
    CVTI2F F15, F15
    DIVF F17, F1, F15
    SF calculoD(R20), F17
    MOVI2FP F18, R8
    CVTI2F F18, F18
    DIVF F19, F1, F18
    SF calculoE(R20), F19
    SUBF F21, F12, F14
    SUBF F21, F21, F17
    SUBF F21, F21, F19
    SF calculoBCDE(R20), F21
    MULTF F22, F10, F21
    SF calculoITE(R20), F22
    ADDF F31, F31, F22
    SF calculoPI(R20), F31

fin_programa:
    TRAP 0