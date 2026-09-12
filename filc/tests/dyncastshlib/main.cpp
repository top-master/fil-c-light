#include <cstdio>
extern "C" void* create_child();
extern "C" void* test_cast_same_lib(void*);
extern "C" void* test_cast_diff_lib(void*);

__attribute__((visibility("default"))) int main() {
    void* obj = create_child();
    fprintf(stderr, "=== Same lib (should succeed) ===\n");
    test_cast_same_lib(obj);
    fprintf(stderr, "=== Different lib (succeeds or fails depending on libc++abi configuration) ===\n");
    test_cast_diff_lib(obj);
    return 0;
}
