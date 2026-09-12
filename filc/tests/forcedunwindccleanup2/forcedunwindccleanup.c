#include <setjmp.h>
#include <unwind.h>
#include <stdfil.h>
#include <stdlib.h>

static jmp_buf jmpBuf;

static _Unwind_Reason_Code stopCallback(
    int version, _Unwind_Action actions, _Unwind_Exception_Class exceptionClass,
    struct _Unwind_Exception* exceptionObject, struct _Unwind_Context* Context, void* stopArg)
{
    ZASSERT(stopArg == (void*)666);
    if (actions & _UA_END_OF_STACK)
        longjmp(jmpBuf, 1);
    return _URC_NO_REASON;
}

static void cleanup_foo(int* x)
{
    zprintf("cleanup_foo(%d);", *x);
}

static __attribute__((__noinline__)) void foo()
{
    int x __attribute__((__cleanup__(cleanup_foo))) = 666;
    _Unwind_Exception* exceptionObject = malloc(sizeof(_Unwind_Exception));
    exceptionObject->exception_class = 0;
    exceptionObject->exception_cleanup = NULL;
    _Unwind_ForcedUnwind(exceptionObject, stopCallback, (void*)666);
}

static void cleanup_bar(int* x)
{
    zprintf("cleanup_bar(%d);", *x);
}

static __attribute__((__noinline__)) void bar()
{
    int x __attribute__((__cleanup__(cleanup_bar))) = 1410;
    foo();
}

int main()
{
    if (!setjmp(jmpBuf))
        bar();
    return 0;
}
