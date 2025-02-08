#ifndef I2C_H_
#define I2C_H_

#include <avr/io.h>

#define I2C_DDR		DDRD
#define I2C_SCL		PORTD0
#define I2C_SDA		PORTD1

#define LCD_DEV_ADDR	(0x27<<1)	// I2C LCD 주소 0x27, <<1은 write 모드 유지

#define COMMAND_DISPLAY_CLEAR	0x01
#define COMMAND_DISPLAY_ON		0x0c
#define COMMAND_DISPLAY_OFF		0x08
#define COMMAND_4_BIT_MODE		0x28
#define COMMAND_ENTRY_MODE		0x06

void LCD_Data4bit(uint8_t data);
void LCD_EnablePin();
void LCD_WriteCommand(uint8_t commandData);
void LCD_WriteData(uint8_t charData);
void LCD_BackLightOn();
void LCD_GotoXY(uint8_t row, uint8_t col);
void LCD_WriteString(char *string);
void LCD_WriteStringXY(uint8_t row, uint8_t col, char *string);
void LCD_Init();

void I2C_Init();
void I2C_Start();
void I2C_Stop();
void I2C_TxData(uint8_t data);
void I2C_TxByte(uint8_t devAddrRW, uint8_t data);

#endif 