#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void do_sidt(void* p);

int main()
{
    unsigned char* buf = malloc(16);
    if (!buf)
        return 1;
    memset(buf, 0xAA, 16);
    do_sidt(buf);
    /* Bytes 0-9 were overwritten: 2-byte limit then 8-byte base. The IDT
       limit on Linux is 0x0FFF (256 16-byte entries minus 1), never 0xAAAA;
       the base is a real (nonzero) kernel virtual address. */
    uint16_t limit;
    uint64_t base;
    memcpy(&limit, buf, 2);
    memcpy(&base, buf + 2, 8);
    if (limit == 0xAAAA || base == 0 || base == 0xAAAAAAAAAAAAAAAAULL) {
        printf("sidt did not store: limit=%04x base=%016lx\n", limit, base);
        return 1;
    }
    /* Bytes 10-15 must still be the sentinel: exactly a 10-byte store. */
    int i;
    for (i = 10; i < 16; i++) {
        if (buf[i] != 0xAA) {
            printf("sidt clobbered byte %d (%02x): not a 10-byte store\n", i, buf[i]);
            return 1;
        }
    }
    printf("sidt ok\n");
    return 0;
}
