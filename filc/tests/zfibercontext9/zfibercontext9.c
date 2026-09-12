#include <pizlonated_runtime.h>

int main()
{
    zfiber_context_setcontext(zfiber_context_new());
    return 0;
}

