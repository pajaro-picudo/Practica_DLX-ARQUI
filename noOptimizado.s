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

;; Variables temporales
valor1: .word 1
valor2: .word 2
valor4: .word 4
valor5: .word 5
valor6: .word 6
valor8: .word 8
float1: .float 1.0
float2: .float 2.0
float4: .float 4.0
floatInv16: .float 0.0625
pi: .float 0.0

.text
.global main
main:
    ;; Cargar el número de iteraciones
    LW R1, wIteraciones(R0)
    BEQZ R1, fin_programa    ;; Si iteraciones == 0, terminar

    ;; Inicializar contador k (R2) y puntero (R3)
    ADD R2, R0, R0           ;; k = 0
    ADD R3, R0, R0           ;; offset = 0

    ;; Inicializar pi a 0
    LF F0, pi(R0)
    MOVF F31, F0             ;; f31 = 0.0 (acumulador de pi)

    ;; Inicializar 1/16^k a 1.0 (para k=0)
    LF F3, float1(R0)        ;; F3 = 1.0 (calculoA inicial)

    ;; Cargar constantes una sola vez fuera del bucle
    LW R5, valor8(R0)        ;; 8
    LW R7, valor1(R0)        ;; 1
    LW R9, valor4(R0)        ;; 4
    LW R11, valor5(R0)       ;; 5
    LW R13, valor6(R0)       ;; 6
    LF F5, float4(R0)        ;; 4.0
    LF F8, float2(R0)        ;; 2.0
    LF F2, float1(R0)        ;; 1.0
    LF F1, floatInv16(R0)    ;; 0.0625

bucle_principal:
    ;; Iteración para k
    SLL R4, R7, R2
    SW potencias16(R3), R4

    BEQZ R2, skip_multf
    MULTF F3, F3, F1
    NOP
    NOP
    NOP
skip_multf:
    SF calculoA(R3), F3

    MULT R6, R2, R5
    ADD R8, R6, R7
    ADD R10, R6, R9
    ADD R12, R6, R11
    ADD R14, R6, R13
    SW kpor8(R3), R6
    SW kpor8mas1(R3), R8
    SW kpor8mas4(R3), R10
    SW kpor8mas5(R3), R12
    SW kpor8mas6(R3), R14

    MOVI2FP F4, R8
    CVTI2F F4, F4
    DIVF F6, F5, F4
    NOP
    NOP
    NOP
    NOP
    SF calculoB(R3), F6

    MOVI2FP F7, R10
    CVTI2F F7, F7
    DIVF F9, F8, F7
    NOP
    NOP
    NOP
    NOP
    SF calculoC(R3), F9

    MOVI2FP F10, R12
    CVTI2F F10, F10
    DIVF F11, F2, F10
    NOP
    NOP
    NOP
    NOP
    SF calculoD(R3), F11

    MOVI2FP F12, R14
    CVTI2F F12, F12
    DIVF F13, F2, F12
    NOP
    NOP
    NOP
    NOP
    SF calculoE(R3), F13

    ADDF F14, F11, F13
    NOP
    SUBF F15, F6, F9
    NOP
    SUBF F14, F15, F14
    NOP
    SF calculoBCDE(R3), F14

    MULTF F16, F3, F14
    NOP
    NOP
    SF calculoITE(R3), F16

    ADDF F31, F31, F16
    NOP
    NOP
    SF calculoPI(R3), F31

    ;; Iteración para k+1 (solo si quedan iteraciones)
    ADDI R20, R2, 1
    ADDI R21, R3, 4
    LW R1, wIteraciones(R0)
    SUB R22, R1, R20
    BEQZ R22, skip_second
    ;; Si R22 == 0, saltamos la segunda iteración
    ;; Si R22 != 0, continuamos con la segunda iteración

    SLL R24, R7, R20
    SW potencias16(R21), R24

    MULTF F17, F3, F1
    NOP
    NOP
    NOP
    SF calculoA(R21), F17

    MULT R26, R20, R5
    ADD R28, R26, R7
    ADD R30, R26, R9
    ADD R18, R26, R11
    ADD R19, R26, R13
    SW kpor8(R21), R26
    SW kpor8mas1(R21), R28
    SW kpor8mas4(R21), R30
    SW kpor8mas5(R21), R18
    SW kpor8mas6(R21), R19

    MOVI2FP F18, R28
    CVTI2F F18, F18
    DIVF F19, F5, F18
    NOP
    NOP
    NOP
    NOP
    SF calculoB(R21), F19

    MOVI2FP F20, R30
    CVTI2F F20, F20
    DIVF F21, F8, F20
    NOP
    NOP
    NOP
    NOP
    SF calculoC(R21), F21

    MOVI2FP F22, R18
    CVTI2F F22, F22
    DIVF F23, F2, F22
    NOP
    NOP
    NOP
    NOP
    SF calculoD(R21), F23

    MOVI2FP F24, R19
    CVTI2F F24, F24
    DIVF F25, F2, F24
    NOP
    NOP
    NOP
    NOP
    SF calculoE(R21), F25

    ADDF F26, F23, F25
    NOP
    SUBF F27, F19, F21
    NOP
    SUBF F26, F27, F26
    NOP
    SF calculoBCDE(R21), F26

    MULTF F28, F17, F26
    NOP
    NOP
    SF calculoITE(R21), F28

    ADDF F31, F31, F28
    NOP
    NOP
    SF calculoPI(R21), F31

