#include <cstdio>
#include <typeinfo>

struct XInterface { virtual ~XInterface() {} virtual int q() { return 0; } };
struct XWeak : public XInterface {};
struct XPropertySet : public XInterface {};
struct XNameContainer : public XInterface {};
struct OWeakObject : public XWeak {};
struct Access : public OWeakObject, public XPropertySet, public XNameContainer { virtual ~Access() {} };
struct ChildAccess : public Access { virtual ~ChildAccess() {} };

__attribute__((visibility("default"))) extern "C" void* create_child() { return new ChildAccess(); }

__attribute__((visibility("default"))) extern "C" void* test_cast_same_lib(void* ptr) {
    XInterface* xi = static_cast<XInterface*>(ptr);
    fprintf(stderr, "same-lib typeid(*xi)=%s\n", typeid(*xi).name());
    ChildAccess* r = dynamic_cast<ChildAccess*>(xi);
    fprintf(stderr, "same-lib %s\n", r ? "SUCCESS" : "FAILED");
    return r;
}
