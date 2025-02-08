/*
 * LED1.h
 *
 * Created: 2023-07-10 오후 2:39:46
 *  Author: USER
 */ 
#ifndef LED1_H_
#define LED1_H_

#include <avr/io.h>						
#include <stdio.h>

#define LED_PORT	PORTB
#define LED_DDR		DDRB


void ledInit();
void GPI0_output(uint8_t data);
void ledLeftShift(uint8_t *data);
void ledRightShift(uint8_t *data);


#endif /* LED1_H_ */