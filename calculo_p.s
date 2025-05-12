.data
wIteraciones:   .word 5
potencias16:    .space 20
calculoA:       .space 20
kpop8:          .space 20
kpop8mas1:      .space 20
kpop8mas4:      .space 20
kpop8mas5:      .space 20
kpop8mas6:      .space 20
calculoB:       .space 20
calculoC:       .space 20
calculoD:       .space 20
calculoE:       .space 20
calculoBCDE:    .space 20
calculoITE:     .space 20
calculoPT:      .space 20
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
fconst_small:   .float 0.0001
temp_mem:       .word 0

.text
.global main
main:
    LW R1, wIteraciones(R0)
    BEQZ R1, end_program
    LF F29, fconst1(R0)
    LF F28, fconst4(R0)
    LF F27, fconst2(R0)
    LF F30, fconst_small(R0)
    ADD R2, R0, R0
    LW R3, const16(R0)
    LW R4, const8(R0)

loop:
    JAL potencia16
    SW potencias16(R2), R5
    SW temp_mem(R0), R5
    LF F5, temp_mem(R0)
    DIVF F6, F29, F5
    SF calculoA(R2), F6
    MULT R6, R2, R4
    SW kpop8(R2), R6
    LW R7, const1(R0)
    ADD R8, R6, R7
    SW kpop8mas1(R2), R8
    LW R7, const4(R0)
    ADD R9, R6, R7
    SW kpop8mas4(R2), R9
    LW R7, const5(R0)
    ADD R10, R6, R7
    SW kpop8mas5(R2), R10
    LW R7, const6(R0)
    ADD R11, R6, R7
    SW kpop8mas6(R2), R11
    SW temp_mem(R0), R8
    LF F8, temp_mem(R0)
    DIVF F9, F28, F8
    SF calculoB(R2), F9
    SW temp_mem(R0), R9
    LF F10, temp_mem(R0)
    DIVF F11, F27, F10
    SF calculoC(R2), F11
    SW temp_mem(R0), R10
    LF F12, temp_mem(R0)
    DIVF F13, F29, F12
    SF calculoD(R2), F13
    SW temp_mem(R0), R11
    LF F14, temp_mem(R0)
    DIVF F15, F29, F14
    SF calculoE(R2), F15
    SUBF F16, F9, F11
    SUBF F16, F16, F13
    SUBF F16, F16, F15
    SF calculoBCDE(R2), F16
    MULTF F17, F6, F16
    SF calculoITE(R2), F17
    ADDF F30, F30, F17
    SF calculoPT(R2), F30
    MOVF F31, F30
    ADDI R2, R2, 1
    LW R1, wIteraciones(R0)
    SUB R12, R1, R2
    BNEZ R12, loop

end_program:
    TRAP 0

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