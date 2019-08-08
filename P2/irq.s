.section INTERRUPT_VECTOR, "x"
.global _start
_start:
	b _Reset @posição 0x00 - Reset
	LDR pc, _undefined_instruction @posição 0x04 - Intrução não-definida
	LDR pc, _software_interrupt @posição 0x08 - Interrupção de Software
	LDR pc, _prefetch_abort @posição 0x0C - Prefetch Abort
	LDR pc, _data_abort @posição 0x10 - Data Abort
	LDR pc, _not_used @posição 0x14 - Não utilizado
	LDR pc, _irq @posição 0x18 - Interrupção (IRQ)
	LDR pc, _fiq @posição 0x1C - Interrupção(FIQ)

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq

INTPND: .word 0x10140000    @Interrupt status register
INTSEL: .word 0x1014000C    @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010     @interrupt enable register
TIMER0L: .word 0x101E2000   @Timer 0 load register
TIMER0V: .word 0x101E2004   @Timer 0 value registers
TIMER0C: .word 0x101E2008   @timer 0 control register
TIMER0X: .word 0x101E200c   @timer 0 interrupt clear register

_Reset:
	BL main
	B .
undefined_instruction:
 	B do_undefined_instruction  @vai para o handler de undefined instruction
software_interrupt:
 	B do_software_interrupt     @vai para o handler de software interrupt
prefetch_abort:
 	B .
data_abort:
 	B do_data_abort             @vai para o handler de data_abort
not_used:
 	B .
irq:
	B do_irq_interrupt      @ vai para o handler de interrupções IRQ
fiq:
 	B .

do_software_interrupt:      @ Rotina de Interrupçãode software
	SUB lr, lr, #4
	STMFD sp!,{R0-R12,lr}
	ADD r1, r2, r3 			@ r1 = r2 + r3
	LDMFD sp!,{R0-R12,pc}^

do_undefined_instruction:      @ Rotina de Interrupçãode software
	SUB lr, lr, #4
	STMFD sp!,{R0-R12,lr}
	BL undefined_handler
	LDMFD sp!,{R0-R12,pc}^

do_data_abort:      @ Rotina de Interrupçãode software
	SUB lr, lr, #4
	STMFD sp!,{R0-R12,lr}
	BL data_abort_handler
	LDMFD sp!,{R0-R12,pc}^

timer_init:
	LDR	r0, INTEN
	LDR r1,=0x10 			@ bit 4 for timer 0 interrupt enable
	STR r1,[r0]
	LDR r0, TIMER0C
	LDR r1, [r0]
	MOV r1, #0xA0 			@ enable timer module
	STR r1, [r0]
	LDR r0, TIMER0V
	MOV r1, #0xff 			@ setting timer value
	STR r1,[r0]
	MRS r0, cpsr
	BIC r0,r0, #0x80
	MSR cpsr_c,r0 			@ enabling interrupts in the cpsr
	MOV pc, lr

save_registers:
	STMFD sp!,{lr}			@ empilha o LR
	STMFD sp!,{r0}			@ empilha r0 pois ele sera utilizado
	ADR	lr, nproc		    @ carrega nproc
	LDR r0, [lr]			@ carrega nproc
	CMP r0, #0			    @ compara nproc com 0
	ADREQ lr, linhaA		@ carrega linhaA se igual
	CMP r0, #1			    @ compara nproc com 1
	ADREQ lr, linhaB		@ carrega linhaB se igual
	CMP r0, #2			    @ compara nproc com 2
	ADREQ lr, linhaC		@ carrega linhaC se igual
	LDMFD sp!,{r0}			@ volta o valor anterior de r0
	STMIA lr!, {R0-R12} 	@ salva registradores normais
	MOV r2, lr			    @ utiliza r2 como cabeca da pilha
	MRS r0, CPSR			@ carrega CPSR em r0
	MRS r1, SPSR			@ carrega SPSR (CPSR antes da interrupcao) em r1
	STMIA r2!, {r1} 		@ salva CPSR
	ORR r1, r1, #0x80 		@ desabilita interrupcoes
	LDMFD sp!,{lr}			@ desempilha LR
	LDMFD sp!,{r3}			@ desempilha PC em r3
	MSR cpsr_c, r1			@ copia r1 pra CPSR desabilitando interrupcao
	STMIA r2!, {sp, lr} 	@ salva registradores especiais
	STMIA r2!, {r3} 		@ salva PC
	MSR cpsr_c, r0			@ volta o CPSR
	MOV pc, lr			    @ retorna

