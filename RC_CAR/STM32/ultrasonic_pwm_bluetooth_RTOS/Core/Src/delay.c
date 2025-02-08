#include "delay.h"

void delay_us(uint16_t us)
{
  //__HAL_TIM_SET_COUNTER() 함수는 타이머를 원하는 숫자로 설정하는 함수
  __HAL_TIM_SET_COUNTER(&htim3, 0);     //타이머를 0으로 초기화

  //타이머의 값을 받아와야
  while((__HAL_TIM_GET_COUNTER(&htim3)) < us);
}
