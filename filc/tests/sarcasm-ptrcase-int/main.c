#include <stdio.h>
#include <stdlib.h>

void pc_store_lower(void** slot, void* v);
void pc_store_mixed1(void** slot, void* v);
void pc_store_mixed2(void** slot, void* v);
void pc_store_mixed3(void** slot, void* v);
void pc_store_upper(void** slot, void* v);
void* pc_load_lower(void** slot);
void* pc_load_mixed(void** slot);

struct cell {
    long q;
    int d;
    short w;
    unsigned char b;
};

void pc_arith(struct cell* c);

#define CHECK(exp) do { \
    if (!(exp)) { \
        fprintf(stderr, "%s:%d: FAILED: %s\n", __FILE__, __LINE__, #exp); \
        return 1; \
    } \
} while (0)

int main()
{
    static long payload[4] = { 11, 22, 33, 44 };
    void** slot = malloc(4 * sizeof(void*));
    CHECK(slot);

    /* every casing of the PTR keyword stores a real pointer capability */
    pc_store_lower(&slot[0], &payload[0]);
    pc_store_mixed1(&slot[1], &payload[1]);
    pc_store_mixed2(&slot[2], &payload[2]);
    pc_store_mixed3(&slot[3], &payload[3]);
    pc_store_upper(&slot[0], &payload[3]);

    CHECK(pc_load_lower(&slot[0]) == &payload[3]);
    CHECK(pc_load_mixed(&slot[0]) == &payload[3]);
    CHECK(pc_load_lower(&slot[1]) == &payload[1]);
    CHECK(pc_load_lower(&slot[2]) == &payload[2]);
    CHECK(pc_load_mixed(&slot[3]) == &payload[3]);

    /* and the loaded pointers are usable capabilities */
    CHECK(*(long*)pc_load_lower(&slot[0]) == 44);
    CHECK(*(long*)pc_load_lower(&slot[1]) == 22);

    /* lowercase size words of every width, all through the checked path */
    struct cell c = { 100, 200, 300, 10 };
    pc_arith(&c);
    CHECK(c.q == 105);
    CHECK(c.d == 203);
    CHECK(c.w == 302);
    CHECK(c.b == 11);

    printf("ptrcase int ok\n");
    return 0;
}
