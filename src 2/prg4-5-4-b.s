   .text
   .globl main

main:
    adr r1, a                     @ address vector a
    mov r2, #5                 @ inicializa r2
    mov r5, #0                 @inicializa r5 com 0
    add r4, r1, r2, LSL #2  @ adiciona r1 e r2 em r4 (soma de dois endereços)
loop:
    cmp r1, r4                  @ compara se r1 chegou em r4
    bge  writedone           @ branch se terminou
    strb    r5, [r1], #4        @ escreve 0 em r1+i
    b loop                         @ branch loop
writedone:
    swi 0x123456              @fim
     
a:
     .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

