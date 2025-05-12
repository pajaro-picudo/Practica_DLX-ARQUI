.data
    wIteraciones: .word 5       ; Número de iteraciones (k=0 a k=4)
    ; --- Variables de salida (reserva espacio)
    potencias16:   .space 20    ; 5 words (k=0:16^0=1, k=1:16^1=16...)
    calculoA:      .space 20    ; 5 floats (1/16^k)
    kpop8:         .space 20    ; 5 words (8k)
    ; ... (añade el resto de variables del enunciado)

.text
    .global main
main:
    ; === Inicialización ===
    addi r1, r0, 0          ; r1 = k = 0
    addi r2, r0, 5          ; r2 = iteraciones máximas (5)
    ; ... (registros adicionales según necesites)

loop:
    ; === Cálculos para cada k ===
    ; 1. Calcular 16^k (almacenar en potencias16)
    ; 2. Calcular 1/16^k (almacenar en calculoA)
    ; 3. Calcular 8k, 8k+1, etc. (almacenar en kpop8, kpop8mas1...)
    ; 4. Calcular términos de la fórmula (4/(8k+1), 2/(8k+4), etc.)
    ; 5. Sumar al valor acumulado de π (calculoPT)

    ; === Condición del bucle ===
    addi r1, r1, 1          ; k++
    slt r3, r1, r2          ; r3 = (k < iteraciones)? 1 : 0
    bnez r3, loop           ; Si r3 != 0, repetir

    trap 0                  ; Terminar