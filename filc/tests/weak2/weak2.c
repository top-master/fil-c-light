#include <stdfil.h>
#include <stdlib.h>
#include <inttypes.h>

#define N 10000
#define REPEAT 1000

int main()
{
    unsigned count;
    for (count = REPEAT; count--;) {
        unsigned** array = zgc_alloc(N * sizeof(unsigned*));
        zweak** weaks = zgc_alloc(N * sizeof(zweak*));
        unsigned i;
        for (i = N; i--;) {
            array[i] = zgc_alloc(sizeof(unsigned));
            *array[i] = i;
        }
        for (i = N; i--;)
            weaks[i] = zweak_new(array[i]);
        for (i = N; i--;) {
            ZASSERT(zweak_get(weaks[i]) == array[i]);
            ZASSERT(zinbounds(zweak_get(weaks[i])));
        }
        for (i = N; i--;)
            array[i] = NULL;
        for (i = N; i--;) {
            unsigned* ptr = zweak_get(weaks[i]);
            if (!ptr)
                continue;
            ZASSERT(*ptr == i);
        }
    }
    return 0;
}

