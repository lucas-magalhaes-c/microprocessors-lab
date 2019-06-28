	.text
	.global main
main:
   	LDR r0, =0xFFFFFFFF
	LDR r1, =0x80000000
	UMULL r3, r4, r0, r1
	SWI 0x00123456
