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

bucle_principal:
    ;; 1. Calcular 16^k (potencias16[k])
    JAL calcular_potencia16
    SW potencias16(R3), R4    ;; Guardar 16^k
    
    ;; 2. Calcular 1/16^k (calculoA[k])
    ;; F3 ya contiene el valor anterior de 1/16^k
    BEQZ R2, guardar_calculoA ;; Para k=0, no multiplicar
    LF F1, floatInv16(R0)    ;; Cargar 1/16 (0.0625)
    MULTF F3, F3, F1         ;; F3 = F3 * (1/16) (nuevo 1/16^k)
    NOP
    NOP
    NOP
guardar_calculoA:
    SF calculoA(R3), F3      ;; Guardar 1/16^k
    
    ;; 3. Calcular 8k (kpor8[k])
    LW R5, valor8(R0)        ;; Cargar 8
    MULT R6, R2, R5          ;; 8*k
    SW kpor8(R3), R6         ;; Guardar 8k
    
    ;; 4. Calcular 8k+1 (kpor8mas1[k])
    LW R7, valor1(R0)        ;; Cargar 1
    ADD R8, R6, R7           ;; 8k+1
    SW kpor8mas1(R3), R8     ;; Guardar 8k+1
    
    ;; 5. Calcular 8k+4 (kpor8mas4[k])
    LW R9, valor4(R0)        ;; Cargar 4
    ADD R10, R6, R9          ;; 8k+4
    SW kpor8mas4(R3), R10    ;; Guardar 8k+4
    
    ;; 6. Calcular 8k+5 (kpor8mas5[k])
    LW R11, valor5(R0)       ;; Cargar 5
    ADD R12, R6, R11         ;; 8k+5
    SW kpor8mas5(R3), R12    ;; Guardar 8k+5
    
    ;; 7. Calcular 8k+6 (kpor8mas6[k])
    LW R13, valor6(R0)       ;; Cargar 6
    ADD R14, R6, R13         ;; 8k+6
    SW kpor8mas6(R3), R14    ;; Guardar 8k+6
    
    ;; 8. Calcular 4/(8k+1) (calculoB[k])
    MOVI2FP F4, R8           ;; Mover 8k+1 a F4
    CVTI2F F4, F4            ;; Convertir a flotante
    LF F5, float4(R0)        ;; Cargar 4.0
    DIVF F6, F5, F4          ;; 4/(8k+1)
    NOP
    NOP
    NOP
    NOP
    SF calculoB(R3), F6      ;; Guardar 4/(8k+1)
    
    ;; 9. Calcular 2/(8k+4) (calculoC[k])
    MOVI2FP F7, R10          ;; Mover 8k+4 a F7
    CVTI2F F7, F7            ;; Convertir a flotante
    LF F8, float2(R0)        ;; Cargar 2.0
    DIVF F9, F8, F7          ;; 2/(8k+4)
    NOP
    NOP
    NOP
    NOP
    SF calculoC(R3), F9      ;; Guardar 2/(8k+4)
    
    ;; 10. Calcular 1/(8k+5) (calculoD[k])
    MOVI2FP F10, R12         ;; Mover 8k+5 a F10
    CVTI2F F10, F10          ;; Convertir a flotante
    LF F2, float1(R0)        ;; Cargar 1.0
    DIVF F11, F2, F10        ;; 1/(8k+5)
    NOP
    NOP
    NOP
    NOP
    SF calculoD(R3), F11     ;; Guardar 1/(8k+5)
    
    ;; 11. Calcular 1/(8k+6) (calculoE[k])
    MOVI2FP F12, R14         ;; Mover 8k+6 a F12
    CVTI2F F12, F12          ;; Convertir a flotante
    DIVF F13, F2, F12        ;; 1/(8k+6)
    NOP
    NOP
    NOP
    NOP
    SF calculoE(R3), F13     ;; Guardar 1/(8k+6)
    
    ;; 12. Calcular calculoBCDE = B - C - D - E
    ADDF F14, F11, F13       ;; F14 = D + E
    NOP                      ;; Evitar dependencia
    SUBF F15, F6, F9         ;; F15 = B - C
    NOP                      ;; Evitar dependencia
    SUBF F14, F15, F14       ;; F14 = (B - C) - (D + E)
    NOP                      ;; Evitar dependencia
    SF calculoBCDE(R3), F14  ;; Guardar B - C - D - E
    
    ;; 13. Calcular calculoITE = (1/16^k) * (B - C - D - E)
    MULTF F15, F3, F14       ;; (1/16^k) * (B - C - D - E)
    NOP
    NOP
    SF calculoITE(R3), F15   ;; Guardar término de la iteración
    
    ;; 14. Acumular en pi (calculoPI)
    ADDF F31, F31, F15       ;; Sumar término al acumulador
    NOP
    NOP
    SF calculoPI(R3), F31    ;; Guardar pi acumulado
    
    ;; Incrementar contador y puntero
    ADDI R2, R2, 1           ;; k++
    ADDI R3, R3, 4           ;; offset += 4
    
    ;; Comprobar si hemos terminado
    LW R1, wIteraciones(R0)
    SUB R15, R1, R2          ;; iteraciones - k
    BNEZ R15, bucle_principal

fin_programa:
    TRAP 0                   ;; Terminar programa

;; Subrutina para calcular 16^k
calcular_potencia16:
    ADD R4, R0, R0           ;; Inicializar resultado a 0
    ADDI R4, R4, 1           ;; resultado = 1 (caso k=0)
    BEQZ R2, fin_potencia    ;; Si k=0, terminar
    ADD R16, R0, R0          ;; contador i = 0
    ADDI R17, R0, 1          ;; valor temporal = 1
bucle_potencia:
    SLL R17, R17, 4          ;; Multiplicar por 16 (shift left 4 bits)
    ADDI R16, R16, 1         ;; i++
    SUB R18, R2, R16         ;; k - i
    BNEZ R18, bucle_potencia ;; Continuar si i < k
    ADD R4, R17, R0          ;; Guardar resultado en R4
fin_potencia:
    JR R31                   ;; Retornar
