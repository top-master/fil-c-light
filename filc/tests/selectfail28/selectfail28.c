#include <sys/select.h>
#include <stdfil.h>
#include <stdlib.h>
#include "utils.h"

int main()
{
    struct timeval* timeout = malloc(sizeof(struct timeval));
    timeout->tv_sec = 0;
    timeout->tv_usec = 0;
    
    // Free the memory and then use it
    free(opaque(timeout));
    select(0, NULL, NULL, NULL, timeout);
    
    return 0;
}
