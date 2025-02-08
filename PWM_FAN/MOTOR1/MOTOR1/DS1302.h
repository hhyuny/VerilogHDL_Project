
#ifndef DS1302_H_
#define DS1302_H_

#include <avr/io.h>

#define DS1302_CLK_DDR  DDRF
#define DS1302_CLK_PORT PORTF
#define DS1302_DAT_DDR  DDRF
#define DS1302_DAT_PORT PORTF
#define DS1302_DAT_PIN	PINF
#define DS1302_RST_DDR	DDRF
#define DS1302_RST_PORT PORTF
#define DS1302_CLK		2
#define DS1302_DAT		3
#define DS1302_RST		4

#define ADDR_SEC		0x80
#define ADDR_MIN		0x82
#define ADDR_HOUR		0x84
#define ADDR_DATE		0x86
#define ADDR_MONTH		0x88
#define ADDR_DAYOFWEEK	0x8A
#define ADDR_YEAR		0x8C

typedef struct _DS1302
{
	uint8_t sec, min, hour, date, month, dayofweek, year;
}DS1302;

void DS1302_Init();															//DS1302 초기화 함수, 클럭 핀, 데이터 핀 출력 설정, 리셋 핀 LOW로 설정
void DS1302_Selected();														//RST H
void DS1302_Deselected();													//RST L
void DS1302_Clock();														//CLOCK
void DS1302_DataBitSet();													//bit H
void DS1302_DataBitReset();													//bit L
void DS1302_Change_ReadMode();												//read set
void DS1302_Change_WriteMode();												//write set
uint8_t decimal_to_bcd(uint8_t decimal);
uint8_t bcd_to_decimal(uint8_t bcd);
void DS1302_TxData(uint8_t txData);											//RTC data send
void DS1302_WriteData(uint8_t address, uint8_t data);						//주소와 데이터를 전송하고 RST핀을 LOW로 설정
void DS1302_SetTimeDate(DS1302 timeDate);									//date, time set
uint8_t DS1302_RxData();													//데이터를 하위비트부터 상위비트 순으로 읽고 클럭 신호를 발생시켜 데이터를 읽음
uint8_t DS1302_ReadData(uint8_t address);									//지정된 주소의 데이터를 읽어옴
void DS1302_GetTime(DS1302 *timeDate);										//RTC
void DS1302_GetDate(DS1302 *timeDate);



#endif 