/*
 * I2C_LCD.h
 *
 *  Created on: Oct 23, 2023
 *      Author: USER
 */

#ifndef INC_I2C_LCD_H_
#define INC_I2C_LCD_H_

#include "stm32f4xx_hal.h"
#include "i2c.h"

void lcd_init();
void lcd_send_cmd(char cmd);
void lcd_send_data(char data);
void lcd_send_string(char *str);
void lcd_put_cur(int row, int col);
void lcd_clear();


#endif /* INC_I2C_LCD_H_ */
