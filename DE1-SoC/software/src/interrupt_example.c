#include "nios2_irq.h"
#include "interval_timer.h"
#include "pushbutton.h"
#include "simple_printf.h"


int main(void)
{

   interval_timer_start();
   simple_printf("Let's start...\n");
   unsigned int d = interval_timer_val();
   simple_printf("Last print took %d cycles\n",d);

   RegisterISR(0, interval_timer_ISR);
   RegisterISR(1, pushbutton_ISR);

   interval_timer_init_periodic();
   pushbutton_init();

   // test reading timer value
   for (int l=0;l<10; l++) {
     unsigned int t,tt;
     tt = interval_timer_val();
     for (int i=0;i<33;i++) asm volatile("nop");
     t = interval_timer_val();
     simple_printf("time 0x%x (%u) -> duration %u \n",t,t,t-tt);
     tt = t;
   }

   irq_enable();

   int t = 0;

   while(1)
   {
      if (timer_tick)
      {
         t ++;
         timer_tick = 0;
         simple_printf("*%d*: %04d\r",t/2, pb_count);

      }
   }

   // never return
   for(;;)
      ;
   return 0;
}
