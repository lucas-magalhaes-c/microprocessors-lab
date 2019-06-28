    .text
    .globl main

main:
    mov r0, #0                     @ initialize (i = 0)
    mov r9, #20                   @ i_max
    adr r1, a                         @ address vector a
    mov r8, r1                      @ copy a address into a temp reg
    mov r3, #1                     @ initiate max value
loop: 
    cmp r0, r9                      @ compare i with i_max
    beq end_loop                @ finish if end_loop
    ldr r2, [r1, r0, lsl #2]       @ load from address a + i*4 -> a[i]
    cmp r2, r3                      @ compare a[i] and max value
    movhi r3, r2                   @ atualize max value if a[i] is higher
    addne r0, r0, #1             @ increment i
    bne loop                         @ branch loop
end_loop:
    str r3, [r8]                        @ stores the max value into first address a
    swi 0x123456                 @ fim
     
@ note that 64 is the major value
a:
     .word 0, 12, 21, 35, 41, 20, 6, 43, 65, 12, 9, 64, 1, 7, 14, 18,16, 50, 36, 19, 25

