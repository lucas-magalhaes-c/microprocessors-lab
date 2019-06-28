.text
.globl main

main:
	MOV r1, #4		@ N
	ADR r0, matrix		@ matrix addres
	ADR r11, unique_vec	@ unique check vector
	MUL r10, r1, r1		@ vec size
	MOV r8, #1		@ vec init		
check_unique:
	ADD r9, r0, r8, LSL #2  @ next increment vector index
	
	





matrix:
.word 16, 3, 2, 13, 5, 10, 11, 8, 9, 6, 7, 12, 4, 15, 14, 1

unique_vec:
.size 200
