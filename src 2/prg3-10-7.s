	.text
	.globl main

main:
	LDR	r1, #13				@ r1 = 0xd = #13 divident   		 
	LDR	r2, #2				@ r2 = 0x2 = #2	 divisor que sofrera shift
	LDR	r3, #0				@ r3 = 0x0 = #0  quocient
	CMP	r3, r2				@ compara r3 com r2
	BEQ	erro                @ se igual a 0, erro
	MOV	r4, r2				@ r4 = r2 copia do divisor
alinha:
	CMP	r1, r2				@ compara r1 com r2
	MOVPL	r2, r2, LSL #1	@ shift << r2 se positivo
	BPL	alinha				@ branch loop se comparacao positiva
loop:
	CMP	r1, r2				@ compara r1 com r2
	MOV	r3, r3, LSL #1		@ shift << r3
	ADDPL	r3, r3, #1		@ add 1 se comparacao positiva 
	SUBPL	r1, r1, r2		@ subtracao de r2 no r3  se comparacao positiva
	MOV	r2, r2, LSR #1		@ shift >> r2 
	CMP	r2, r4				@ compara r2 com r4
	BPL	loop				@ branch loop se igual ou positivo
	MOV	r5, r1				@ r5 = r1, resto 
	SWI	0x123456			@ end
erro:
	BL	erro				@ caso de erro caso divisao por zero
