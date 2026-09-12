#include <stdio.h>
#include <stdlib.h>

void swap_xchg(unsigned long* a, unsigned long* b, unsigned long n);
void swap_moves(unsigned long* a, unsigned long* b, unsigned long n);
void xchg_straight(unsigned long* a, unsigned long* b);

/* Each iteration swaps the two pointed-to words AND swaps the two pointers,
   so the values are exchanged exactly when the iteration count is odd. Every
   access must run against the capability of the object the pointer currently
   names — a stale lower would trap (or worse). The two words live in
   separately allocated objects so their capabilities differ. */
static int check(void (*swap)(unsigned long*, unsigned long*, unsigned long),
                 const char* name)
{
    unsigned long* a = malloc(8);
    unsigned long* b = malloc(8);
    if (!a || !b)
        return 1;
    static const unsigned long VA = 0x1111111111111111UL, VB = 0x2222222222222222UL;
    unsigned long counts[4] = { 1, 2, 3, 24 };   /* 24 = keccak's round count */
    for (int i = 0; i < 4; i++) {
        *a = VA;
        *b = VB;
        swap(a, b, counts[i]);
        int odd = counts[i] % 2;
        unsigned long ea = odd ? VB : VA, eb = odd ? VA : VB;
        if (*a != ea || *b != eb) {
            printf("FAIL %s n=%lu: a=%lx b=%lx (expected a=%lx b=%lx)\n",
                   name, counts[i], *a, *b, ea, eb);
            return 1;
        }
    }
    free(a);
    free(b);
    return 0;
}

int main()
{
    if (check(swap_xchg, "swap_xchg"))
        return 1;
    if (check(swap_moves, "swap_moves"))
        return 1;
    /* The straight-line xchg: rdi/rsi swap, then *new-rdi is read into *new-rsi. */
    unsigned long* a = malloc(8);
    unsigned long* b = malloc(8);
    if (!a || !b)
        return 1;
    *a = 0x1111111111111111UL;
    *b = 0x2222222222222222UL;
    xchg_straight(a, b);   /* rdi->b, rsi->a; reads *b and stores it into *a */
    if (*a != 0x2222222222222222UL) {
        printf("FAIL xchg_straight: a=%lx\n", *a);
        return 1;
    }
    free(a);
    free(b);
    printf("ptrflow swap att ok\n");
    return 0;
}
