.global _start
.text

_start:
    b _Reset @posição 0x00 - Reset
    ldr pc, _undefined_instruction @posição 0x04 - Intrução não-definida
    ldr pc, _software_interrupt @posição 0x08 - Interrupção de Software
    ldr pc, _prefetch_abort @posição 0x0C - Prefetch Abort
    ldr pc, _data_abort @posição 0x10 - Data Abort
    ldr pc, _not_used @posição 0x14 - Não utilizado
    ldr pc, _irq @posição 0x18 - Interrupção (IRQ)
    ldr pc, _fiq @posição 0x1C - Interrupção(FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 interrupt clear register

_Reset:
    LDR sp, =stack_top
    MRS r0, cpsr    @ salvando o modo corrente em r0
    MSR cpsr_ctl, #0b11011011 @ alterando o modo para undefined - o SP eh automaticamente chaveado ao chavear o modo
    LDR sp, =undefined_stack_top @ a pilha de undefined eh setada 
    MSR cpsr_ctl, #0b11010010 @ alterando o modo para interrupt - o SP eh automaticamente chaveado ao chavear o modo
    LDR sp, =interrupt_stack_top @ a pilha de interrupt eh setada 
    MSR cpsr, r0 @ volta para o modo anterior
    bl main
    b .
undefined_instruction:
    b .
software_interrupt:
    b do_software_interrupt @vai para o handler de interrupções de software
prefetch_abort:
    b .
data_abort:
    b .
not_used:
    b .
irq:
    b do_irq_interrupt @vai para o handler de interrupções IRQ
fiq:
    b .
do_software_interrupt: @Rotina de Interrupçãode software
    ADD r1, r2, r3 @r1 = r2 + r3
    MOV pc, r14 @volta p/ o endereço armazenado em r14
do_irq_interrupt: @Rotina de interrupções IRQ
    SUB lr, lr, #4
    STMFD sp!, {r0-r12,lr} @Empilha os registradores
    LDR r0, INTPND @Carrega o registrador de status de interrupção
    LDR r0, [r0]
    TST r0, #0x0010 @verifica se é uma interupção de timer
    BLNE handler_timer @vai para o rotina de tratamento da interupção de timer
    LDMFD sp!,{r0-r12,pc}^

timer_init:
    LDR r0, INTEN
    LDR r1,=0x10 @bit 4 for timer 0 interrupt enable
    STR r1,[r0]
    LDR r0, TIMER0L
    LDR r1, =0xf @setting timer value
    STR r1,[r0]
    LDR r0, TIMER0C
    MOV r1, #0xE0 @enable timer module
    STR r1, [r0]
    mrs r0, cpsr
    bic r0,r0,#0x80
    msr cpsr_c,r0 @enabling interrupts in the cpsr
    mov pc, lr

main:
    bl c_entry
    LDR r0, =nproc
    LDR r1, =0x00
    STR r1, [r0]
    BL init_procA
    BL init_procB
    BL timer_init @initialize interrupts and timer 0
stop: 
    @LDR r0, =nproc
    @LDR r0, [r0]
    @CMP r0, #0
    @BLEQ print_1
    @BLGT print_2
    BL proc_1
    B stop

@ Experiência 11

init_procA:
    LDR r0, =linhaA
    LDR r1, =0x0
    LDR r2, =0x0
loop:
    CMP r1, #13*4
    BEQ out
    STR r2, [r0, r1]
    ADD r1, r1, #4
    B   loop 
out: 
    ADD r0, r0, r1
    STR sp, [r0], #4
    LDR r5, =0x0
    STR r5, [r0], #4
    STR lr, [r0], #4
    MRS r7, cpsr
    STR r7, [r0], #4
    BX lr
    
init_procB:
    LDR r0, =linhaB
    LDR r1, =0x0
    LDR r2, =0x0
loop2:
    CMP r1, #52
    BEQ out2
    STR r2, [r0, r1]
    ADD r1, r1, #4
    B   loop2 
out2: 
    ADD r0, r0, r1
    SUB r3, sp, #0x300
    STR r3, [r0], #4
    LDR r5, =0x0
    STR r5, [r0], #4
    LDR r6, =proc_2
    STR r6, [r0], #4
    MRS r7, cpsr
    STR r7, [r0], #4
    BX lr

handler_timer:
    LDR r0, =previous_lr
    STR lr, [r0]
    LDR r0, TIMER0X
    MOV r1, #0x0
    STR r1, [r0]
    bl handle_process
    LDR r14, previous_lr
    bx  lr @retorna

previous_lr:
    .word 0

handle_process:
    LDR r0, =save_lr
    STR r14, [r0]
    LDMFD sp!, {r0-r12}
    LDR lr, last_process
    SUB lr, lr, #4
    STMFA lr!, {r0-r12}
    LDR r2, [sp], #4
    MOV r12, lr
    LDR r5, =save_cpsr
    MRS r1, cpsr    @ salvando o modo corrente em r1
    STR r1, [r5]
    MRS r3, spsr
    MRS r7, spsr
    ADD r3,r3,#0x80
    ADD r7,r7,#0x80
    AND r6, r3, #0x1f
    CMP r6, #0x10
    ADDEQ r7, r3, #0xf
    MSR cpsr_ctl, r7 @ alterando para o modo anterior
    MOV r0, sp
    MOV r1, lr
    STMFA r12!, {r0-r3}
    LDR r0, save_cpsr
    MSR cpsr, r0
    LDR r0, =nproc
    LDR r1, [r0]
    ADD r1, r1, #1
    AND r1, r1, #1
    STR r1, [r0]
    CMP r1, #0
    LDREQ r2, =linhaA
    LDRGT r2, =linhaB
    STR r2, last_process
    STR r1, [r0]
    LDR lr, last_process
    LDR r0, [lr, #15 * 4]
    LDR r1, [lr, #13 * 4]
    LDR r2, [lr, #14 * 4]
    STR r1, recover_sp
    STR r2, recover_lr
    STMFD sp!, {r0}
    LDMFD lr!, {r0-r12}
    STMFD sp!, {r0-r12}
    MRS r3, spsr
    MRS r7, spsr
    ADD r3,r3,#0x80
    ADD r7,r7,#0x80
    AND r6, r3, #0x1f
    CMP r6, #0x10
    ADDEQ r7, r3, #0xf
    MSR cpsr_ctl, r7 @ alterando para o modo anterior
    LDR sp, recover_sp
    LDR lr, recover_lr
    LDR r0, save_cpsr
    MSR cpsr, r0    
    LDR lr, save_lr
    BX lr
    
save_lr:
    .word 0
save_cpsr:
    .word 0
recover_sp:
    .word 0
recover_lr:
    .word 0

last_process:
    .word 0x5050
