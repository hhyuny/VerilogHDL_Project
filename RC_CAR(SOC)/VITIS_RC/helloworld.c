/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "bluetooth.h"

#define MOTOR_RIGHT_ADDR 0x44A00000
#define MOTOR_LEFT_ADDR 0x44A10000

#define ULTRA_FRONT_ADDR 0x44A20000
#define ULTRA_RIGHT_ADDR 0x44A30000
#define ULTRA_LEFT_ADDR 0x44A40000

#define FORWARD 0
#define BACKWARD 1

//u32 distance_front;
//u32 distance_right;
//u32 distance_left;
//u8 direction_right;
//u8 direction_left;
//u8 right_duty;
//u8 left_duty;

extern u8 rxData;

int main()
{
    init_platform();

    BTInit();

    print("Start!\n\r");
//    u8 data_t[4] = {0,};

//    XIic_Initialize(&iic_device, IIC_ID);	// initialize iic
//    XIic_Send(iic_device.BaseAddress, 0x27, data_t, 1, XIIC_STOP); // 1문자 보내고 stop
//    Iic_LCD_init();
//    lcd_send_string("Auto Driving");
//    Iic_gotoXY(1, 0);
//    lcd_send_string("123456789abcdefghijklmnopqrstuvwxyz");

    volatile unsigned int *motor_R = (volatile unsigned int *) MOTOR_RIGHT_ADDR;
    volatile unsigned int *motor_L = (volatile unsigned int *) MOTOR_LEFT_ADDR;
    // motor[0] = duty, [1] = freq, [2] = direction

    volatile unsigned int *ultra_F = (volatile unsigned int *) ULTRA_FRONT_ADDR;
    volatile unsigned int *ultra_R = (volatile unsigned int *) ULTRA_RIGHT_ADDR;
    volatile unsigned int *ultra_L = (volatile unsigned int *) ULTRA_LEFT_ADDR;
    //ultra_F[0] = distance

    motor_R[1] = 100;
    motor_L[1] = 100;

//    print("Hello World\n\r");

    while(1)
    {

//    	distance_front = ultra_F[0];
//    	distance_right = ultra_R[0];
//    	distance_left = ultra_L[0];
//
//    	motor_R[0] = right_duty;
//    	motor_L[0] = left_duty;
//    	motor_R[2] = direction_right;
//    	motor_L[2] = direction_left;

//    	xil_printf("distance : %d\n\r", ultra_L[0]);

		if(rxData == 't')
    	{
			if( ultra_F[0] < 42)
			{
				if(ultra_R[0] > ultra_L[0])
				{
					motor_R[2] = BACKWARD;
					motor_L[2] = FORWARD;
					motor_R[0] = 33;
					motor_L[0] = 70;
				}
				else
				{
					motor_R[2] = FORWARD;
					motor_L[2] = BACKWARD;
					motor_R[0] = 33;
					motor_L[0] = 70;
				}
			}
			else if( ultra_F[0] < 62)
			{
				if(ultra_L[0] < 30 || ultra_R[0] < 30)
				{
					if(ultra_R[0] > ultra_L[0])
					{
						motor_R[2] = FORWARD;
						motor_L[2] = FORWARD;
						motor_R[0] = 0;
						motor_L[0] = 70;
					}
					else
					{
						motor_R[2] = FORWARD;
						motor_L[2] = FORWARD;
						motor_R[0] = 70;
						motor_L[0] = 0;
					}
				}
				else
				{
					motor_R[2] = FORWARD;
					motor_L[2] = FORWARD;
					motor_R[0] = 70;
					motor_L[0] = 70;
				}
			}
			else if(ultra_L[0] < 22 || ultra_R[0] < 22)
			{
				if(ultra_R[0] > ultra_L[0])
				{
					motor_R[2] = FORWARD;
					motor_L[2] = FORWARD;
					motor_R[0] = 0;
					motor_L[0] = 70;
				}
				else
				{
					motor_R[2] = FORWARD;
					motor_L[2] = FORWARD;
					motor_R[0] = 70;
					motor_L[0] = 0;
				}
			}
			else
			{
				motor_R[2] = FORWARD;
				motor_L[2] = FORWARD;
				motor_R[0] = 70;
				motor_L[0] = 70;
			}
    	}
		else if(rxData == 'w')
		{
			motor_R[2] = FORWARD;
			motor_L[2] = FORWARD;
			motor_R[0] = 50;
			motor_L[0] = 50;
//			bt_drive_go();
		}
		else if(rxData == 's')
		{
			motor_R[2] = FORWARD;
			motor_L[2] = FORWARD;
			motor_R[0] = 0;
			motor_L[0] = 0;
//			bt_drive_stop();
		}
		else if(rxData == 'a')
		{
			motor_R[2] = FORWARD;
			motor_L[2] = BACKWARD;
			motor_R[0] = 100;
			motor_L[0] = 50;
//			bt_drive_right();
		}
		else if(rxData == 'd')
		{
			motor_R[2] = BACKWARD;
			motor_L[2] = FORWARD;
			motor_R[0] = 50;
			motor_L[0] = 100;
//			bt_drive_left();
		}
}

    cleanup_platform();
    return 0;
}


