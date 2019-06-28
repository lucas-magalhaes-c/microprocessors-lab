.text
    .globl main
main:
    adr r11, x                   @ carrega o vetor x 
    adr r12, z                   @ carrega o vetor z
    mov r9, #32                  @ size of Y
    mov r1, #10               @ quantidade de valores em r8
    mov r7, #0                  @ inicializa i
    ldr r4, =0xB                @ inicializa b1011
    ldr r5, =0xF                @ inicializa b1111 para usar no AND
new_iteration:
    mov r2, #0                  @ inicializa 0 em z
    ldr r8, [r11, r7, lsl #2]  @ inicializacao value x[i]
    mov r3, #1                  @ inicializa 1 no incremento
    rsb r9, r9, #32             @ decrementa, r9 = 32-(r9 anterior)
    mov r8, r8, lsl r9         @ shift left de 32-(r9 anterior)
    mov r8, r8, lsr r9         @ shift right, para preencher com zeros a esquerda
loop:
    cmp r8, r4                  @ compara x com b1011
    blo end                      @ branch se x < 1011
    and r6, r8, r5             @ pega os 4 bits menos significativos do x atual
    cmp r6, r4                  @ compara se da match
    addeq r2, r2, r3         @ adiciona o incremento r3 ao z somente se houver match
    mov r8, r8, lsr #1       @ shift right em x 
    mov r3, r3, lsl #1       @ shift left no incremento r3 de z
    b loop                        @ branch loop
end: 
   str r2, [r12, r7, lsl #2]  @ salva o valor no vetor z
   add r7, r7, #1              @ incrementa i 
   cmp r7, r1                   @ compara i_max com i
   blo new_iteration        @ faz uma nova iteracao caso ainda haja elementos em x
   swi 0x123456          @ end

x:
    .word 91, 182, 21, 35, 41, 20, 6, 43, 34, 12, 9, 64, 1, 7, 14, 18,16, 50, 36, 19, 25
z: 
    .space 100
