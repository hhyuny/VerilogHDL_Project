
#ifndef LCD_H_
#define LDC_H_

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>

#define LCD_DATA_DDR  DDRA
#define LCD_DATA_PORT PORTA
#define LCD_DATA_PIN  PINA
#define LCD_RS_DDR	  DDRD
#define LCD_RW_DDR    DDRD
#define LCD_E_DDR	  DDRD
#define LCD_RS_PORT   PORTD
#define LCD_RW_PORT   PORTD
#define LCD_E_PORT    PORTD
#define LCD_RS        5
#define LCD_RW        4
#define LCD_E		  3

//COMMAND
#define COMMAND_DISPLAY_CLEAR	0x01
#define COMMAND_DISPLAY_ON		0x0C
#define COMMAND_DISPLAY_OFF		0x08
#define COMMAND_ENTRY_MODE		0x06
#define COMMAND_8_BIT_MODE		0x38
#define COMMAND_4_BIT_MODE		0x28

void LCD_Data(uint8_t data);
void LCD_Data4bit(uint8_t data);
void LCD_EnablePin();
void LCD_Writepin();
void LCD_Readpin();
void LCD_WriteCommand(uint8_t commandData);
void LCD_WriteData(uint8_t charData);
void LCD_gotoXY(uint8_t row, int8_t col);
void LCD_WriteString(char *string);
void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string);
void LCD_Init();

#endif /* INCFILE1_H_ */