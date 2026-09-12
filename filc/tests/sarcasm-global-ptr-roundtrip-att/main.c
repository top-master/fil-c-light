/* Pointer round-trip through a global: a pointer store into a writable
   global forces REGISTRATION (the inline-GP materialization calls the
   slow-init, so the GC scans the object's aux array); the loads then
   round-trip the capability in both directions, C->asm and asm->C. */
#include <stdio.h>
#include <stdlib.h>
void gstore(void* p);
void* gload(void);
extern void* gp;
int main()
{
    char* buf = malloc(16);
    buf[0] = 42;
    buf[1] = 43;
    gstore(buf);
    char* p = gload();
    if (p != buf || p[0] + p[1] != 85) {
        printf("FAIL asm->asm round trip\n");
        return 1;
    }
    gp = buf + 1;   /* C stores through its getter/registration */
    p = gload();
    if (p != buf + 1 || p[0] != 43) {
        printf("FAIL C->asm round trip\n");
        return 1;
    }
    gstore(buf);
    if (gp != buf) {
        printf("FAIL asm->C round trip\n");
        return 1;
    }
    printf("ptr-roundtrip att ok\n");
    return 0;
}
