/* The other direction: C writes the same-file-defined global (through the
   filcc getter against the alias), asm reads it back through the inline-GP
   seeded lea. */
#include <stdio.h>
long c_read(long i);
extern int g[4];
int main()
{
    for (int i = 0; i < 4; i++) g[i] = (i + 1) * 10;
    long s = 0;
    for (long i = 0; i < 4; i++) s += c_read(i);
    if (s != 100) {
        printf("FAIL asm read of C-written data\n");
        return 1;
    }
    printf("c-side att ok\n");
    return 0;
}
