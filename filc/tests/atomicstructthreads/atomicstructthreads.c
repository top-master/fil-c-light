#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

/* 48 bytes, so all atomic accesses to this go through the lock-based
   __atomic_* libcalls in libpizlo.so. Every field is a function of a single
   tag, so a torn read is trivially detectable. */
struct S {
    unsigned long a, b, c, d, e, f;
};

static struct S shared;

static void fill(struct S* s, unsigned long tag)
{
    s->a = tag;
    s->b = tag ^ 0x1111111111111111UL;
    s->c = tag * 3;
    s->d = ~tag;
    s->e = tag + 7;
    s->f = tag * tag;
}

static int check(struct S* s)
{
    unsigned long tag = s->a;
    return s->b == (tag ^ 0x1111111111111111UL) &&
        s->c == tag * 3 &&
        s->d == ~tag &&
        s->e == tag + 7 &&
        s->f == tag * tag;
}

#define NWRITERS 4
#define NREADERS 4
#define COUNT 20000

static void* writer_main(void* arg)
{
    unsigned long base = (unsigned long)arg;
    struct S v, old;
    unsigned n;
    for (n = 0; n < COUNT; n++) {
        fill(&v, base + n);
        if (n & 1)
            __atomic_store(&shared, &v, __ATOMIC_SEQ_CST);
        else
            __atomic_exchange(&shared, &v, &old, __ATOMIC_SEQ_CST);
    }
    return NULL;
}

static void* reader_main(void* arg)
{
    struct S v;
    unsigned n;
    (void)arg;
    for (n = 0; n < COUNT; n++) {
        __atomic_load(&shared, &v, __ATOMIC_SEQ_CST);
        if (!check(&v)) {
            printf("FAIL: torn read detected\n");
            exit(1);
        }
    }
    return NULL;
}

int main(void)
{
    pthread_t threads[NWRITERS + NREADERS];
    struct S v;
    unsigned n;

    fill(&v, 0);
    __atomic_store(&shared, &v, __ATOMIC_SEQ_CST);

    for (n = 0; n < NWRITERS; n++) {
        pthread_create(threads + n, NULL, writer_main,
                       (void*)(unsigned long)(n * 1000000UL + 1));
    }
    for (n = 0; n < NREADERS; n++)
        pthread_create(threads + NWRITERS + n, NULL, reader_main, NULL);
    for (n = 0; n < NWRITERS + NREADERS; n++)
        pthread_join(threads[n], NULL);
    printf("success\n");
    return 0;
}
