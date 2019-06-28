	.text
	.globl main

main:
	MOV r0, #0xFFFFFFFE
	ADD r1, r0, r0, ASR #31
	EOR r0, r1, r0, ASR #31
	SWI #0x123456
