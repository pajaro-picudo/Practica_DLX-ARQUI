.data
;; Variables de entrada y salida
wIteraciones:   .word 5

;; Variables de salida
potencias16:    .space 5*4
calculoA:       .space 5*4
kpop8:          .space 5*4
kpop8mas1:      .space 5*4
kpop8mas4:      .space 5*4
kpop8mas5:      .space 5*4
kpop8mas6:      .space 5*4
calculoB:       .space 5*4
calculoC:       .space 5*4
calculoD:       .space 5*4
calculoE:       .space 5*4
calculoBCDE:    .space 5*4
calculoITE:     .space 5*4
calculoPT:      .space 5*4

;; Constantes
const16:        .word 16
const8:         .word 8
const1:         .word 1
const4:         .word 4
const2:         .word 2
fconst1:        .float 1.0
fconst4:        .float 4.0
fconst2:        .float 2.0
pi_acumulado:   .float 0.0

.text
.global main
main:
    LW R1, wIteraciones
    BEQZ R1, end_program

    MOVI2F F31, fconst0
    MOVI2F F30, pi_acumulado
    MOVI2F F29, fconst1
    MOVI2F F28, fconst4
    MOVI2F F27, fconst2
    
    ADD R2, R0, R0
    LW R3, const16
    LW R4, const8
    
loop:
    JAL potencia16
    SW (R2*4)(potencias16), R5
    
    CVTI2F F5, R5
    DIVF F6, F29, F5
    SF (R2*4)(calculoA), F6
    
    MULT R6, R2, R4
    SW (R2*4)(kpop8), R6
    
    LW R7, const1
    ADD R8, R6, R7
    SW (R2*4)(kpop8mas1), R8
    
    LW R7, const4
    ADD R9, R6, R7
    SW (R2*4)(kpop8mas4), R9
    
    LW R7, const5
    ADD R10, R6, R7
    SW (R2*4)(kpop8mas5), R10
    
    LW R7, const6
    ADD R11, R6, R7
    SW (R2*4)(kpop8mas6), R11
    
    CVTI2F F8, R8
    DIVF F9, F28, F8
    SF (R2*4)(calculoB), F9
    
    CVTI2F F10, R9
    DIVF F11, F27, F10
    SF (R2*4)(calculoC), F11
    
    CVTI2F F12, R10
    DIVF F13, F29, F12
    SF (R2*4)(calculoD), F13
    
    CVTI2F F14, R11
    DIVF F15, F29, F14
    SF (R2*4)(calculoE), F15
    
    SUBF F16, F9, F11
    SUBF F16, F16, F13
    SUBF F16, F16, F15
    SF (R2*4)(calculoBCDE), F16
    
    MULTF F17, F6, F16
    SF (R2*4)(calculoITE), F17
    
    ADDF F30, F30, F17
    SF (R2*4)(calculoPT), F30
    
    ADDI R2, R2, 1
    MOVF F31, F30
    
    LW R1, wIteraciones
    SUB R12, R1, R2
    BNEZ R12, loop

end_program:
    TRAP 0

potencia16:
    ADD R5, R0, 1
    BEQZ R2, end_potencia
    
    ADD R6, R0, R2
potencia_loop:
    MULT R5, R5, R3
    SUBI R6, R6, 1
    BNEZ R6, potencia_loop
    
end_potencia:
    JR R31