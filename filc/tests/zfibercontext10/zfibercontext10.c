#include <pizlonated_runtime.h>

int main()
{
    zfiber_context_swapcontext(zfiber_context_new(), zfiber_context_new());
    return 0;
}

