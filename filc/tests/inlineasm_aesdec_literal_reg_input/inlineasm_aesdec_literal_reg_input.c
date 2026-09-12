#include <stdfil.h>

typedef unsigned char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = {0x10, 0x20};
    asm volatile("aesdec %%xmm1, %0" : "+x"(a));
    zprintf("done\n");
    return 0;
}
