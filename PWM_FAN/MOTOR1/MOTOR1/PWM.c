#include "PWM.h"
void buzzerInit()
{
	DDRB |= (1<<5);
	TCCR1B |= (0<<CS12) | (1<<CS11) | (0<<CS10);						//8분주
	TCCR1B |= (0<<WGM13) | (1<<WGM12);
	TCCR1A |= (0<<WGM11) | (0<<WGM10);
}

void noBuzzer()
{
	TCCR1A &= ~((1<<COM1A1) | (1<<COM1A0));							//미출력
}

void playBuzzer()
{
	TCCR1A |= (0<<COM1A1) | (1<<COM1A0);								//출력
}

void setBuzzer(int note)
{
	OCR1A = 1000000 / note;
}

void powerBuzzer()
{
	playBuzzer();
	setBuzzer(2000);
	_delay_ms(100);
	setBuzzer(3000);
	_delay_ms(100);
	setBuzzer(4000);
	_delay_ms(100);
	noBuzzer();
}