#include <stdio.h>

void cas16_test(long* args, long* buf);
void cas16_ul_test(long* args, long* buf);

static long args[16];
_Alignas(16) static long gbuf[2];

/* The flag out slot also sums args[7]+[8]+[9] (webs kept live across the
   pinned instruction) plus args[2] (the desired-lo value in rbx, which the
   hardware preserves across the CAS while it is also the implicit pinned
   source) — with args[i] = 1000 + i that is 3024 + desired-lo. */
static long extra;

static void prep(void)
{
    int i;
    for (i = 0; i < 16; i++)
        args[i] = 1000 + i;
}

static int check(const char* what, int ok)
{
    if (!ok)
        printf("%s\n", what);
    return ok;
}

int main()
{
    void (*fn)(long*, long*) = cas16_test;
    int variant;
    for (variant = 0; variant < 2; variant++, fn = cas16_ul_test) {
        /* success path: expected == dest, CAS stores the desired pair */
        gbuf[0] = 111; gbuf[1] = 222;
        prep();
        args[0] = 111; args[1] = 222;
        args[2] = 333; args[3] = 444;
        extra = 1007 + 1008 + 1009 + args[2];
        fn(args, gbuf);
        if (!check("buf lo after success", gbuf[0] == 333)) return 1;
        if (!check("buf hi after success", gbuf[1] == 444)) return 1;
        if (!check("old lo after success", args[4] == 111)) return 1;
        if (!check("old hi after success", args[5] == 222)) return 1;
        if (!check("flag after success", args[6] == 1 + extra)) return 1;

        /* failure path: expected != dest, no store, rdx:rax <- old dest */
        prep();
        args[0] = 999; args[1] = 888;
        args[2] = 555; args[3] = 666;
        extra = 1007 + 1008 + 1009 + args[2];
        fn(args, gbuf);
        if (!check("buf lo after failure", gbuf[0] == 333)) return 1;
        if (!check("buf hi after failure", gbuf[1] == 444)) return 1;
        if (!check("old lo writeback", args[4] == 333)) return 1;
        if (!check("old hi writeback", args[5] == 444)) return 1;
        if (!check("flag after failure", args[6] == 0 + extra)) return 1;
    }
    printf("cmpxchg16b int ok\n");
    return 0;
}
