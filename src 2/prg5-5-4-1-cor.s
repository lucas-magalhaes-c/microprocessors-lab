 .text
    .globl main
main:
    adr r11, x                   @ carrega o vetor x 
    adr r12, z                   @ carrega o vetor z
    mov r1, #10               @ quantidade de valores em r8
    mov r7, #0                  @ inicializa i
    ldr r4, =0xB                @ inicializa b1011
    ldr r5, =0xF                @ inicializa b1111 para usar no AND
new_iteration:
    mov r2, #0                  @ inicializa 0 em z
    mov r9, #32                  @ size of Y
    ldr r8, [r11, r7, lsl #2]  @ inicializacao value x[i]
    mov r3, #1                  @ inicializa 1 no incremento
    rsb r9, r9, #32             @ decrementa, r9 = 32-(r9 anterior)
    mov r8, r8, lsl r9         @ shift left de 32-(r9 anterior)
    mov r8, r8, lsr r9         @ shift right, para preencher com zeros a esquerda
 @ Registradores especificados
    @     r1 = Input
    @     r2 = Output
    @     r8 = Sequencia
    @     r9 = Tamanho da sequencia

    @ Registradores auxiliares
    @     r3 = Input shiftado: Registrador com shifts do input para nao alterar r1
    @     r4 = Mascara de input: Mascara de bits 1 para realizar ANDs p/ comparacoes
    @     r5 = Input shiftado com mascara: r4 & r3
    @     r6 = Iterador: Mantem numero das iteracoes
    @     r7 = Sequencia com mascara: r4 & r8

main:
    @ Entradas do programa
    LDR    r1, =0xF0F0F0F0 @ Sequencia de entrada
    LDR    r8, =0xFFFFFFFF @ Palavra de busca
    MOV    r9, #32   	 @ Tamanho da palavra de busca

    @ Inicializacao de registradores
    MOV    r2, #0   	 @ Limpa registrador de output

    @ Casos invalidos
    CMP    r9, #1   	 @ Se possui menos que 1 bit de sequencia...
    MVNLT    r2, #0   	 @ ... entao sempre encontra na entrada...
    BLT    fim   	 @ ... e nao precisa executar a rotina.
    CMP    r9, #32   	 @ Se a sequencia for maior que a entrada...
    BGT    fim   	 @ ... entao nunca encontrara o resultado na rotina.

    @ Criar mascara
    MVN    r4, #0   	 @ Inicializa mascara com todos os bits em 1
    RSB    r6, r9, #32    @ Bits da mascara = Iteracoes = 32 - tam. sequencia
    MOV    r4, r4, LSR r6    @ Arruma posicao da mascara com shift do num. de bits
    AND    r7, r4, r8    @ Obtem sequencia mascarada (ignora MSB)

loop:    
    @ Loop sobre o input
    MOV    r2, r2, LSL #1    @ Move valor final um bit para a esquerda
    MOV    r3, r1, LSR r6    @ Shifta input para a direita de acordo com a iteracao
    AND    r5, r4, r3    @ Obtem input mascarado (ignora MSB)
    CMP    r5, r7   	 @ Verifica se r5 == r7 (i.e. trecho bate com sequencia)
    ADDEQ    r2, r2, #1    @ Se sim, bit #1 no final. Senao, bit #0 no final.
    SUBS    r6, r6, #1    @ Decrementa loop counter, e verifica se r6 >= 0
    BPL    loop   	 @ Se sim, termina loop. Senao, recomeca o loop.                       @ branch loop
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
@ #91 -> b1011011 -> result em z = 0001001 = 0x9
@ #182 -> b10110110 -> result em z = 00010010 = 0x12


   
