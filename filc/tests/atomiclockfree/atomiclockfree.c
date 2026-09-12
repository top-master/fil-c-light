#include <stdio.h>

struct S16 { long a, b; };
struct S24 { long a, b, c; };

/* _Atomic promotes the alignment of a 16-byte struct to 16 bytes, which makes 16-byte
   atomic accesses to it eligible for cmpxchg16b. */
static _Atomic struct S16 g16;
static _Atomic struct S24 g24;
static _Atomic long g8;

int main(void)
{
    _Static_assert(sizeof(struct S16) == 16, "S16 is 16 bytes");
    _Static_assert(_Alignof(_Atomic struct S16) == 16, "_Atomic S16 is 16-byte aligned");
    _Static_assert(sizeof(struct S24) == 24, "S24 is 24 bytes");

    if (__atomic_is_lock_free(8, &g8) != 1) {
        printf("FAIL: 8-byte atomic is not lock-free\n");
        return 1;
    }
    if (__atomic_is_lock_free(16, &g16) != 1) {
        printf("FAIL: 16-byte aligned 16-byte atomic is not lock-free\n");
        return 1;
    }
    if (__atomic_is_lock_free(24, &g24) != 0) {
        printf("FAIL: 24-byte atomic is lock-free\n");
        return 1;
    }
    printf("8-byte: lock-free\n");
    printf("16-byte (16-aligned): lock-free\n");
    printf("24-byte: not lock-free\n");
    printf("success\n");
    return 0;
}
