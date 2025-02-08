#include "button.h"
void Button_init(Button *button, volatile uint8_t *ddr, volatile uint8_t *pin, uint8_t pinNum){
	button->ddr=ddr;
	button->pin=pin;
	button->btnPin=pinNum;
	button->prevState=RELEASED;											//초기화로 아무것도 안누른 상태
	*button->ddr &= ~(1<<button->btnPin);								//버튼 핀을 입력으로 설정
}
// Button
uint8_t BUTTON_getState(Button*button){
	uint8_t curState = *button->pin & (1<<button->btnPin);				//버튼 상태를 읽어옴
	
	if((curState==PUSHED)&&(button->prevState==RELEASED))				//안누른 상태에서 누르면
	{
		
		_delay_ms(50);													//debounce코드
		button->prevState=PUSHED;										//버튼 상태를 누른 상태로 변환
		return ACT_PUSH;												//버튼이 눌렀음을 반환
	}
	else if((curState!=PUSHED) && (button->prevState==PUSHED))			//버튼은 누른 상태
	{
		
		_delay_ms(50);
		button->prevState=RELEASED;									//버튼 상태를 뗀 상태로 변환
		return ACT_RELEASED;											//버튼이 떨어졌으면 반환
	}
	return NO_ACT;														//아무것도 안했을 때
}
