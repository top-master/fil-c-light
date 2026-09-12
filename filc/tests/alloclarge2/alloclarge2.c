#include <stdfil.h>
#include "utils.h"

int main()
{
    unsigned i;
    for (i = 100; i--;)
        zmemset(zgc_alloc(i * 1048576), 0xff, i * 1048576);
    zgc_request_and_wait();
    for (i = 1; i < 100; i += 20) {
        int** array = zgc_alloc(i * 66666 * sizeof(int*));
        unsigned j;
        for (j = i * 66666; j--;) {
            array[j] = zgc_alloc(sizeof(int));
            *array[j] = i + j;
        }
        zgc_request_and_wait();
        for (j = i * 66666; j--;)
            ZASSERT(*array[j] == i + j);
    }
    return 0;
}

