#include <stdio.h>

extern long fna(long);
extern long fnb(long);

int main()
{
    long a = fna(4);
    long b = fnb(5);
    if (a != 4) { printf("bad fna %ld\n", a); return 1; }
    if (b != 10) { printf("bad fnb %ld\n", b); return 1; }
    printf("trampname int ok\n");
    return 0;
}
