#ifndef BUTTON_H_
#define BUTTON_H_

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>

#define  LED_DDR DDRF
#define  LED_PORT PORTF
#define  BUTTON_DDR DDRC
#define  BUTTON_PIN PINC
#define  BUTTON_ON 0
#define  BUTTON_OFF 1
#define  BUTTON_TOGGLE 2
#define  BUTTON_TOGGLE1 3

enum{PUSHED, RELEASED};					//enum은 enumerated type의 줄임말로 열거형 - 값의 집합 자료형
enum{NO_ACT, ACT_PUSH, ACT_RELEASED};
	
typedef struct _button{
	volatile uint8_t *ddr;				//volatile :컴파일할때 최적화하지말라는 의미, 레지스터 주소를 받는 것이기 때문에 사용
	volatile uint8_t *pin;
	uint8_t btnPin;
	uint8_t prevState;
}Button;
void Button_init(Button *button, volatile uint8_t *ddr, volatile uint8_t *pin, uint8_t pinNum);
uint8_t BUTTON_getState(Button*button);



#endif /* BUTTON_H_ */