/* A closure passed to zthread_create2() reachable only through the new thread's
   filc_thread::thread_main field once the creating thread's frame goes away. */
#include <stdfil.h>
#include <pizlonated_runtime.h>
#include <string.h>
#include <stdbool.h>

static zweak* closure_weak;
// Maintain a reference so we can inspect
static void* live_zthread;
static bool go;
static bool go2;

static void* closure_body(void* arg)
{
    while (!go)
        asm volatile ("" : : : "memory");
    ZASSERT(!strcmp((const char*)zcallee_closure_data(), "closure data"));
    ZASSERT(arg == (void*)666);
    while (!go2)
        asm volatile ("" : : : "memory");
    return (void*)1234;
}

static __attribute__((noinline)) void start_thread_with_closure(void)
{
    void* zthread = 0;
    void* (*closure)(void*) = zclosure_new(closure_body, "closure data");
    closure_weak = zweak_new(closure);
    ZASSERT(zthread_create2(closure, (void*)666, &zthread, 0));
    ZASSERT(zthread);
    live_zthread = zthread;
}

// Racey, but can show a UAF on thread_main if the collects race
static void test_collect_during_thread_startup(void)
{
    unsigned index;
    for (index = 0; index < 50; ++index) {
        start_thread_with_closure();

        zgc_request_and_wait();
        go = true;
        ZASSERT(zweak_get(closure_weak));
        go2 = true;
            
        void* result = 0;
        ZASSERT(zthread_join(live_zthread, &result));
        ZASSERT(result == (void*)1234);
        live_zthread = 0;
    }
}

int main(void)
{
    test_collect_during_thread_startup();
    return 0;
}

