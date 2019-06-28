.text
.globl main

main:
    ADR		r13, stack @ anteriormente estava MOV r3, #0x5000
    MOV		r1, #1	@ b
    MOV		r2, #2	@ c
    MOV		r3, #3	@ d
    MOV		r4, #4	@ a

@ Transmitir usando stack, com 2 subrotinas
  @		var b, c, d
  @		func3 = (b, c, d) => func2(b, c) + d
  @		func2 = (b, c) => b + c

    STMEA	r13!, {r1-r3}   @b, c, d na pilha
    BL		func3
    B		fim
func3:
    LDMEA	r13!, {r4-r6} @ tira b,c,d
    STMEA	r13!, {r14}
    STMEA	r13!, {r4-r5} @ empilha Link register, b, c
    BL		func4
    LDMEA	r13!, {r4-r5} @r4 = link register, r5 = b+c
    MOV	r9, #0
    ADD		r9, r5, r6
    MOV	pc, r4
func4:
    LDMEA	r13!, {r7-r8} @tira b,c
    MOV	r9, #0
    ADD		r9, r9, r7
    ADD		r9, r9, r8
    STMEA	r13!, {r9} @ empilha b+c
    MOV	pc, r14

  fim:
    SWI 	0x123456
stack:
.word 0,0,0,0,0,0,0,0,0,0