recover_registers:
	STMFD sp!,{r0}			@ empilha r0 pois ele sera utilizado
	ADR	lr, nproc		    @ carrega nproc
	LDR r0, [lr]			@ carrega nproc
	CMP r0, #0			    @ compara nproc com 0
	ADREQ lr, linhaA		@ carrega linhaA se igual
	CMP r0, #1			    @ compara nproc com 1
	ADREQ lr, linhaB		@ carrega linhaB se igual
	CMP r0, #2			    @ compara nproc com 2
	ADREQ lr, linhaC		@ carrega linhaC se igual
	LDMFD sp!,{r0}			@ volta o valor anterior de r0
	LDMIA lr!, {R0-R12} 	@ recupera os registradores normais
	STMFD sp!, {R0-R3}		@ empilha r0-r3 pois eles serao utilizados
	MOV r2, lr			    @ utiliza r2 como cabeca da pilha
	MRS r0, CPSR			@ carrega CPSR em r0
	LDMIA r2!, {r1} 		@ recupera CPSR guardado
	MSR spsr_c, r1			@ altera CPSR
	ORR r1, r1, #0x80 		@ desabilita interrupcoes
	MSR cpsr_c, r1			@ desabilita interrupcoes
	LDMIA r2!, {sp, lr} 	@ recupera registradores especiais
	MSR cpsr_c, r0			@ volta o CPSR
	MOV lr, r2			    @ volta r2 para LR
	LDMFD sp!,{R0-R3}		@ desempilha os registradores r0-r3
	LDMIA lr!,{pc}^ 		@ recupera PC



do_irq_interrupt: 			@ rotina de interrupções IRQ
	SUB lr, lr, #4
	STMFD sp!,{lr}
	BL save_registers		@ salva registradores
	LDR r0, INTPND
	LDR r0, [r0]
	TST r0, #0x0010
	BLNE handler_timer		@ trata a interrupcao de tempo
	B recover_registers		@ carrega registradores

handler_timer:
	STMFD sp!,{lr}
	LDR r0, TIMER0X
	MOV r1, #0x0
	STR r1, [r0]
	ADR r0, nproc
	LDR r1, [r0]
	@CMP r1, #0
	@MOVEQ r1, #1
	@BLNE cmp_nproc
    @
    ADD r1, r1, #1
    CMP r1, #3
    MOVEQ r1, #0
    @
	STR r1, [r0]
    LDMFD sp!,{lr}
    mov pc, r14

cmp_nproc:
	CMP r1, #1
	MOVNE r1, #0
	MOVEQ r1, #2
	MOV pc, lr


sp_init:
	@ init sp for interrupt mode
	MRS r0, CPSR_all
  	BIC r0, r0, #0x1f		@ and not
  	ORR r0, r0, #0b10010
  	MSR CPSR_all, r0

  	LDR r13, =0x3000

	@ init sp for supervisor mode
  	MRS r0, CPSR_all
  	BIC r0, r0, #0x1f
  	ORR r0, r0, #0b10011
  	MSR CPSR_all, r0

    @ init sp for undefined instruction mode 
  	MRS r0, CPSR_all
  	BIC r0, r0, #0x1f
  	ORR r0, r0, #0b11011
  	MSR CPSR_all, r0

    @ init sp for data abort mode
  	MRS r0, CPSR_all
  	BIC r0, r0, #0x1f
  	ORR r0, r0, #0b10111
  	MSR CPSR_all, r0

  	LDR sp, =stack_top
	MOV pc, lr

