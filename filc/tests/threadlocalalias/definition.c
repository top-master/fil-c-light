#include "header.h"

__thread int x = 666;

extern __thread int y __attribute__ ((alias ("x")));
