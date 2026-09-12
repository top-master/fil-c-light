#include <stdfil.h>

int main()
{
    unsigned original_value = __builtin_ia32_stmxcsr();
    __builtin_ia32_ldmxcsr(0);
    ZASSERT(!__builtin_ia32_stmxcsr());
    __builtin_ia32_ldmxcsr(original_value);
    ZASSERT(__builtin_ia32_stmxcsr() == original_value);
    return 0;
}

