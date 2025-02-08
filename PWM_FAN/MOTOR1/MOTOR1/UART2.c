#include "UART2.h"

void UART0_Init()
{
	UBRR0H = 0x00;
	UBRR0L = 0xCf;											//207bps 설정
	
	UCSR0A = (1<<U2X0);										//2배속 모드
	//비동기, 8비트데이터, 패리티비트 없음, 1비트 Stop bit
	
	UCSR0B |= (1<<RXEN0);									//수신가능
	UCSR0B |= (1<<TXEN0);									//송신가능
	
	UCSR0B |= (1<<RXCIE0);									//수신 인터럽트 ENABLE
}

void UART0_Transmit(char data)
{
	while(!(UCSR0A & (1<<UDRE0)));							//송신 가능 대기, UDR이 비어있는지?
	UDR0 = data;										//데이터 전송
}

unsigned UART0_Receive(void)
{
	while(!(UCSR0A & (1<<RXC0)));
	return UDR0;
}

