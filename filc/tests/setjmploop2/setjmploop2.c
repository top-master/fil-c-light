#include <setjmp.h>
#include <stdfil.h>
#include <stdlib.h>

#define N 10000

static __attribute__((noinline)) void foo(jmp_buf** buf_ptrs, unsigned index)
{
    longjmp(*buf_ptrs[index], index + 666);
}

static __attribute__((noinline)) void* alloc1(size_t s)
{
    return malloc(s);
}

static __attribute__((noinline)) void* alloc2(size_t s)
{
    return zgc_alloc(s);
}

int main()
{
    jmp_buf** buf_ptrs = malloc(sizeof(jmp_buf*) * N);
    unsigned index;
    volatile unsigned expected_index = 0;
    for (index = 0; index < N / 2; ++index) {
        buf_ptrs[index] = alloc1(sizeof(jmp_buf));
        unsigned result = setjmp(*buf_ptrs[index]);
        if (result) {
            zprintf("(1) result = %u\n", result);
            ZASSERT(result == expected_index + 666);
            expected_index++;
            goto bar;
        }
    }
    for (index = N / 2; index < N; ++index) {
        buf_ptrs[index] = alloc2(sizeof(jmp_buf));
        unsigned result = setjmp(*buf_ptrs[index]);
        if (result) {
            zprintf("(2) result = %u\n", result);
            ZASSERT(result == expected_index + 666);
            expected_index++;
            goto bar;
        }
    }
bar:
    if (expected_index < N)
        foo(buf_ptrs, expected_index);
    return 0;
}

