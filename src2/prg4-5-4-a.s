  .text
  .globl main

main:
    ldr r0, =0                   @ initialize (r0 = 0)
    ldr r9, =10                 @ s value
    adr r1, a                    @ address vector a
    ldr r8, =0                   @ carrega zero

loop: 
    cmp r0, r9                  @ compara i com s
    beq writedone           @ branch se terminou
    add r2, r1, r0, lsl #2   @ endereco a + i*4
    str r8,[r2]                    @ escreve 0 no endereco a[i]
    add r0, r0, #1                 @ incrementa i
    b loop                         @ branch loop
writedone:
    swi 0x123456                            @ fim

a:
    .word    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 

