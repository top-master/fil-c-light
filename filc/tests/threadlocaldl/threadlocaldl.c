#include <stdfil.h>
#include <stdlib.h>
#include <pthread.h>
#include "utils.h"
#include <dlfcn.h>

static int z = 666;

static __thread int x = 42;
static __thread int* y = &z;

static void (*setx)(int value);
static int (*getx)(void);
static void (*sety)(int* value);
static int* (*gety)(void);

static void* thread_main(void* arg)
{
    ZASSERT(x == 42);
    x = 555;
    opaque(NULL);
    ZASSERT(x == 555);

    void* lib = dlopen("filc/test-output/threadlocaldl/libbundle.so", RTLD_LAZY | RTLD_LOCAL);
    ZASSERT(lib);
    setx = dlsym(lib, "setx");
    getx = dlsym(lib, "getx");
    sety = dlsym(lib, "sety");
    gety = dlsym(lib, "gety");
    ZASSERT(setx);
    ZASSERT(sety);
    ZASSERT(getx);
    ZASSERT(gety);

    zprintf("Loaded the library.\n");

    ZASSERT(getx() == 1410);
    setx(101);
    ZASSERT(getx() == 101);
    ZASSERT(*gety() == 47);
    int* p = malloc(sizeof(int));
    *p = 102;
    sety(p);
    ZASSERT(gety() == p);
    ZASSERT(*gety() == 102);

    return NULL;
}

int main()
{
    ZASSERT(x == 42);
    ZASSERT(*y == 666);

    x = 35;
    int* p = malloc(sizeof(int));
    *p = 36;
    y = p;

    opaque(NULL);
    ZASSERT(x == 35);
    ZASSERT(y == p);
    ZASSERT(*y == 36);

    pthread_t thread;
    pthread_create(&thread, NULL, thread_main, NULL);
    pthread_join(thread, NULL);

    zprintf("Thread is done.\n");

    ZASSERT(getx() == 1410);
    ZASSERT(*gety() == 47);
    setx(103);
    ZASSERT(getx() == 103);
    
    return 0;
}

