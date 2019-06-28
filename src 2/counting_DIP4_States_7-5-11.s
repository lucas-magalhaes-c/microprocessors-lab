    .text
    .globl main
main:
    LDR r0, =0x3ff500           @ endereco IOPMOD 
    LDR r2, =0x1FCF0            @ seta OUTPUT [16:10] e [7:4]  | INPUT [3:0]
    STR r2, [r0]                @ seta r2 em IOPMOD (input e outputs setados)
    LDR r9, =0xF                @ cte F
    ADR r7, display_array       @ recebe endereco do vetor display codficador de 7 seg
    LDR r1, =0x3ff508           @ endereco IOPDATA
    LDR r10, =0x0               @ contador
    LDR r11, =0x1               @ cte 1
inicializa:
    LDR r3, [r1]                @ load valor IOPDATA
    AND r4, r3, r11             @ extrai valor de DIP4 (primeiro bit do IOPDATA)
    MOV r8, r4                  @ variavel aux que guarda valor anterior de DIP4 (aux DIP4)
    LDR r6, [r7]                @ recebe primeiro valor do vetor display (0x0)
    STR r6, [r1]                @ escreve 0 no display de 7 seg (IOPDATA[16:10])
loop_checagem:
    LDR r3, [r1]                @ load valor IOPDATA
    AND r4, r3, r11             @ extrai valor de DIP4 (primeiro bit do IOPDATA)
    CMP r4, r8                  @ compara com valor guardado de DIP4 anteriormente
    BEQ loop_checagem           @ se igual, checar novamente
    MOV r8, r4                  @ como eh diferente, mov r4 para r8 (aux DIP4)
    ADD r10, r10, r11           @ incrementa o contador
atualiza_display:
    LDR r6, [r7, r10, LSL #2]   @ recebe endereco do vetor display shiftado
    LDR r5, [r6]                @ recebe valor desse endereco shiftado
    STR r5, [r1]                @ escreve valor no display HEX (IOPDATA[16:10])
    CMP r9, r5                  @ compara se contador chegou em 0xF
    BEQ final                   @ se sim, finaliza
    B loop_checagem             @ se nao, volta a checar
@
display_array:
    .word	0x17C00, 0x1800, 0xEC00, 0xBC00, 0x19800, 0x1B400, 0x1F400, 0x1C00, 0x1FC00, 0x1BC00, 0x1DC00, 0x1F000, 0x16400, 0xF800, 0x1E400, 0x1C400
@
final:
    SWI 0x123