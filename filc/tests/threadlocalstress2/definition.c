#include "header.h"

static int x = 666;
__thread int* ptr = &x;

extern __thread int* ptr2 __attribute__ ((alias ("ptr")));


