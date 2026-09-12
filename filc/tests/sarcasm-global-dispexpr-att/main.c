/* Displacement expressions on globals: `tab-4+8(%rip)` and `tab+16-8(%rip)`
   fold to sym+K; `buf+512-128(%rip)` folds to buf+384; and the pure-constant
   `512-128(%rdi)` folds to 384(%rdi). */
#include <stdio.h>
#include <string.h>
long disps(void* p);
int main()
{
    char buf[512];
    memset(buf, 0, sizeof(buf));
    int v = 77;
    memcpy(buf + 384, &v, 4);
    /* tab+4 = 200, tab+8 = 300, movd of buf+384 lane0 = 1000, +77 */
    if (disps(buf) != 1577) {
        printf("FAIL dispexpr\n");
        return 1;
    }
    printf("dispexpr att ok\n");
    return 0;
}
