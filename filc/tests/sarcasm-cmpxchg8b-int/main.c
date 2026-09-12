#include <stdio.h>

void cas8_test(void* args, long* buf);
void cas8_ul_test(void* args, long* buf);

static struct {
    int expLo, expHi, desLo, desHi;   /* offsets 0, 4, 8, 12 */
    int oldLo, oldHi;                 /* offsets 16, 20 */
    long pad;                         /* offset 24 */
    long live1, live2;                /* offsets 32, 40 (kept live across the pin) */
    long flag;                        /* offset 48: ZF flag + live1 + live2 */
} a;

static long gbuf;

static long pack(int lo, int hi)
{
    return (long)(((unsigned long)(unsigned)hi << 32) | (unsigned)lo);
}

static int check(const char* what, int ok)
{
    if (!ok)
        printf("%s\n", what);
    return ok;
}

int main()
{
    void (*fn)(void*, long*) = cas8_test;
    int variant;
    for (variant = 0; variant < 2; variant++, fn = cas8_ul_test) {
        /* success path: expected == dest, CAS stores the desired pair */
        gbuf = pack(111111, 222222);
        a.expLo = 111111; a.expHi = 222222;
        a.desLo = 333333; a.desHi = 444444;
        a.oldLo = a.oldHi = 0;
        a.live1 = 1008; a.live2 = 1009;
        a.flag = 0;
        fn(&a, &gbuf);
        if (!check("buf after success", gbuf == pack(333333, 444444))) return 1;
        if (!check("old lo after success", a.oldLo == 111111)) return 1;
        if (!check("old hi after success", a.oldHi == 222222)) return 1;
        if (!check("flag after success", a.flag == 1 + 1008 + 1009)) return 1;

        /* failure path: expected != dest, no store, edx:eax <- old dest */
        a.expLo = 999999; a.expHi = 888888;
        a.desLo = 555555; a.desHi = 666666;
        a.oldLo = a.oldHi = 0;
        a.flag = 0;
        fn(&a, &gbuf);
        if (!check("buf after failure", gbuf == pack(333333, 444444))) return 1;
        if (!check("old lo writeback", a.oldLo == 333333)) return 1;
        if (!check("old hi writeback", a.oldHi == 444444)) return 1;
        if (!check("flag after failure", a.flag == 0 + 1008 + 1009)) return 1;
    }
    printf("cmpxchg8b int ok\n");
    return 0;
}
