#include <stdio.h>
#include <stdlib.h>
int f(void** slot, long d);
int main() {
    char* buf = malloc(16);
    void** slot = malloc(sizeof(void*));
    *slot = &buf[15];               /* last valid byte */
    int v = f(slot, 1);             /* walks to &buf[16], one past the end */
    printf("SHOULD NOT PRINT (no oob trap): %d\n", v);
    return 0;
}
