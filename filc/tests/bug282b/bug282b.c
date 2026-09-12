#include <unwind.h>
#include <stdfil.h>
#include <stdlib.h>

static zweak* weak_callback;
static zweak* weak_callback_arg;

static _Unwind_Reason_Code stopCallback(
    int version, _Unwind_Action actions, _Unwind_Exception_Class exceptionClass,
    struct _Unwind_Exception* exceptionObject, struct _Unwind_Context* Context, void* stopArg)
{
    return _URC_NO_REASON;
}

static __attribute__((noinline)) void bar(void)
{
    void* callback = zclosure_new(stopCallback, NULL);
    void* callback_arg = malloc(1);
    weak_callback = zweak_new(callback);
    weak_callback_arg = zweak_new(callback_arg);
    _Unwind_Exception* exceptionObject = malloc(sizeof(_Unwind_Exception));
    exceptionObject->exception_class = 0;
    exceptionObject->exception_cleanup = NULL;
    _Unwind_ForcedUnwind(exceptionObject, callback, callback_arg);
}

static void cleanup_foo(int* x)
{
    zgc_request_and_wait();
    ZASSERT(zweak_get(weak_callback));
    ZASSERT(zweak_get(weak_callback_arg));
    zprintf("SUCCESS");
    _Exit(0);
}

static __attribute__((noinline)) void foo(void)
{
    int x __attribute__((__cleanup__(cleanup_foo))) = 666;
    bar();
}

int main()
{
    foo();
    return 0;
}

