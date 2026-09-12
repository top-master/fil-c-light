#include <setjmp.h>
#include <unwind.h>
#include <stdfil.h>
#include <vector>
#include <string>

using namespace std;

static vector<string> things;

struct C {
    C()
    {
        things.push_back("C::C");
    }

    ~C()
    {
        things.push_back("C::~C");
    }
};

struct D {
    D()
    {
        things.push_back("D::D");
    }

    ~D()
    {
        things.push_back("D::~D");
    }
};

static jmp_buf jmpBuf;
static void* barFrame;

static _Unwind_Reason_Code stopCallback(
    int version, _Unwind_Action actions, _Unwind_Exception_Class exceptionClass,
    _Unwind_Exception* exceptionObject, _Unwind_Context* context, void* stopArg)
{
    ZASSERT(stopArg == (void*)666);
    ZASSERT(!(actions & _UA_END_OF_STACK));
    if ((void*)_Unwind_GetCFA(context) == barFrame)
        longjmp(jmpBuf, 1);
    return _URC_NO_REASON;
}

static __attribute__((__noinline__)) void foo()
{
    C c;
    _Unwind_Exception* exceptionObject = new _Unwind_Exception;
    exceptionObject->exception_class = 0;
    exceptionObject->exception_cleanup = nullptr;
    _Unwind_ForcedUnwind(exceptionObject, stopCallback, (void*)666);
}

static __attribute__((__noinline__)) void bar()
{
    barFrame = __builtin_frame_address(0);
    D d;
    foo();
}

int main()
{
    if (!setjmp(jmpBuf))
        bar();
    ZASSERT(things.size() == 3);
    ZASSERT(things[0] == "D::D");
    ZASSERT(things[1] == "C::C");
    ZASSERT(things[2] == "C::~C");
    return 0;
}
