#ifndef PWM_H_
#define PWM_H_

#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>

void buzzerInit();
void noBuzzer();
void playBuzzer();
void setBuzzer(int note);
void powerBuzzer();



#endif 