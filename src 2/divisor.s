	.text
	.globl main
main:
divisor:
	LDR	r0, =9833127		@ r0 = dividendo   		 
	LDR	r1, =2				@ r1 = 0x2 = #2	 divisor que sofrera shift
	LDR	r2, =0				@ r2 = 0x0 = #0  quociente
	CMP	r2, r1				@ compara r2 com r1
	BEQ	erro				@ se igual a 0, erro
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
	B end_div				@ end
divd_lt_divs:
	MOV	r1, r0				@ r1 = r0, resto 
	MOV	r0, #0				@ r0 = r2, resultado
	B end_div					@ branch end
erro:
	B erro				@ caso de erro, caso divisao por zero
