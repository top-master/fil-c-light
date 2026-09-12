#include <stdio.h>
struct String { unsigned char* bytes; size_t size; };
unsigned long hash(struct String* string);
int main() {
    struct String s = { (unsigned char*)"hello", 5 };
    printf("%lu\n", hash(&s));
    return 0;
}
