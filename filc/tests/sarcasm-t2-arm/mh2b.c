#include <stdio.h>
struct String { unsigned char* bytes; size_t size; };
unsigned long hash(struct String* s);
int main() {
    struct String h5 = { (unsigned char*)"hello", 5 };
    struct String h2 = { (unsigned char*)"hi", 2 };
    struct String e  = { (unsigned char*)"", 0 };
    printf("hello/5 = %lu\n", hash(&h5));
    printf("hi/2    = %lu\n", hash(&h2));
    printf("empty/0 = %lu\n", hash(&e));
    return 0;
}
