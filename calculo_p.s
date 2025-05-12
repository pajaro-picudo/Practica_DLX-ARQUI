.data
;; Variables de entrada y salida
wIteraciones:   .word 5

;; Variables de salida
potencias16:    .space 20       ; 5 words
calculoA:       .space 20       ; 5 floats
kpop8:          .space 20       ; 5 words
kpop8mas1:      .space 20       ; 5 words
kpop8mas4:      .space 20       ; 5 words
kpop8mas5:      .space 20       ; 5 words
kpop8mas6:      .space 20       ; 5 words
calculoB:       .space 20       ; 5 floats
calculoC:       .space 20       ; 5 floats
calculoD:       .space 20       ; 5 floats
calculoE:       .space 20       ; 5 floats
calculoBCDE:    .space 20       ; 5 floats
calculoITE:     .space 20       ; 5 floats
calculoPT:      .space 20       ; 5 floats

;; Constantes
const16:        .word 16
const8:         .word 8
const1:         .word 1
const4:         .word 4
const2:         .word 2
const5:         .word 5
const6:         .word 6
fconst1:        .float 1.0
fconst4:        .float 4.0
fconst2:        .float 2.0
fconst0:        .float 0.0

.text
.global main
main:
    LW R1, wIteraciones(R0)
    BEQZ R1, end_program

    ;; Inicialización de registros flotantes
    LF F29, fconst1(R0)
    LF F28, fconst4(R0)
    LF F27, fconst2(R0)
    LF F30, fconst0(R0)       
    
    ADD R2, R0, R0            
    LW R3, const16(R0)
    LW R4, const8(R0)

loop:
    ;; 1. Calcular 16^k y almacenar
    JAL potencia16
    SW potencias16(R2*4), R5

    ;; 2. Calcular 1/16^k y almacenar
    CVTI2F F5, R5
    DIVF F6, F29, F5           
    SF calculoA(R2*4), F6

    ;; 3. Calcular 8k y derivados
    MULT R6, R2, R4          
    SW kpop8(R2*4), R6

    LW R7, const1(R0)
    ADD R8, R6, R7             
    SW kpop8mas1(R2*4), R8

    LW R7, const4(R0)
    ADD R9, R6, R7             
    SW kpop8mas4(R2*4), R9

    LW R7, const5(R0)
    ADD R10, R6, R7            
    SW kpop8mas5(R2*4), R10

    LW R7, const6(R0)
    ADD R11, R6, R7          
    SW kpop8mas6(R2*4), R11

    ;; 4. Calcular componentes flotantes
    CVTI2F F8, R8
    DIVF F9, F28, F8          
    SF calculoB(R2*4), F9

    CVTI2F F10, R9
    DIVF F11, F27, F10        
    SF calculoC(R2*4), F11

    CVTI2F F12, R10
    DIVF F13, F29, F12        
    SF calculoD(R2*4), F13

    CVTI2F F14, R11
    DIVF F15, F29, F14         
    SF calculoE(R2*4), F15

    ;; 5. Calcular BCDE = B - C - D - E
    SUBF F16, F9, F11          
    SUBF F16, F16, F13       
    SUBF F16, F16, F15       
    SF calculoBCDE(R2*4), F16

    ;; 6. Calcular término iteración
    MULTF F17, F6, F16         
    SF calculoITE(R2*4), F17

    ;; 7. Acumular π
    ADDF F30, F30, F17
    SF calculoPT(R2*4), F30
    MOVF F31, F30              

    ;; 8. Siguiente iteración
    ADDI R2, R2, 1
    LW R1, wIteraciones(R0)
    SUB R12, R1, R2
    BNEZ R12, loop

end_program:
    TRAP 0

;; Subrutina para calcular 16^k
potencia16:
    ADDI R5, R0, 1
    BEQZ R2, end_potencia
    
    ADD R6, R0, R2
potencia_loop:
    MULT R5, R5, R3
    SUBI R6, R6, 1
    BNEZ R6, potencia_loop
    
end_potencia:
    JR R31