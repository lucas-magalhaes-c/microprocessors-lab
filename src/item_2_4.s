.text
.global main
main: 
	LDR r0, =0x0000000F                        @ set up parameters 
	LDR r1, =0x00000014		
	BL firstfunc 			            @ call subroutine 
	LDR r0, =0x00000018 		 
	LDR r1, =0x00020026 		
	SWI 0x00123456		@ terminate the program 
firstfunc:
	ADD r0, r0, r1		            @ r0 = r0 + r1 
	MOV pc, lr 			@ return from subroutine 
end:					@ mark the end of file
