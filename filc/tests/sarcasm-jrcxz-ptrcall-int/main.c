#include <stdio.h>
#include <stdlib.h>

extern long jzeroret(long);
extern long passthru(long *);
extern long icall(void *(*f)(void *));
extern void *ident(void *);
extern void *nulid(void *);

int main()
{
    long *p = malloc(64);
    if (jzeroret(9) != 0) { printf("bad jzeroret\n"); return 1; }
    if (passthru(p) != 1) { printf("bad passthru p\n"); return 1; }
    if (passthru(0) != 0) { printf("bad passthru null\n"); return 1; }
    if (icall(ident) != 1) { printf("bad icall ident\n"); return 1; }
    if (icall(nulid) != 0) { printf("bad icall nulid\n"); return 1; }
    free(p);
    printf("jrcxz ptrcall int ok\n");
    return 0;
}
