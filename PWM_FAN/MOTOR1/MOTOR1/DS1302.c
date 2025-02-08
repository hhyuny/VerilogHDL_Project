#include "DS1302.h"

void DS1302_Init()															//DS1302 초기화 함수, 클럭 핀, 데이터 핀 출력 설정, 리셋 핀 LOW로 설정
{
	DS1302_CLK_DDR |= (1<<DS1302_CLK);										//2
	DS1302_DAT_DDR |= (1<<DS1302_DAT);										//3
	DS1302_RST_DDR |= (1<<DS1302_RST);										//4
	
	DS1302_CLK_PORT &= ~(1<<DS1302_CLK);									//초기값 LOW
	DS1302_DAT_PORT |= (1<<DS1302_DAT);										//초기값 HIGH
	DS1302_RST_PORT |= (1<<DS1302_RST);										//초기값 HIGH
	
}

void DS1302_Selected()
{
	DS1302_RST_PORT |= (1<<DS1302_RST);										//CE핀 HIGH
}

void DS1302_Deselected()
{
	DS1302_RST_PORT &= ~(1<<DS1302_RST);									//CE핀 LOW
}

void DS1302_Clock()
{
	DS1302_DAT_PORT |= (1<<DS1302_CLK);										//HIGH
	DS1302_DAT_PORT &= ~(1<<DS1302_CLK);									//LOW										
}

void DS1302_DataBitSet()
{
	DS1302_DAT_PORT |= (1<<DS1302_DAT);										//DATA핀 HIGH
}

void DS1302_DataBitReset()
{
	DS1302_DAT_PORT &= ~(1<<DS1302_DAT);									//DATA핀 LOW
}

void DS1302_Change_ReadMode()
{
	DS1302_DAT_DDR &= ~(1<<DS1302_DAT);										//읽기 모드에서 데이터 핀 출력 설정 변경
}

void DS1302_Change_WriteMode()
{
	DS1302_DAT_DDR |= (1<<DS1302_DAT);										//쓰기 모드에서 데이터 핀 출력 설정 변경
}

uint8_t decimal_to_bcd(uint8_t decimal)
{
	return (((decimal/10)<<4) | (decimal%10));								//10진값을 2진값으로 변환, 4비트씩 묶어서 1의 자리와 10의 자리로 변경
}

uint8_t bcd_to_decimal(uint8_t bcd)
{
	return(((bcd>>4)*10)+(bcd&0x0f));										//bcd값을 4비트씩 묶어서 1자리와 10자리로 구분 --> 10진수로 변환										
}

void DS1302_TxData(uint8_t txData)
{
	DS1302_Change_WriteMode();												//데이터를 하위비트로부터 상위비트 순으로 보내고 클럭신호를 발생시켜 데이타를 전송한다
	
	for(int i=0; i<8; i++)													//하위비트 -> 상위비트로 1비트 출력하고 클럭 올렸다가 내리고
	{
		if(txData & (1<<i))
		DS1302_DataBitSet();												//1이면 실행
		else
		DS1302_DataBitReset();												//0이면, 그렇지 않으면 실행
		
		DS1302_Clock();														//클럭 올렸다가 내린다
	}
}

void DS1302_WriteData(uint8_t address, uint8_t data)						//주소와 데이터를 전송하고 RST핀을 LOW로 설정
{
	DS1302_Selected();														//RST PIN HIGH
	DS1302_TxData(address);													//address send
	DS1302_TxData(decimal_to_bcd(data));									//data send
	DS1302_Deselected();													//RST PIN LOW
}

void DS1302_SetTimeDate(DS1302 timeDate)
{
	DS1302_WriteData(ADDR_SEC, timeDate.sec);
	DS1302_WriteData(ADDR_MIN, timeDate.min);
	DS1302_WriteData(ADDR_HOUR, timeDate.hour);
	DS1302_WriteData(ADDR_DATE, timeDate.date);
	DS1302_WriteData(ADDR_MONTH, timeDate.month);
	DS1302_WriteData(ADDR_DAYOFWEEK, timeDate.dayofweek);
	DS1302_WriteData(ADDR_YEAR, timeDate.year);
}

uint8_t DS1302_RxData()														//데이터를 하위비트부터 상위비트 순으로 읽고 클럭 신호를 발생시켜 데이터를 읽음
{
	uint8_t rxData = 0;
	DS1302_Change_ReadMode();
	
	for(int i=0; i<8; i++)
	{
		rxData |= (DS1302_DAT_PIN & (1<<DS1302_DAT)) ? (1<<i) : 0;
		if(i!=7) DS1302_Clock();
	}
	return rxData;
}

uint8_t DS1302_ReadData(uint8_t address)									//지정된 주소의 데이터를 읽어옴
{
	uint8_t rxData = 0;														//수신된 데이터를 저장할 변수
	DS1302_Selected();
	DS1302_TxData(address+1);												//지정된 주소를 전송(Write에서 1더하면 Read주소
	rxData = DS1302_RxData();												//수신된 데이터 읽음
	DS1302_Deselected();
	return bcd_to_decimal(rxData);
}

void DS1302_GetTime(DS1302 *timeDate)
{
	timeDate->sec = DS1302_ReadData(ADDR_SEC);
	timeDate->min = DS1302_ReadData(ADDR_MIN);
	timeDate->hour = DS1302_ReadData(ADDR_HOUR);
}

void DS1302_GetDate(DS1302 *timeDate)
{
	timeDate->date = DS1302_ReadData(ADDR_DATE);
	timeDate->month = DS1302_ReadData(ADDR_MONTH);
	timeDate->dayofweek = DS1302_ReadData(ADDR_DAYOFWEEK);
	timeDate->year = DS1302_ReadData(ADDR_YEAR);
}