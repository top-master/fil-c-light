#include <stdio.h>
long foo_alias(long);
long foo_distinct(long);
int main() {
    // foo_alias: -8(%rbp) and 8(%rsp) are the SAME address (rbp = rsp + 16), so the
    // 42 stored via 8(%rsp) must be visible through -8(%rbp) -> 42.
    // foo_distinct: -8(%rbp) (= rsp+8) and -8(%rsp) (red zone) are DISTINCT addresses,
    // so the argument stored via -8(%rbp) must survive the 42 stored via -8(%rsp) -> 7.
    printf("%ld %ld\n", foo_alias(7), foo_distinct(7));
    return 0;
}
