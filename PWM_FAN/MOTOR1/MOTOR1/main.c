#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <stdio.h>
#include <stdint.h>
#include "I2C_LCD.h"
#include "button.h"


int main(void)
{
	LED_DDR = 0xff;														//LED포트 출력 설정												
	Button btnOn;														//구조체 변수 설정
	Button btnOff;														//상태 저장
	Button btnTog;
	Button btnPin;
	
	Button_init(&btnOn, &BUTTON_DDR, &BUTTON_PIN, BUTTON_ON);			//버튼 초기화
	Button_init(&btnOff, &BUTTON_DDR, &BUTTON_PIN, BUTTON_OFF);			//DDR - 데이터 레지스터
	Button_init(&btnTog, &BUTTON_DDR, &BUTTON_PIN, BUTTON_TOGGLE);		//PIN - 핀 상태 읽는 레지스터
	Button_init(&btnPin, &BUTTON_DDR, &BUTTON_PIN, BUTTON_TOGGLE1);
	
	
	//buzzerInit();
	TCCR0 |= (0<<CS02) | (1<<CS01) | (0<<CS00);	//타이머/카운터 클락 분주비 설정 분주비 8
	TCCR0 |= (1<<WGM01) | (1<<WGM00);			//WGM01, WGM00 비트를 1로 설정 Fast PWM MODE 설정
	TCCR0 |= (1<<COM01) | (0<<COM00);			//COM01 - 1, COM00 - 0 설정 비반전 MODE 설정
	OCR0 = 0;									//타이머/카운터 출력 비교 레지스터 초기값 0
	DDRB |= (1<<4);								//PWM PB4번 핀 사용 
	
	//powerBuzzer();
	char buff[30];
	LCD_Init();
	//sprintf(buff, "PARKJIHOON");
	//LCD_WriteStringXY(0,0,buff);
	//LCD_WriteStringXY(0,0,"PARKJIHOON");
	
	while (1)
	{
		if(BUTTON_getState(&btnOn)==ACT_RELEASED)		 
		{
			LED_PORT = 0x01;							//LED 1번 출력
			LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);	//디스플레이 초기화 후 재송출
			OCR0 = 90;									//선풍기 속도 제어 30%
			sprintf(buff, "PARKJIHOON");
			LCD_WriteStringXY(0,0,buff);
			//sprintf(buff, "WIND Stats :30");
			//LCD_WriteStringXY(1,0,buff);
			LCD_WriteStringXY(1,0,"WIND Stats:30%");	//속도 표시
		}
		if(BUTTON_getState(&btnOff)==ACT_RELEASED)
		{
			LED_PORT = 0x03;							//LED 1,2번 출력
			LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);	//디스플레이 초기화 후 재송출
			OCR0 = 150;									//선풍기 속도 제어 65%
			sprintf(buff, "PARKJIHOON");
			LCD_WriteStringXY(0,0,buff);
			//sprintf(buff, "WIND Stats :  65");
			//LCD_WriteStringXY(1,0,buff);
			LCD_WriteStringXY(1,0,"WIND Stats:65%");	//속도 표시
		}
		if(BUTTON_getState(&btnTog)==ACT_RELEASED)
		{
			LED_PORT = 0x07;							//LED 1,2,3번 출력
			LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);	//디스플레이 초기화 후 재송출
			OCR0 = 250;									//선풍기 속도 제어 100%
			sprintf(buff, "PARKJIHOON");
			LCD_WriteStringXY(0,0,buff);
			//sprintf(buff, "WIND Stats : 100");
			//LCD_WriteStringXY(1,0,buff);
			LCD_WriteStringXY(1,0,"WIND Stats:100%");	//속도 표시
		}
		if(BUTTON_getState(&btnPin)==ACT_RELEASED)
		{
			LED_PORT = 0x00;							//LED 전체 OFF
			LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);	//디스플레이 초기화 후 재송출
			OCR0 = 0;									//선풍기 STOP
			sprintf(buff, "PARKJIHOON");
			LCD_WriteStringXY(0,0,buff);
			//sprintf(buff, "WIND Stats :STOP");
			//LCD_WriteStringXY(1,0,buff);
			LCD_WriteStringXY(1,0,"WIND Stats:STOP");	//속도 표시
		}
	}
}
