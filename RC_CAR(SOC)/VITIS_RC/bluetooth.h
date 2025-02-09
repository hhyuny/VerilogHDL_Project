#ifndef __BLUETOOTH_H_
#define __BLUETOOTH_H_

#include <stdio.h>
#include <string.h>
#include "xparameters.h" // hw 정보
#include "xuartlite.h"	//uart 사용
#include "xintc.h"	//interrupt controller 처리
#include "xil_exception.h" 	//interrupt exception 처리

#define BT_DEV_ID			XPAR_UARTLITE_1_DEVICE_ID
#define INTC_DEV_ID			XPAR_INTC_0_DEVICE_ID
#define BT_VEC_ID			XPAR_INTC_0_UARTLITE_1_VEC_ID

u8 rxData;

void BTInit(void);
void BT_SendHandler (void *CallBackRef, unsigned int EventData);
void BT_RecvHandler (void *CallBackRef, unsigned int EventData); 	//이 입력 자료형 형식 맞춰줘야함 이름은 변경 가능 , interrupt 뜨면 이걸로 받음

#endif

