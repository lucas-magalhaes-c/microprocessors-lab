#define TIMER0X ((volatile unsigned *)(0x101E200c))
volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
 
void print_uart0(const char *s) {
	while(*s != '\0') {
		*UART0DR = (unsigned int)(*s);
		s++;
	}
}

void print_3(){
	print_uart0("9833127");
    return;
}

void print_1(){
	print_uart0("1");
	return;
}

void print_2(){
	print_uart0("2");
	return;
}

void undefined_handler (){
    print_uart0("U");
	return;
}

void data_abort_handler (){
    print_uart0("Data Abort");
	return;
}