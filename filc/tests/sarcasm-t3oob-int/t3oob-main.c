#include <stdio.h>
struct String { unsigned char* bytes; size_t size; };
unsigned long hash(struct String* string);
int main() {
    struct String bad = { (unsigned char*)"hi", 2 };
    bad.bytes += 100;                    // foo reads bytes[i] out of bounds -> trap
    printf("t3 OOB:\n");
    printf("%lu (SHOULD NOT PRINT)\n", hash(&bad));
    return 0;
}
