#include <stdio.h>

extern long int_dispatch(long x);
extern long *ptr_dispatch(long *p);

static long buf[8];

int main(void)
{
    long r1 = int_dispatch(5);   /* -> int_variant: 1005 */
    long r2 = int_dispatch(0);   /* fallthrough: 0 */
    buf[2] = 4242;
    long *p1 = ptr_dispatch(buf);      /* -> ptr_variant: buf+2, value 4242 */
    long *p2 = ptr_dispatch(NULL);     /* fallthrough: NULL */
    if (r1 != 1005 || r2 != 0) {
        printf("FAIL: int %ld %ld\n", r1, r2);
        return 1;
    }
    if (p1 != buf + 2 || *p1 != 4242 || p2 != NULL) {
        printf("FAIL: ptr %p %p\n", (void *)p1, (void *)p2);
        return 1;
    }
    printf("tailcall retval att ok\n");
    return 0;
}
