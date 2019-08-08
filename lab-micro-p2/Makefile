#Para escrever comentários ##
############################# Makefile ##########################
all: irq.bin
irq.bin: irq.elf
		# O compilador faz a ligação entre os dois objetos
		arm-none-eabi-objcopy -O binary irq.elf irq.bin
#-----> Distancia com o botão TAB ### e não com espaços
irq.elf: irq.o irqld.ld handler.o
		arm-none-eabi-ld -T irqld.ld irq.o handler.o -o irq.elf
irq.o: irq.s 
		arm-none-eabi-as -c -mcpu=arm926ej-s -g irq.s -o irq.o
handler.o: handler.c
		arm-none-eabi-gcc -c -mcpu=arm926ej-s -Wall -Wextra -g handler.c -o handler.o
clean:
		rm -rf *.o 
