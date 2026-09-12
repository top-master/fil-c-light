#include <stdfil.h>

int main(void)
{
    /* The safe hint numbers: nop/yield/sev/sevl (0/1/4/5), dgh (6), esb
       (16), csdb (20), an unallocated encoding that decodes as a nop (21),
       clrbhb (22), and the bti variants (32/34/36/38). Deliberately no
       wfe/wfi (hint #2/#3), which can sleep, and none of the pointer
       authentication aliases (hint #25-#31), which rewrite lr. */
    asm volatile("hint #0");
    asm volatile("hint #1");
    asm volatile("hint #4");
    asm volatile("hint #5");
    asm volatile("hint #6");
    asm volatile("hint #16");
    asm volatile("hint #20");
    asm volatile("hint #21");
    asm volatile("hint #22");
    asm volatile("hint #32");
    asm volatile("hint #34");
    zprintf("hints ok\n");
    return 0;
}
