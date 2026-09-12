#include <pthread.h>
#include <pizlonated_runtime.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"

static char* main_str = "";
static char* thread_str = "";

static void append_str(char** to_str, const char* str)
{
    *to_str = zasprintf("%s%s", *to_str, str);
}

static zfiber_context* ctx_main;
static zfiber_context* ctx_thread;
static zfiber_context* ctx_func1;
static zfiber_context* ctx_func2;
static zfiber_context* ctx_func3;
static zfiber_context* ctx_func4;

static void func1(void)
{
    append_str(&main_str, "func1(swapcontext);");
    zfiber_context_swapcontext(ctx_func1, ctx_func2);
    append_str(&main_str, "func1(setcontext);");
    zfiber_context_setcontext(ctx_main);
}

static void func2(void)
{
    append_str(&main_str, "func2(swapcontext);");
    zfiber_context_swapcontext(ctx_func2, ctx_func1);
    append_str(&main_str, "func2(setcontext);");
    zfiber_context_setcontext(ctx_func1);
}

static void foo(void)
{
    void (*recurse)(void) = opaque(foo);
    recurse();
}

static void func3(void)
{
    append_str(&thread_str, "func3(swapcontext);");
    zfiber_context_swapcontext(ctx_func3, ctx_func4);
    append_str(&thread_str, "func3(setcontext);");
    foo();
    zfiber_context_setcontext(ctx_thread);
}

static void func4(void)
{
    append_str(&thread_str, "func4(swapcontext);");
    zfiber_context_swapcontext(ctx_func4, ctx_func3);
    append_str(&thread_str, "func4(setcontext);");
    zfiber_context_setcontext(ctx_func3);
}

static void* thread_func(void* arg)
{
    ctx_thread = zfiber_context_new();
    ctx_func3 = zfiber_context_new();
    ctx_func4 = zfiber_context_new();

    zfiber_context_getcontext(ctx_thread);

    zfiber_context_getcontext(ctx_func3);
    zfiber_context_makecontext(ctx_func3, 16384, func3);

    zfiber_context_getcontext(ctx_func4);
    zfiber_context_makecontext(ctx_func4, 16384, func4);

    append_str(&thread_str, "main(swapcontext);");
    zfiber_context_swapcontext(ctx_thread, ctx_func4);
    append_str(&thread_str, "main(exiting);");

    return NULL;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, thread_func, NULL);
    
    ctx_main = zfiber_context_new();
    ctx_func1 = zfiber_context_new();
    ctx_func2 = zfiber_context_new();

    zfiber_context_getcontext(ctx_main);

    zfiber_context_getcontext(ctx_func1);
    zfiber_context_makecontext(ctx_func1, 16384, func1);

    zfiber_context_getcontext(ctx_func2);
    zfiber_context_makecontext(ctx_func2, 16384, func2);

    append_str(&main_str, "main(swapcontext);");
    zfiber_context_swapcontext(ctx_main, ctx_func2);
    append_str(&main_str, "main(exiting);");

    pthread_join(t, NULL);

    zprintf("main_str = %s\n", main_str);
    zprintf("thread_str = %s\n", thread_str);

    ZASSERT(!strcmp(main_str, "main(swapcontext);func2(swapcontext);func1(swapcontext);func2(setcontext);func1(setcontext);main(exiting);"));
    ZASSERT(!strcmp(thread_str, "main(swapcontext);func4(swapcontext);func3(swapcontext);func4(setcontext);func3(setcontext);main(exiting);"));

    return 0;
}

