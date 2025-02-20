#include "nios2_irq.h"
#include "simple_printf.h"

typedef struct {
   int data;
   int enable;
   int irq_mask;
   int irq_pool;
   int irq_ack;
} GPIO_t;

#define GPIO ((volatile GPIO_t *) 0x9000)

volatile unsigned int buffer;

void gpio_init() {
    GPIO->enable = 0x3FF;
    GPIO->irq_mask = 0x1;
    GPIO->irq_pool = 0x1;
}

void gpio_ISR(void) {
    simple_printf("Interruption generated!\n");
    GPIO->irq_ack = 0xFFFFFFFF;
}

int main(void) {
    RegisterISR(0, gpio_ISR);
    gpio_init();
    irq_enable();

    while (1)
    {
        buffer = GPIO->data;
        GPIO->data = buffer;
    }
    
    return 0;
}