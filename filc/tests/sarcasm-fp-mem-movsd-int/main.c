#include <stdio.h>
#include <stdlib.h>

void store8(void* p, long bits);
long load8(void* p);
void store4(void* p, long bits);
long load4(void* p);

#define BITS_15   0x3FF8000000000000L  /* 1.5 */
#define BITS_NEG2 0xC000000000000000L  /* -2.0 */
#define BITS_3_5F 0x40600000L          /* 3.5f */
#define BITS_NEG125F 0xBFA00000L       /* -1.25f */

int main()
{
    char* buf = malloc(32);
    if (!buf)
        return 1;
    store8(buf, BITS_15);
    store8(buf + 8, BITS_NEG2);
    store4(buf + 16, BITS_3_5F);
    store4(buf + 20, BITS_NEG125F);
    if (load8(buf) != BITS_15)
        return 1;
    if (load8(buf + 8) != BITS_NEG2)
        return 1;
    if (load4(buf + 16) != BITS_3_5F)
        return 1;
    if (load4(buf + 20) != BITS_NEG125F)
        return 1;
    /* stores at odd offsets inside the object must round-trip too */
    store8(buf + 4, BITS_NEG2);
    if (load8(buf + 4) != BITS_NEG2)
        return 1;
    store4(buf + 27, BITS_3_5F);
    if (load4(buf + 27) != BITS_3_5F)
        return 1;
    printf("movsd ok\n");
    return 0;
}
