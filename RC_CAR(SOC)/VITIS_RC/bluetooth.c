#include "bluetooth.h"

static XUartLite BT;
static XIntc Intc;


void BTInit(void)
{
    XUartLite_Initialize(&BT, BT_DEV_ID);
    XUartLite_SelfTest(&BT);		//넣어주라고 되어있다.

    ///////////////////// interrupt initialize
    XIntc_Initialize(&Intc, INTC_DEV_ID);
    XIntc_Connect(&Intc, BT_VEC_ID,
    		(XInterruptHandler)XUartLite_InterruptHandler,
			(void *)&BT ); 		// 이 형태 그대로 넣어줘야한다. 외워야한다.

    XIntc_Start(&Intc, XIN_REAL_MODE);
    XIntc_Enable(&Intc, BT_VEC_ID);

    // Exception
    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XIntc_InterruptHandler, &Intc);
    Xil_ExceptionEnable();

    //uart interrupt handler 설정
    XUartLite_SetSendHandler(&BT, BT_SendHandler, &BT);
    XUartLite_SetRecvHandler(&BT, BT_RecvHandler, &BT);

    XUartLite_EnableInterrupt(&BT);
}


void BT_SendHandler (void *CallBackRef, unsigned int EventData)
{
	return;
}

void BT_RecvHandler (void *CallBackRef, unsigned int EventData)
{
	XUartLite_Recv(&BT, &rxData, 1);
	xil_printf("Select mode : %c\n\r", rxData);
}
