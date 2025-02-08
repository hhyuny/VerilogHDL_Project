
 #include "LED1.h"

void ledInit(){
	LED_DDR = 0xff;	
}
void GPI0_output(uint8_t data){
	LED_PORT = data; // 0x01
}
void ledLeftShift(uint8_t *data){
	*data = (*data>>7) |(*data <<1);
	GPI0_output(*data);
}
void ledRightShift(uint8_t *data){
	*data = (*data <<7)|(*data >> 1);
	GPI0_output(*data);
}
 
