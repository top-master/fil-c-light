#include <stdio.h>
#include <stdlib.h>
void bump(void* p, long v);
int main()
{
    /* 16-byte object; an 8-byte locked RMW at offset 16 is fully out of
       bounds and must trap. */
    long* buf = malloc(16);
    if (!buf) return 1;
    buf[0] = 1; buf[1] = 2;
    bump((char*)buf + 16, 5);
    printf("SHOULD NOT PRINT (no OOB trap)\n");
    return 0;
}
