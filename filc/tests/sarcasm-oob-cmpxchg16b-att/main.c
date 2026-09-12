#include <stdio.h>
#include <stdlib.h>
void cas16(void* p);
int main()
{
    /* 16-byte object; a 16-byte CAS at offset 8 runs past the end and must
       trap the upper-bound check (before any hardware alignment fault). */
    _Alignas(16) long* buf = malloc(16);
    if (!buf) return 1;
    buf[0] = 1; buf[1] = 2;
    cas16((char*)buf + 8);
    printf("SHOULD NOT PRINT (no OOB trap)\n");
    return 0;
}
