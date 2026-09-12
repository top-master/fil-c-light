#include <cstdio>
#include <typeinfo>

struct XInterface { virtual ~XInterface() {} virtual int q() { return 0; } };
struct XWeak : public XInterface {};
struct XPropertySet : public XInterface {};
struct XNameContainer : public XInterface {};
struct OWeakObject : public XWeak {};
struct Access : public OWeakObject, public XPropertySet, public XNameContainer { virtual ~Access() {} };
struct ChildAccess : public Access { virtual ~ChildAccess() {} };

extern "C" void* create_child();
extern "C" void* test_cast_same_lib(void*);

__attribute__((visibility("default"))) extern "C" void* test_cast_diff_lib(void* ptr) {
    XInterface* xi = static_cast<XInterface*>(ptr);
    fprintf(stderr, "diff-lib typeid(*xi)=%s\n", typeid(*xi).name());
    fprintf(stderr, "diff-lib typeid(XInterface)@%p\n", (void*)&typeid(XInterface));
    ChildAccess* r = dynamic_cast<ChildAccess*>(xi);
    fprintf(stderr, "diff-lib %s\n", r ? "SUCCESS" : "FAILED");
    return r;
}