init_proc_1:				@ inicializacao da task 1
	LDR r0, =0x1000			@ coloca o topo da pilha em r0
	ADR r1, proc_print_1		@ coloca o pc (endereco da funcao) em r1
	ADR r2, linhaA			@ coloca o endereco da pilha em r2
	MRS r3, CPSR_all		@ coloca CPSR em r3
  	BIC r3, r3, #0x9f		@ coloca CPSR em r3
  	ORR r3, r3, #0b10011		@ coloca CPSR em r3
	STR r0,[r2, #14*4]		@ guarda r0 na posicao 14 da pilha linhaA
	STR r3,[r2, #13*4]		@ guarda r3 na posicao 13 da pilha linhaA
	STR r1,[r2, #16*4]		@ guarda r1 na posicao 16 da pilha linhaA
	MOV pc, lr				@ retorna

init_proc_2:				@ inicializacao da task 2
	LDR r0, =0x2000			@ coloca o topo da pilha em r0
	ADR r1, proc_print_2	@ coloca o pc (endereco da funcao) em r1
	ADR r2, linhaB			@ coloca o endereco da pilha em r2
	MRS r3, CPSR_all		@ coloca CPSR em r3
  	BIC r3, r3, #0x9f		@ coloca CPSR em r3
  	ORR r3, r3, #0b10011	@ coloca CPSR em r3
	STR r0,[r2, #14*4]		@ guarda r0 na posicao 14 da pilha linhaB
	STR r3,[r2, #13*4]		@ guarda r3 na posicao 13 da pilha linhaB
	STR r1,[r2, #16*4]		@ guarda r1 na posicao 16 da pilha linhaB
	MOV pc, lr				@ retorna

init_proc_3:				@ inicializacao da task 3
	LDR r0, =0x5000			@ coloca o topo da pilha em r0
	ADR r1, proc_print_3	@ coloca o pc (endereco da funcao) em r1
	ADR r2, linhaC			@ coloca o endereco da pilha em r2
	MRS r3, CPSR_all		@ coloca CPSR em r3
  	BIC r3, r3, #0x9f		@ coloca CPSR em r3
  	ORR r3, r3, #0b10011	@ coloca CPSR em r3
	STR r0,[r2, #14*4]		@ guarda r0 na posicao 14 da pilha linhaB
	STR r3,[r2, #13*4]		@ guarda r3 na posicao 13 da pilha linhaB
	STR r1,[r2, #16*4]		@ guarda r1 na posicao 16 da pilha linhaB
	MOV pc, lr				@ retorna

proc_print_1:
	LDR r1, =3000000		@ limite de contador
    @.word 0xFFFFFFFF        @ undefined instruction
LOOP1_print_1:
	MOV r0, #0			    @ inicio do contador
LOOP2_print_1:
	ADD r0, r0, #1			@ soma 1 no contador
	CMP r0, r1				@ compara o contador com o limite
	BNE LOOP2_print_1		@ volta pro loop (para mais tempo entre impressoes)
	BL print_1				@ imprime
	B LOOP1_print_1			@ volta para o comeco

proc_print_2:
	LDR r1, =3000000		@ limite de contador
LOOP1_print_2:
	MOV r0, #0			    @ inicio do contador
LOOP2_print_2:
	ADD r0, r0, #1			@ soma 1 no contador
	CMP r0, r1			    @ compara o contador com o limite
	BNE LOOP2_print_2		@ volta pro loop (para mais tempo entre impressoes)
	BL print_2			    @ imprime
	B LOOP1_print_2			@ volta para o comeco

proc_print_3:
	LDR r1, =3000000		@ limite de contador
LOOP1_print_3:
	MOV r0, #0			    @ inicio do contador
LOOP2_print_3:
	ADD r0, r0, #1			@ soma 1 no contador
	CMP r0, r1			    @ compara o contador com o limite
	BNE LOOP2_print_3		@ volta pro loop (para mais tempo entre impressoes)
	BL print_3			    @ imprime
	B LOOP1_print_3			@ volta para o comeco

@user_mode:
	@ init sp for supervisor mode
  	@MRS r0, CPSR_all
  	@BIC r0, r0, #0x1f
  	@ORR r0, r0, #0b10000
  	@MSR CPSR_all, r0

  	@LDR sp, =stack_top
	@MOV pc, lr

main:
	BL sp_init			@ initializa stack pointers
	BL init_proc_1			@ inicializa task 1
	BL init_proc_2			@ inicializa task 2
	BL init_proc_3			@ inicializa task 3
	BL timer_init 			@ initialize interrupts and timer 0
	B proc_print_1			@ inicia o programa em task 1

stop:
	B stop

linhaA:
	.skip 17*4
linhaB:
	.skip 17*4
linhaC:
	.skip 17*4

nproc:
	.word 0
