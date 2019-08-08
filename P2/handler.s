.section HANDLER_TIMER
.global handler_timer
.text
handler_timer:
    LDR r0, TIMER0X
    MOV r1, #0x0
    STR r1, [r0] @Escreve no registrador TIMER0X para limpar o pedido de interrupção
    MOV pc,lr

TIMER0X: .word 0x101E200c @timer 0 interrupt clear register
