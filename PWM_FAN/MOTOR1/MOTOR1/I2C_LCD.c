#include "I2C_LCD.h"

uint8_t I2C_LCD_Data;

void LCD_Data4bit(uint8_t data)
{
	I2C_LCD_Data = (I2C_LCD_Data & 0x0f) | (data & 0xf0);			//상위 4비트 사용
	LCD_EnablePin();
	I2C_LCD_Data = (I2C_LCD_Data & 0x0f) | ((data & 0x0f) << 4);	//하위 4비트 사용
	LCD_EnablePin();
}

void LCD_EnablePin()
{
	I2C_LCD_Data &= ~(1<<LCD_E);									//E LOW 설정
	I2C_TxByte(LCD_DEV_ADDR, I2C_LCD_Data);
	
	I2C_LCD_Data |= (1<<LCD_E);										//HIGH 설정
	I2C_TxByte(LCD_DEV_ADDR, I2C_LCD_Data);
	
	I2C_LCD_Data &= ~(1<<LCD_E);									//E LOW 설정
	I2C_TxByte(LCD_DEV_ADDR, I2C_LCD_Data);
	
	_delay_us(1800);
}

void LCD_WriteCommand(uint8_t commandData)
{
	I2C_LCD_Data &= ~(1<<LCD_RS);									//RS LOW - COMMAND MODE
	I2C_LCD_Data &= ~(1<<LCD_RW);									//RW LOW - Write MODE
	LCD_Data4bit(commandData);	
}

void LCD_WriteData(uint8_t charData)
{
	I2C_LCD_Data |= (1<<LCD_RS);									//RS HIGH - DATA MODE
	I2C_LCD_Data &= ~(1<<LCD_RW);									//RW LOW  - Write MODE
	LCD_Data4bit(charData);
}

void LCD_BackLightOn()
{
	I2C_LCD_Data |= (1<<LCD_BACKLIGHT);								//LCD 백라이트 비트 설정
	I2C_TxByte(LCD_DEV_ADDR, I2C_LCD_Data);							//I2C 통신 데이터 전송
}

void LCD_GotoXY(uint8_t row, uint8_t col)
{
	row %= 2;														//행 row 0~1까지 2*16 LCD Display
	col %= 16;														//열 column	0~15까지
	uint8_t address = (0x40 * row) + col;
	uint8_t command = 0x80 + address;
	LCD_WriteCommand(command);
}

void LCD_WriteString(char *string)									
{
	for(uint8_t i=0; string[i]; i++)
	{
		LCD_WriteData(string[i]);
	}
}

void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string)		//문자열 LCD 출력
{
	LCD_GotoXY(row, col);
	LCD_WriteString(string);
}

void LCD_Init()														//I2C 통신 초기화
{
	I2C_Init();
	
	_delay_ms(20);													//초기화 대기시간
	LCD_WriteCommand(0x03);
	_delay_ms(10);
	LCD_WriteCommand(0x03);
	_delay_ms(1);
	LCD_WriteCommand(0x03);
	
	LCD_WriteCommand(0x02);									
	LCD_WriteCommand(COMMAND_4_BIT_MODE);
	LCD_WriteCommand(COMMAND_DISPLAY_OFF);
	LCD_WriteCommand(COMMAND_DISPLAY_CLEAR);
	LCD_WriteCommand(COMMAND_ENTRY_MODE);
	LCD_WriteCommand(COMMAND_DISPLAY_ON);
	LCD_BackLightOn();
}

