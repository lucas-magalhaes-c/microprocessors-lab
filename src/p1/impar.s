.text
.globl main

main:
    LDR r1, =30             @ 30 
    ADR r2, primos          @ ponteiro para a fila de primos
    BL search_primos
    B done

@ Subrotina search_primos
@ recebe um número de primos para ser colocado na memória em r1
@ recebe o local da memória para ser colocado em r2
search_primos:
            STMFD   sp!, {r4-r12, lr} @ Empilha estado anterior
            LDR     r4, =0x2 @ Número inicial
            LDR     r5, =0x0 @ Contador de números
            MOV     r6, r2
searching:
            BL        eh_primo
            CMP       r0, #0
            LDR       r0, =0 @ Limpa o registrador para receber uma nova resposta
            STRNE     r4, [r6], #4
            ADD       r4, r4, #1 @ Incrementa para encontrar o próximo numero primo
            ADDNE     r5, r5, #1 @ Incrementa se encontrou numero primo
            CMP       r5, #30
            BLT       searching
            LDMFD   sp!, {r4-r12, lr} @Desempilha estado anterior
            MOV       pc, lr @ retorna da subrotina


@ Subrotina eh_primo
@ recebe um valor no r4 (Numero a ser verificado)
@ retorna r0 = 1 se r4 é primo
@ retorna r0 = 0 se r4 não é primo
eh_primo:
            STMFD   sp!, {r4-r12, lr} @ Empilha estado anterior
            MOV     r5, r4    @ Proximo numero a dividir
            LDR     r6, =0x00 @ Contatador de divisoes
loop:
            MOV     r1, r4 @ Carrega Dividendo
            MOV     r2, r5 @ Carrega Divisor
            CMP     r5, #0x00 @ Compara se ja estamos no 0
            BEQ     checagem @ Caso positivo entao vamos para checagem
            BLNE     divide @ Caso nao, entao dividimo r4 por r5
continue_loop:
            CMP     r1, #0 @ Verifica se o resto eh 0
            ADDEQ   r6, r6, #1 @ Se sim, entao a divisao deu certo, incrementamos o r6
            SUB     r5, r5, #1 @ Tiramos 1 do r5 para a proxima rodada
            B       loop @ Volta pro Loop

checagem:
            CMP     r6, #2  @ Compara se tivemos mais que 2 divisoes entre 1 e r4
            LDRNE   r0, =0 @ r0 = 0 caso numero nao seja primo
            LDREQ   r0, =1 @ r0 = 1 caso numero seja primo
            LDMFD   sp!, {r4-r12, lr} @ Desempilha estado anterior
            MOV     pc, lr @ Retorna da subrotina

@ Subrotina divide
@ Divide r1 por r2, resto no r1, e quociente no r0
divide:
            STMFD   sp!, {r3, lr} @ Empilha estado anterior
            CMP     r2, #0
            BEQ     continue_loop

            MOV     r0, #0
            MOV     r3, #1

divide_start:
            CMP     r2, r1
            MOVLS   r2, r2, LSL #1
            MOVLS   r3, r3, LSL #1
            BLS     divide_start

divide_next:
            CMP     r1, r2
            SUBCS   r1, r1, r2
            ADDCS   r0, r0, r3
            MOVS    r3, r3, LSR #1
            MOVCC   r2, r2, LSR #1
            BCC     divide_next
            LDMFD   sp!, {r3, lr} @ Restaura estado anterior
            MOV     pc, lr @ retorna da subrotina

done:
            SWI         0x123456 @ End

primos: 
    .space 1600