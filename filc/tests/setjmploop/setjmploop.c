#include <setjmp.h>
#include <stdfil.h>
#include <stdlib.h>

#define N 10000

static __attribute__((noinline)) void foo(jmp_buf** buf_ptrs, unsigned index)
{
    longjmp(*buf_ptrs[index], index + 666);
}

int main()
{
    jmp_buf** buf_ptrs = malloc(sizeof(jmp_buf*) * N);
    unsigned index;
    volatile unsigned expected_index = 0;
    for (index = N; index--;) {
        buf_ptrs[index] = malloc(sizeof(jmp_buf));
        unsigned result = setjmp(*buf_ptrs[index]);
        if (result) {
            zprintf("result = %u\n", result);
            ZASSERT(result == expected_index + 666);
            expected_index++;
            break;
        }
    }
    if (expected_index < N)
        foo(buf_ptrs, expected_index);
    return 0;
}

