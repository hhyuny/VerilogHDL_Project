#include "IncFile1.h"

void LCD_Data(uint8_t data)
{
	LCD_DATA_PORT = data;
}

void LCD_Data4bit(uint8_t data)
{
	LCD_DATA_PORT = (LCD_DATA_PORT & 0x0f) | (data & 0xf0);			//상위 4비트 출력
	LCD_EnablePin();
	LCD_DATA_PORT = (LCD_DATA_PORT & 0x0f) | ((data & 0x0f)<<4);	//하위 4비트 출력
	LCD_EnablePin();
}

void LCD_Data4bitinit(uint8_t data)
{
	LCD_RW_PORT=(LCD_DATA_PORT & 0x0f) | (data & 0xf0);
	LCD_EnablePin();
}

void LCD_EnablePin()
{
	LCD_E_PORT &= ~(1<<LCD_E);
	LCD_E_PORT |= (1<<LCD_E);
	LCD_E_PORT &= ~(1<<LCD_E);
	_delay_us(1800);
}

void LCD_Writepin()
{
	LCD_RW_PORT &= ~(1<<LCD_RW);									//RW핀을 LOW로 설정하여 쓰기모드
}

//void LCD_Readpin()
//{
	//LCD_RW_PORT |= (1<<LCD_RW);										//RW핀을 HIGH로 설정 읽기모드
//}

void LCD_WriteCommand(uint8_t commandData)
{
	LCD_RS_PORT &= ~(1<<LCD_RS);									//RS핀을 LOW로 설정해서 명령어 모드 설정
	LCD_Writepin();													//데이터 쓰기 함수 호출
	LCD_Data4bit(commandData);											//명령어 데이터를 데이터 핀에 출력
	//LCD_EnablePin();											//LCD 동작 신호 전송
}

void LCD_WriteData(uint8_t charData)
{
	LCD_RW_PORT |= (1<<LCD_RS);										//RS핀을 HIGH로 설정, 문자 데이터 모드 설정
	LCD_Writepin();
	LCD_Data4bit(charData);
	//LCD_EnablePin();
}

void LCD_gotoXY(uint8_t row, int8_t col)
{
	col %= 16;														//열 인덱스를 0부터 15로 제한
	row %= 2;														//행 인덱스를 0부터 1로 제한
	
	uint8_t address = (0x40 * row) + col;							//주소계산
	uint8_t command = 0x80 + address;								//command값 계산
	LCD_WriteCommand(command);										//주소 설정 command를 LCD에 전달
}

void LCD_WriteString(char *string)
{
	for(uint8_t i=0; string[i]; i++)
	{
		LCD_WriteData(string[i]);
	}
}

void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string)
{
	LCD_gotoXY(row, col);											//지정된 커서로 이동
	LCD_WriteString(string);										//문자열을 해당 위치부터 출력
}

void LCD_Init()
{
	LCD_DATA_DDR = 0xff;
	LCD_RS_DDR |= (1<<LCD_RS);
	LCD_RW_DDR |= (1<<LCD_RW);
	LCD_E_DDR |= (1<<LCD_E);
	
	_delay_ms(20);
	LCD_WriteCommand(0x03);
	_delay_ms(10);
	LCD_WriteCommand(0x03);
	_delay_ms(1);
	LCD_WriteCommand(0x03);
	LCD_WriteCommand(0x02);
	LCD_WriteCommand(COMMAND_4_BIT_MODE);
	LCD_WriteCommand(COMMAND_DISPLAY_OFF);
	LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);
	LCD_WriteCommand(COMMAND_DISPLAY_ON);
	LCD_WriteCommand(COMMAND_ENTRY_MODE);
}
