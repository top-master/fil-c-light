#include <stdlib.h>
#include <stdfil.h>

struct __attribute__((packed)) Packed {
    unsigned char prefix[7];
    int *pointer;
};

int main(void)
{
    volatile struct Packed *value = malloc(sizeof(struct Packed));
    int target = 41;
    // ABI carrier staging must not relax actual C pointer-access alignment.
    value->pointer = &target;
    ZASSERT(*value->pointer == 41);
    zprint("nono\n");
    return 0;
}
