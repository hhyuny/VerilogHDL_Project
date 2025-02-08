/*
 * delay.h
 *
 *  Created on: Oct 20, 2023
 *      Author: USER
 */

#ifndef DELAY_H_
#define DELAY_H_

#include "tim.h"        //타이머를 쓰기위한 헤더파일
#include "stm32f4xx_hal.h"      //HAL 함수를 쓰기위한 헤더

void delay_us(uint16_t us);

#endif /* DELAY_H_ */
