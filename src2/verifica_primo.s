	.text
	.globl main
main:
verify_prime:
	LDR	r0, =4		        @ r0  <- numero a ser verificado  	
	MOV r9, r0				@ r9 <- guarda o numero a ser verificado
	LDR	r10, =3				@ r1  <- inicializa divisor que sofrera incremento (inicia em 3, sera incrementado de 2 em 2)
	LDR r11, =1				@ r11 <- flag indica se eh primo. Inicia em 1 (eh primo) e altera caso nao seja 		 
	LDR r12, =0				@ cte 0
verify_case_1:
	CMP r0, r11				@ checa se dividendo eh 1 (r11=1), se sim, 1 eh primo
	BEQ end_verify			@ branch *** EH PRIMO ****
verify_div_2:
	AND r0, r0, r11			@ AND Logico, verifica primeiro bit (r11=1), guarda em r0
	CMP r0, r11				@ compara se primeiro bit eh igual a r11 = 1 
	BNE not_prime		    @ branch se flag indica que *** NAO EH PRIMO ****
loop_verify_prime:
	MOV r0, r9				@ recebe novamente o numero a ser verificado (r9 -> dividendo)
	MOV r1, r10				@ inicializa r1 com o divisor (r10)
	B divisor				@ branch divisor
return_div:
	CMP r1, r12				@ compara se o resto (r1) eh zero (se for, eh divisivel, logo nao eh primo)
	BEQ not_prime			@ branch se flag indica que *** NAO EH PRIMO ****
	ADD r10, r10, #2		@ incrementa divisor (r10 = r10 + 2) -> OBS: nao precisa testar numeros pares
	CMP r10, r9				@ cmp divisor e dividendo, respectivamente
	BEQ	end_verify			@ branch se divisao terminou e flag indica que *** EH PRIMO ****
	B loop_verify_prime		@ branch loop
	@
	@	**** DA PRA FAZER UMA OTIMIZACAO AQUI. SE DIVISOR > 1/2 DIVIDENDO, COM CERTEZA O DIVIDENDO EH PRIMO
	@   **** USAR SHIFT >>
	@	OBS2****: descobri que para testar se eh primo basta ir ate a RAIZ QUADRADA do dividendo
	@ 	https://educacao.uol.com.br/disciplinas/matematica/numeros-primos-veja-algoritmo-para-encontra-los.htm
not_prime:
	MOVNE r11, #0			@ se for 0, eh div por 2, logo nao eh primo
end_verify:
	MOV r0, r11				@ r0 = r11 (flag) indica se eh primo (1 -> eh primo, 0 > nao eh primo)
end_verify_prime:
	B end_verify_prime
@
@
@
@
divisor:
	LDR	r2, =0				@ r2 <- inicializa quociente
	CMP	r2, r1				@ compara r2 com r1
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
