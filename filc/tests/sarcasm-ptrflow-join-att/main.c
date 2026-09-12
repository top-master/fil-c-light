#include <stdio.h>
#include <stdlib.h>

void join_store(unsigned long* a, unsigned long** b);

/* The store's destination web is %rdi or %rsi depending on the condition word
   at *a; the joined web must carry the taken branch's capability so the
   `;! store ptr` lands the pointer with a working capability. */
int main()
{
    unsigned long** a = malloc(sizeof(unsigned long*));  /* condition cell and pointer slot */
    unsigned long** b = malloc(sizeof(unsigned long*));  /* pointer slot */
    if (!a || !b)
        return 1;

    *(unsigned long*)a = 0;
    *b = 0;
    join_store((unsigned long*)a, b);   /* condition false: stores a's pointer into *b */
    if (*b != (unsigned long*)a) {
        printf("FAIL join false: b=%p (expected %p)\n", (void*)*b, (void*)a);
        return 1;
    }
    (*b)[0] = (unsigned long)99;        /* derefs the stored pointer: writes *a */
    if (*(unsigned long*)a != 99) {
        printf("FAIL join false deref: a=%lx\n", *(unsigned long*)a);
        return 1;
    }

    *(unsigned long*)a = 1;
    *b = 0;
    join_store((unsigned long*)a, b);   /* condition true: stores a's pointer into *a */
    unsigned long* p = *a;
    if (p != (unsigned long*)a) {
        printf("FAIL join true: a=%p (expected %p)\n", (void*)p, (void*)a);
        return 1;
    }
    unsigned long v = *p;               /* derefs the joined pointer (reads *a) */
    if (v != (unsigned long)a) {
        printf("FAIL join true deref: %lx\n", v);
        return 1;
    }

    free(a);
    free(b);
    printf("ptrflow join att ok\n");
    return 0;
}
