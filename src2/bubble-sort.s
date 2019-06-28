.text
.globl main

main:
	ADR r0, vector		@ first vector address	
	LDR r9, [r0]		@ vector load size
	CMP r9, #0		@ compare if size 0 or lower
	BLE end			@ end if size is lower or equal to 0
bubble_sort:
	CMP r9, #1		@ compare if bubble sort ends
	BEQ end			@ branch if end sorting	
	MOV r8, #1		@ initialize index
sort:
	ADD r5, r0, r8, LSL #2	@ next increment vector index
	LDMIA r5,{r1,r2}	@ load multiple values (bubble of size 2)
	CMP r2,r1		@ compare r1 and r2
	MOVLT r3,r1		@ aux invert r1 <-> r2
	MOVLT r1,r2		@ aux invert r1 <-> r2
	MOVLT r2,r3		@ aux invert r1 <-> r2
	STMIA r5,{r1,r2}	@ store only if r1 is greater than r2
	ADD r8,r8,#1		@ increment index
	CMP r8,r9		@ compare index and size
	BEQ bsort_end_step	@ branch if already finish the step
	B sort			@ next vector bubble
bsort_end_step:
	SUB r9,r9,#1		@ decrement vector size
	B bubble_sort		@ branch next step
end:
	SWI 0x123456

vector:
.word 10,9,6,4,3,1,5,0,2,7,8
