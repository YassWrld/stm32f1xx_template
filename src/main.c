#include "stm32f10x.h"

void delay_ms(uint32_t ms);

int main(void) {
    // Enable clock for GPIOA
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);

    // Configure PA5 as push-pull output
    GPIO_InitTypeDef GPIO_InitStructure;
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOA, &GPIO_InitStructure);

    while (1) {
        // Toggle PA5
        GPIO_WriteBit(GPIOA, GPIO_Pin_5, Bit_SET);
        delay_ms(500);

        GPIO_WriteBit(GPIOA, GPIO_Pin_5, Bit_RESET);
        delay_ms(500);
    }
}

void delay_ms(uint32_t ms) {
    // crude blocking delay (assuming 72 MHz system clock)
    for (uint32_t i = 0; i < ms * 8000; i++) {
        __NOP();
    }
}