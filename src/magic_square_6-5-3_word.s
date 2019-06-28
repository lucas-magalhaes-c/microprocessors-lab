.text
.globl main

main:
	MOV	r1, #3

	MOV	r9, #0
	ADR	r0, array
	CMP	r1, #16
	BGE	fim
	MULS	r2, r1, r1	 @ r2 = N^2
	BEQ	fim		 @ ignora matrix
	ADD	r2, r2, #1
	MUL	r3, r2, r1	 @ r3 = (N^2 + 1) * N
	MOV	r2, r3, LSR #1  @ r2 = (N^2 + 1) * N / 2

	@ Verificar se array contem 1..N2 com busca linear
	MUL	r3, r1, r1           @ N^2
	MOV	r7, r3                @ N^2
search:
            SUB	r3, r3, #1                    @ N^2-1
	LDR	r5, [r0, r3, LSL #2]     @ r5 <= array[n^2] -> removi B*
	CMP	r5, #1                         @ compare r5 com 1
	BLT	fim                             @ termina se vetor tiver tamanho 1
	CMP	r5, r7                         @ compara r5 com r7
	BGT	fim                             @ branch se se valor em r5 é maior do que N^2 
	SUBS	r4, r3, #1                   @ r4 = N^2 - 2
	BMI	s_cont                       @ branch se 
s_loop:	
        LDR 	r6, [r0, r4, LSL #2]     @ r6 <= array[n^2-2]
	CMP	r5, r6                         @  compara  r5 <= array[n^2] com r6 <= array[n^2-2]
	BEQ	fim                             @ branch se igual (numero encontrado) 
	SUBS	r4, r4, #1                   @ r4 = r4 -1 
	BPL	s_loop                       @ se positivo, s_loop
	BAL	search                       @ branch search
s_cont:
	@ array = r0                
	@ N = r1
	@ sum = r2
	@ newsum = r3

	@ Verificar diagonal NE-SO
	@
	@ for (i = 0; i < n; i++)
	@ 	diag_1 += a[0 + (n+1)*i]
	MOV	r4, #0            @ r4 <= 0
	ADD	r5, r1, #1       @ r5 = r1 + 1
        MOV r5, r5, LSL #2
	BL	sum               @ branch sum
	CMP	r2, r3             @ compare with new sum
	BNE	fim                 @ termina

	@ Verificar diagonal NO-SE
	@
	@ for (i = 0; i < n; i++)
	@ 	diag_2 += a[(n-1) + (n-1)*i]
	SUB	r4, r1, #1      @ r4 = r4 - 1 
	MOV	r5, r4            @ r5 = r4
        MOV r5, r5, LSL #2
	BL	sum              @ branch sum
 	CMP	r2, r3            @ compare with new sum
	BNE	fim

	@ Verificar linhas
	@
	@ for (i = 0; i < n; i++)
	@ 	lin_X += a[(X*n) + i]
	MOV	r4, #0
	MOV	r5, #1
	MOV	r9, r1
            MOV r5, r5, LSL #2
lin_lp: 
            BL	sum
	CMP	r2, r3
	BNE	fim
	ADD	r4, r4, r1
	SUBS	r9, r9, #1
	BNE	lin_lp

	@ Verificar colunas
	@
	@ for (i = 0; i < n; i++)
	@ 	col_X += a[X + (n*i)]
	MOV	r4, #0
	MOV	r5, r1
            MOV r5, r5, LSL #2
col_lp: 
            BL	sum
	CMP	r2, r3
	BNE	fim
	ADD	r4, r4, #1
	CMP	r4, r1
	BLT	col_lp

ok:	
            MOV	r9, #1
fim:	
            SWI	0x123456

@ Subrotina para somar valores alinhados em uma matriz NxN
@
@ Argumentos:
@ 	r0 - array
@ 	r1 - N (dimensao matriz quadrada)
@ 	r4 - offset primeiro valor
@ 	r5 - espacamento entre valores
@
@ Retorno:
@ 	r3 - soma dos valores
@
@ Registradores auxiliares: r6 a r8
@
sum:
	MOV	r3, #0
	ADD	r7, r0, r4, LSL #2
	MOV	r6, r1
sum_lp: 
            LDR	r8, [r7], r5
	ADD	r3, r3, r8
	SUBS	r6, r6, #1
	BNE	sum_lp
	MOV	pc, lr


array:
.word 4,9,2,3,5,7,8,1,6

