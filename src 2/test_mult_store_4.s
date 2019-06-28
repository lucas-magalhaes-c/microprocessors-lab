.text
.globl main

main:
	ldr r1, =0xbabe2222		
	ldr r2, =0x12340000
	mov r4, #1
	ldr r5, =0xfeeddaf
	ldr r3, =0x8010
	STMIA r3!,{r5,r4}	
	STMIA r3!,{r1}
	STMIA r3!,{r2}
	LDMIA r3!,{r2,r1}
	SWI 0x121222
