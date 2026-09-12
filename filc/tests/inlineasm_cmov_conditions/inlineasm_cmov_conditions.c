#include <stdfil.h>

#define TEST_CMOV(cc) do {                      \
    int dst = 0;                                \
    int src = 1;                                \
    int cond = 1;                               \
    asm volatile("cmpl $0, %2\n\t"              \
                 "cmov" #cc " %1, %0"          \
                 : "+r"(dst)                   \
                 : "r"(src), "r"(cond)         \
                 : "cc");                       \
} while (0)

int main(void)
{
    TEST_CMOV(o);
    TEST_CMOV(no);
    TEST_CMOV(b);
    TEST_CMOV(c);
    TEST_CMOV(nae);
    TEST_CMOV(nb);
    TEST_CMOV(nc);
    TEST_CMOV(ae);
    TEST_CMOV(e);
    TEST_CMOV(z);
    TEST_CMOV(ne);
    TEST_CMOV(nz);
    TEST_CMOV(be);
    TEST_CMOV(na);
    TEST_CMOV(nbe);
    TEST_CMOV(a);
    TEST_CMOV(s);
    TEST_CMOV(ns);
    TEST_CMOV(p);
    TEST_CMOV(pe);
    TEST_CMOV(np);
    TEST_CMOV(po);
    TEST_CMOV(l);
    TEST_CMOV(nge);
    TEST_CMOV(nl);
    TEST_CMOV(ge);
    TEST_CMOV(le);
    TEST_CMOV(ng);
    TEST_CMOV(nle);
    TEST_CMOV(g);
    return 0;
}
