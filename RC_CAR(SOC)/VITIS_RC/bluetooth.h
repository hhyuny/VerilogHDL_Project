#ifndef __BLUETOOTH_H_
#define __BLUETOOTH_H_

#include <stdio.h>
#include <string.h>
#include "xparameters.h" // hw ����
#include "xuartlite.h"	//uart ���
#include "xintc.h"	//interrupt controller ó��
#include "xil_exception.h" 	//interrupt exception ó��

#define BT_DEV_ID			XPAR_UARTLITE_1_DEVICE_ID
#define INTC_DEV_ID			XPAR_INTC_0_DEVICE_ID
#define BT_VEC_ID			XPAR_INTC_0_UARTLITE_1_VEC_ID

u8 rxData;

void BTInit(void);
void BT_SendHandler (void *CallBackRef, unsigned int EventData);
void BT_RecvHandler (void *CallBackRef, unsigned int EventData); 	//�� �Է� �ڷ��� ���� ��������� �̸��� ���� ���� , interrupt �߸� �̰ɷ� ����

#endif

