    .text
    .globl main
main:
    ldr r8, =0b0110110  @ inicializacao 0b0110110 = 0x36 (value of Y)
    ldr r9, =0x7              @ size of Y
    mov r2, #0               @ inicializa 0 em z
    mov r3, #1               @ inicializa 1 em 
    ldr r4, =0xB             @ inicializa b1011
    ldr r5, =0xF             @ inicializa b1111 para usar no AND
    rsb r9, r9, #32         @ decrementa, r9 = 32-(r9 anterior)
    mov r8, r8, lsl r9      @ shift left de 32-(r9 anterior)
    mov r8, r8, lsr r9     @ shift right, para preencher com zeros a esquerda
loop:
    cmp r8, r4                @ compara x com b1011
    blo end                    @ branch se x < 1011
    and r6, r8, r5           @ pega os 4 bits menos significativos do x atual
    cmp r6, r4                @ compara se da match
    addeq r2, r2, r3       @ adiciona o incremento r3 ao z somente se houver match
    mov r8, r8, lsr #1     @ shift right em x 
    mov r3, r3, lsl #1     @ shift left no incremento r3 de z
    b loop                      @ branch loop
end: 
    swi 0x123456         @ end

