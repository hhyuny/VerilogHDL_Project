
#include <stdio.h>
#ifndef LED_S_H_
#define LED_S_H_

#define LED_COUNT 8
typedef struct{
	volatile uint8_t *port;				//LED가 연결된 포트
	uint8_t pin;						//LED가 연결된 핀번호
	}LED;

void ledInit(LED *led);
void ledOn(LED *led);
void ledOff(LED *led);

#endif /* LED_S_H_ */