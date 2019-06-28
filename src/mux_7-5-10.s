    .text
    .globl main
main:
    LDR r0, =0x3ff5000           @ endereco IOPMOD 
    LDR r2, =0x1FCF0            @ seta OUTPUT [16:10] e [7:4]  | INPUT [3:0]
    STR r2, [r0]                @ seta r2 em IOPMOD (input e outputs setados)
    LDR r9, =0xF                @ cte F
    ADR r7, display_array       @ recebe endereco do vetor display codficador de 7 seg
    LDR r1, =0x3ff5008           @ endereco IOPDATA
    LDR r11, =0x1               @ cte 1
    ADR r12, values_vec         @ endereco a ser mostrado
loop:
    LDR r2, =0xfffff            @ tempo de espera
    LDR r3, [r1]                @ recebe conteudo de IOPDATA
    AND r4, r3, r9              @ recebe DIPS
    LDR r8, [r12, r4, LSL #2]   @ conteudo de values_vec [+DIPS]
atualiza_display_e_LEDs:
    LDR r6, [r7, r8, LSL #2]    @ recebe endereco do vetor display shiftado
    MOV r10, r4, LSL #2         @ Shift pra escrever nos LEDS
    ADD r6, r6, r10             @ Soma leds e hex values para escrever no IOPDATA
    STR r6, [r1]                @ escreve valor no IOPDATA
    LDR r5, =0x0                @ inicializa pra comparar
wait_loop:
    SUB r2, r2, r11             @ sub
    CMP r2, r5
    BNE wait_loop               @ se nao, volta a checar
    B loop
@
display_array:
    .word	0x17C00, 0x1800, 0xEC00, 0xBC00, 0x19800, 0x1B400, 0x1F400, 0x1C00, 0x1FC00, 0x1BC00, 0x1DC00, 0x1F000, 0x16400, 0xF800, 0x1E400, 0x1C400
values_vec:
    .word	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    SWI 0x123