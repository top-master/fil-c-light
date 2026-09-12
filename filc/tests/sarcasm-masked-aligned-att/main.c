#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long al_load(void* p, long k);
long al_store(void* p, long k);

static uint64_t buf[8] __attribute__((aligned(64)));

int main()
{
    int i;
    for (i = 0; i < 8; i++)
        buf[i] = 300 + i;
    /* vmovdqa32 {z}-masked load (aligned form) at the 64-byte-aligned buffer,
       mask 0x0F: sum lanes 0..3 (dwords). buf[0]=300 -> dwords 44,45; etc.
       Compute the expected dword sum: lane j of the dwords view. */
    long r = al_load(buf, 0xF);
    uint32_t* d = (uint32_t*)buf;
    long want = 0;
    for (i = 0; i < 16; i++)
        if (0xF & (1 << i))
            want += d[i];
    if (r != want) {
        printf("al_load: got %ld want %ld\n", r, want);
        return 1;
    }
    /* vmovaps masked store at the aligned buffer, mask 0x3: lanes 0,1 (floats)
       get 8.5f. */
    r = al_store(buf, 0x3);
    float* f = (float*)buf;
    if (r != 7 || f[0] != 8.5f || f[1] != 8.5f) {
        printf("al_store: r=%ld f=[%f,%f]\n", r, (double)f[0], (double)f[1]);
        return 1;
    }
    printf("masked aligned ok\n");
    return 0;
}
