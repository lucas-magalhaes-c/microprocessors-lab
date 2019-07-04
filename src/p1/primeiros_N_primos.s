	.text
	.globl main
main:
	LDR r0, =0			@ numero inicial
	LDR r1, =30				@ numero N de primos a serem escritos (!! MAX 50 !!)
	LDR r2, =1				@ flag -> 1 eh ascendente, 0 eh decrescente
	ADR r3, prime_vec		@ endereco do vetor para escrever os N primos
	LDR r4, =0				@ indice prime vec
	@
	CMP r2, #1				@ compara se eh asc ou desc
	BNE loop_N_primes_desc	@ branch se for desc
loop_N_primes_asc:
	STMEA sp!, {r0-r4}		@ guarda dados na pilha
	BL verify_prime			@ verifica se o proximo numero eh primo (o numero eh o primeiro valor em stack_state)
	MOV r6, r0				@ move se eh primo para r6
	LDMEA sp!, {r0-r4}		@ recupera dados na pilha
	CMP r6, #1				@ compara se a flag eh 1 (primo)
	STREQ r0,[r3,r4,LSL #2]	@ guarda no vetor de primos, caso for primo
	ADDEQ r4, r4, #1		@ incrementa indice prime_vec
	CMP r4, r1				@ compara se ja chegou nos N valores
	BEQ end_N_primes		@ branch se chegou
	ADD r0,r0,#1			@ incrementa proximo numero a ser checado
	B loop_N_primes_asc		@ branch loop
loop_N_primes_desc:
	STMEA sp!, {r0-r4}		@ guarda dados na pilha
	BL verify_prime			@ verifica se o proximo numero eh primo (o numero eh o primeiro valor em stack_state)
	MOV r6, r0				@ move se eh primo para r6
	LDMEA sp!, {r0-r4}		@ recupera dados na pilha
	CMP r6, #1				@ compara se a flag eh 1 (primo)
	STREQ r0,[r3,r4,LSL #2]	@ guarda no vetor de primos, caso for primo
	ADDEQ r4, r4, #1		@ incrementa indice prime_vec
	CMP r4, r1				@ compara se ja chegou nos N valores
	BEQ end_N_primes		@ branch se chegou
	SUB r0,r0,#1			@ incrementa proximo numero a ser checado
	B loop_N_primes_desc		@ branch loop
end_N_primes:
	SWI 0x0
	B end_N_primes
@
@
@
@
@
@
verify_prime:
	@LDR	r0, =9				@ r0  <- numero a ser verificado (na pilha eh o primeiro valor) 	
	MOV r9, r0				@ r9 <- guarda o numero a ser verificado (dividendo)
	LDR	r10, =3				@ r1  <- inicializa divisor que sofrera incremento (inicia em 3, sera incrementado de 2 em 2)
	LDR r11, =1				@ r11 <- flag indica se eh primo. Inicia em 1 (eh primo) e altera caso nao seja 		 
verify_case_1:
	CMP r0, #1				@ checa se dividendo eh 1 (r11=1), se sim, 1 eh primo
	BEQ not_prime			@ branch se for 1 *** NAO EH PRIMO ****
verify_div_2:
	CMP r0, #2				@ compara dividendo com 2
	BEQ end_verify			@ branch se for 2 *** EH PRIMO ****
	AND r5, r0, r11			@ AND Logico, recebe primeiro bit
	CMP r5, #1				@ compara se primeiro bit eh igual a r11 = 1 
	BNE not_prime		    @ branch se for par (primeiro bit = 0) *** NAO EH PRIMO ****
	B square_majorate		@ MAJORATE - faz a majoracao do maior numero que deve ser checado, quando r10 passar desse numero, o valor com certeza eh primo
loop_verify_prime:
	MOV r0, r9				@ recebe novamente o numero a ser verificado (r9 -> dividendo)
	MOV r1, r10				@ inicializa r1 com o divisor (r10)
	CMP r0, r1				@ compara dividendo e divisor
	BEQ	end_verify			@ branch se divisao terminou && dividendo e divisor sao iguais *** EH PRIMO ****
	B divisor				@ branch divisor
return_div:
	CMP r1, #0				@ compara se o resto eh 0
	BEQ not_prime			@ branch se for 0, flag indicara que *** NAO EH PRIMO ****
	ADD r10, r10, #2		@ incrementa divisor (r10 = r10 + 2) -> OBS: nao precisa testar numeros pares
	CMP r10, r6				@ MAJORATE - compara proximo divisor com numero majorado (maior ou igual a raiz do numero checado)
	BHI	end_verify			@ MAJORATE - branch se great or equal. Com certeza o dividendo eh primo
	B loop_verify_prime		@ branch loop
square_majorate:
	mov r6, #5				@ inicia valor de majoracao
loop_majorate:
	MUL r7, r6, r6			@ calcula a multiplicacao
	CMP r7, r0				@ compara multiplicacao com o dividendo
	BHS	loop_verify_prime	@ se unsigned >= dividendo (numero a saber se eh primo), branch. Majoracao em r6
	ADD r6, r6, #1			@ incrementa r6
	B loop_majorate 		@ branch loop, ate encontrar a majoracao
	@
	@	**** DA PRA FAZER UMA OTIMIZACAO AQUI. SE DIVISOR > 1/2 DIVIDENDO, COM CERTEZA O DIVIDENDO EH PRIMO
	@   **** USAR SHIFT >>
	@	OBS2****: descobri que para testar se eh primo basta ir ate a RAIZ QUADRADA do dividendo
	@ 	https://educacao.uol.com.br/disciplinas/matematica/numeros-primos-veja-algoritmo-para-encontra-los.htm
not_prime:
	MOV r11, #0				@ se for 0 (par), eh div por 2, logo nao eh primo
end_verify:
	MOV r1, r9				@ numero verificado
	MOV r0, r11				@ coloca o valor da flag indicando se eh primo em r0 (1 eh primo, 0 eh nao primo)
end_verify_prime:
	BX LR					@ retorna para a func que a chamou
@
@
@
@
divisor:
	LDR	r2, =0				@ r2 <- inicializa quociente
	CMP	r1, #0				@ compara r1 com 0
	BEQ	erro				@ se divisor (r1) igual a 0, branch erro
	CMP r0, r1				@ compara se r0 < r1 (signed) 
	BLT divd_lt_divs		@ se dividendo menor que o divisor
	MOV	r3, r1				@ r3 = r1 copia do divisor
align:
	CMP	r0, r1				@ compara r0 com r1
	MOVPL r1, r1, LSL #1	@ shift << r1 se positivo
	BPL	align				@ branch loop se comparacao positiva
loop:
	CMP	r0, r1				@ compara r0 com r1
	MOV	r2, r2, LSL #1		@ shift << r2
	ADDPL r2, r2, #1		@ add 1 se comparacao positiva 
	SUBPL r0, r0, r1		@ subtracao de r1 no r0  se comparacao positiva
	MOV	r1, r1, LSR #1		@ shift >> r1 
	CMP	r1, r3				@ compara r1 com r3
	BPL	loop				@ branch loop se igual ou positivo
result_and_rest:
	MOV	r1, r0				@ r1 = r0, resto 
	MOV	r0, r2				@ r0 = r2, resultado
end_div:
	B return_div			@ branch para result_div
divd_lt_divs:
	MOV	r1, r0				@ r1 = r0, resto 
	MOV	r0, #0				@ r0 = r2, resultado
	B end_div				@ branch end
erro:
	B erro				@ caso de erro, caso divisao por zero
@
@
@
@
prime_vec:
	.space 1600 	@ cabe N = 50 numeros de 32 bits

