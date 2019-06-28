.text
.globl main

main:
    MOV r1, #0x000000B4 @ 10 11 01 00
    @ r2 = 010 011 001 000 100 101 111 110
    @  9 210
    @ r3 = 00 r4 = 01 r5 = 11 r6 = 10
    
    MOV r3, r1, LSL #30
    MOV r3, r3, LSR #30
    @r3 = 00

    MOV r4, r1, LSL #28
    MOV r4, r4, LSR #30
    @r4 = 01

    MOV r5, r1, LSL #26
    MOV r5, r5, LSR #30
    @r5 = 11

    MOV r6, r1, LSL #24
    MOV r6, r6, LSR #30
    @r6 = 10

    MOV r2, r6    	    @r2 = 0000000000000000<10>
    ADD r2, r5, r2, LSL #3  @r2 = 000000000000<010>011
    ADD r2, r2, r4, LSL #3  @r2 = 000000000<010><011>001
    ADD r2, r2, r3, LSL #3  @r2 = 000000<010><011><001>000
    ADD r2, r2, r3, LSL #3  @r2 = 000<010><011><001><000>000
    ADD r2, r2, #4   	    @r2 = 000<010><011><001><000>100
    ADD r2, r2, r4, LSL #3
    ADD r2, r2, #4
    ADD r2, r2, r5, LSL #3
    ADD r2, r2, #4
    ADD r2, r2, r6, LSL #3
    ADD r2, r2, #4
 
    SWI #0x123456