skip_second:
    ;; Incrementar contador y puntero en 2
    ADDI R2, R2, 2
    ADDI R3, R3, 8

    ;; Comprobar si hemos terminado (R2 >= wIteraciones)
    LW R1, wIteraciones(R0)
    SUB R15, R2, R1        ;; R15 = R2 - wIteraciones
    BEQZ R15, ultima_iteracion_check ;; Si R2 == wIteraciones, comprobar si falta la última iteración
    ;; Si R15 < 0, seguimos en el bucle
    ;; Si R15 > 0, terminamos (ya hemos sobrepasado el límite)
    BNEZ R15, fin_programa
    J bucle_principal

ultima_iteracion_check:
    ;; Si el número de iteraciones es impar, falta una última iteración
    ;; Comprobamos si R2 - wIteraciones == 0 y wIteraciones es impar
    LW R1, wIteraciones(R0)
    ANDI R23, R1, 1        ;; R23 = wIteraciones & 1
    BEQZ R23, fin_programa ;; Si es par, terminamos

    ;; Última iteración si es impar (usa R2 y R3 actuales)
    SLL R4, R7, R2
    SW potencias16(R3), R4

    BEQZ R2, skip_multf_final
    MULTF F3, F3, F1
    NOP
    NOP
    NOP
skip_multf_final:
    SF calculoA(R3), F3

    MULT R6, R2, R5
    ADD R8, R6, R7
    ADD R10, R6, R9
    ADD R12, R6, R11
    ADD R14, R6, R13
    SW kpor8(R3), R6
    SW kpor8mas1(R3), R8
    SW kpor8mas4(R3), R10
    SW kpor8mas5(R3), R12
    SW kpor8mas6(R3), R14

    MOVI2FP F4, R8
    CVTI2F F4, F4
    DIVF F6, F5, F4
    NOP
    NOP
    NOP
    NOP
    SF calculoB(R3), F6

    MOVI2FP F7, R10
    CVTI2F F7, F7
    DIVF F9, F8, F7
    NOP
    NOP
    NOP
    NOP
    SF calculoC(R3), F9

    MOVI2FP F10, R12
    CVTI2F F10, F10
    DIVF F11, F2, F10
    NOP
    NOP
    NOP
    NOP
    SF calculoD(R3), F11

    MOVI2FP F12, R14
    CVTI2F F12, F12
    DIVF F13, F2, F12
    NOP
    NOP
    NOP
    NOP
    SF calculoE(R3), F13

    ADDF F14, F11, F13
    NOP
    SUBF F15, F6, F9
    NOP
    SUBF F14, F15, F14
    NOP
    SF calculoBCDE(R3), F14

    MULTF F16, F3, F14
    NOP
    NOP
    SF calculoITE(R3), F16

    ADDF F31, F31, F16
    NOP
    NOP
    SF calculoPI(R3), F31

fin_programa:
    TRAP 0

;; Subrutina para calcular 16^k
calcular_potencia16:
    ADD R4, R0, R0
    ADDI R4, R4, 1
    BEQZ R2, fin_potencia
    ADD R16, R0, R0
    ADDI R17, R0, 1
bucle_potencia:
    SLL R17, R17, 4
    ADDI R16, R16, 1
    SUB R18, R2, R16
    BNEZ R18, bucle_potencia
    ADD R4, R17, R0
fin_potencia:
    JR R31
