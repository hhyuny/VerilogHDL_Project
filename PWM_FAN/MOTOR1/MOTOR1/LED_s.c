
#include "LED_s.h"
void ledInit(LED *led){
	//포트에 해당하는 핀을 출력 0번 핀
	*(led->port -1) |= (1<<led->pin);
	//*(led->port -1) =*(led->port -1) | (1<<led->pin);
	//*(led->port -1)를 이용해서 port에서 ddr로 접근
	//|=(1<<led->pin) or연산을 통해 led->pin으로 지정된 포트를 출력으로 설정
}
void ledOn(LED *led){
	//해당 핀을 high로 설정
	*(led->port)|=(1<<led->pin);
}
void ledOff(LED *led){
	//해당 핀을 low로 설정
	*(led->port)&=~(1<<led->pin);
}