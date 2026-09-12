#include <stdio.h>
#include <stdlib.h>
void cas16(void* p);
int main()
{
    /* 32-byte object; a 16-byte CAS at offset 8 is fully IN BOUNDS (the
       bounds checks pass) but only 8-aligned, not 16-aligned: the align-16
       check must trap (a clean filc safety error, not a hardware #GP). The
       fail origin word-clamps the recorded alignment to 8 — this exercises
       that align>8 clamp. */
    _Alignas(16) long* buf = malloc(32);
    if (!buf) return 1;
    buf[0] = 1; buf[1] = 2; buf[2] = 3; buf[3] = 4;
    cas16((char*)buf + 8);
    printf("SHOULD NOT PRINT (no misalign trap)\n");
    return 0;
}
