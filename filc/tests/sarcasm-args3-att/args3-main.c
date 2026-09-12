#include <stdio.h>

/* Three register args, mixed ptr/int: exercises the dense Fil-C CC packing of the
   third argument (r9 at the fast entrypoint). */
unsigned long get2(unsigned char* p, unsigned long i, unsigned long j);

int main()
{
    unsigned char* s = (unsigned char*)"hello, world";
    printf("%lu\n", get2(s, 1, 4));   /* 'e' + 'o' = 212 */
    printf("%lu\n", get2(s, 0, 11));  /* 'h' + 'd' = 204 */
    return 0;
}
