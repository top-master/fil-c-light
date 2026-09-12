#include <stdio.h>

long driver(long *a, long *b, long *c, long *d, long *e, int n);
long driver7(long *a, long *b, long *c, long *d, long *e, int n, int m);

/* the C side asserts every received argument */
__attribute__((noinline)) long cfn5(long *a, long *b, size_t n) {
    if (*a != 1 || *b != 2 || n != 1000)
        printf("cfn5 BAD ARGS: %ld %ld %zu\n", *a, *b, n);
    return *a + *b + (long)n;
}
__attribute__((noinline)) long cfn11(long *a, long *b, long *c, long *d, long *e, int n) {
    if (*a != 1 || *b != 2 || *c != 4 || *d != 8 || *e != 16 || n != 1000)
        printf("cfn11 BAD ARGS\n");
    return *a + *b + *c + *d + *e + n;
}
__attribute__((noinline)) long cfn7(long *a, long *b, long *c, long *d, long *e, int n, int m) {
    if (*a != 1 || *b != 2 || *c != 4 || *d != 8 || *e != 16 || n != 1000 || m != 2000)
        printf("cfn7 BAD ARGS\n");
    return *a + *b + *c + *d + *e + n + m;
}

/* mismatch: really long(ptr) — the callsite declares the 11-word signature, so
   the resolver takes the generic buffer-CC path and cread receives arg0 only */
long callcread(long *p);
__attribute__((noinline)) long cread(long *p) {
    return *p + 7;
}

int main()
{
    long a = 1, b = 2, c = 4, d = 8, e = 16;
    /* (1+2+1000) + (1+2+4+8+16+1000) = 2034 */
    printf("%ld\n", driver(&a, &b, &c, &d, &e, 1000));
    /* 1+2+4+8+16+1000+2000 = 3031 */
    printf("%ld\n", driver7(&a, &b, &c, &d, &e, 1000, 2000));
    /* 35 + 7 = 42 (generic buffer-CC path of the 11-word callsite signature) */
    long v = 35;
    printf("%ld\n", callcread(&v));
    return 0;
}
