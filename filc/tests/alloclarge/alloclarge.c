#include <stdfil.h>
#include "utils.h"

int main()
{
    unsigned i;
    for (i = 100; i--;)
        zmemset(zgc_alloc(i * 1048576), 0xff, i * 1048576);
    zgc_request_and_wait();
    for (i = 0; i < 100; ++i) {
        opaque(zgc_alloc(i * 666666));
        zgc_request_and_wait();
    }
    return 0;
}

