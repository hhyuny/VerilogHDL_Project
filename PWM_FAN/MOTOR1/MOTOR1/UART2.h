#include <avr/io.h>
#ifndef UART2_H_
#define UART2_H_

void UART0_Init();
void UART0_Transmit(char data);
unsigned UART0_Receive(void);



#endif /* UART2_H_ */