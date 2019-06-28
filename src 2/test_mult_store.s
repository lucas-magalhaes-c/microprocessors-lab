.text
.globl main

main:
	adr r6, a
	add r5, r6, #0x10
	LDMIA r6,{r7,r4,r0,lr}
	LDMDA r5,{r7,r4,r0,lr}
	LDMIA r6!,{r7,r4,r0,lr}
	SWI 0x12312

a: 
.word 1,2,3,4,5,6,7
