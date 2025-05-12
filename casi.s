.data
;; INICIO VARIABLES DE ENTRADA Y SALIDA: NO MODIFICAR ORDEN
;; VARIABLE DE ENTRADA:
wIteraciones: .word 5
;; VARIABLES DE SALIDA:
potencias16: .space 5*4
kpop8: .space 5*4
kpop8mas1: .space 5*4
kpop8mas4: .space 5*4
kpop8mas5: .space 5*4
kpop8mas6: .space 5*4
calculoA: .space 5*4
calculoB: .space 5*4
calculoC: .space 5*4
calculoD: .space 5*4
calculoE: .space 5*4
calculoBCDE: .space 5*4
calculoITE: .space 5*4
calculoPT: .space 5*4
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

bucle_principal:
    ;; 1. Calcular 16^k (potencias16[k])
    JAL calcular_potencia16
    SW potencias16(R3), R4    ;; Guardar 16^k
    
    ;; 2. Calcular 1/16^k (calculoA[k])
    MOVI2FP F1, R4           ;; Convertir 16^k a float (CORRECCIÓN: MOVI2FP en lugar de CVTI2F)
    LF F2, float1(R0)        ;; Cargar 1.0
    DIVF F3, F2, F1          ;; 1/16^k
    SF calculoA(R3), F3      ;; Guardar 1/16^k
    
    ;; 3. Calcular 8k (kpop8[k])
    LW R5, valor8(R0)        ;; Cargar 8
    MULT R6, R2, R5          ;; 8*k
    SW kpop8(R3), R6         ;; Guardar 8k
    
    ;; 4. Calcular 8k+1 (kpop8mas1[k])
    LW R7, valor1(R0)        ;; Cargar 1
    ADD R8, R6, R7           ;; 8k+1
    SW kpop8mas1(R3), R8     ;; Guardar 8k+1
    
    ;; 5. Calcular 8k+4 (kpop8mas4[k])
    LW R9, valor4(R0)        ;; Cargar 4
    ADD R10, R6, R9          ;; 8k+4
    SW kpop8mas4(R3), R10    ;; Guardar 8k+4
    
    ;; 6. Calcular 8k+5 (kpop8mas5[k])
    LW R11, valor5(R0)       ;; Cargar 5
    ADD R12, R6, R11         ;; 8k+5
    SW kpop8mas5(R3), R12    ;; Guardar 8k+5
    
    ;; 7. Calcular 8k+6 (kpop8mas6[k])
    LW R13, valor6(R0)       ;; Cargar 6
    ADD R14, R6, R13         ;; 8k+6
    SW kpop8mas6(R3), R14    ;; Guardar 8k+6
    
    ;; 8. Calcular 4/(8k+1) (calculoB[k])
    MOVI2FP F4, R8           ;; Convertir 8k+1 a float (CORRECCIÓN: MOVI2FP)
    LF F5, float4(R0)        ;; Cargar 4.0
    DIVF F6, F5, F4          ;; 4/(8k+1)
    SF calculoB(R3), F6      ;; Guardar 4/(8k+1)
    
    ;; 9. Calcular 2/(8k+4) (calculoC[k])
    MOVI2FP F7, R10          ;; Convertir 8k+4 a float (CORRECCIÓN: MOVI2FP)
    LF F8, float2(R0)        ;; Cargar 2.0
    DIVF F9, F8, F7          ;; 2/(8k+4)
    SF calculoC(R3), F9      ;; Guardar 2/(8k+4)
    
    ;; 10. Calcular 1/(8k+5) (calculoD[k])
    MOVI2FP F10, R12         ;; Convertir 8k+5 a float (CORRECCIÓN: MOVI2FP)
    DIVF F11, F2, F10        ;; 1/(8k+5) (F2 ya tiene 1.0)
    SF calculoD(R3), F11     ;; Guardar 1/(8k+5)
    
    ;; 11. Calcular 1/(8k+6) (calculoE[k])
    MOVI2FP F12, R14         ;; Convertir 8k+6 a float (CORRECCIÓN: MOVI2FP)
    DIVF F13, F2, F12        ;; 1/(8k+6)
    SF calculoE(R3), F13     ;; Guardar 1/(8k+6) (CORRECCIÓN: calculoE estaba mal escrito)
    
    ;; 12. Calcular calculoBCDE = B - C - D - E
    SUBF F14, F6, F9         ;; B - C
    SUBF F14, F14, F11       ;; - D
    SUBF F14, F14, F13       ;; - E
    SF calculoBCDE(R3), F14  ;; Guardar B - C - D - E
    
    ;; 13. Calcular calculoITE = (1/16^k) * (B - C - D - E)
    MULTF F15, F3, F14       ;; (1/16^k) * (B - C - D - E)
    SF calculoITE(R3), F15   ;; Guardar término de la iteración
    
    ;; 14. Acumular en pi (calculoPT)
    ADDF F31, F31, F15       ;; Sumar término al acumulador
    SF calculoPT(R3), F31    ;; Guardar pi acumulado
    
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
    ;; Entrada: R2 = k
    ;; Salida: R4 = 16^k
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
