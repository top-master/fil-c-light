#include <stdio.h>
#include <stdlib.h>

long fx_rt(void* buf, long n);
long mxcsr_rt(void* buf, long val);

#define NEW_MXCSR 0x9FC0L  /* FTZ | DAZ | all exception masks */

int main()
{
    /* Fil-C malloc guarantees 16-byte alignment (fxsave requires it) */
    void* buf = malloc(512);
    unsigned* mb = malloc(16);
    if (!buf || !mb)
        return 1;
    if (fx_rt(buf, 12345) != 24690)
        return 1;
    long got = mxcsr_rt(mb, NEW_MXCSR);
    if (got != NEW_MXCSR)
        return 1;
    mxcsr_rt(mb, mb[0]);         /* restore original mxcsr */
    printf("fxsave 24690 ok\n");
    return 0;
}
