#include <stdfil.h>
#include <unistd.h>
#include <sched.h>
#include <stdbool.h>

extern bool lockish;

static void my_bar(void)
{
    zprintf("gctor: in my_bar.\n");
}

static void (*resolve_bar(void))(void)
{
    ZASSERT(!lockish);
    lockish = true;
    zprintf("gctor: gonna sleep a bit.\n");
    sched_yield();
    zprintf("gctor: done.\n");
    ZASSERT(lockish);
    lockish = false;
    return my_bar;
}

void bar(void) __attribute__((ifunc("resolve_bar")));
